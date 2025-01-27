local a = require("plenary.async.async")

-- https://github.com/DetachHead/basedpyright/blob/main/packages/pyright-internal/src/common/configOptions.ts

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  -- cmd = { vim.fs.joinpath(require("mason-core.path").package_prefix("basedpyright"), "venv", "bin", "basedpyright-langserver"), "--stdio" },
  cmd = { "/usr/local/share/pipx/basedpyright-langserver", "--stdio" },
  settings = {
    basedpyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
      openFilesOnly = false,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly", -- "workspace", -- "openFilesOnly"
        diagnosticSeverityOverrides = {},
        exclude = {},
        extraPaths = function()
          local paths = {
            "/usr/local/google-cloud-sdk/lib",
            "/usr/local/google-cloud-sdk/lib/third_party",
            vim.fn.getcwd() .. "/third_party",
          }
          local third_party_path = vim.fs.joinpath(vim.fn.getcwd(), "third_party")
          if not a.uv.fs_stat(third_party_path) then
            paths:add(third_party_path)
          end
          return paths
        end,
        ignore = {},
        include = {},
        logLevel = "Error",
        -- stubPath = "",
        typeCheckingMode = "off", -- "off", "basic", "standard", "strict", "recommended", or "all"
        -- typeshedPaths = {},
      },
      useLibraryCodeForTypes = true,
      functionSignatureDisplay = "formatted",
    },
  },
}
