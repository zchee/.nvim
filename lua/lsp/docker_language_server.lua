local util = require("util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("docker-language-server", "docker-language-server"), "start", "--stdio" },
  root_dir = require("lspconfig").util.root_pattern("Dockerfile", "*.dockerfile", "Dockerfile*"),
  init_options = {
    docker = {
      dockerfileExperimental = {
        removeOverlappingIssues = true,
      },
      lsp = {
        experimental = {
          vulnerabilityScanning = "all",
        },
        telemetry = "off",
      },
    },
  },
  -- init_options = {
  --   docker = {
  --     languageserver = {
  --       diagnostics = {
  --         -- string values must be equal to "ignore", "warning", or "error"
  --         deprecatedMaintainer = "error",
  --         directiveCasing = "warning",
  --         emptyContinuationLine = "ignore",
  --         instructionCasing = "error",
  --         instructionCmdMultiple = "error",
  --         instructionEntrypointMultiple = "error",
  --         instructionHealthcheckMultiple = "error",
  --         instructionJSONInSingleQuotes = "error",
  --       },
  --       formatter = {
  --         ignoreMultilineInstructions = true,
  --       },
  --     },
  --   },
  -- },
  -- settings = {
  --   docker = {
  --     languageserver = {
  --       diagnostics = {
  --         -- string values must be equal to "ignore", "warning", or "error"
  --         deprecatedMaintainer = "error",
  --         directiveCasing = "warning",
  --         emptyContinuationLine = "ignore",
  --         instructionCasing = "error",
  --         instructionCmdMultiple = "error",
  --         instructionEntrypointMultiple = "error",
  --         instructionHealthcheckMultiple = "error",
  --         instructionJSONInSingleQuotes = "error",
  --       },
  --       formatter = {
  --         ignoreMultilineInstructions = true,
  --       },
  --     },
  --   },
  -- },
}
