--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { "/usr/local/opt/terraform-ls-head/bin/terraform-ls", "serve" },
  root_dir = require("lspconfig").util.root_pattern(
    ".terraform.lock.hcl",
    "providers.tf",
    "version.tf",
    ".terraform",
    ".git"
  ),

  -- capabilities = vim.lsp.protocol.make_client_capabilities(),
  capabilities = require('cmp_nvim_lsp').default_capabilities(),

  settings = {
    terraformls = {
      indexing = {
        ignoreDirectoryNames = {},
        ignorePaths = {},
      },
      experimentalFeatures = {
        validateOnSave = true,
        prefillRequiredFields = true,
      },
      validation = {
        enableEnhancedValidation = true,
      },
    },
  },
}
