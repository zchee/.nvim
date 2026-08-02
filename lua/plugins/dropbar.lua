-- Winbar breadcrumbs, replacing lspsaga's removed symbol_in_winbar.
-- Defaults are kept: path source shows the cwd-relative directory chain
-- (richer than lspsaga's folder_level = 1) and symbols come from
-- LSP/treesitter/markdown sources with built-in special-buffer exclusion.
local dropbar = require("dropbar")

dropbar.setup({})
