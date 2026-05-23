local util = require("util")

-- local lazydev = require("lazydev")
--
-- lazydev.setup({
--   ---@type lazydev.Config
--   runtime = vim.env.VIMRUNTIME,
--   ---@type lazydev.Library.spec[]
--   library = {
--     {
--       path = "${3rd}/luv/library",
--       words = { "vim%.uv" },
--     },
--     "lazy.nvim",
--     "plenary.nvim",
--     "nvim-treesitter",
--   },
--   integrations = {
--     lspconfig = true,
--     cmp = true,
--   },
--   enabled = true,
--   debug = false,
-- })

vim.env.EMMYLUALS_CONFIG = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "lsp", "emmylua_ls.json")

-- https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md
---@type vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("emmylua_ls", "emmylua_ls") },
  root_markers = {
    ".git",
    ".stylua.toml",
  },
}
