local lspconfig = require("lspconfig")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	cmd = { require("mason-core.path").bin_prefix("bzl"), "lsp", "serve" },
	filetypes = { "bzl" },
	-- https://docs.bazel.build/versions/5.4.1/build-ref.html#workspace
	root_dir = lspconfig.util.root_pattern(".git", "WORKSPACE", "WORKSPACE.bazel"),
	settings = {},
}
