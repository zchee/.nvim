local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("asm-lsp", "asm-lsp") },
  filetypes = {
    "asm",
    "vmasm",
    -- "goasm",
  },
  root_markers = { ".asm-lsp.toml", ".git" },
}
