-- zsh.lua: Neovim filetype plugin for Zsh.

if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

-- vim.opt_local.shiftwidth = 4
-- vim.opt_local.tabstop = 4
-- vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
-- vim.bo.commentstring = "// %s"
-- vim.opt.formatoptions:remove("t")
-- vim.bo.expandtab = false
