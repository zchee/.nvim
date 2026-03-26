local util = require("util")

local include_paths = {
  util.src_path("github.com", "googleapis", "googleapis"),
  util.src_path("github.com", "bufbuild", "protovalidate", "proto", "protovalidate"),
}

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- cmd = { util.homebrew_binary("protols-head", "protols") },
  cmd = { util.homebrew_binary("protols-head", "protols"), "--include-paths=" .. table.concat(include_paths, ",") },
  filetypes = { "proto" },
  root_markers = {
    "buf.yaml",
    "buf.gen.yaml",
    ".git",
  },
}
