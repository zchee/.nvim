-- Extends nvim-treesitter (main branch) parser registry with custom and
-- forked grammars.
--
-- This user module shadows the plugin's lua/nvim-treesitter/parsers.lua via
-- runtimepath order ON PURPOSE: install.lua's reload_parsers() re-requires
-- "nvim-treesitter.parsers" right before every install/update, wiping any
-- runtime table mutation -- an overlay module is the only way custom entries
-- survive. It loads the plugin's own registry file first, then overlays.
local util = require("util")

-- realpath, not normalize: when the repo sits on the runtimepath twice under
-- different spellings (~/.config/nvim symlink + the checkout path), a string
-- compare lets this file pick *itself* as the base registry and recurse until
-- the stack overflows. Resolving symlinks identifies the file, not its path.
local this = vim.uv.fs_realpath(vim.fs.normalize(debug.getinfo(1, "S").source:sub(2)))
local base
for _, f in ipairs(vim.api.nvim_get_runtime_file("lua/nvim-treesitter/parsers.lua", true)) do
  if vim.uv.fs_realpath(f) ~= this then
    base = f
    break
  end
end
-- read + load the source text directly: vim.loader patches loadfile() to
-- serve bytecode from its cache, which trips "wrong mode" here
assert(base, "nvim-treesitter plugin registry not found in runtimepath")
local f = assert(io.open(base, "r"))
local src = f:read("*a")
f:close()
local parsers = assert(load(src, "@" .. base, "t"))()

-- custom grammars (not in the upstream registry)
parsers.goasm = {
  -- queries ship with the local tree-sitter-goasm plugin (see after/queries)
  install_info = {
    url = "https://github.com/zchee/tree-sitter-goasm",
    branch = "main",
  },
  maintainers = { "@zchee" },
  tier = 3,
}
parsers.cel = {
  install_info = {
    url = "https://github.com/bufbuild/tree-sitter-cel",
    branch = "main",
  },
  tier = 3,
}
parsers.modulemap = {
  install_info = {
    url = "https://github.com/panicinc/tree-sitter-modulemap",
    branch = "main",
  },
  tier = 3,
}
parsers.x86asm = {
  install_info = {
    url = "https://github.com/bearcove/tree-sitter-x86asm",
    branch = "main",
  },
  tier = 3,
}
parsers.mustache = {
  install_info = {
    url = "https://github.com/zchee/tree-sitter-mustache",
    branch = "dev",
  },
  tier = 3,
}

-- forks replacing upstream registry entries
parsers.dockerfile = {
  install_info = {
    url = "https://github.com/zchee/tree-sitter-dockerfile",
    branch = "main",
  },
  tier = 3,
}
parsers.mlir = {
  install_info = {
    url = "https://github.com/zchee/tree-sitter-mlir",
    branch = "dev",
  },
  tier = 3,
}
parsers.swift = {
  -- local checkout; parser.c is pre-generated there
  install_info = {
    path = util.src_path("github.com/alex-pinkus/tree-sitter-swift"),
  },
  tier = 3,
}
parsers.zsh = {
  -- local checkout; parser.c is pre-generated there
  install_info = {
    path = util.src_path("github.com/georgeharker/tree-sitter-zsh"),
  },
  tier = 3,
}

return parsers
