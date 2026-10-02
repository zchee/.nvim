-- The on_attach every server shares (vim.lsp.config("*") in lua/lsp/init.lua),
-- with each server's own attach-time work as one entry of `attach` below.
--
-- A server's attach work lives here, not in an `on_attach` of its
-- lsp/<name>.lua: configs resolve through
-- vim.tbl_deep_extend("force", config["*"], rtp_config, ...), which replaces a
-- function instead of merging it, so a per-server on_attach silently drops
-- this shared one.

---@type table<string, fun(client: vim.lsp.Client, bufnr: integer)>
local attach = {}

attach.dockerls = function(client)
  client.server_capabilities.documentHighlightProvider = false
  client.server_capabilities.semanticTokensProvider = nil
  -- client.server_capabilities.semanticTokensProvider.range = true
  -- client.server_capabilities.semanticTokensProvider.full.delta = true
end

-- Inlined from nvim-lspconfig's lsp/clangd.lua (removed from the dep tree):
-- the switch-source/header and symbol-info user commands.
-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr, client)
  local method_name = "textDocument/switchSourceHeader"
  if not client:supports_method(method_name) then
    return vim.notify(("method %s is not supported by any servers active on the current buffer"):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify("corresponding file cannot be determined")
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info(bufnr, client)
  local method_name = "textDocument/symbolInfo"
  if not client:supports_method(method_name) then
    return vim.notify("Clangd client not found", vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request(method_name, params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is no reason to parse it
      return
    end
    local container = ("container: %s"):format(res[1].containerName) ---@type string
    local name = ("name: %s"):format(res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, "", {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      title = "Symbol Info",
    })
  end, bufnr)
end

attach.clangd = function(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
    switch_source_header(bufnr, client)
  end, { desc = "Switch between source/header" })

  vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
    symbol_info(bufnr, client)
  end, { desc = "Show symbol info" })
end

-- Inlined from nvim-lspconfig's lsp/basedpyright.lua (removed from the dep
-- tree): reconfigure the running client's python.pythonPath in place.
local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
    client:notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

attach.basedpyright = function(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
    local params = {
      command = "basedpyright.organizeimports",
      arguments = { vim.uri_from_bufnr(bufnr) },
    }
    -- A plain workspace/executeCommand request: "basedpyright.organizeimports"
    -- is private (not advertised via capabilities), which client:exec_cmd()
    -- refuses.
    client:request("workspace/executeCommand", params, nil, bufnr)
  end, {
    desc = "Organize Imports",
  })

  vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
    desc = "Reconfigure basedpyright with the provided python path",
    nargs = 1,
    complete = "file",
  })
end

attach.terraformls = function(_, bufnr)
  vim.lsp.codelens.enable(true, { bufnr = bufnr })
end

-- Inlined from nvim-lspconfig's lsp/markdown_oxide.lua: :LspToday,
-- :LspTomorrow and :LspYesterday open the daily note through the server.
---@param client vim.lsp.Client
---@param bufnr integer
---@param cmd string
local function daily_note(client, bufnr, cmd)
  return client:exec_cmd({
    title = ("Markdown-Oxide-%s"):format(cmd),
    command = "jump",
    arguments = { cmd },
  }, { bufnr = bufnr })
end

attach.markdown_oxide = function(client, bufnr)
  for _, cmd in ipairs({ "today", "tomorrow", "yesterday" }) do
    vim.api.nvim_buf_create_user_command(bufnr, "Lsp" .. cmd:gsub("^%l", string.upper), function()
      daily_note(client, bufnr, cmd)
    end, {
      desc = ("Open %s daily note"):format(cmd),
    })
  end
end

-- Both features are pull-based: without these calls Neovim never sends
-- textDocument/inlayHint or textDocument/codeLens, so the inlayHints and
-- *CodeLens settings in lsp/vtsls.lua would reach the server and never show up
-- on screen.
attach.vtsls = function(_, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  vim.lsp.codelens.enable(true, { bufnr = bufnr })
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

-- Buffer-local, so it shadows the global <C-]> only where jsonls is attached.
attach.jsonls = function(client, bufnr)
  vim.keymap.set("n", "<C-]>", function()
    jump_to_ref(client, bufnr)
  end, { buffer = bufnr, silent = true, desc = "jsonls: jump to $ref target" })
end

---@param client vim.lsp.Client
---@param bufnr integer
return function(client, bufnr)
  local fn = attach[client.name]
  if fn then
    fn(client, bufnr)
  end
end
