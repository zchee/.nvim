local dressing = require('dressing')
dressing.setup({
  input = {
    -- Default prompt string
    default_prompt = "➤ ",

    -- When true, <Esc> will close the modal
    insert_only = true,

    -- These are passed to nvim_open_win
    anchor = "SW",
    relative = "cursor",
    border = "rounded",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 40,
    max_width = nil,
    min_width = 20,

    -- Window transparency (0-100)
    winblend = 10,

    -- see :help dressing_get_config
    get_config = nil,

    override = function(conf)
      conf.row = 0
      conf.col = 0

      return conf
    end,
  },

  select = {
    -- Priority list of preferred vim.select implementations
    backend = { "nui", "telescope", "fzf", "builtin" },

    require('telescope.themes').get_dropdown(),
    -- Options for telescope selector
    -- telescope = {
    --   -- can be 'dropdown', 'cursor', or 'ivy'
    --   theme = "dropdown",
    -- },

    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },

    -- Options for nui Menu
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",  -- "cursor",
      border = {
        style = "rounded",
        highlight = "NightflyRed",
        text = {
          top_align = "right",
        },
      },
      max_width = 80,
      max_height = 40,
    },

    -- Options for built-in selector
    builtin = {
      -- These are passed to nvim_open_win
      anchor = "NW",
      relative = "cursor",
      border = "rounded",

      -- Window transparency (0-100)
      winblend = 10,

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      width = nil,
      max_width = 0.8,
      min_width = 40,
      height = nil,
      max_height = 0.9,
      min_height = 10,

      override = function(conf)
        conf.row = 0
        conf.col = 0

        return conf
      end,
    },

    -- Used to override format_item. See :help dressing-format
    format_item_override = {},

    -- see :help dressing_get_config
    get_config = function(opts)
      if opts.kind == 'codeaction' then
        return {
          backend = 'nui',
          nui = {
            relative = 'cursor',
            max_width = 80,
          }
        }
      end
    end
  },
})
