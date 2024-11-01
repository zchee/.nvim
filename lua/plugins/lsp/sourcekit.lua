local lspconfig = require("lspconfig")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = false,
  cmd = {
    "sourcekit-lsp",
    "-c", "release",
    "--completion-server-side-filtering=false",
    "--completion-max-results", "500",
  },
  filetypes = { "swift", "objective-c", "objective-cpp" }, -- , "c", "cpp"
  root_dir = function(filename, _)
    -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
    return lspconfig.util.root_pattern "buildServer.json" (filename)
        or lspconfig.util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
        or lspconfig.util.root_pattern("compile_commands.json", "Package.swift")(filename)
        or lspconfig.util.find_git_ancestor(filename)
  end,
}
