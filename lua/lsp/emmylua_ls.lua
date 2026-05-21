local util = require("util")

vim.env.EMMYLUALS_CONFIG = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "lsp", "emmylua_ls.json")

require("lazydev").setup({
  ---@type lazydev.Config
  runtime = vim.env.VIMRUNTIME,
  ---@type lazydev.Library.spec[]
  library = {
    "lazy.nvim",
    "plenary.nvim",
    "nvim-treesitter",
    "none-ls.nvim",
  },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  enabled = true,
  debug = false,
})

-- https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md
---@type vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("emmylua_ls", "emmylua_ls") },
  root_markers = {
    ".stylua.toml",
    ".git",
  },
}
