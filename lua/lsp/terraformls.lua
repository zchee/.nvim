local util = require("util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = true,
  cmd = { util.homebrew_binary("terraform-ls-head", "terraform-ls"), "serve", "-req-concurrency=32" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
  -- root_dir = require("lspconfig").util.root_pattern(
  --   ".terraform",
  --   ".terraform.lock.hcl",
  --   "providers.tf",
  --   "version.tf",
  --   ".git"
  -- ),
  settings = {
    terraformls = {
      indexing = {
        ignoreDirectoryNames = {
          ".git",
          ".idea",
          ".vscode",
          "terraform.tfstate.d",
        },
        ignorePaths = {
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
