local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("tombi", "tombi"), "lsp" },
  filetypes = { "toml" },
  -- NOTE(zchee): tombi config exists in `~/.config/tombi/config.toml`
  settings = {},
}
