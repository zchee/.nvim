local lspconfig = require("lspconfig")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = true,
  cmd = { "/usr/local/opt/node@20/bin/node", vim.fs.joinpath(require("mason-core.path").package_prefix("bash-language-server"), "node_modules/bash-language-server/out/cli.js"), "start" },
  filetypes = { "sh", "bash" },
  --- @type function | string
  root_dir = lspconfig.util.find_git_ancestor,
  settings = {
    bashIde = {
      backgroundAnalysisMaxFiles = 10000,
      enableSourceErrorDiagnostics = true,
      globPattern = "*@(.sh|.inc|.bash|.command)", -- globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
      -- explainshellEndpoint = "",
      -- logLevel = "info",
      includeAllWorkspaceSymbols = true,
      shellcheckPath = "/opt/local/bin/shellcheck",
      shellcheckArguments = { "-f", "gcc" }, --  "--enable=all"
    }
  },
}
