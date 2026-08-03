-- Loaded from the blink.cmp spec's config in lua/plugins/init.lua.
--
-- The spec tracks blink.cmp main and builds the fuzzy matcher from source
-- (prebuilt download stays off). The pre-2025-10 migration failed because a
-- broken RUSTFLAGS build line left no Rust matcher and "prefer_rust" fell
-- back to the Lua matcher SILENTLY -- whose weak filterText handling drops
-- exactly the gopls deep/unimported candidates. Hence
-- "prefer_rust_with_warning": if the source build ever breaks again, it must
-- be loud, not a quiet completion downgrade.
local blink = require("blink.cmp")

local np = require("nvim-autopairs")
local np_rule = require("nvim-autopairs.rule")
local np_ts_conds = require("nvim-autopairs.ts-conds")

local ls = require("luasnip")
local ls_loader_lua = require("luasnip.loaders.from_lua")

-- autopairs
np.setup({
  disable_filetype = {
    "AvanteInput",
    "TelescopePrompt",
  },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,%`]]=],
    end_key = "$",
    avoid_move_to_end = true,
    before_key = "h",
    after_key = "l",
    cursor_pos_before = true,
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    highlight = "Search",
    highlight_grey = "Comment",
    manual_position = true,
    use_virt_lines = true,
  },
  map_bs = true,
  map_cr = true,
  check_ts = true,
  ts_config = {
    go = { "string" },
  },
  disable_in_macro = false,
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  enable_afterquote = true,
  disable_in_visualblock = false,
})
-- Go
np.add_rules({
  np_rule('"', "'", "'", "go"):with_pair(np_ts_conds.is_ts_node({ "string" })),
  np_rule("'", '"', '"', "go"):with_pair(np_ts_conds.is_ts_node({ "string" })),
  np_rule("[", "]", "go"):with_pair(np_ts_conds.is_ts_node({ "string", "comment" })),
})
-- Lua
np.add_rules({
  np_rule("%", "%", "lua"):with_pair(np_ts_conds.is_ts_node({ "string", "comment" })),
  np_rule("$", "$", "lua"):with_pair(np_ts_conds.is_not_ts_node({ "function" })),
})

-- LuaSnip
ls.setup({
  region_check_events = "InsertEnter",
  history = true,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})
--- @type LuaSnip.Loaders.LoadOpts
ls_loader_lua.load({
  lazy_paths = {
    vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "lua", "luasnippets"),
  },
  fs_event_providers = {
    libuv = true,
  },
})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuOpen',
--   callback = function()
--     require("copilot.suggestion").dismiss()
--     vim.b.copilot_suggestion_hidden = true
--     vim.b.copilot_suggestion_auto_trigger = false
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'BlinkCmpMenuClose',
--   callback = function()
--     vim.b.copilot_suggestion_hidden = false
--   end,
-- })

---@type blink.cmp.Config
blink.setup({
  sources = {
    default = {
      "lsp",
      "snippets",
      "path",
      "buffer",
    },
    providers = {
      lsp = {
        name = "LSP",
        module = "blink.cmp.sources.lsp",
        score_offset = 500,
        async = true,
        fallbacks = { "buffer" },
        -- Filter text items from the LSP provider, since we have the buffer provider for that
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
          end, items)
        end,
      },
      snippets = {
        name = "LuaSnip",
        module = "blink.cmp.sources.snippets",
        score_offset = 300, -- receives a -3 from top level snippets.score_offset
        async = true,
        opts = {
          use_show_condition = true, -- Whether to use show_condition for filtering snippets
          show_autosnippets = true, -- Whether to show autosnippets in the completion list
          prefer_doc_trig = false,
        },
      },
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
        -- Same restriction the old cmp entry_filter enforced: in Go buffers,
        -- only offer Copilot on comment lines or inside fmt.Errorf format
        -- strings.
        should_show_items = function(ctx)
          if vim.bo[ctx.bufnr].filetype ~= "go" then
            return true
          end
          return ctx.line:find("^%s*//") ~= nil or ctx.line:find('fmt%.Errorf%("') ~= nil
        end,
        opts = {
          max_completions = 3,
          kind_name = "Copilot",
          kind_icon = " ",
          max_attempts = 3,
          kind_hl = false,
          debounce = 200,
          auto_refresh = {
            backward = false,
            forward = false,
          },
        },
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 500,
        async = true,
      },
    },
    per_filetype = {
      -- codecompanion registers its own blink source/filetype mapping at
      -- runtime (providers/completion/blink/setup.lua) -- do not list it here.
      go = {
        "lsp",
        "snippets",
        "copilot",
        "path",
        "buffer",
      },
      lua = {
        "lsp",
        "lazydev",
        "snippets",
        "path",
        "buffer",
        inherit_defaults = false,
      },
      sh = {
        "lsp",
        "snippets",
        "path",
        "buffer",
        inherit_defaults = false,
      },
      snacks_picker_input = {
        "path",
        "buffer",
        inherit_defaults = false,
      },
    },
    ---@param ctx blink.cmp.Context Minimum number of characters in the keyword to trigger all providers
    ---@return number
    min_keyword_length = function(ctx)
      _ = ctx
      return 1
    end,
    -- transform_items = function(_, items)
    --   -- return items
    --   return vim.tbl_filter(
    --     function(item)
    --       return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
    --     end,
    --     items
    --   )
    -- end,
  },
  keymap = {
    preset = "none",
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
    ["<C-n>"] = { "select_next", "fallback_to_mappings" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-k>"] = { "snippet_forward", "show_signature", "hide_signature", "fallback" },
  },
  snippets = {
    preset = "luasnip",
  },
  ---@type blink.cmp.CompletionConfigPartial
  completion = {
    keyword = {
      range = "full", -- "full", -- "prefix",
    },
    --- @type blink.cmp.CompletionTriggerConfig
    trigger = {
      prefetch_on_insert = false, -- When true, will prefetch the completion items when entering insert mode
      show_in_snippet = true, -- When false, will not show the completion window automatically when in a snippet
      show_on_keyword = true, -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
      show_on_backspace = true,
      show_on_backspace_in_keyword = false,
      show_on_backspace_after_accept = true,
      show_on_backspace_after_insert_enter = true,
      show_on_trigger_character = true, -- When true, will show the completion window after typing a trigger character
      show_on_insert = true,
      -- v2 no longer accepts a function here (the old draft special-cased
      -- markdown with a larger blocked set).
      show_on_blocked_trigger_characters = { " ", "\n", "\t" },
      show_on_accept_on_trigger_character = true, -- will show the completion window when the cursor comes after a trigger character after accepting an item
      show_on_insert_on_trigger_character = true, -- will show the completion window when the cursor comes after a trigger character when entering insert mode
      show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "[" },
    },
    --- @class blink.cmp.CompletionListConfig
    list = {
      max_items = 200,
      selection = {
        preselect = true,
        auto_insert = false,
      },
      cycle = {
        from_bottom = true, -- calling `select_next` at the _bottom_ of the completion list will select the _first_ completion item.
        from_top = true, -- calling `select_prev` at the _top_ of the completion list will select the _last_ completion item.
      },
    },
    accept = {
      dot_repeat = true,
      create_undo_point = true,
      resolve_timeout_ms = 200,
      auto_brackets = {
        enabled = true,
      },
    },
    menu = {
      enabled = true,
      min_width = 40,
      max_height = 50,
      -- border inherits vim.o.winborder
      winblend = 0,
      winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
      scrolloff = 2, -- Keep the cursor X lines away from the top/bottom of the window
      scrollbar = true, -- Note that the gutter will be disabled when border ~= 'none'
      direction_priority = { "s", "n" }, -- Which directions to show the window, falling back to the next direction when there's not enough space
      auto_show = true, -- Whether to automatically show the window when new completion items are available
      cmdline_position = function() -- Screen coordinates of the command line
        if vim.g.ui_cmdline_pos ~= nil then
          local pos = vim.g.ui_cmdline_pos
          return { pos[1] - 1, pos[2] }
        end
        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
        return { vim.o.lines - height, 0 }
      end,
      draw = {
        align_to = "label", -- Aligns the keyword you"ve typed to a component in the menu. "none" to disable, or "cursor" to align to the cursor
        -- Spaces between the border and the row content on each side. The
        -- upstream docstring advertises { left, right }, but blink.lib's
        -- validator only accepts a number -- a table fails setup() entirely.
        padding = 2,
        gap = 1, -- Gap between columns
        treesitter = { "lsp" }, -- Use treesitter to highlight the label text for the given list of sources
        columns = { -- Components to render, grouped by column
          { "label", "label_description", gap = 2 },
          { "kind_icon", "kind", "source_name", gap = 2 },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return kind_icon
            end,
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
          kind = {
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
          label = {
            width = { fill = true, max = 60 },
            text = function(ctx)
              return ctx.label .. ctx.label_detail
            end,
            highlight = function(ctx)
              -- label and label details
              local highlights = {
                {
                  0,
                  #ctx.label,
                  group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
                },
              }
              if ctx.label_detail then
                table.insert(highlights, {
                  #ctx.label,
                  #ctx.label + #ctx.label_detail,
                  group = "BlinkCmpLabelDetail",
                })
              end
              -- characters matched on the label by the fuzzy matcher
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, {
                  idx,
                  idx + 1,
                  group = "BlinkCmpLabelMatch",
                })
              end
              return highlights
            end,
          },
          label_description = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.label_description
            end,
            highlight = "BlinkCmpLabelDescription",
          },
          source_name = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.source_name
            end,
            highlight = "BlinkCmpSource",
          },
          source_id = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.source_id
            end,
            highlight = "BlinkCmpSource",
          },
        },
      },
    },
    documentation = {
      auto_show = true, -- Controls whether the documentation window will automatically show when selecting a completion item
      auto_show_delay_ms = 500, -- Delay before showing the documentation window
      update_delay_ms = 50, -- Delay before updating the documentation window when selecting a new item, while an existing item is still visible
      treesitter_highlighting = true, -- Whether to use treesitter highlighting, disable if you run into performance issues
      -- Draws the item in the documentation window, by default using an internal treesitter based implementation
      draw = function(opts)
        opts.default_implementation()
      end,
      window = {
        min_width = 10,
        max_width = 80,
        max_height = 20,
        border = nil, -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
        winblend = 0,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
        scrollbar = true, -- Note that the gutter will be disabled when border ~= 'none'
        -- Which directions to show the documentation window, for each of the possible menu window directions, falling back to the next direction when there's not enough space
        direction_priority = {
          menu_north = { "e", "w", "n", "s" },
          menu_south = { "e", "w", "s", "n" },
        },
      },
    },
    ghost_text = {
      enabled = false,
      show_with_selection = true, -- Show the ghost text when an item has been selected
      show_without_selection = false, -- Show the ghost text when no item has been selected, defaulting to the first item
      show_with_menu = false, -- Show the ghost text when the menu is open
      show_without_menu = false, -- Show the ghost text when the menu is closed
    },
  },
  cmdline = {
    enabled = false,
    keymap = {
      preset = "none",
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
            return cmp.select_and_accept()
          end
        end,
        "show_and_insert",
        "select_next",
      },
      ["<CR>"] = { "accept_and_enter", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
    },
    completion = {
      menu = {
        auto_show = false,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
    },
  },
  fuzzy = {
    implementation = "rust",
    max_typos = 0,
    -- upstream annotates FuzzyConfigFrecency as (exact) with `path` required,
    -- but setup() merges the stdpath("state") default at runtime
    ---@diagnostic disable-next-line: missing-fields
    frecency = { -- boosts recently/frequently used items
      enabled = true,
    },
    -- max_typos = function(keyword) -- Allows for a number of typos relative to the length of the query Set this to 0 to match the behavior of fzf
    --   return math.floor(#keyword / 2)
    -- end,
    use_proximity = true, -- Proximity bonus boosts the score of items matching nearby words
    -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
    -- You may pass a function instead of a string to customize the sorting
    sorts = {
      function(item_a, item_b)
        return item_a.score > item_b.score
      end,
      "exact",
      "score",
      "sort_text",
    },
    -- v2 loads the matcher from <repo>/lib/ via blink.lib; the spec's build
    -- cmd compiles it from source and copies it there (no prebuilt download).
  },
  signature = {
    enabled = true,
    trigger = {
      enabled = true, -- Show the signature help automatically
      show_on_keyword = true, -- Show the signature help window after typing any of alphanumerics, `-` or `_`
      blocked_trigger_characters = {},
      blocked_retrigger_characters = {},
      show_on_trigger_character = true, -- Show the signature help window after typing a trigger character
      show_on_insert = true, -- Show the signature help window when entering insert mode
      show_on_insert_on_trigger_character = true, -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
    },
    window = {
      min_width = 1,
      max_width = 100,
      max_height = 10,
      -- border inherits vim.o.winborder
      winblend = 0,
      winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
      scrollbar = true, -- Note that the gutter will be disabled when border ~= 'none'
      direction_priority = { "n", "s" }, -- Which directions to show the window, falling back to the next direction when there's not enough space, or another window is in the way
      treesitter_highlighting = true, -- Disable if you run into performance issues
      show_documentation = true,
    },
  },
  appearance = {
    highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
    nerd_font_variant = "normal",
    kind_icons = {
      Text = "󰉿",
      Method = "󰊕",
      Function = "󰊕",
      Constructor = "󰒓",
      Field = "󰜢",
      Variable = "󰆦",
      Property = "󰖷",
      Class = "󱡠",
      Interface = "󱡠",
      Struct = "󱡠",
      Module = "󰅩",
      Unit = "󰪚",
      Value = "󰦨",
      Enum = "󰦨",
      EnumMember = "󰦨",
      Keyword = "󰻾",
      Constant = "󰏿",
      Snippet = "󱄽",
      Color = "󰏘",
      File = "󰈔",
      Reference = "󰬲",
      Folder = "󰉋",
      Event = "󱐋",
      Operator = "󰪚",
      TypeParameter = "󰬛",
    },
  },
})
