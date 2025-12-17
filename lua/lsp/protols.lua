local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "protols" },
  filetypes = { "proto" },
  root_markers = { ".git" },
  -- cmd = { util.homebrew_binary("protols-head", "protols") },
  -- cmd = { util.prefix("rust/cargo/bin/protols") },
  -- filetypes = { "proto" },
  -- root_markers = { "buf.yaml", "buf.gen.yaml", ".git" },
  before_init = function(_, config)
    config.init_options = {
      include_paths = {
        ".",
        util.src_path("github.com", "protocolbuffers", "protobuf"),
        util.src_path("github.com", "googleapis", "googleapis"),
      }
    }
  end,
  -- settings = {
  --   protols = {
  --     include_paths = {
  --       util.src_path("github.com", "protocolbuffers", "protobuf"),
  --     },
  --   },
  -- },
}
