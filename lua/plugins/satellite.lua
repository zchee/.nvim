-- lewis6991/satellite.nvim, successor of the dormant nvim-scrollbar.
-- Handler parity with the old config (diagnostics + gitsigns, no cursor),
-- except search: scrollbar kept it off only because it required hlslens,
-- which satellite does not need.
local satellite = require("satellite")

satellite.setup({
  current_only = false,
  winblend = 0,
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
    "noice",
  },
  handlers = {
    cursor = {
      enable = false,
    },
    search = {
      enable = true,
    },
    diagnostic = {
      enable = true,
      signs = { "-", "=" },
      min_severity = vim.diagnostic.severity.HINT,
    },
    gitsigns = {
      enable = true,
    },
    marks = {
      enable = false,
    },
    quickfix = {
      enable = false,
    },
  },
})
