local util = require("util")

---@type vim.lsp.Config
return {
  cmd = { util.homebrew_binary("buf", "buf"), "lsp", "serve" },
  filetypes = { "proto" },
  root_markers = { "buf.yaml", ".git" },
  reuse_client = function(client, config)
    return client.name == config.name
  end,
}
