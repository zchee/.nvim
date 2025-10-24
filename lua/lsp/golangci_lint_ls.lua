local util = require("util")

local bin_golangci_lint_langserver = vim.fs.joinpath(util.go_path("bin/golangci-lint-langserver"))
local bin_golangci_lint = require("mason-core.path").bin_prefix("golangci-lint")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  autostart = false,
  cmd = { bin_golangci_lint_langserver },
  filetypes = { "go" },
  -- root_dir = lspconfig.util.root_pattern(".golangci.yaml", ".golangci.yml"),
  -- root_dir = function(bufnr, on_dir)
  --   local fname = vim.api.nvim_buf_get_name(bufnr)
  --   local dir
  --   for _, f in ipairs({ ".golangci.yaml", ".golangci.yml" }) do
  --     dir = vim.fs.root(fname, f)
  --     if dir ~= nil then
  --       on_dir(dir)
  --       return
  --     end
  --   end
  -- end,
  root_markers = { ".golangci.yaml", ".golangci.yml", ".git" },
  init_options = {
    command = { bin_golangci_lint, "run", "--out-format", "json" },
  },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}
