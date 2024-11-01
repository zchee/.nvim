local nvim_tree = require("nvim-tree")
local nonicons_extention = require("nvim-nonicons.extentions.nvim-tree")

nvim_tree.setup({
  on_attach = "disable", -- function(bufnr). If nil, will use the deprecated mapping strategy
  hijack_cursor = true,
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  disable_netrw = true,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  -- root_dirs = {},
  prefer_startup_root = false,
  sync_root_with_cwd = false,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  open_on_tab = false,
  select_prompts = false,
  -- ignore_buf_on_tab_change = {},
  sort = {
    sorter = "name", -- "name", "case_sensitive", "modification_time", "extension", "suffix", "filetype"
    folders_first = true,
    files_first = false,
  },
  view = {
    centralize_selection = false,
    cursorline = true,
    debounce_delay = 15, -- ms
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    preserve_window_proportions = false,
    side = "left",
    width = {
      min = "7%",
      max = -1,
    },
    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 30,
        height = 30,
        row = 1,
        col = 1,
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    full_name = false,
    root_folder_label = ":~:s?$?/..?", -- root_folder_modifier = ":~",
    indent_width = 2,
    special_files = { "Cargo.toml", "Makefile", "README.md" },
    symlink_destination = true,
    highlight_git = false,
    highlight_diagnostics = false,
    highlight_opened_files = "all", -- "none", "icon", "name", "all"
    highlight_modified = "none",    -- "none", "icon", "name", "all"
    highlight_bookmarks = "none",   -- "none", "icon", "name", "all"
    highlight_clipboard = "none",   -- "none", "icon", "name", "all"
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      web_devicons = {
        file = {
          enable = true,
          color = true,
        },
        folder = {
          enable = true,
          color = true,
        },
      },
      git_placement = "before",
      diagnostics_placement = "signcolumn",
      modified_placement = "after",
      bookmarks_placement = "signcolumn",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
        modified = true,
        diagnostics = true,
        bookmarks = true,
      },
      glyphs = nonicons_extention.glyphs,
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = {},
  },
  system_open = {
    cmd = "",
    args = {},
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    disable_for_dirs = {},
    timeout = 200, -- ms
  },
  diagnostics = {
    enable = false,
    debounce_delay = 50, -- ms
    show_on_dirs = false,
    show_on_open_dirs = true,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  modified = {
    enable = false,
  },
  filters = {
    git_ignored = false,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = {
      "^.git$",
      "^.DS_Store$",
    },
    exclude = {},
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50, -- ms
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
      exclude = {},
    },
    file_popup = {
      open_win_config = {
        col = 1,
        row = 1,
        relative = "cursor",
        border = "shadow",
        style = "minimal",
      },
    },
    open_file = {
      quit_on_open = true,
      eject = true,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },
  trash = {
    cmd = "",
  },
  tab = {
    sync = {
      open = false,
      close = false,
      ignore = {},
    },
  },
  notify = {
    threshold = vim.log.levels.INFO,
    absolute_path = true,
  },
  ui = {
    confirm = {
      remove = true,
      trash = true,
    },
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      profile = false,
      config = false,
      copy_paste = false,
      dev = false,
      diagnostics = false,
      git = false,
      watcher = false,
    },
  },
})

-- nvim_tree.setup({
--   on_attach = "disable", -- function(bufnr). If nil, will use the deprecated mapping strategy
--   hijack_cursor = true,
--   auto_reload_on_write = true,
--   create_in_closed_folder = false,
--   disable_netrw = true,
--   hijack_netrw = true,
--   hijack_unnamed_buffer_when_opening = false,
--   -- root_dirs = {},
--   prefer_startup_root = false,
--   sync_root_with_cwd = false,
--   reload_on_bufenter = true,
--   respect_buf_cwd = true,
--   open_on_tab = false,
--   select_prompts = false,
--   -- ignore_buf_on_tab_change = {},
--   sort = {
--     sorter = "name", -- "name", "case_sensitive", "modification_time", "extension", "suffix", "filetype"
--     folders_first = true,
--     files_first = false,
--   },
--   view = {
--     centralize_selection = false,
--     cursorline = true,
--     debounce_delay = 15, -- ms
--     side = "left",
--     preserve_window_proportions = false,
--     number = false,
--     relativenumber = false,
--     signcolumn = "yes",
--     width = {
--       min = "15%",
--       max = -1,
--     },
--     float = {
--       enable = false,
--       quit_on_focus_loss = true,
--       open_win_config = {
--         relative = "editor",
--         border = "rounded",
--         width = 30,
--         height = 30,
--         row = 1,
--         col = 1,
--       },
--     },
--   },
--   renderer = {
--     add_trailing = false,
--     group_empty = false,
--     full_name = false,
--     root_folder_label = ":~:s?$?/..?", -- root_folder_modifier = ":~",
--     indent_width = 2,
--     special_files = { "Cargo.toml", "Makefile", "README.md" },
--     symlink_destination = true,
--     highlight_git = "none", -- "none", "icon", "name", "all"
--     highlight_diagnostics = "none",
--     highlight_opened_files = "all",
--     highlight_modified = "none",
--     highlight_bookmarks = "none",
--     highlight_clipboard = "none",
--     indent_markers = {
--       enable = false,
--       inline_arrows = true,
--       icons = {
--         corner = "└",
--         edge = "│",
--         item = "│",
--         bottom = "─",
--         none = " ",
--       },
--     },
--     icons = {
--       web_devicons = {
--         file = {
--           enable = true,
--           color = true,
--         },
--         folder = {
--           enable = true,
--           color = true,
--         },
--       },
--       git_placement = "before",
--       modified_placement = "after",
--       diagnostics_placement = "signcolumn",
--       bookmarks_placement = "signcolumn",
--       padding = " ",
--       symlink_arrow = " ➛ ",
--       show = {
--         file = true,
--         folder = true,
--         folder_arrow = true,
--         git = true,
--         modified = true,
--         diagnostics = true,
--         bookmarks = true,
--       },
--       glyphs = nonicons_extention.glyphs,
--     },
--   },
--   hijack_directories = {
--     enable = true,
--     auto_open = true,
--   },
--   update_focused_file = {
--     enable = true,
--     update_root = {
--       enable = false,
--       ignore_list = {},
--     },
--     exclude = false,
--   },
--   system_open = {
--     cmd = "",
--     args = {},
--   },
--   git = {
--     enable = true,
--     show_on_dirs = true,
--     show_on_open_dirs = true,
--     disable_for_dirs = {},
--     timeout = 200, -- ms
--   },
--   diagnostics = {
--     enable = false,
--     debounce_delay = 50, -- ms
--     show_on_dirs = false,
--     show_on_open_dirs = true,
--     severity = {
--       min = vim.diagnostic.severity.HINT,
--       max = vim.diagnostic.severity.ERROR,
--     },
--     icons = {
--       hint = "",
--       info = "",
--       warning = "",
--       error = "",
--     },
--   },
--   modified = {
--     enable = false,
--   },
--   filters = {
--     git_ignored = false,
--     dotfiles = false,
--     git_clean = false,
--     no_buffer = false,
--     custom = {},
--     exclude = {},
--   },
--   live_filter = {
--     prefix = "[FILTER]: ",
--     always_show_folders = true,
--   },
--   filesystem_watchers = {
--     enable = true,
--     debounce_delay = 50, -- ms
--   },
--   actions = {
--     use_system_clipboard = true,
--     change_dir = {
--       enable = true,
--       global = false,
--       restrict_above_cwd = false,
--     },
--     expand_all = {
--       max_folder_discovery = 300,
--       exclude = {},
--     },
--     file_popup = {
--       open_win_config = {
--         col = 1,
--         row = 1,
--         relative = "cursor",
--         border = "shadow",
--         style = "minimal",
--       },
--     },
--     open_file = {
--       quit_on_open = true,
--       eject = true,
--       resize_window = true,
--       window_picker = {
--         enable = true,
--         chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
--         exclude = {
--           filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
--           buftype = { "nofile", "terminal", "help" },
--         },
--       },
--     },
--     remove_file = {
--       close_window = true,
--     },
--   },
--   trash = {
--     cmd = "",
--   },
--   tab = {
--     sync = {
--       open = false,
--       close = false,
--       ignore = {},
--     },
--   },
--   notify = {
--     threshold = vim.log.levels.INFO,
--     absolute_path = true,
--   },
--   ui = {
--     confirm = {
--       remove = true,
--       trash = true,
--     },
--   },
--   log = {
--     enable = false,
--     truncate = false,
--     types = {
--       all = false,
--       profile = false,
--       config = false,
--       copy_paste = false,
--       dev = false,
--       diagnostics = false,
--       git = false,
--       watcher = false,
--     },
--   },
-- })
