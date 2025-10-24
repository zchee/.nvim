local lspconfig = require("lspconfig")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { require("util.init").homebrew_binary("tilt-head", "tilt"), "lsp", "start" },
  filetypes = { "tiltfile" },
  -- root_dir = lspconfig.util.root_pattern("Tiltfile", ".git"),
  root_markers = { "Tiltfile", ".git" },
  settings = {},
}
