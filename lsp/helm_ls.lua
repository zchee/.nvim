--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- A function, not a table: vim.fn.exepath walks $PATH, so a table literal
  -- would pay that walk when the config resolves (any first FileType event)
  -- rather than when a helm buffer actually starts the server.
  cmd = function(dispatchers)
    return vim.lsp.rpc.start({ vim.fn.exepath("helm_ls"), "serve" }, dispatchers)
  end,
  filetypes = { "helm" },
  root_markers = { "Chart.yaml" },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  -- helm-ls pulls exactly one workspace/configuration section, "helm-ls"
  -- (internal/handler/configuration.go), so everything must nest under it;
  -- a bare table answers that request with null and the server keeps its
  -- defaults.
  settings = {
    ["helm-ls"] = {
      logLevel = "info",
      valuesFiles = {
        mainValuesFile = "values.yaml",
        lintOverlayValuesFile = "values.lint.yaml",
        additionalValuesFilesGlobPattern = "values*.yaml",
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
        },
      },
    },
  },
}
