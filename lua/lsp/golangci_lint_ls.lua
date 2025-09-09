local util = require("util")

local lspconfig = require("lspconfig")

local bin_golangci_lint_langserver = vim.fs.joinpath(util.go_path("bin/golangci-lint-langserver"))
local bin_golangci_lint = require("mason-core.path").bin_prefix("golangci-lint")

--- @type vim.lsp.ClientConfig
return {
  autostart = false,
  cmd = { bin_golangci_lint_langserver },
  filetypes = { "go" },
  root_dir = lspconfig.util.root_pattern(".golangci.yaml", ".golangci.yml"),
  init_options = {
    command = { bin_golangci_lint, "run", "--out-format", "json" },
  },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}
