local lspconfig = require("lspconfig")

local gopath = vim.fs.joinpath(vim.uv.os_homedir(), "go")
local bin_bufls = vim.fs.joinpath(gopath, "bin", "bufls")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { bin_bufls, "serve" },
  filetypes = { "proto" },
  ---@type fun(): string
  root_dir = function()
    local match = lspconfig.util.root_pattern("buf.yaml", ".git")
    return tostring(match)
  end,
  settings = {},
}
