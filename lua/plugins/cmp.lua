local util = require("util")

local cmp = require("cmp")

local npairs = require("nvim-autopairs")
local npairs_cmp = require("nvim-autopairs.completion.cmp")
local npairs_handlers = require("nvim-autopairs.completion.handlers")
local npairs_rule = require("nvim-autopairs.rule")
local npairs_treesitter_node = require("nvim-autopairs.ts-conds")

local ts_utils = require("nvim-treesitter.ts_utils")

local lspkind = require("lspkind")

local ls = require("luasnip")
local ls_loader_lua = require("luasnip.loaders.from_lua")

local minipairs = require("mini.pairs")
-- minipairs.setup({
--   modes = {
--     insert = true,
--     command = false,
--     terminal = false,
--   },
--   -- Global mappings. Each right hand side should be a pair information, a
--   -- table with at least these fields (see more in |MiniPairs.map|):
--   -- - <action> - one of "open", "close", "closeopen".
--   -- - <pair> - two character string for pair to be used.
--   -- By default pair is not inserted after `\`, quotes are not recognized by
--   -- <CR>, `'` does not insert pair after a letter.
--   -- Only parts of tables can be tweaked (others will use these defaults).
--   -- Supply `false` instead of table to not map particular key.
--   mappings = {
--     ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
--     ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
--     ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
--
--     [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
--     ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
--     ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
--
--     ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
--     ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
--     ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
--   },
-- })

npairs.setup({
  disable_filetype = {
    "AvanteInput",
    "TelescopePrompt",
  },
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,%`]]=],
    end_key = '$',
    avoid_move_to_end = true,
    before_key = 'h',
    after_key = 'l',
    cursor_pos_before = true,
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    highlight = 'Search',
    highlight_grey = 'Comment',
    manual_position = true,
    use_virt_lines = true
  },
  map_bs = true,
  map_cr = true,
  check_ts = true,
  ts_config = {
    -- lua = { "string" },
    go = { "string" },
  },
  disable_in_macro = false,
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  enable_afterquote = true,
  disable_in_visualblock = false,
})
-- Go
npairs.add_rules({
  npairs_rule('"', "'", "'", "go"):with_pair(npairs_treesitter_node.is_ts_node({ "string" })),
  npairs_rule("'", '"', '"', "go"):with_pair(npairs_treesitter_node.is_ts_node({ "string" })),
  npairs_rule("[", ']', "go"):with_pair(npairs_treesitter_node.is_ts_node({ "string", "comment" })),
})
-- Lua
npairs.add_rules({
  npairs_rule("%", "%", "lua"):with_pair(npairs_treesitter_node.is_ts_node({ "string", "comment" })),
  npairs_rule("$", "$", "lua"):with_pair(npairs_treesitter_node.is_not_ts_node({ "function" })),
})

_G.MUtils = {}
MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
    return npairs.esc("<C-e>") .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ "selected" }).selected ~= -1 then
      return npairs.esc("<C-y>")
    else
      return npairs.esc("<C-e>") .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end

-- local remap = vim.api.nvim_set_keymap
-- remap("i", "<BS>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
-- remap("i", "<CR>", "v:lua.MUtils.CR()", { expr = true, noremap = true })
-- remap("i", "<ESC>", [[pumvisible() ? "<C-e><ESC>" : "<ESC>"]], { expr = true, noremap = true })
-- remap("i", "<Tab>", [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true, noremap = true })
-- remap("i", "<S-Tab>", [[pumvisible() ? "<C-p>" : "<BS>"]], { expr = true, noremap = true })
-- remap("i", "<C-c>", [[pumvisible() ? "<C-e><C-c>" : "<C-c>"]], { expr = true, noremap = true })
-- remap("i", "<C-u>", "pumvisible() ? '<C-e><C-u>' : '<C-u>'", { expr = true, noremap = true })
-- remap("i", "<C-w>", "pumvisible() ? '<C-e><C-w>' : '<C-w>'", { expr = true, noremap = true })

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

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local ignore_filetypes = {
  "sagarename",
}

-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
---@class cmp.ConfigSchema
cmp.setup({
  ---@class cmp.PerformanceConfig
  performance = {
    debounce = 60,                    -- default: 60
    throttle = 10,                    -- default: 30
    fetching_timeout = 500,           -- default: 500
    filtering_context_budget = 3,     -- default: 3
    confirm_resolve_timeout = 80,     -- default: 80
    async_budget = 1,                 -- default: 1
    max_view_entries = 350,           -- default: 200
  },
  preselect = cmp.PreselectMode.None, -- cmp.PreselectMode.Item, cmp.PreselectMode.None
  ---@class cmp.Mapping
  mapping = {
    ["<Up>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<Down>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<C-b>"] = cmp.config.disable, -- cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.config.disable, -- cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if ls.jumpable(-1) then
        ls.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  ---@class cmp.SnippetConfig
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },
  ---@class cmp.CompletionConfig
  completion = {
    ---@class cmp.TriggerEvent[] | string[]
    autocomplete = {
      cmp.TriggerEvent.InsertEnter,
      cmp.TriggerEvent.TextChanged,
      -- "TextChangedI",
      -- "TextChangedP",
    },
    completeopt = "menu,menuone,noinsert",                            -- default
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]], -- default
    keyword_length = 1,                                               -- default
  },
  ---@class cmp.FormattingConfig
  formatting = {
    expandable_indicator = true,
    fields = {
      "abbr",
      "kind",
      "menu",
    },
    format = lspkind.cmp_format({
      mode = "text_symbol", -- "text", "text_symbol", "symbol_text", "symbol"
      maxwidth = {
        -- menu = function() return math.floor(0.45 * vim.o.columns) end,
        menu = 200,
        abbr = 200,
      },
      menu = {
        buffer = "[Buffer]    ",
        copilot = "[Copilot]    ",
        luasnip = "[LuaSnip]    ",
        nvim_lsp = "[LSP]    ",
        nvim_lua = "[Lua]    ",
        treesitter = "[TreeSitter]    ",
      },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 1,
        luasnip = 1,
      },
      symbol_map = {
        Text = '  ',
        Method = '  ',
        Function = '  ',
        Constructor = '  ',
        Field = '  ',
        Variable = '  ',
        Class = '  ',
        Interface = '  ',
        Module = '  ',
        Property = '  ',
        Unit = '  ',
        Value = '  ',
        Enum = '  ',
        Keyword = '  ',
        Snippet = '  ',
        Color = '  ',
        File = '  ',
        Reference = '  ',
        Folder = '  ',
        EnumMember = '  ',
        Constant = '  ',
        Struct = '  ',
        Event = '  ',
        Operator = '  ',
        TypeParameter = '  ',
      },
      ellipsis_char = "...",
      show_labelDetails = true,
      before = function(entry, vim_item)
        _ = entry
        return vim_item
      end,
    }),
  },
  ---@class cmp.MatchingConfig
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = false,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = false,
  },
  ---@class cmp.SortingConfig
  sorting = {
    priority_weight = 2,

    ---@type function | table
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.sort_text,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  ---@type cmp.SourceConfig
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      priority = 100,
      -- group_index = 100,
      option = {
        markdown_oxide = {
          keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
        }
      },
      ---@param ctx cmp.Context
      entry_filter = function(_, ctx)
        return not (util.contains(ignore_filetypes, ctx.filetype))
      end,
    },
    {
      name = "luasnip",
      priority = 50,
      -- group_index = 50,
      ---@param ctx cmp.Context
      entry_filter = function(_, ctx)
        return not (util.contains(ignore_filetypes, ctx.filetype))
      end,
    },
    {
      name = "copilot",
      priority = 30,
      -- group_index = 30,
      ---@param ctx cmp.Context
      entry_filter = function(_, ctx)
        if util.contains({ "go" }, ctx.filetype) then
          -- NOTE(zchee): only trigger Comment
          return string.find(ctx.cursor_line, "^%s*//") ~= nil
        end
        return util.contains(ignore_filetypes, ctx.filetype) ~= nil
      end,
    },
    {
      name = "path",
      priority = 20,
    },
    {
      name = "buffer",
      priority = 10,
      -- group_index = 20,
    },
    -- {
    --   name = "zsh",
    --   priority = 20,
    --   -- group_index = 20,
    -- },
    {
      name = "avante",
      priority = 50,
      group_index = 50,
      ---@param ctx cmp.Context
      entry_filter = function(_, ctx)
        return not (util.contains(ignore_filetypes, ctx.filetype))
      end,
    },
    -- {
    --   name = "go_deep",
    --   keyword_length = 1,
    --   max_item_count = 5,
    --   ---@module "cmp_go_deep"
    --   ---@type cmp_go_deep.Options
    --   option = {
    --     -- Enable/disable notifications.
    --     notifications = true,
    --     -- Symbol matching strategy.
    --     -- options:
    --     -- "substring" - exact match on symbol name substrings.
    --     -- "fuzzy" - fuzzy match on package/container/symbol names.
    --     -- "substring_fuzzy_fallback" - try "substring" match, then fallback to "fuzzy".
    --     matching_strategy = "substring_fuzzy_fallback",
    --     -- Filetypes to enable the source for.
    --     filetypes = { "go" },
    --     -- How to get documentation for Go symbols.
    --     -- options:
    --     -- "hover" - LSP 'textDocument/hover'. Prettier.
    --     -- "regex" - faster and simpler.
    --     get_documentation_implementation = "regex",
    --     -- How to get the package names.
    --     -- options:
    --     -- "treesitter" - accurate but slower.
    --     -- "regex" - faster but can fail in edge cases.
    --     get_package_name_implementation = "regex",
    --     -- Whether to exclude vendored packages from completions.
    --     exclude_vendored_packages = false,
    --     -- Timeout in milliseconds for fetching documentation.
    --     -- Controls how long to wait for documentation to load.
    --     documentation_wait_timeout_ms = 100,
    --     -- Maximum time (in milliseconds) to wait before "locking-in" the current request and sending it to gopls.
    --     debounce_gopls_requests_ms = 0,
    --     -- Maximum time (in milliseconds) to wait before "locking-in" the current request and loading data from cache.
    --     debounce_cache_requests_ms = 0,
    --     -- Path to store the SQLite database
    --     -- Default: "~/.local/share/nvim/cmp_go_deep.sqlite3"
    --     db_path = vim.fs.joinpath(vim.fn.stdpath("data"), "/cmp_go_deep.sqlite3"),
    --     -- Maximum size for the SQLite database in bytes.
    --     db_size_limit_bytes = 200 * 1024 * 1024, -- 200MB
    --   },
    -- },
    {
      name = "lazydev",
      -- group_index = 0,
      -- priority = 50,
    },
    -- {
    --   name = "nvim_lua",
    -- },
    {
      name = "nvim_lsp_signature_help",
    },
    -- {
    --   name = "treesitter",
    --   priority = 80,
    --   entry_filter = function(_, _)
    --     return vim.b.filetype ~= "sagarename"
    --   end,
    -- },
  }),

  ---@class cmp_types.cmp.ConfirmationConfig
  confirmation = {
    default_behavior = cmp.ConfirmBehavior.Replace, -- "replace"
    get_commit_characters = function(commit_characters)
      return commit_characters
    end,
  },

  event = {},

  ---@class cmp.ExperimentalConfig
  experimental = {
    ghost_text = false,
  },

  ---@class cmp.ViewConfig
  view = {
    entries = {
      name = "custom", -- "custom", "wildmenu", "native"
      selection_order = "near_cursor",
      follow_cursor = true,
    },
  },

  ---@class cmp.WindowConfig
  window = {
    ---@class cmp.CompletionWindowOptions: cmp.WindowOptions
    completion = {
      scrolloff = 5,
      col_offset = 10,
      side_padding = 3,
      scrollbar = true,
      border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }, -- double
      -- border = { "╭", "┄", "╮", "┊", "╯", "┄", "╰", "┊" }, -- dashed
      -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None", -- "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
      winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
      winblend = vim.o.pumblend,
    },
    ---@type cmp.DocumentationWindowOptions
    documentation = {
      -- max_height = 300,
      -- max_width = 300,
      -- max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      -- max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
      max_height = math.floor(40 * (40 / vim.o.lines)),
      max_width = math.floor((40 * 2) * (vim.o.columns / (40 * 2 * 16 / 9))),
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = 'FloatBorder:NormalFloat',
      winblend = vim.o.pumblend,
    },
  },
})

cmp.setup.cmdline("/", {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
    { name = "buffer" },
  }),
})

-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

-- local ts_node_func_parens_disabled = {
--   named_imports = true,   -- ecma
--   use_declaration = true, -- rust
-- }
-- local default_handler = npairs_cmp.filetypes["*"]["("].handler
-- npairs_cmp.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
--   local node_type = ts_utils.get_node_at_cursor():type()
--   if ts_node_func_parens_disabled[node_type] then
--     if item.data then
--       item.data.funcParensDisabled = true
--     else
--       char = ""
--     end
--   end
--   default_handler(char, item, bufnr, rules, commit_character)
-- end

-- cmp.event:on(
--   "confirm_done",
--   npairs_cmp.on_confirm_done({
--     sh = false,
--   })
-- )

local on_confirm_done = function(opts)
  opts = vim.tbl_deep_extend("force", {
    filetypes = npairs_cmp.filetypes,
  }, opts or {})

  return function(event)
    if event.commit_character then
      return
    end

    local entry = event.entry
    local commit_character = entry:get_commit_characters()
    local bufnr = vim.api.nvim_get_current_buf() ---@cast bufnr integer
    local filetype = vim.api.nvim_get_option_value("filetype", {})
    local item = entry:get_completion_item()

    -- Without options and fallback
    if not opts.filetypes[filetype] and not opts.filetypes["*"] then
      return
    end

    if opts.filetypes[filetype] == false then
      return
    end

    -- If filetype is nil then use *
    local completion_options = opts.filetypes[filetype] or opts.filetypes["*"]

    local rules = vim.tbl_filter(function(rule)
      return completion_options[rule.key_map]
    end, npairs.get_buf_rules(bufnr))

    for char, value in pairs(completion_options) do
      if value and value.handler and vim.tbl_contains(value.kind, item.kind) then
        value.handler(char, item, bufnr, rules, commit_character)
      end
    end
  end
end
cmp.event:on(
  "confirm_done",
  on_confirm_done({
    filetypes = {
      ["*"] = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = function(char, item, bufnr, rules, commit_character)
            local node_type = ts_utils.get_node_at_cursor()
            if not node_type then
              return
            end
            if node_type:type() then
              local ts_node_func_parens_disabled = {
                -- ecma
                named_imports = true,
                -- rust
                use_declaration = true,
              }
              if ts_node_func_parens_disabled[node_type:type()] then
                if item.data then
                  item.data.funcParensDisabled = true
                else
                  char = ""
                end
              end
            end
            npairs_cmp.filetypes["*"]["("].handler(
              char,
              item,
              bufnr,
              rules,
              commit_character
            )
          end,
        },
      },
      go = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          -- ---@param char string
          -- ---@param item table item completion
          -- ---@param bufnr number buffer number
          -- ---@param rules table
          -- ---@param commit_character table<string>
          -- function(char, item, bufnr, rules, commit_character)
          --   -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
          --   _, _, _, _, _ = char, item, bufnr, rules, commit_character
          -- end,
        },
      },
      lua = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          -- ---@param char string
          -- ---@param item table item completion
          -- ---@param bufnr number buffer number
          -- ---@param rules table
          -- ---@param commit_character table<string>
          -- function(char, item, bufnr, rules, commit_character)
          --   -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
          --   _, _, _, _, _ = char, item, bufnr, rules, commit_character
          -- end,
        },
      },
      clojure = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = npairs_handlers.lisp,
        },
      },
      clojurescript = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = npairs_handlers.lisp,
        },
      },
      fennel = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = npairs_handlers.lisp,
        },
      },
      janet = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = npairs_handlers.lisp,
        },
      },
      tex = false,
      haskell = false,
      purescript = false,
      sh = false,
    },
  })
)
