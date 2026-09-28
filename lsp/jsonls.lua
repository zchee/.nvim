local util = require("util")

-- vscode-json-language-server validates a `json5` buffer as strict JSON.
-- jsonServer.js picks the severities off a literal languageId match:
--
--   documentSettings = textDocument.languageId === 'jsonc'
--     ? { comments: 'ignore', trailingCommas: 'warning' }
--     : { comments: 'error',  trailingCommas: 'error'   }
--
-- so every languageId that is not exactly "jsonc" -- "json5" included -- lands
-- in the strict branch. filetype.lua routes the JSONC-shaped files to json5
-- (tsconfig.json, .vscode/*.json, renovate.json/.renovaterc, lsif.json), and in
-- those every `//` and every trailing comma is reported as an Error.
--
-- Answering "jsonc" as the languageId would only move the problem: measured
-- against this server, real JSON5 -- unquoted keys, single-quoted strings --
-- still yields Property keys must be doublequoted / Value expected / Expected
-- comma under jsonc, because the parser behind both is the same one and has no
-- JSON5 mode. It would also silently retarget the server's json-vs-jsonc
-- formatter registration and folding/color limits, which the ask does not cover.
--
-- So drop the grammar complaints on json5 buffers and keep the schema ones,
-- which are the reason jsonls attaches to these files at all. ErrorCode in
-- vscode-json-languageservice separates the two cleanly: the scanner owns
-- 0x101-0x106 and the parser 0x201-0x210, while everything schema-level is
-- below 0x100 (Undefined/EnumValueMismatch/Deprecated -- most schema problems
-- carry no code at all) or at 0x300 and above (SchemaUnsupportedFeature 0x301,
-- SchemaResolveError 0x10000), and an unresolvable schema is still worth
-- reporting.
local SYNTAX_CODE_FIRST = 0x100
local SYNTAX_CODE_LAST = 0x300 -- exclusive

-- HuJSON (JWCC) is the opposite case: its grammar is exactly JSONC plus
-- trailing commas, so "jsonc" is the right languageId for it (get_language_id
-- below). Measured against this server, a hujson buffer sent as "hujson" gets
-- an Error on every comment (521) and every trailing comma (519); sent as
-- "jsonc" the comments are accepted and only the trailing commas remain, as
-- Warnings. Those are legal HuJSON, so ErrorCode.TrailingComma alone is dropped
-- -- a missing comma (514) and every other grammar error still report.
local TRAILING_COMMA_CODE = 0x207

---Whether `diagnostic` is the JSON grammar talking rather than a schema.
---@param diagnostic lsp.Diagnostic
---@return boolean
local function is_json_syntax_diagnostic(diagnostic)
  local code = diagnostic.code
  return type(code) == "number" and code >= SYNTAX_CODE_FIRST and code < SYNTAX_CODE_LAST
end

---Per filetype, the diagnostics its dialect makes false. Filetypes absent here
---are real JSON or JSONC and keep everything.
---@type table<string, fun(diagnostic: lsp.Diagnostic): boolean>
local FALSE_DIAGNOSTICS = {
  json5 = is_json_syntax_diagnostic,
  hujson = function(diagnostic)
    return diagnostic.code == TRAILING_COMMA_CODE
  end,
}

-- Pull, not push: the server hands diagnostics to whichever transport the
-- client asked for (`registerDiagnosticsPushSupport` only when the client
-- advertises no textDocument.diagnostic at all), and Neovim 0.11+ always
-- advertises it. vim.lsp.diagnostic requests with a nil handler, so this one is
-- reached through Client:_resolve_handler and stays scoped to this client --
-- unlike assigning vim.lsp.handlers, which every server would inherit.
--
-- Only `full` reports carry items; `unchanged` ones are passed through so the
-- resultId bookkeeping upstream still sees them. relatedDocuments is left alone
-- because this server reports interFileDependencies: false and never fills it,
-- and resolving a filetype per URI would materialize buffers as a side effect.
---@param err lsp.ResponseError?
---@param result lsp.DocumentDiagnosticReport
---@param ctx lsp.HandlerContext
local function filter_dialect_diagnostics(err, result, ctx)
  local bufnr = ctx.bufnr
  local is_false = bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) and FALSE_DIAGNOSTICS[vim.bo[bufnr].filetype]
  if err == nil and type(result) == "table" and result.kind == "full" and is_false then
    result.items = vim.tbl_filter(function(diagnostic)
      return not is_false(diagnostic)
    end, result.items or {})
  end
  -- Looked up at call time, not captured, so the real handler stays swappable.
  return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
end

-- <C-]> on a `$ref` (jump through textDocument/documentLink, since this server
-- answers no textDocument/definition) is bound in lua/lsp/on_attach.lua.

-- Schemas that own the files their `fileMatch` names outright.
--
-- A plain SchemaStore association cannot express that.
-- vscode-json-languageservice (getAssociatedSchemas) collects every
-- association that matches a file and merges them under one allOf, with no
-- notion of a more specific pattern winning; only an in-file `$schema` is
-- exclusive. So every other catalog entry that claims the same file name gets
-- the pattern appended as a `!` negation -- after its own patterns, because
-- FilePatternAssociation lets the last matching one decide. The server
-- prefixes each pattern with `**/`. The pattern's final segment must be a
-- literal file name, since that is what the competitors are found by.
--
-- `name` is the catalog entry to take over, and is added when the catalog no
-- longer carries it.
local EXCLUSIVE_SCHEMAS = {
  -- The catalog gives chrome-manifest.json no fileMatch at all, and hands every
  -- bare manifest.json to Foxx Manifest, WebExtensions and Web App Manifest at
  -- once; the Firefox-shaped WebExtensions schema then flags MV3's object
  -- content_security_policy. Chrome extensions are recognized by the
  -- chrome-extension* naming of their repositories instead.
  {
    name = "Chrome Extension",
    description = "Google Chrome extension manifest file",
    url = "https://json.schemastore.org/chrome-manifest.json",
    fileMatch = "chrome-extension*/**/manifest.json",
  },
}

---Gives each EXCLUSIVE_SCHEMAS entry sole ownership of the files it matches.
---
---Mutates `schemas` in place, so it must be the copy json.schemas() makes when
---given opts, never the catalog module's own table.
---@param schemas table[] SchemaStore entries: name, description, fileMatch, url.
---@return table[]
local function apply_exclusive_schemas(schemas)
  for _, exclusive in ipairs(EXCLUSIVE_SCHEMAS) do
    local file_name = exclusive.fileMatch:match("[^/]+$")
    local owner
    for _, schema in ipairs(schemas) do
      if schema.name == exclusive.name then
        owner = schema
      else
        local file_match = type(schema.fileMatch) == "string" and { schema.fileMatch } or schema.fileMatch or {}
        for _, pattern in ipairs(file_match) do
          if pattern == file_name or vim.endswith(pattern, "/" .. file_name) then
            file_match[#file_match + 1] = "!" .. exclusive.fileMatch
            schema.fileMatch = file_match
            break
          end
        end
      end
    end
    if owner == nil then
      owner = { name = exclusive.name, description = exclusive.description }
      schemas[#schemas + 1] = owner
    end
    owner.url = exclusive.url
    owner.fileMatch = { exclusive.fileMatch }
  end
  return schemas
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- Spelled out interpreter first: the bin is a `#!/usr/bin/env node` script,
  -- so through the nodenv shim its node version comes from the cwd it happens
  -- to be spawned in -- see util.nodenv_prefix. A function, as in
  -- lsp/sourcekit.lua, so both lookups run when a JSON buffer starts the
  -- server, not whenever configs resolve; the rpc options are the ones vim.lsp
  -- passes for a table cmd.
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { util.nodenv_prefix("node"), util.bun_prefix("vscode-json-language-server"), "--stdio" },
      dispatchers,
      { cwd = config.cmd_cwd or config.root_dir, env = config.cmd_env, detached = config.detached }
    )
  end,
  filetypes = { "json", "jsonc", "json5", "jsonschema", "hujson" },
  -- The server relaxes validation for the literal "jsonc" alone; see
  -- TRAILING_COMMA_CODE for why hujson is sent as that and json5 is not.
  get_language_id = function(_, filetype)
    return filetype == "hujson" and "jsonc" or filetype
  end,
  init_options = {
    -- The server registers its formatter only when asked to at initialize
    -- time; without this every textDocument/formatting request returns null.
    provideFormatter = true,
  },
  handlers = {
    ["textDocument/diagnostic"] = filter_dialect_diagnostics,
  },
  -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
  settings = {
    json = {
      -- schemas = {
      --   {
      --     url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
      --     fileMatch = ".*/%.?codex/hooks.json",
      --   },
      --   {
      --     url = "file:///Users/zchee/src/github.com/zchee/schema/claude-code.schema.json",
      --     -- url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/claude-code.schema.json",
      --     fileMatch = ".*/%.claude.json$$",
      --   },
      --   {
      --     url = "/Users/zchee/src/github.com/zchee/schema/claude-code.settings.schema.json",
      --     fileMatch = ".*/%.?claude/settings.json$$",
      --   },
      --   {
      --     url = "https://raw.githubusercontent.com/google-gemini/gemini-cli/main/schemas/settings.schema.json",
      --     fileMatch = ".*/%.?gemini/settings.json",
      --   },
      -- },
      -- schemas: filled in by before_init below, so the SchemaStore catalog
      -- (~1000 entries) only materializes when a JSON buffer actually starts
      -- the server. Every config file under lsp/ is read when
      -- vim.lsp.enable() runs in lua/lsp/init.lua (and again on the first
      -- FileType of any filetype), so even a module-scope require here would
      -- load the catalog for a Go-only session.
      validate = {
        enable = true,
      },
      format = {
        enable = true,
      },
      -- Keeps a single-line array or object on one line instead of breaking
      -- every element onto its own. The server reads only this shape: VS Code's
      -- `json.format.keepLines` setting is renamed to it by the VS Code client,
      -- so `format.keepLines` here is silently ignored. The formatter pads a
      -- single-line bracket pair with spaces (`[ "a", "b" ]`, `[ ]`), and that
      -- is not configurable.
      keepLines = {
        enable = true,
      },
      -- Nothing else under `json` reaches this server: its configuration
      -- handler reads schemas, validate.enable, keepLines.enable,
      -- format.enable and the resultLimit/*FoldingLimit/*ColorDecoratorLimit
      -- caps, and leaves every limit unbounded when unset. VS Code's
      -- colorDecorators, maxItemsComputed and schemaDownload are settings of
      -- its client extension, which the server never sees.
    },
  },
  -- vim.lsp deepcopies the config per client start, so this mutation stays
  -- scoped to the starting client (same seam lsp/gopls.lua uses).
  ---@param config vim.lsp.ClientConfig
  before_init = function(_, config)
    local schemas = require("schemastore").json.schemas({
      -- `ignore` and `select`: https://github.com/b0o/SchemaStore.nvim/blob/main/lua/schemastore/catalog.lua
      -- ignore = {
      --   "Codex Hooks",
      -- },
      -- select = {
      --   ".eslintrc",
      --   "package.json",
      -- },
      -- replace = {
      --   ["Codex Hooks"] = {
      --     name = "Codex Hooks",
      --     description = "OpenAI Codex hooks configuration file",
      --     url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
      --     fileMatch = ".codex/hooks.json",
      --   },
      -- },
      -- extra = {
      --   {
      --     name = "Codex Hooks",
      --     description = "Codex hooks JSON Schema",
      --     fileMatch = ".*/%.?codex/hooks.json",
      --     url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
      --   },
      --   {
      --     name = "Codex Plugin Manifest",
      --     description = "OpenAI Codex plugin manifest file",
      --     fileMatch = "**/%.codex-plugin/plugin.json",
      --     url = "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/codex-plugin-manifest.json",
      --   },
      -- },
    })
    config.settings.json.schemas = apply_exclusive_schemas(schemas)
  end,
}
