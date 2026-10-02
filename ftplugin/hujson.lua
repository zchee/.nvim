-- HuJSON is JWCC -- JSON with commas and comments -- so it takes jsonc's
-- settings wholesale: $VIMRUNTIME/ftplugin/jsonc.vim sets 'commentstring' and
-- 'comments', and after/ftplugin/jsonc.lua the indent options. 'runtimepath'
-- carries the after/ dirs, so one `:runtime!` reaches both files in their
-- usual order.
vim.cmd("runtime! ftplugin/jsonc[.]{vim,lua}")

-- hujsonfmt (lua/plugins/conform.lua) indents with tabs; with jsonc's
-- shiftwidth = tabstop = 2 left in place, one indent level is one tab.
vim.opt_local.expandtab = false
