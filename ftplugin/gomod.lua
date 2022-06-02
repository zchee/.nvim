-- gomod.vim: Vim filetype plugin for Go modules.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.commentstring = "// %s"
vim.opt.formatoptions:remove("t")
vim.bo.expandtab = false

vim.cmd([[
augroup gomodBuffer
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup end
]])
