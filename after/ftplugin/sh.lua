-- The runtime ftplugin/sh.vim must run first for comments/commentstring.

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- The runtime ftplugin points a bash buffer's 'keywordprg' at :ShKeywordPrg,
-- which in Nvim (where :terminal exists) calls Vim's term_start() and fails
-- with E117. The empty local value falls back to the global one (:Help).
vim.bo.keywordprg = ""
