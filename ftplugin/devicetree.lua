if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 8

-- No runtime ftplugin covers this filetype, so 'commentstring' stayed empty
-- and gcc only worked while the devicetree parser was attached (it answers
-- with dts's "/* %s */"). Same string as $VIMRUNTIME/ftplugin/dts.vim, so
-- gcc does not change with parser availability.
vim.opt_local.comments = "s1:/*,mb:*,ex:*/,://"
vim.opt_local.commentstring = "/* %s */"
