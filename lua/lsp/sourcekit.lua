local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig.util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "sourcekit-lsp", "--configuration=release", "--scratch-path=.build", "--default-workspace-type=swiftPM", "--experimental-feature=on-type-formatting" },
  -- cmd = { "sourcekit-lsp", "--configuration=release" },
  filetypes = { "swift" },
  root_markers = { "Package.swift", "compile_commands.json" },
  -- get_language_id = function(_, ftype)
  --   local t = { objc = "objective-c", objcpp = "objective-cpp" }
  --   return t[ftype] or ftype
  -- end,
}
