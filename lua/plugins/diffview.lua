local actions = require("diffview.actions")
require("diffview").setup({
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    default = {
      layout = "diff2_horizontal",
      winbar_info = true,
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
    },
    file_history = {
      layout = "diff2_horizontal",
      winbar_info = true,
    },
  },
  file_panel = {
    listing_style = "tree",
    tree_options = { flatten_dirs = true },
    win_config = { position = "left", width = 35 },
  },
  keymaps = {
    view = {
      { "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
      { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
      { "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
      { "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
      { "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
      { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose ours" } },
      { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
      { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose base" } },
      { "n", "dx", actions.conflict_choose("none"), { desc = "Delete conflict" } },
    },
    file_panel = {
      { "n", "j", actions.next_entry, { desc = "Next entry" } },
      { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
      { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
      { "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
      { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
      { "n", "S", actions.stage_all, { desc = "Stage all" } },
      { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
      { "n", "X", actions.restore_entry, { desc = "Restore entry" } },
      { "n", "L", actions.open_commit_log, { desc = "Open commit log" } },
      { "n", "g?", actions.help("file_panel"), { desc = "Help" } },
    },
  },
})
