local dressing = require("dressing")

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
    win_options = {
      winblend = 10,
    },
    -- see :help dressing_get_config
    get_config = nil,
    override = function(conf)
      conf.row = 0
      conf.col = 0

      return conf
    end,
  },
  select = {
    backend = { "nui", "telescope", "fzf", "builtin" },
    nui = {
      position = "50%",
      size = nil,
      relative = "editor", -- "cursor",
      border = {
        style = "rounded",
        highlight = "NightflyRed",
        text = {
          top_align = "right",
        },
      },
      max_width = 80,
      max_height = 40,
      keymap = {
        focus_next = { "j", "<Down>", "<Tab>" },
        focus_prev = { "k", "<Up>", "<S-Tab>" },
        close = { "<Esc>", "<C-c>" },
        submit = { "<CR>" },
      },
    },
    require("telescope.themes").get_dropdown(),
    -- Used to override format_item. See :help dressing-format
    format_item_override = {},
    -- see :help dressing_get_config
    get_config = function(opts)
      if opts.kind == "codeaction" then
        return {
          backend = "nui",
          nui = {
            relative = "cursor",
            max_width = 80,
          },
        }
      end
    end,
  },
})
