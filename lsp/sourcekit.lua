--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- $PATH picks the toolchain (here Xcode's ahead of swiftly's), and exepath
  -- only turns that choice into an absolute path. A function, as in
  -- lsp/helm_ls.lua, so the $PATH walk happens when a swift buffer starts the
  -- server rather than whenever configs resolve; the rpc options are the ones
  -- vim.lsp passes for a table cmd.
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({
      vim.fn.exepath("sourcekit-lsp"),
      "--configuration=release",
      "--scratch-path=.build",
      "--default-workspace-type=swiftPM",
      -- Repeat the flag per feature: it is a swift-argument-parser array option,
      -- which does not split on commas, and unknown values are silently dropped.
      "--experimental-feature=on-type-formatting",
      "--experimental-feature=structured-logs",
    }, dispatchers, { cwd = config.cmd_cwd or config.root_dir, env = config.cmd_env, detached = config.detached })
  end,
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
