vim.g.matchup_enabled = 1

vim.g.matchup_mappings_enabled = 0
vim.g.matchup_mouse_enabled = 0
vim.g.matchup_motion_enabled = 0
vim.g.matchup_text_obj_enabled = 0

vim.g.matchup_transmute_enabled = 0

vim.g.matchup_delim_stopline = 0 -- 1500
vim.g.matchup_delim_noskips = 0
vim.g.matchup_delim_nomids = 0   -- middle words (like `return`) are not matched to start and end words for higlighting and motions
vim.g.matchup_delim_start_plaintext = 0

vim.g.matchup_matchparen_enabled = 0
-- vim.g.matchup_matchparen_fallback = 0

vim.g.matchup_matchparen_singleton = 0
vim.g.matchup_matchparen_offscreen = { method = "popup", highlight = "OffscreenPopup", fullwidth = 1 }

vim.g.matchup_matchparen_stopline = 400

vim.g.matchup_matchparen_timeout = vim.g.matchparen_timeout               -- 300
vim.g.matchup_matchparen_insert_timeout = vim.g.matchparen_insert_timeout -- 60

vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_deferred_show_delay = 50
vim.g.matchup_matchparen_deferred_hide_delay = 700
vim.g.matchup_matchparen_deferred_fade_time = 450 -- 0
vim.g.matchup_matchparen_pumvisible = 0           -- 1
vim.g.matchup_matchparen_hi_surround_always = 1

vim.g.matchup_motion_override_Npercent = 6
vim.g.matchup_motion_cursor_end = 1
vim.g.matchup_delim_count_fail = 0

vim.g.matchup_text_obj_linewise_operators = { "d", "y" }
vim.g.matchup_surround_enabled = 0

vim.cmd([[
  hi MatchParen gui=underline guifg=NONE guibg=#343941 blend=0
]])
