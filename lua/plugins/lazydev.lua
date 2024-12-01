local lazydev = require("lazydev")

---@class lazydev.Config
lazydev.setup({
  runtime = vim.env.VIMRUNTIME,
  library = {
    {
      "folke/lazydev.nvim",
      {
        path = "luvit-meta/library",
        words = { "vim%.uv" },
      },
      "L3MON4D3/LuaSnip",
    },
  },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  enabled = true,
})
