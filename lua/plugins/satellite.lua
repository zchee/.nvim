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
      -- OFF, restoring old-scrollbar parity: satellite rescans the whole
      -- buffer for matches on EVERY WinScrolled (blink docs-float scrolling
      -- included) -- measured 2026-09-01: p90 29ms / max 63ms per scroll
      -- step on a 1.6k-line file with hlsearch "function"; 0.96/2.3ms with
      -- this handler off (diag+gitsigns are cheap and stay).
      enable = false,
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
