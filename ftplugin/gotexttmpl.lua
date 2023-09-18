-- gotexttmpl.lua: Vim filetype plugin for Go template file.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.cmd("runtime! syntax/go.vim")

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.commentstring = "// %s"
vim.opt.formatoptions:remove("t")
vim.bo.expandtab = false
