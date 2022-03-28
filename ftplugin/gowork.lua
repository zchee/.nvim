-- gowork.vim: Vim filetype plugin for Go modules.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.commentstring = "// %s"
vim.opt.formatoptions:remove("t")
vim.bo.expandtab = false

vim.cmd([[
augroup goworkBuffer
  autocmd! * <buffer>

  autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup end
]])
