local lspsaga = require("lspsaga")

lspsaga.setup({
  ui = {
    theme = "round",
    border = "solid",
    title = true,
    winblend = 0,
    -- expand = '⊞',
    -- collapse = '⊟',
    -- code_action = '💡',
    -- actionfix = ' ',
    -- lines = { '┗', '┣', '┃', '━', '┏' },
    expand = "",
    collapse = "",
    preview = " ",
    code_action = " ", -- "💡",
    diagnostic = "🐞",
    incoming = " ",
    outgoing = " ",
    colors = {
      normal_bg = "#202122",
      title_bg = "#838c93",
    },
    -- imp_sign = '󰳛 ',
    kind = {},
    devicon = true,
  },
  hover = {
    max_width = 0.9,
    max_height = 0.8,
    open_link = 'gx',
    open_cmd = '!chrome',
  },
  diagnostic = {
    show_code_action = true,
    -- show_source = true,
    show_layout = 'float',
    show_normal_height = 10,
    jump_num_shortcut = true,
    max_width = 0.8,
    max_height = 0.6,
    max_show_width = 0.9,
    max_show_height = 0.6,
    text_hl_follow = true,
    border_follow = true,
    extend_relatedInformation = false,
    diagnostic_only_current = false,
    keys = {
      exec_action = 'o',
      quit = 'q',
      toggle_or_jump = '<CR>',
      quit_in_show = { 'q', '<ESC>' },
    },
  },
  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
    keys = {
      quit = "<C-c>",
      exec = "<CR>",
    },
  },
  lightbulb = {
    enable = false,
    sign = true,
    debounce = 10,
    sign_priority = 40,
    virtual_text = true,
    enable_in_insert = true,
  },
  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  preview = {
    lines_above = 10,
    lines_below = 50,
  },
  request_timeout = 2000,
  finder = {
    methods = {},
    default = 'ref+imp',
    layout = 'float',
    silent = false,
    filter = {},
    keys = {
      -- edit = "<CR>",
      shuttle = '[w',
      toggle_or_open = 'o',
      vsplit = 's',
      split = 'i',
      tabe = 't',
      tabnew = 'r',
      quit = 'q',
      close = '<C-c>k',
    },
  },
  definition = {
    keys = {
      edit = "<C-c>o",
      vsplit = "<C-c>v",
      split = "<C-c>i",
      tabe = "<C-c>t",
      quit = "q",
      close = "<Esc>",
    },
  },
  rename = {
    in_select = false,
    auto_save = false,
    keys = {
      quit = "<C-c>",
      exec = '<CR>',
      select = 'x',
    },
  },
  symbol_in_winbar = {
    enable = true,
    separator = " ",
    hide_keyword = false,
    show_file = true,
    folder_level = 1,
    -- respect_root = false,
    color_mode = true,
    dely = 300,
  },
  outline = {
    win_position = 'right',
    win_width = 30,
    auto_preview = true,
    detail = true,
    auto_close = true,
    close_after_jump = false,
    layout = 'normal',
    max_height = 0.5,
    left_width = 0.3,
    keys = {
      toggle_or_jump = 'o',
      quit = 'q',
      jump = 'e',
    },
  },
  callhierarchy = {
    layout = 'float',
    keys = {
      edit = 'e',
      vsplit = 's',
      split = 'i',
      tabe = 't',
      close = '<C-c>k',
      quit = 'q',
      shuttle = '[w',
      toggle_or_req = 'u',
    },
  },
  implement = {
    enable = true,
    sign = true,
    lang = {},
    virtual_text = true,
    priority = 100,
  },
  beacon = {
    enable = true,
    frequency = 7,
  },
  -- -- "single" | "double" | "rounded" | "bold" | "plus"
  -- -- border_style = "single",
  -- border_style = {
  --   { "╭", "NormalFloat" },
  --   { "─", "NormalFloat" },
  --   { "╮", "NormalFloat" },
  --   { "│", "NormalFloat" },
  --   { "╯", "NormalFloat" },
  --   { "─", "NormalFloat" },
  --   { "╰", "NormalFloat" },
  --   { "│", "NormalFloat" },
  -- },
  -- -- the range of 0 for fully opaque window (disabled) to 100 for fully
  -- -- transparent background. Values between 0-30 are typically most useful.
  -- saga_winblend = 100,
  -- -- when cursor in saga window you config these to move
  -- move_in_saga = {
  --   prev = "<C-p>",
  --   next = "<C-n>",
  -- },
  -- -- Error, Warn, Info, Hint
  -- -- use emoji like
  -- -- { "🙀", "😿", "😾", "😺" }
  -- -- or
  -- -- { "😡", "😥", "😤", "😐" }
  -- -- and diagnostic_header can be a function type
  -- -- must return a string and when diagnostic_header
  -- -- is function type it will have a param `entry`
  -- -- entry is a table type has these filed
  -- -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
  -- diagnostic_header = {
  --   " ",
  --   " ",
  --   " ",
  --   "ﴞ ",
  -- },
  -- -- finder icons
  -- finder_icons = {
  --   def = "  ",
  --   ref = "諭 ",
  --   link = "  ",
  -- },
  -- definition_action_keys = {
  --   edit = "<C-c>o",
  --   vsplit = "<C-c>v",
  --   split = "<C-c>i",
  --   tabe = "<C-c>t",
  --   quit = "<C-c>",
  -- },
  -- -- custom lsp kind
  -- -- usage { Field = "color code"} or {Field = {your icon, your color code}}
  -- custom_kind = {},
  -- -- if you don"t use nvim-lspconfig you must pass your server name and
  -- -- the related filetypes into this table
  -- -- like server_filetype_map = { metals = { "sbt", "scala" } }
  -- server_filetype_map = {},
})
