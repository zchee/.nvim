vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_create_in_closed_folder = 0
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_icon_padding = ' '
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_symlink_arrow = ' >> '

vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 0,
}
vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = "",
    ignored = "◌",
  },
  folder = {
    arrow_open = "",
    arrow_closed = "",
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
    symlink_open = "",
  }
}

local nvim_tree = require("nvim-tree")
nvim_tree.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  open_on_tab         = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  -- auto_close          = true,
  hijack_cursor       = true,
  update_cwd          = true,
  hide_root_folder    = false,
  update_focused_file = {
    enable      = false,
    update_cwd  = true,
    ignore_list = {}
  },
  ignore_ft_on_setup = {},
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  filters = {
    dotfiles = true,
    -- custom_filter = {}
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  view = {
    width = "10%",
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff" },
          buftype  = { "nofile", "terminal", "help" },
        }
      }
    },
  },
}

vim.api.nvim_set_keymap("n", "-", ":<C-u>NvimTreeFindFile<CR>", { noremap = true, silent = true, nowait = true } )
