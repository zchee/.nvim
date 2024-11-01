--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
	settings = {
		python = {
			disableLanguageServices = false,
			disableOrganizeImports = false,
			openFilesOnly = false,
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace", -- "openFilesOnly"
				diagnosticSeverityOverrides = {},
				exclude = {},
				extraPaths = {
					-- "/usr/local/google-cloud-sdk/lib",
					-- "/usr/local/google-cloud-sdk/lib/third_party",
					vim.fn.getcwd() .. "/third_party",
				},
				ignore = {},
				include = {},
				logLevel = "Error",
				stubPath = "",
				typeCheckingMode = "off", -- "basic", -- "strict"
				typeshedPaths = {},
			},
			useLibraryCodeForTypes = true,
			functionSignatureDisplay = "formatted",
			venvPath = ".venv",
		},
	},
}
