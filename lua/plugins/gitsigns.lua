local gitsigns = require("gitsigns")
local gitsigns_config = require("gitsigns.config").config

-- vim.cmd([[
-- " highlight  GitGutterAddIntraLine                 gui=reverse
-- " highlight  GitGutterAddInvisible                 guifg=bg guibg=#010101
-- highlight  GitSignsChange                        guifg=#bbbb00 guibg=#010101
-- " highlight  GitGutterChangeInvisible              guifg=bg guibg=#010101
-- highlight  GitSignsDelete                        guifg=#ff2222 guibg=#010101
-- " highlight  GitGutterDeleteIntraLine              gui=reverse
-- " highlight  GitGutterDeleteInvisible              guifg=bg guibg=#010101
-- highlight  GitSignsAdd                           guifg=#009900 guibg=#010101
-- highlight  link  GitSignsAddLn                   DiffAdd
-- highlight  link  GitSignsAddNr                   CursorLineNr
-- " highlight  link  GitGutterChangeDelete           GitGutterChange
-- " highlight  link  GitGutterChangeDeleteInvisible  GitGutterChangeInvisible
-- " highlight  link  GitGutterChangeDeleteLine       GitGutterChangeLine
-- " highlight  link  GitGutterChangeDeleteLineNr     CursorLineNr
-- highlight  link  GitSignsChangeLn                DiffChange
-- highlight  link  GitSignsChangeNr                CursorLineNr
-- highlight  link  GitSignsDeleteLn                DiffDelete
-- highlight  link  GitSignsDeleteNr                CursorLineNr
-- ]])

vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bbbb00", bg = "#010101" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff2222", bg = "#010101" })
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900", bg = "#010101" })
vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "CursorLineNr" })
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "CursorLineNr" })
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "CursorLineNr" })
-- 'signs.add.hl' is now deprecated, please define highlight 'GitSignsAdd'
-- 'signs.add.linehl' is now deprecated, please define highlight 'GitSignsAddLn'
-- 'signs.add.numhl' is now deprecated, please define highlight 'GitSignsAddNr'
-- 'signs.change.hl' is now deprecated, please define highlight 'GitSignsChange'
-- 'signs.change.linehl' is now deprecated, please define highlight 'GitSignsChangeLn'
-- 'signs.change.numhl' is now deprecated, please define highlight 'GitSignsChangeNr'
-- 'signs.changedelete.hl' is now deprecated, please define highlight 'GitSignsChangedelete'
-- 'signs.changedelete.linehl' is now deprecated, please define highlight 'GitSignsChangedeleteLn'
-- 'signs.changedelete.numhl' is now deprecated, please define highlight 'GitSignsChangedeleteNr'
-- 'signs.delete.hl' is now deprecated, please define highlight 'GitSignsDelete'
-- 'signs.delete.linehl' is now deprecated, please define highlight 'GitSignsDeleteLn'
-- 'signs.delete.numhl' is now deprecated, please define highlight 'GitSignsDeleteNr'
-- 'signs.topdelete.hl' is now deprecated, please define highlight 'GitSignsTopdelete'
-- 'signs.topdelete.linehl' is now deprecated, please define highlight 'GitSignsTopdeleteLn'
-- 'signs.topdelete.numhl' is now deprecated, please define highlight 'GitSignsTopdeleteNr'

gitsigns.setup({
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "+",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "_",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "~_",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
    delay = 1000,
    ignore_whitespace = false,
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
})

local on_attach = function(bufnr)
  local gs = package.loaded.gitsigns
  local function map(mode, l, r, mopts)
    mopts = mopts or {}
    mopts.buffer = bufnr
    vim.keymap.set(mode, l, r, mopts)
  end
  map("n", "<Leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
  map("n", "<Leader>gb", function()
    gs.blame_line({ full = true })
  end, { desc = "Blame Line" })
  map("n", "<Leader>gB", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
  map("n", "<Leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
  map("n", "<Leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
  map("n", "<Leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
end

local prev_on_attach = gitsigns_config.on_attach
gitsigns_config.on_attach = function(bufnr)
  if prev_on_attach then
    prev_on_attach(bufnr)
  end
  on_attach(bufnr)
end
