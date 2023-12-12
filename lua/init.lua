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

require("zchee.nvim")
require("zchee.keymap")
require("zchee.plugin")
require("zchee.highlight")
require("zchee.command")
require("zchee.autocmd")
