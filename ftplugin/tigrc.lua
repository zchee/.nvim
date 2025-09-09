-- tigrc.lua: Vim filetype plugin for tigrc file.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.opt_local.commentstring = "#%s"
vim.opt_local.comments = ":#"
vim.b.undo_ftplugin = 'setlocal commentstring< comments<'
