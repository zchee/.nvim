vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = false

-- vim.cmd([[
-- augroup goBuffer
--   autocmd! * <buffer>
-- 
--   " autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
--   autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
-- augroup end
-- ]])
