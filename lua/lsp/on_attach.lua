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
  if not client or not client:supports_method(method_name) then
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
  if not client or not client:supports_method(method_name) then
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
    if client.settings then
      client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
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

---@param client vim.lsp.Client
---@param bufnr integer
return function(client, bufnr)
  local fn = attach[client.name]
  if fn then
    fn(client, bufnr)
  end
end
