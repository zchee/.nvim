local gopath = vim.fs.joinpath(vim.uv.os_homedir(), "go")

local lspconfig = require("lspconfig")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	cmd = { vim.fs.joinpath(gopath, "bin", "cuepls") },
	filetypes = { "cue" },
	root_dir = lspconfig.util.root_pattern("cue.mod", ".git"),
	settings = {},
}
