local dressing = require("dressing")

dressing.setup({
  input = {
    enabled = true, -- Set to false to disable the vim.ui.input implementation
    default_prompt = "Input", -- Default prompt string
    trim_prompt = true, -- Trim trailing `:` from prompt
    title_pos = "left", -- Can be 'left', 'right', or 'center'
    insert_only = true, -- When true, <Esc> will close the modal
    start_in_insert = false, -- When true, input will start in insert mode.
    border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }, -- These are passed to nvim_open_win -- "rounded",
    relative = "cursor", -- 'editor' and 'win' will default to being centered
    prefer_width = 40, -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    min_width = { 20 },
    max_width = { 140, 0.9 }, -- min_width and max_width can be a list of mixed types. min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
    buf_options = {},
    win_options = {
      wrap = false,      -- Disable line wrapping
      list = true,       -- Indicator for when text exceeds window
      listchars = "precedes:…,extends:…",
      sidescrolloff = 0, -- Increase this for more context when text scrolls off the window
    },
    -- Set to `false` to disable
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },
    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,
    get_config = nil, -- see :help dressing_get_config
  },

  select = {
    enabled = true,                                                -- Set to false to disable the vim.ui.select implementation
    backend = { "nui", "telescope", "fzf_lua", "fzf", "builtin" }, -- Priority list of preferred vim.select implementations
    trim_prompt = true,                                            -- Trim trailing `:` from prompt
    nui = {
      show_numbers = true,
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      buf_options = {
        swapfile = false,
        filetype = "DressingSelect",
      },
      win_options = {
        winblend = 0,
      },
      max_width = 80,
      max_height = 40,
      min_width = 40,
      min_height = 10,
    },
    builtin = {
      -- Display numbers for options and set up keymaps
      show_numbers = true,
      -- These are passed to nvim_open_win
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "editor",
      buf_options = {},
      win_options = {
        cursorline = true,
        cursorlineopt = "both",
      },
      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- the min_ and max_ options can be a list of mixed types.
      -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },

      -- Set to `false` to disable
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },

      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end,
    },
    -- Options for telescope selector
    -- These are passed into the telescope picker directly. Can be used like:
    -- telescope = require('telescope.themes').get_ivy({...})
    telescope = nil,
    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },
    -- Options for fzf-lua
    fzf_lua = {
      -- winopts = {
      --   height = 0.5,
      --   width = 0.5,
      -- },
    },

    format_item_override = {}, -- Used to override format_item. See :help dressing-format

    get_config = function(opts)
      if opts.kind == "codeaction" then
        return {
          backend = "nui",
          nui = {
            relative = "cursor",
            position = {
              row = 3,
              col = 15,
            },
          }
        }
      end
    end
  },
})
