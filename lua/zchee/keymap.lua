vim.api.nvim_set_keymap("n",  "j", "<cmd>call accelerated#time_driven#command('j')<CR>", { nowait = true, silent = true })
vim.api.nvim_set_keymap("n",  "k", "<cmd>call accelerated#time_driven#command('k')<CR>", { nowait = true, silent = true })

vim.api.nvim_set_keymap("n",  "b", "b", { nowait = true, silent = true })
vim.api.nvim_set_keymap("n",  "w", "w", { nowait = true, silent = true })
