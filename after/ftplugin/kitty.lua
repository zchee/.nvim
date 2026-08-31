-- after/, not ftplugin/: the bundled $VIMRUNTIME/ftplugin/kitty.vim runs
-- after user ftplugins and resets comments/commentstring, so additions only
-- survive from here. The comments appends moved from ftdetect/kitty.lua,
-- which mutated whatever buffer happened to be current at startup.
vim.opt_local.commentstring = "# %s"
vim.opt_local.comments:append("b:#")
vim.opt_local.comments:append("b:#\\:")
