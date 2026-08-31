local util = require("util")

-- https://docs.basedpyright.com/latest/configuration/language-server-settings
-- https://docs.basedpyright.com/latest/configuration/language-server-settings/#neovim

---@return string[]
local function detect_extra_paths()
  local extra_paths = {
    -- "lib",
    "lib/third_party",
  }

  local paths = {}
  for _, dir in ipairs(extra_paths) do
    if util.is_exists(vim.fs.joinpath(vim.fn.getcwd(), dir)) then
      table.insert(paths, dir)
    end
  end

  return paths
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

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("basedpyright-head", "basedpyright-langserver"), "--stdio" },
  filetypes = { "python" },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
      local params = {
        command = "basedpyright.organizeimports",
        arguments = { vim.uri_from_bufnr(bufnr) },
      }
      -- client.request() directly: "basedpyright.organizeimports" is private
      -- (not advertised via capabilities), which client:exec_cmd() refuses.
      ---@diagnostic disable-next-line: param-type-mismatch
      client.request("workspace/executeCommand", params, nil, bufnr)
    end, {
      desc = "Organize Imports",
    })

    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure basedpyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
  single_file_support = true,
  root_markers = { ".venv", "pyproject.toml", "setup.py", ".git" },
  settings = {
    basedpyright = {
      disableOrganizeImports = false,
      functionSignatureDisplay = "formatted",
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- "workspace", "openFilesOnly",
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          callArgumentNamesMatching = true,
          functionReturnTypes = true,
          genericTypes = true,
        },
        useTypingExtensions = true,
        fileEnumerationTimeout = 100,
        autoFormatStrings = true,
        diagnosticSeverityOverrides = {},
        exclude = {},
        extraPaths = detect_extra_paths(),
        ignore = {},
        include = {},
        typeCheckingMode = "off", -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
    -- python = {
    --   venvPath = vim.fs.joinpath(vim.fn.getcwd(), ".venv"),
    -- },
  },
}
