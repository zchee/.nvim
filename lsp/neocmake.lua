local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("neocmakelsp", "neocmakelsp"), "stdio" },
  filetypes = { "cmake" },
  -- Every add_subdirectory() carries its own CMakeLists.txt, so nearest-first
  -- on that name rooted a subproject apart from the tree that configures it.
  -- Top-level-only markers first, then the repository, then the nearest
  -- CMakeLists.txt for loose trees outside git.
  root_markers = { { "CMakePresets.json", "CTestConfig.cmake" }, ".git", "CMakeLists.txt", "build", "cmake" },
  -- neocmakelsp reads its Config from initializationOptions only (serde struct
  -- in src/languageserver/config.rs) and never requests workspace/configuration.
  init_options = {
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
