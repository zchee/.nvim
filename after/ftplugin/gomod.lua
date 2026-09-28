-- gomod.lua: Neovim filetype plugin for Go modules.
--
-- after/, with no did_ftplugin guard: the runtime ftplugin/gomod.vim sets the
-- guard itself, and it must run first for noexpandtab, formatoptions-=tc,
-- commentstring and b:undo_ftplugin.

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
