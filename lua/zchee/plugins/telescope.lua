local telescope = require("telescope")
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",  -- "smart_case", "ignore_case", "respect_case"
    },
  },
}

telescope.load_extension("fzf")
telescope.load_extension("packer")
telescope.load_extension("ghq")
