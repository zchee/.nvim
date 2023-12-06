-- terraform.lua: Neovim filetype plugin for terraform.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.commentstring = "// %s"
