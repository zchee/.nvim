local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("asm-lsp", "asm-lsp") },
  filetypes = {
    "asm",
    "goasm",
    "vmasm",
  },
}
