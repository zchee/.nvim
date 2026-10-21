if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 8

-- No runtime ftplugin covers this filetype. Same strings as
-- $VIMRUNTIME/ftplugin/dts.vim, so gcc does not depend on the devicetree
-- parser being attached.
vim.opt_local.comments = "s1:/*,mb:*,ex:*/,://"
vim.opt_local.commentstring = "/* %s */"
