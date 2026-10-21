-- The runtime ftplugin/gomod.vim must run first for noexpandtab,
-- formatoptions-=tc, commentstring and b:undo_ftplugin.

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
