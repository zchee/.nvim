local hover = require("hover")
hover.config({
  providers = {
    "hover.providers.diagnostic",
    "hover.providers.lsp",
    "hover.providers.dap",
    "hover.providers.man",
    "hover.providers.dictionary",
  },
  ---@type vim.api.keyset.win_config
  preview_opts = {
    -- explicit: hover.nvim's own default is "single", not vim.o.winborder
    border = "rounded",
  },
  preview_window = false,
  title = false,
  mouse_providers = { "hover.providers.lsp" },
  mouse_delay = 1000,
})
