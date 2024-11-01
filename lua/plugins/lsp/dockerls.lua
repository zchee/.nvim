--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	cmd = { require("mason-core.path").bin_prefix("docker-langserver"), "--stdio" },
	root_dir = require("lspconfig").util.root_pattern("Dockerfile", "*.dockerfile", "Dockerfile*"),
	settings = {
		docker = {
			languageserver = {
				diagnostics = {
					-- string values must be equal to "ignore", "warning", or "error"
					deprecatedMaintainer = "error",
					directiveCasing = "warning",
					emptyContinuationLine = "ignore",
					instructionCasing = "error",
					instructionCmdMultiple = "error",
					instructionEntrypointMultiple = "error",
					instructionHealthcheckMultiple = "error",
					instructionJSONInSingleQuotes = "error",
				},
				formatter = {
					ignoreMultilineInstructions = true,
				},
			},
		},
	},
}
