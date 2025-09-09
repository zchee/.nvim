local util = require("util")

-- https://docs.basedpyright.com/latest/configuration/language-server-settings
-- https://docs.basedpyright.com/latest/configuration/language-server-settings/#neovim

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("basedpyright-head", "basedpyright-langserver"), "--stdio" },
  settings = {
    basedpyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
      openFilesOnly = true,
      useLibraryCodeForTypes = true,
      functionSignatureDisplay = "formatted",
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- "openFilesOnly",
        logLevel = "Error",
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
        extraPaths = {
          vim.fn.getcwd() .. "/third_party",
        },
        ignore = {},
        include = {},
        typeCheckingMode = "off", -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
  },
}
