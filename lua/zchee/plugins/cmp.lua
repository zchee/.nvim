local cmp = require("cmp")

local autopairs = require("nvim-autopairs")
local autopairs_cmp = require("nvim-autopairs.completion.cmp")
local autopairs_handlers = require('nvim-autopairs.completion.handlers')

local ts_utils = require("nvim-treesitter.ts_utils")

local luasnip = require("luasnip")
local luasnip_snippets = require("luasnip_snippets")
local luasnip_loaders_from_lua = require("luasnip.loaders.from_lua")

luasnip.snippets = luasnip_snippets.load_snippets()
luasnip_loaders_from_lua.lazy_load()

luasnip.add_snippets("all", require("zchee.plugins.luasnip.all"))
luasnip.add_snippets("yaml", require("zchee.plugins.luasnip.yaml"))

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
    throttle = 100,                   -- default: 30
    fetching_timeout = 500,           -- default: 500
    async_budget = 1,
    max_view_entries = 300,           -- default: 200
  },
  preselect = cmp.PreselectMode.Item, -- "item", "none"
  ---@class cmp.Mapping
  mapping = {
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
      -- if cmp.visible() then
      --   cmp.select_next_item()
      -- elseif luasnip.expand_or_jumpable() then
      --   luasnip.expand_or_jump()
      -- elseif has_words_before() then
      --   cmp.complete()
      -- else
      --   fallback()
      -- end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
      -- if cmp.visible() then
      --   cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
      --   luasnip.jump(-1)
      -- else
      --   fallback()
      -- end
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
      -- require("clangd_extensions.cmp_scores"),
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,

      -- cmp.config.compare.offset,
      -- cmp.config.compare.exact,
      -- -- cmp.config.compare.sort_text,
      -- cmp.config.compare.score,
      -- -- require("clangd_extensions.cmp_scores"),
      -- cmp.config.compare.recently_used,
      -- cmp.config.compare.locality,
      -- cmp.config.compare.kind,
      -- cmp.config.compare.length,
      -- cmp.config.compare.order,
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
      name = "nvim_lsp_signature_help",
      priority = 2,
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
    { name = "path",    priority = 4 },
    { name = "buffer" },
    { name = "nvim_lua" },
  }),

  ---@class cmp_types.cmp.ConfirmationConfig
  confirmation = {
    default_behavior = cmp.ConfirmBehavior.Insert, -- "replace"
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
      selection_order = "near_cursor",
    },
  },

  ---@class cmp.WindowConfig
  window = {
    completion = {
      border = {
        { "╭", "NormalFloat" },
        { "─", "NormalFloat" },
        { "╮", "NormalFloat" },
        { "│", "NormalFloat" },
        { "╯", "NormalFloat" },
        { "─", "NormalFloat" },
        { "╰", "NormalFloat" },
        { "│", "NormalFloat" },
      },
    },
    documentation = {
      border = {
        { "╭", "NormalFloat" },
        { "─", "NormalFloat" },
        { "╮", "NormalFloat" },
        { "│", "NormalFloat" },
        { "╯", "NormalFloat" },
        { "─", "NormalFloat" },
        { "╰", "NormalFloat" },
        { "│", "NormalFloat" },
      },
      max_height = 300,
      max_width = 200,
    },
  },
})

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
  opts = vim.tbl_deep_extend(
    'force', {
      filetypes = autopairs_cmp.filetypes
    }, opts or {}
  )

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

    local rules = vim.tbl_filter(
      function(rule)
        return completion_options[rule.key_map]
      end,
      autopairs.get_buf_rules(bufnr)
    )

    for char, value in pairs(completion_options) do
      if vim.tbl_contains(value.kind, item.kind) then
        value.handler(char, item, bufnr, rules, commit_character)
      end
    end
  end
end

cmp.event:on(
  "confirm_done",
  on_confirm_done({
    filetypes = {
      ["*"] = { -- "*" is a alias to all filetypes
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = function(char, item, bufnr, rules, commit_character)
            local node_type = ts_utils.get_node_at_cursor()
            if not node_type == nil and node_type:type() then
              if ts_node_func_parens_disabled[node_type:type()] then
                if item.data then
                  item.data.funcParensDisabled = true
                else
                  char = ""
                end
              end
            end
            autopairs_cmp.filetypes["*"]["("].handler(char, item, bufnr, rules, commit_character)
          end
        }
      },
      clojure = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = autopairs_handlers.lisp
        }
      },
      clojurescript = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = autopairs_handlers.lisp
        }
      },
      fennel = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = autopairs_handlers.lisp
        }
      },
      janet = {
        ["("] = {
          kind = { cmp.lsp.CompletionItemKind.Function, cmp.lsp.CompletionItemKind.Method },
          handler = autopairs_handlers.lisp
        }
      },
      tex = false,
      haskell = false,
      purescript = false,
      sh = false,
      lua = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method
          },
          ---@param char string
          ---@param item table item completion
          ---@param bufnr number buffer number
          ---@param rules table
          ---@param commit_character table<string>
          _ = function(char, item, bufnr, rules, commit_character)
            -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
          end
        }
      },
    }
  })
)
