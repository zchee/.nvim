--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = {
    -- clangd version 18.0.0 (https://github.com/llvm/llvm-project 4b5366c9512aa273a5272af1d833961e1ed156e7)
    -- Features: mac+grpc+xpc
    -- Platform: x86_64-apple-darwin23.2.0
    "/opt/llvm/clangd/bin/clangd",
    "--all-scopes-completion",
    "--background-index",
    "--background-index-priority=normal",
    "--clang-tidy",
    "--completion-parse=auto",
    "--completion-style=detailed",
    "--experimental-modules-support",
    "--function-arg-placeholders",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--import-insertions",
    "--limit-references=0",
    "--limit-results=0",
    "--rename-file-limit=1000",
    "--enable-config",
    "-j=32",
    "--parse-forwarding-functions",
    "--pch-storage=memory",
    "--use-dirty-headers",
    "--input-style=standard",
    "--offset-encoding=utf-16",
  },

  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

  capabilities = require('cmp_nvim_lsp').default_capabilities(),

  -- on_new_config = function(new_config, _)
  --   local cwd = vim.fn.getcwd()
  --   new_config.init_options = {
  --     compilationDatabasePath = cwd,
  --   }
  --
  --   -- if string.find(cwd, "google/EXEgesis") then
  --   --   new_config.cmd = vim.tbl_flatten({ new_config.cmd, "--header-insertion=never", "--compile-commands-dir="..cwd })
  --   -- end
  --   -- print(vim.inspect(new_config.init_options))
  -- end
}
