--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = false,
  cmd = { vim.fn.exepath("helm_ls"), "serve" },
  filetypes = { "helm" },
  capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    }
    return capabilities
  end,
  settings = {
    logLevel = "info",
    valuesFiles = {
      mainValuesFile = "values.yaml",
      lintOverlayValuesFile = "values.lint.yaml",
      additionalValuesFilesGlobPattern = "values*.yaml"
    },
    yamlls = {
      enabled = true,
      diagnosticsLimit = 50,
      showDiagnosticsDirectly = false,
      path = "yaml-language-server",
      config = {
        schemas = {
          kubernetes = "templates/**",
        },
        completion = true,
        hover = true,
        -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
      }
    },
  },
}
