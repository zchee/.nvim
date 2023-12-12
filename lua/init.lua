-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.uv.fs_stat(lazypath) then
--   vim.fn.system({
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=main",
--     lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)
-- local lazy = require("lazy")
-- lazy.setup("zchee.plugins")

-- If running in tmux, detect background color. Remove after this is fixed:
-- https://github.com/neovim/neovim/issues/17070#issuecomment-1086775760
if vim.env.TMUX then
  vim.uv.fs_write(2, "\27Ptmux;\27\27]11;?\7\27\\", -1)
end

require("zchee.nvim")
require("zchee.keymap")
require("zchee.plugin")
require("zchee.highlight")
require("zchee.command")
require("zchee.autocmd")
