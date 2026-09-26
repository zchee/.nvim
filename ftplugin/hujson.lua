-- HuJSON is JWCC -- JSON with commas and comments -- so it takes jsonc's
-- settings wholesale: $VIMRUNTIME/ftplugin/jsonc.vim (which sources json's in
-- turn) sets 'commentstring' to "// %s" and 'comments' for `//` and `/* */`,
-- and after/ftplugin/jsonc.lua the indent options. Nvim ships no hujson
-- ftplugin, so without this 'commentstring' stays empty and `gcc` fails with
-- "Option 'commentstring' is empty". The `gc` operator reads it through
-- vim.filetype.get_option("hujson", ...) on a Tree-sitter buffer, which also
-- lands here. 'runtimepath' carries the after/ dirs, so one `:runtime!` reaches
-- both files in their usual order.
vim.cmd("runtime! ftplugin/jsonc[.]{vim,lua}")

-- hujsonfmt (lua/plugins/conform.lua) indents with tabs; with jsonc's
-- shiftwidth = tabstop = 2 left in place, one indent level is one tab.
vim.opt_local.expandtab = false
