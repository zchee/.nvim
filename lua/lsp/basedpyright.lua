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

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("basedpyright-head", "basedpyright-langserver"), "--stdio" },
  single_file_support = true,
  root_markers = { ".venv", "pyproject.toml", "setup.py", ".git" },
  settings = {
    basedpyright = {
      disableOrganizeImports = false,
      functionSignatureDisplay = "formatted",
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly", -- "workspace",
        -- logLevel = "Error",
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
