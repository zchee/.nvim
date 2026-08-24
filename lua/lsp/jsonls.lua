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

---Whether `diagnostic` is the JSON grammar talking rather than a schema.
---@param diagnostic lsp.Diagnostic
---@return boolean
local function is_json_syntax_diagnostic(diagnostic)
  local code = diagnostic.code
  return type(code) == "number" and code >= SYNTAX_CODE_FIRST and code < SYNTAX_CODE_LAST
end

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
local function filter_json5_syntax_diagnostics(err, result, ctx)
  local bufnr = ctx.bufnr
  if
    err == nil
    and type(result) == "table"
    and result.kind == "full"
    and bufnr ~= nil
    and vim.api.nvim_buf_is_valid(bufnr)
    and vim.bo[bufnr].filetype == "json5"
  then
    result.items = vim.tbl_filter(function(diagnostic)
      return not is_json_syntax_diagnostic(diagnostic)
    end, result.items or {})
  end
  -- Looked up at call time, not captured, so the real handler stays swappable.
  return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.bun_prefix("vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "jsonc", "json5", "jsonschema" },
  handlers = {
    ["textDocument/diagnostic"] = filter_json5_syntax_diagnostics,
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
      schemas = require("schemastore").json.schemas({
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
      }),

      validate = {
        enable = true,
      },
      format = {
        enable = true,
        keepLines = true,
      },
      colorDecorators = {
        enable = true,
      },
      maxItemsComputed = 50000,
      schemaDownload = {
        enable = true,
        trustedDomains = {
          ["https://schemastore.azurewebsites.net/"] = true,
          ["https://raw.githubusercontent.com/microsoft/vscode/"] = true,
          ["https://raw.githubusercontent.com/devcontainers/spec/"] = true,
          ["https://www.schemastore.org/"] = true,
          ["https://json.schemastore.org/"] = true,
          ["https://json-schema.org/"] = true,
          ["https://developer.microsoft.com/json-schemas/"] = true,
          -- additional
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/"] = true,
          ["https://raw.githubusercontent.com/zchee/schema/"] = true,
        },
      },
    },
  },
}
