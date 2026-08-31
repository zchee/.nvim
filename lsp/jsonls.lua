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

-- <C-]> on a `$ref` jumps to the JSON Pointer's target.
--
-- vscode-json-language-server answers no `textDocument/definition` at all:
-- measured against the real server, its initialize result carries
-- `definitionProvider = nil`, and vscode-json-languageservice 5.7.2 ships no
-- services/jsonDefinition.js to back one. So the global <C-]>
-- (snacks.picker.lsp_definitions, lua/lsp/init.lua) has nothing to ask on a
-- JSON buffer and a `$ref` is a dead end.
--
-- The resolution does exist -- under a different request. services/jsonLinks.js
-- walks every `$ref` property, resolves the RFC 6901 pointer against the
-- document AST, and hands it back as a DocumentLink; the server advertises
-- `documentLinkProvider` and returns 38 links for ganja-config.schema.json.
-- Neovim carries the documentLink types in vim.lsp.protocol but implements no
-- client for the request -- there is no vim.lsp.buf.document_link -- so nothing
-- ever surfaces them.
--
-- Two shapes of that reply are load-bearing here:
--
--   * `target` is not a plain URI. findLinks builds
--     `${document.uri}#${line + 1},${character + 1}`, a VS Code fragment
--     convention rather than an lsp.Location, so the position is parsed back
--     out of the string and rebuilt into one for show_document.
--   * It points at the *value* node, not the key: findNode returns
--     `propertyNode.valueNode`, so `#/$defs/AgentConfig` lands on the `{`
--     opening the definition rather than on `"AgentConfig"`.
--
-- Pointers are same-document only -- parseJSONPointer bails unless the path
-- starts with "#/" -- so a cross-file `other.json#/$defs/X` produces no link and
-- falls through to the global definition picker, as does any cursor position
-- outside a `$ref` string.
local LINK_TARGET_PATTERN = "^(.*)#(%d+),(%d+)$"

---Whether a 0-indexed, end-exclusive `range` covers `line`/`character`.
---
---The range findLinks reports spans the string's contents, not its quotes
---(`positionAt(offset + 1)` to `positionAt(offset + length - 1)`), so a cursor
---parked on either `"` is deliberately outside it.
---@param range lsp.Range
---@param line integer
---@param character integer
---@return boolean
local function range_covers(range, line, character)
  if line < range.start.line or line > range["end"].line then
    return false
  end
  if line == range.start.line and character < range.start.character then
    return false
  end
  if line == range["end"].line and character >= range["end"].character then
    return false
  end
  return true
end

---Jumps to the `$ref` target under the cursor, or falls back to LSP definitions.
---
---The request is async so a keypress never blocks on the server; the cursor is
---sampled up front because the reply lands after it may have moved.
---@param client vim.lsp.Client
---@param bufnr integer
local function jump_to_ref(client, bufnr)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = row - 1

  -- Not lsp_definitions() from init.lua: that one first nudges the cursor onto
  -- the next identifier character for rust-analyzer's attribute macros, which
  -- no JSON buffer wants.
  local function fallback()
    require("snacks").picker.lsp_definitions()
  end

  local ok = client:request("textDocument/documentLink", {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
  }, function(err, result)
    if err ~= nil or type(result) ~= "table" then
      return fallback()
    end
    for _, link in ipairs(result) do
      if type(link.target) == "string" and range_covers(link.range, line, col) then
        local uri, target_line, target_character = link.target:match(LINK_TARGET_PATTERN)
        if uri ~= nil then
          local position = {
            line = tonumber(target_line) - 1,
            character = tonumber(target_character) - 1,
          }
          -- show_document saves the jumplist position under `focus`, so <C-o>
          -- comes back, and converts `character` out of the server's encoding.
          return vim.lsp.util.show_document(
            { uri = uri, range = { start = position, ["end"] = position } },
            client.offset_encoding,
            { reuse_win = true, focus = true }
          )
        end
      end
    end
    return fallback()
  end, bufnr)

  if not ok then
    fallback()
  end
end

-- Bound on LspAttach rather than in this file's `on_attach`, for the reason
-- lua/plugins/rustaceanvim.lua binds its Rust keymaps the same way: configs are
-- resolved with vim.tbl_deep_extend("force", config["*"], ...), which replaces
-- rather than merges a function, so an `on_attach` here would silently drop the
-- shared one that lua/lsp/init.lua installs for every server.
--
-- Buffer-local, so it shadows the global <C-]> only where jsonls is attached.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("jsonls_ref_definition", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or client.name ~= "jsonls" then
      return
    end
    vim.keymap.set("n", "<C-]>", function()
      jump_to_ref(client, args.buf)
    end, { buffer = args.buf, silent = true, desc = "jsonls: jump to $ref target" })
  end,
})

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.bun_prefix("vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "jsonc", "json5", "jsonschema" },
  init_options = {
    -- The server registers its formatter only when asked to at initialize
    -- time; without this every textDocument/formatting request returns null.
    provideFormatter = true,
  },
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
      -- schemas: filled in by before_init below, so the SchemaStore catalog
      -- (~1000 entries) only materializes when a JSON buffer actually starts
      -- the server. Config files under lsp/ are read on the first FileType
      -- event of ANY filetype, so even a module-scope require here would
      -- load the catalog for a Go-only session.
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
  -- vim.lsp deepcopies the config per client start, so this mutation stays
  -- scoped to the starting client (same seam lsp/gopls.lua uses).
  ---@param config vim.lsp.ClientConfig
  before_init = function(_, config)
    config.settings.json.schemas = require("schemastore").json.schemas({
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
  end,
}
