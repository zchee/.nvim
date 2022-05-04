vim.g.matchup_enabled = 1
vim.g.matchup_mappings_enabled = 0
vim.g.matchup_matchparen_enabled = 1
vim.g.matchup_mouse_enabled = 0
vim.g.matchup_motion_enabled = 0
vim.g.matchup_text_obj_enabled = 0
vim.g.matchup_transmute_enabled = 0
vim.g.matchup_matchparen_offscreen = { fullwidth = 1 }
vim.g.matchup_matchparen_singleton = 0
vim.g.matchup_surround_enabled = 0
vim.g.matchup_matchparen_stopline = 200
vim.g.matchup_matchparen_deferred = 5
-- vim.g.matchup_matchparen_pumvisible = 0
-- vim.g.matchup_motion_cursor_end = 0

vim.cmd([[
  hi MatchParen gui=underline guifg=NONE guibg=#343941 blend=0
]])
