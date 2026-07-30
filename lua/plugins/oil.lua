-- Returned as `opts` for stevearc/oil.nvim in lua/plugins/init.lua.

return {
  default_file_explorer = true,
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
  },
  float = {
    padding = 2,
    max_width = 120,
    max_height = 40,
    border = "rounded",
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["-"] = "actions.parent",
    ["g."] = "actions.toggle_hidden",
  },
}
