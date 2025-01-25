-- zsh.lua: Neovim filetype plugin for Zsh.

vim.opt_local.comments = "s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:•,b:#\\:"
vim.opt_local.commentstring = "# %s"
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2
vim.opt_local.formatoptions:remove("t")
