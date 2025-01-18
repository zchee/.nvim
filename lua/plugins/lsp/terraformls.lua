--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = true,
  cmd = { "/usr/local/opt/terraform-ls-head/bin/terraform-ls", "serve" },
  root_dir = require("lspconfig").util.root_pattern(
    ".terraform.lock.hcl",
    "providers.tf",
    "version.tf",
    ".terraform",
    ".git"
  ),

  capabilities = require('cmp_nvim_lsp').default_capabilities(),

  settings = {
    terraformls = {
      path = "/usr/local/opt/terraform-ls-head/bin/terraform-ls",
      indexing = {
        ignorePaths = {
          ".git",
          ".idea",
          ".vscode",
          "terraform.tfstate.d",
          ".terragrunt-cache"
        },
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
