-- sh.lua: Neovim filetype plugin for Sh.
--
-- after/, with no did_ftplugin guard: the runtime ftplugin/sh.vim sets the
-- guard itself, and it must run first for comments/commentstring.

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
