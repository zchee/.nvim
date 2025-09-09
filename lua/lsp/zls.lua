local util = require("util")

local lspconfig = require("lspconfig")

--- @type vim.lsp.ClientConfig
return {
  cmd = { vim.fs.joinpath(util.prefix(), "zig", "zls") },
  filetypes = { "zig", "zon" },
  -- root_dir = lspconfig.util.root_pattern(".golangci.yaml", ".golangci.yml"),
  init_options = {
    zls = {
      enable_build_on_save = true,
      semantic_tokens = "partial",
      zig_exe_path = vim.fs.joinpath(util.prefix(), "zig", "zig")
    }
  }
}
