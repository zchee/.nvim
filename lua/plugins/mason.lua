local mason = require("mason")

---@class MasonSettings
mason.setup({
  log_level = vim.log.levels.OFF,
  max_concurrent_installers = 8,
  registries = {
    "github:mason-org/mason-registry",
  },
  providers = {
    "mason.providers.registry-api",
    "mason.providers.client",
  },
})
