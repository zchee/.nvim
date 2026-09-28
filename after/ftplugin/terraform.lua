-- terraform.lua: Neovim filetype plugin for terraform.

-- No did_ftplugin guard: after/ runs once the runtime ftplugin has set it,
-- so a guard here skipped the comment settings below.

vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.commentstring = "// %s"
