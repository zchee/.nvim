local lspconfig = require("lspconfig")

local gopath = vim.fs.joinpath(vim.uv.os_homedir(), "go")
local bin_pls = vim.fs.joinpath(gopath, "bin", "pls")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	cmd = { bin_pls },
	filetypes = { "proto" },
	root_dir = lspconfig.util.root_pattern("buf.yaml", ".git"),
	settings = {},
}
