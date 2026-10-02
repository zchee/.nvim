local lsp_cmd = require("lsp.cmd")
local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- lsp.cmd.lazy, not a table: vim.fn.exepath walks $PATH, and a table would
  -- pay that walk whenever the config resolves (see lua/lsp/cmd.lua).
  cmd = lsp_cmd.lazy(function()
    return { vim.fn.exepath("helm_ls"), "serve" }
  end),
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
        -- path: an argv set by before_init below.
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
  -- yamlls.path is an argv, not a name: helm-ls (YamllsPath) takes the
  -- executable plus its arguments, so node is named explicitly as in
  -- lsp/yamlls.lua. Set here, not in the table above, so the lookups run when
  -- a helm buffer starts the server; client.settings is this same table, so
  -- helm-ls pulls the path with the rest.
  ---@param config vim.lsp.ClientConfig
  before_init = function(_, config)
    local helm_ls = config.settings["helm-ls"] --[[@as table]]
    helm_ls.yamlls.path = { util.nodenv_prefix("node"), util.bun_prefix("yaml-language-server"), "--stdio" }
  end,
}
