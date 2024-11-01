--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	-- cmd = { vim.fs.joinpath(cargo_home, "bin", "xor-lsp") },
	cmd = { "cargo", "run", "--release", "--all-features", "/Users/zchee/src/github.com/krmpotic/xor-lsp" },
	filetypes = { "asm" },
	-- root_dir = lspconfig.util.root_pattern(".git"),
	root_dir = "/Users/zchee/src/github.com/krmpotic/xor-lsp",
	settings = {},
}
