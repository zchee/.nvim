local toggleterm = require("toggleterm")

vim.cmd([[
autocmd TermEnter term://*toggleterm#* tnoremap <silent><BS>t <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent><BS>t <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><BS>t <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
]])

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<BS>t]],
  ---@param t Terminal
  on_create = function(t)
    _ = t
  end,
  ---@param t Terminal
  on_open = function(t)
    _ = t
  end,
  ---@param t Terminal
  on_close = function(t)
    _ = t
  end,
  ---@param t Terminal
  ---@param job number
  ---@param data string[]
  ---@param name string
  on_stdout = function(t, job, data, name)
    _ = t
    _ = job
    _ = data
    _ = name
  end,
  ---@param t Terminal
  ---@param job number
  ---@param data string[]
  ---@param name string
  on_stderr = function(t, job, data, name)
    _ = t
    _ = job
    _ = data
    _ = name
  end,
  ---@param t Terminal
  ---@param job number
  ---@param exit_code number
  ---@param name string
  on_exit = function(t, job, exit_code, name)
    _ = t
    _ = job
    _ = exit_code
    _ = name
  end,
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  autochdir = false,   -- when neovim changes it current directory the terminal will change it's own when next it's opened
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    -- Normal = {
    --   guibg = "<VALUE-HERE>",
    -- },
    -- NormalFloat = {
    --   link = "Normal",
    -- },
    -- FloatBorder = {
    --   guifg = "<VALUE-HERE>",
    --   guibg = "<VALUE-HERE>",
    -- },
  },
  shade_terminals = true,   -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  shading_factor = -30,     -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
  start_in_insert = true,
  insert_mappings = true,   -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true,      -- if set to true (default) the previous terminal mode will be remembered
  direction = "float",      -- "vertical" | "horizontal" | "tab" | "float",
  close_on_exit = true,     -- close the terminal window when the process exits
  -- Change the default shell. Can be a string or a function returning a string
  shell = vim.o.shell,
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = "double", -- "single" | "double" | "shadow" | "curved" | ... other options supported by win open
    -- like `size`, width and height can be a number or function which is passed the current terminal
    width = 200,
    height = 50,
    winblend = 3,
    -- zindex = nil,
  },
  winbar = {
    enabled = false,
    ---@param term Terminal
    name_formatter = function(term)
      return term.name
    end,
  },
})

-- :ToggleTerm size=40 dir=~/Desktop direction=horizontal name=desktop
