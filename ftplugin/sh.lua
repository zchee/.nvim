-- zsh.lua: Neovim filetype plugin for Sh.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
