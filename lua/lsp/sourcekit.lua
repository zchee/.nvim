--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = {
    "sourcekit-lsp",
    "--configuration=release",
    "--scratch-path=.build",
    "--default-workspace-type=swiftPM",
    -- Repeat the flag per feature: it is a swift-argument-parser array option,
    -- which does not split on commas, and unknown values are silently dropped.
    "--experimental-feature=on-type-formatting",
    "--experimental-feature=structured-logs",
  },
  filetypes = { "swift" },
  root_markers = { "Package.swift", "compile_commands.json" },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
        relatedDocumentSupport = true,
      },
    },
  },
  -- get_language_id = function(_, ftype)
  --   local t = { objc = "objective-c", objcpp = "objective-cpp" }
  --   return t[ftype] or ftype
  -- end,
}
