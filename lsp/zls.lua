-- zls and the zig it builds with both live in zvm's install tree. With
-- $ZVM_PATH unset, joinpath would quietly build the relative "bin/zls", so say
-- so once and leave cmd out: vim.lsp then declines to start zls on a zig
-- buffer, while every other server still enables (a config file that raised
-- here would abort vim.lsp.enable() for all of them).
local zvm = vim.env.ZVM_PATH
if zvm == nil or zvm == "" then
  vim.notify_once("lsp/zls.lua: $ZVM_PATH is unset, so zls cannot be located and stays off", vim.log.levels.ERROR)
  zvm = nil
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = zvm and { vim.fs.joinpath(zvm, "bin", "zls") },
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
      zig_exe_path = zvm and vim.fs.joinpath(zvm, "bin", "zig"),
    },
  },
}
