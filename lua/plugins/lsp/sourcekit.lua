local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig.util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = true,
  cmd = { "/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/sourcekit-lsp", "--configuration=release", "--experimental-feature=example-case" },
  filetypes = { "swift", "objective-c", "objective-cpp" },
  root_dir = function(filename, _)
    return lspconfig_util.root_pattern "buildServer.json" (filename)
        or lspconfig_util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
        -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
        or lspconfig_util.root_pattern("compile_commands.json", "Package.swift")(filename)
        or lspconfig_util.find_git_ancestor(filename)
  end,
  get_language_id = function(_, ftype)
    local t = { objc = "objective-c", objcpp = "objective-cpp" }
    return t[ftype] or ftype
  end,
}
