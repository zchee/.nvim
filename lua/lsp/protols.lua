local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("protols-head", "protols") },
  filetypes = { "proto" },
  before_init = function(_, config)
    config.init_options = {
      include_paths = {
        util.src_path("github.com", "protocolbuffers", "protobuf"),
      }
    }
  end,
  -- init_options = {
  --   zls = {
  --     enable_build_on_save = true,
  --     semantic_tokens = "partial",
  --     zig_exe_path = vim.fs.joinpath(util.prefix(), "zig", "zig")
  --   }
  -- },
}
