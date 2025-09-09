local util = require("util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("pyright-head", "pyright-langserver"), "--stdio" },
  settings = {
    python = {
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
