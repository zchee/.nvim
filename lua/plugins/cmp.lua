local util = require("util")

local cmp = require("cmp")
local npairs = require("nvim-autopairs")
local npairs_cmp = require("nvim-autopairs.completion.cmp")
local npairs_handlers = require("nvim-autopairs.completion.handlers")
local npairs_rule = require("nvim-autopairs.rule")
local npairs_treesitter_node = require("nvim-autopairs.ts-conds")

npairs.setup({
  disable_filetype = {
    "TelescopePrompt",
  },
  fast_wrap = {},
  map_bs = false,
  map_cr = false,
  check_ts = true,
  ts_config = {
    lua = { "string" },
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

-- Luasnip
local luasnip = require("luasnip")
local luasnip_loaders_from_lua = require("luasnip.loaders.from_lua")
luasnip.setup({
  region_check_events = "InsertEnter",
})
luasnip.config.set_config({
  history = true,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})
luasnip_loaders_from_lua.lazy_load({
  lazy_paths = {
    vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "lua", "luasnip"),
  },
  fs_event_providers = { libuv = true },
})
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
---@class cmp.ConfigSchema
cmp.setup({
  ---@class cmp.PerformanceConfig
  performance = {
    debounce = 60,                    -- default: 60
    throttle = 30,                    -- default: 30
    fetching_timeout = 500,           -- default: 500
    async_budget = 1,
    max_view_entries = 350,           -- default: 200
  },
  preselect = cmp.PreselectMode.Item, -- "item", "none"
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
    ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
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
      luasnip.lsp_expand(args.body)
    end,
  },
  ---@class cmp.CompletionConfig
  completion = {
    ---@class cmp.TriggerEvent[] | string[]
    autocomplete = {
      cmp.TriggerEvent.InsertEnter,
      cmp.TriggerEvent.TextChanged,
      "TextChangedI",
      "TextChangedP",
    },
    completeopt = "menu,menuone,noinsert",                            -- default, ,noinsert
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
    format = require("lspkind").cmp_format({
      mode = "text_symbol", -- "symbol_text",
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        compilot = "[Compilot]",
      },
      preset = "codicons",
      before = function(entry, vim_item)
        _ = entry
        return vim_item
      end,
      maxwidth = 150,
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      },
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

  ---@class cmp.SourceConfig
  sources = cmp.config.sources({
    {
      name = "nvim_lsp",
      priority = 100,
      entry_filter = function(_, _)
        return vim.b.filetype ~= "sagarename"
      end,
    },
    {
      name = "luasnip",
      priority = 3,
      entry_filter = function(_, _)
        return vim.b.filetype ~= "sagarename"
      end,
    },
    {
      name = "nvim_lsp_signature_help",
      priority = 2,
      entry_filter = function(_, _)
        return vim.b.filetype ~= "sagarename"
      end,
    },
    {
      name = "lazydev",
      group_index = 0
    },
    { name = "path",      priority = 4 },
    { name = "buffer" },
    { name = "treesitter" },
    { name = "nvim_lua" },
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
      name = "native", -- "custom", "wildmenu", "native"
      -- name = "custom",
      -- selection_order = "near_cursor",
    },
  },

  ---@class cmp.WindowConfig
  window = {
    ---@type cmp.CompletionWindowOptions
    completion = {
      scrolloff = 1,
      col_offset = 0,
      side_padding = 4,
      scrollbar = true,
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = 'Normal:Pmenu,FloatBorder:NormalFloat,CursorLine:PmenuSel,Search:None',
      winblend = vim.o.pumblend,
      zindex = 1000,
    },
    ---@type cmp.DocumentationWindowOptions
    documentation = {
      max_height = 300, -- math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      max_width = 300,  -- math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = 'FloatBorder:NormalFloat',
      winblend = vim.o.pumblend,
      zindex = 1000,
    },
  },
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

local ts_node_func_parens_disabled = {
  -- ecma
  named_imports = true,
  -- rust
  use_declaration = true,
}

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" },
    { name = "buffer" },
  }),
})

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

    -- TODO(zchee):
    -- Error executing vim.schedule lua callback: /Users/zchee/.config/nvim/lua/zchee/plugins/cmp.lua:312: attempt to call field 'handler' (a nil value)
    -- stack traceback:
    --         /Users/zchee/.config/nvim/lua/zchee/plugins/cmp.lua:312: in function 'callback'
    --         ...im/site/pack/packer/opt/nvim-cmp/lua/cmp/utils/event.lua:47: in function 'emit'
    --         ...hare/nvim/site/pack/packer/opt/nvim-cmp/lua/cmp/core.lua:505: in function ''
    --         vim/_editor.lua: in function <vim/_editor.lua:0>
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
            local node_type = require("nvim-treesitter.ts_utils").get_node_at_cursor()
            if not node_type then
              return
            end
            if node_type:type() then
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
          ---@param char string
          ---@param item table item completion
          ---@param bufnr number buffer number
          ---@param rules table
          ---@param commit_character table<string>
          function(char, item, bufnr, rules, commit_character)
            -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
            _, _, _, _, _ = char, item, bufnr, rules, commit_character
          end,
        },
      },
      lua = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          ---@param char string
          ---@param item table item completion
          ---@param bufnr number buffer number
          ---@param rules table
          ---@param commit_character table<string>
          function(char, item, bufnr, rules, commit_character)
            -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
            _, _, _, _, _ = char, item, bufnr, rules, commit_character
          end,
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
