local util = require("util")

-- https://docs.basedpyright.com/latest/configuration/language-server-settings
-- https://docs.basedpyright.com/latest/configuration/language-server-settings/#neovim

---Entries of extra_paths that exist under `root`. They stay relative:
---basedpyright resolves extraPaths against its workspace root.
---@param root string
---@return string[]
local function detect_extra_paths(root)
  local extra_paths = {
    -- "lib",
    "lib/third_party",
  }

  local paths = {}
  for _, dir in ipairs(extra_paths) do
    if util.is_exists(vim.fs.joinpath(root, dir)) then
      table.insert(paths, dir)
    end
  end

  return paths
end

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
        -- extraPaths: filled in by before_init below, since the lookup stats
        -- the disk.
        ignore = {},
        include = {},
        typeCheckingMode = "off", -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
    -- python = {
    --   venvPath = vim.fs.joinpath(vim.fn.getcwd(), ".venv"),
    -- },
  },
  ---@param config vim.lsp.ClientConfig
  before_init = function(_, config)
    -- root_dir is nil for a buffer no root marker was found for.
    config.settings.basedpyright.analysis.extraPaths = detect_extra_paths(config.root_dir or vim.fn.getcwd())
  end,
}
