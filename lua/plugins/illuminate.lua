require("illuminate").configure({
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 200,
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
  large_file_cutoff = 2000,
  large_file_overrides = {
    providers = { "lsp" },
  },
  min_count_to_highlight = 1,
})
