vim.b.caw_oneline_comment = '//'
vim.b.caw_wrap_oneline_comment = {'/*', '*/'}

if vim.b.did_caw_ftplugin then
  if vim.b.undo_ftplugin then
    vim.b.undo_ftplugin = vim.b.undo_ftplugin..' | '
  else
    vim.b.undo_ftplugin = ''
  end
  vim.b.undo_ftplugin = vim.b.undo_ftplugin..'unlet! b:caw_oneline_comment b:caw_wrap_oneline_comment b:caw_wrap_multiline_comment b:did_caw_ftplugin'
  vim.b.did_caw_ftplugin = 1
end
