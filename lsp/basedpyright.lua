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

-- :LspPyrightOrganizeImports and :LspPyrightSetPythonPath are created in
-- lua/lsp/on_attach.lua.

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("basedpyright-head", "basedpyright-langserver"), "--stdio" },
  filetypes = { "python" },
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
        -- extraPaths: filled in by before_init below, which runs when a
        -- python buffer starts the server; the lookup stats the disk, and
        -- vim.lsp.enable() resolves every config file at startup.
        ignore = {},
        include = {},
        typeCheckingMode = "off", -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
    -- python = {
    --   venvPath = vim.fs.joinpath(vim.fn.getcwd(), ".venv"),
    -- },
  },
  -- vim.lsp deepcopies the config per client start, so the assignment stays
  -- scoped to the starting client.
  ---@param config vim.lsp.ClientConfig
  before_init = function(_, config)
    config.settings.basedpyright.analysis.extraPaths = detect_extra_paths()
  end,
}
