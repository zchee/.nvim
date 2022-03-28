vim.g.matchup_enabled = 1
vim.g.matchup_mappings_enabled = 0
vim.g.matchup_matchparen_enabled = 0
vim.g.matchup_matchparen_offscreen = { fullwidth = 1 }
vim.g.matchup_matchparen_singleton = 1
vim.g.matchup_surround_enabled = 0
vim.g.matchup_transmute_enabled = 1
vim.g.matchup_matchparen_stopline = 200
vim.g.matchup_matchparen_deferred = 10

vim.cmd([[
hi MatchParen gui=underline guibg=#343941 guisp=fg_indexed,bg_indexed blend=0
]])
