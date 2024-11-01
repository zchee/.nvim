require("jit.opt").start(2)
jit.on(true, true)

-- lazy.nvim
local lazypath = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "lazy", "lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "<Space>"
vim.g.maplocalleader = "<BS>"
require("config.lazy")

require("config")
