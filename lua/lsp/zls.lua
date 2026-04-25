local util = require("util")


--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { vim.fs.joinpath(vim.env.ZVM_PATH, "bin", "zls") },
  filetypes = { "zig", "zon" },
  settings = {
    zls = {
      enable_build_on_save = true,
      semantic_tokens = "full",
      warn_style = true,
      highlight_global_var_declarations = true,
      zig_exe_path = vim.fs.joinpath(vim.env.ZVM_PATH, "bin", "zig")
    }
  }
}
