local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("tombi", "tombi"), "lsp" },
  filetypes = { "toml" },

  settings = {
    format = {
      rules = {
        ["indent-width"] = 4,
      },
    },
  },
}
