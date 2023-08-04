if vim.b.current_syntax then
  return
end

if not vim.g.main_syntax then
  vim.g.main_syntax = "html"
end

vim.cmd([[
  runtime! syntax/gotexttmpl.lua
  runtime! syntax/html.lua
]])

vim.b.current_syntax = nil

vim.cmd([[
  syn cluster htmlPreproc add=gotplAction,goTplComment
]])

vim.b.current_syntax = "gohtmltmpl"
