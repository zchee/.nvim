vim.cmd("packadd packer.nvim")
local packer = require("packer")

packer.init {
  max_jobs = 20,
  package_root = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "vscode"),
  compile_path = vim.fs.joinpath(vim.fn.stdpath("config"), "vscode", "plugin", "packer_compiled.vscode.lua"),
  luarocks = {
    python_cmd = "python3.11",
  },
}

packer.startup(
  function()
    local use = packer.use

    use {
      "wbthomason/packer.nvim",
    }
    use {
      "rhysd/accelerated-jk"
    }
  end
)

vim.api.nvim_set_keymap("n", "@", "^",
  { nowait = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "^", "@",
  { nowait = true, noremap = true, silent = true })

vim.g.accelerated_jk_enable_deceleration = 1
vim.g.accelerated_jk_acceleration_limit = 500 -- 70, 250, 350
vim.g.accelerated_jk_acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 } -- g.accelerated_jk_acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28 }

vim.api.nvim_set_keymap("n", "j", "<cmd>call accelerated#time_driven#command('j')<CR>", { nowait = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "<cmd>call accelerated#time_driven#command('k')<CR>", { nowait = true, silent = true })
