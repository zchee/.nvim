local compat = require("plugins.illuminate_compat")

do
  local ok, provider = pcall(require, "illuminate.providers.treesitter")
  if ok then
    -- Keep the treesitter provider enabled, but skip the known broken
    -- nvim-treesitter locals path so illuminate can fall back cleanly.
    compat.patch_treesitter_provider(provider)
  end
end

require("illuminate").configure({
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 100,
  filetype_overrides = {},
  filetypes_denylist = {
    "NvimTree",
    "man",
  },
  filetypes_allowlist = {},
  modes_denylist = {},
  modes_allowlist = {},
  providers_regex_syntax_denylist = {},
  -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  providers_regex_syntax_allowlist = {},
  under_cursor = true,
  large_file_cutoff = 10000,
  -- large_file_overrides = {
  --   providers = { "lsp" },
  -- },
  large_file_overrides = nil, -- for performance
  min_count_to_highlight = 1,
  case_insensitive_regex = true,
})
