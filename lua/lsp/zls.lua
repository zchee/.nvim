local util = require("util")


--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { vim.fs.joinpath(util.prefix(), "zig", "zls") },
  filetypes = { "zig", "zon" },
  init_options = {
    zls = {
      enable_build_on_save = true,
      semantic_tokens = "partial",
      zig_exe_path = vim.fs.joinpath(util.prefix(), "zig", "zig")
    }
  }
}
