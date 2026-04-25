local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("neocmakelsp", "neocmakelsp"), "stdio" },
  filetypes = { "cmake" },
  rotoot_markers = { "CMakeLists.txt", "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
  settings = {
    format = {
      enable = false,
    },
    lint = {
      enable = false,
    },
    scan_cmake_in_package = true,
    semantic_token = true,
    use_snippets = true,
  },
}
