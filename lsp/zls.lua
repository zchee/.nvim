local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { vim.fs.joinpath(vim.env.ZVM_PATH, "bin", "zls") },
  -- No "zon": nvim's own filetype table maps the .zon extension to zig, so a
  -- zon filetype never exists and the entry only made :checkhealth vim.lsp
  -- report an unknown filetype. build.zig.zon still reaches zls as zig.
  filetypes = { "zig" },
  root_markers = { "zls.json", "build.zig", ".git" },
  settings = {
    zls = {
      enable_build_on_save = true,
      semantic_tokens = "full",
      warn_style = true,
      highlight_global_var_declarations = true,
      zig_exe_path = vim.fs.joinpath(vim.env.ZVM_PATH, "bin", "zig"),
    },
  },
}
