local util = require("util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("asm-lsp", "asm-lsp") },
  filetypes = {
    "asm",
    "goasm",
    "vmasm",
  },
}
