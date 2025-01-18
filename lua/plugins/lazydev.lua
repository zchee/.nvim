local lazydev = require("lazydev")

vim.g.lazydev_enabled = true

---@type lazydev.Config
lazydev.setup({
  runtime = vim.env.VIMRUNTIME,
  ---@type lazydev.Library.spec[]
  library = {
    {
      "lazy.nvim",
      {
        path = "${3rd}/luv/library",
        words = { "vim.uv" },
      },
      "plenary.nvim",
    },
  },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  enabled = function()
    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
  end,
  debug = false,
})
