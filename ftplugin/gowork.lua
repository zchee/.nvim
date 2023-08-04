-- gowork.vim: Neovim filetype plugin for Go workspace.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.opt_local.comments = "s1:/*,mb:*,ex:*/,://"
vim.opt_local.commentstring = "// %s"
vim.opt_local.expandtab = false
vim.opt_local.formatoptions:remove("t")
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
