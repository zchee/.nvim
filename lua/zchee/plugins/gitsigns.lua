require('gitsigns').setup {
  signs = {
    add = {
      hl     = "GitSignsAdd",
      text   = "+",
      numhl  = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl     = "GitSignsChange",
      text   = "~",
      numhl  = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl     = "GitSignsDelete",
      text   = "_",
      numhl  = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl     = "GitSignsDelete",
      text   = "‾",
      numhl  = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl     = "GitSignsChange",
      text   = "~_",
      numhl  = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border   = "single",
    style    = "minimal",
    relative = "cursor",
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

vim.cmd([[
" highlight  GitGutterAddIntraLine                 gui=reverse
" highlight  GitGutterAddInvisible                 guifg=bg guibg=#010101
highlight  GitSignsChange                        guifg=#bbbb00 guibg=#010101
" highlight  GitGutterChangeInvisible              guifg=bg guibg=#010101
highlight  GitSignsDelete                        guifg=#ff2222 guibg=#010101
" highlight  GitGutterDeleteIntraLine              gui=reverse
" highlight  GitGutterDeleteInvisible              guifg=bg guibg=#010101
highlight  GitSignsAdd                           guifg=#009900 guibg=#010101
highlight  link  GitSignsAddLn                   DiffAdd
highlight  link  GitSignsAddNr                   CursorLineNr
" highlight  link  GitGutterChangeDelete           GitGutterChange
" highlight  link  GitGutterChangeDeleteInvisible  GitGutterChangeInvisible
" highlight  link  GitGutterChangeDeleteLine       GitGutterChangeLine
" highlight  link  GitGutterChangeDeleteLineNr     CursorLineNr
highlight  link  GitSignsChangeLn                DiffChange
highlight  link  GitSignsChangeNr                CursorLineNr
highlight  link  GitSignsDeleteLn                DiffDelete
highlight  link  GitSignsDeleteNr                CursorLineNr
]])
