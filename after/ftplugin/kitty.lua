-- after/, not ftplugin/: the bundled $VIMRUNTIME/ftplugin/kitty.vim runs
-- after user ftplugins and resets comments/commentstring, so additions only
-- survive from here.
vim.opt_local.comments:append("b:#")
vim.opt_local.comments:append("b:#\\:")
