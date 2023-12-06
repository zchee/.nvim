local toggleterm = require("toggleterm")

toggleterm.setup{
  -- size can be a number or function which is passed the current terminal
  -- default: 20
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<C-\>]],
  -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
  -- on_open = fun(t: Terminal), -- function to run when the terminal opens
  -- on_close = fun(t: Terminal), -- function to run when the terminal closes
  -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
  -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
  -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    -- Normal = {
    --   guibg = "<VALUE-HERE>",
    -- },
    -- NormalFloat = {
    --   link = 'Normal'
    -- },
    -- FloatBorder = {
    --   guifg = "<VALUE-HERE>",
    --   guibg = "<VALUE-HERE>",
    -- },
  },
  shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  -- shading_factor = '<number>', -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float',
  close_on_exit = true, -- close the terminal window when the process exits
   -- Change the default shell. Can be a string or a function returning a string
  shell = vim.o.shell,
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = "shadow", -- "single" | "double" | "shadow" | "curved"
    -- like `size`, width and height can be a number or function which is passed the current terminal
    -- width = <value>,
    -- height = <value>,
    winblend = 3,
    -- zindex = <value>,
  },
  winbar = {
    enabled = true,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}
