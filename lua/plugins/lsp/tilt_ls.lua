local lspconfig = require("lspconfig")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	cmd = { require("util.init").homebrew_binary("tilt-head", "tilt"), "lsp", "start" },
	filetypes = { "tiltfile" },
	root_dir = lspconfig.util.root_pattern("Tiltfile", ".git"),
	settings = {},
}
