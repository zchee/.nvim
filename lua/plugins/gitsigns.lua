local gitsigns = require("gitsigns")
local gitsigns_config = require("gitsigns.config").config

-- The GitSigns* highlight groups live in colors/equinusocio_material.lua, so
-- a :colorscheme re-apply keeps them. Per-sign hl/numhl/linehl keys are gone
-- from gitsigns (SignConfig is text + show_count); it derives GitSigns<Type>,
-- <Type>Nr and <Type>Ln from the sign type itself.
gitsigns.setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~_" },
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
