vim.g.matchup_no_version_check = true

---@type matchup.Config
require("match-up").setup({
  ---@diagnostic disable-next-line
  matchparen = {
    enabled = 0,
    deferred = 1,
    deferred_fade_time = 450,
  },
  treesitter = {
    enabled = true,
    disabled = {},
    include_match_words = true,
    disable_virtual_text = true,
    enable_quotes = true,
    stopline = 5000,
  },
})
