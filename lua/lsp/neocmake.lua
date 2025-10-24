local util = require("util")

local lspconfig = require("lspconfig")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("neocmakelsp", "neocmakelsp"), "--stdio" },
  filetypes = { "cmake" },
  -- root_dir = function(fname)
  --   return lspconfig.util.find_git_ancestor(fname)
  -- end,
  -- settings = {
  --   neocmake = {
  --   }
  -- },
  init_options = {
    format = {
      enable = false
    },
    lint = {
      enable = false
    },
    scan_cmake_in_package = true,
    semantic_token = true,
  }
}
