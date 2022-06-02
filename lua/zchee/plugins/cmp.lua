local cmp = require("cmp")
local cmp_compare = require('cmp.config.compare')
local luasnip = require("luasnip")

-- luasnip.snippets = require("luasnip_snippets").load_snippets()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
cmp.setup({
  preselect = "item",  -- "item", "none"

  completion = {
    autocomplete = {
      "TextChanged",
      "TextChangedI",
      "TextChangedP",
      "InsertEnter",
    },
    completeopt = "menu,menuone,noinsert",  -- ,noselect
    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
    keyword_length = 1,
  },

  formatting = {
    format = require("lspkind").cmp_format({
      mode = "text_symbol",
      preset = "codicons",
      codicons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      },
      maxwidth = 50,
      before = function (entry, vim_item)
        _ = entry
        return vim_item
      end
    })
  },

  view = {
    entries = "native"  -- "custom", "wildmenu", "native"
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<Down>"]    = cmp.mapping(cmp.mapping.select_next_item({ behavior = "insert" }), { "i", "c" }),
    ["<Up>"]      = cmp.mapping(cmp.mapping.select_prev_item({ behavior = "insert" }), { "i", "c" }),
    ["<C-b>"]     = cmp.config.disable,  -- cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"]     = cmp.config.disable,  -- cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"]     = cmp.config.disable,
    ["<C-e>"]     = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),  -- function(fallback) fallback() end,

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  sorting = {
    priority_weight = 1,
    comparators = {
      cmp_compare.offset,
      cmp_compare.exact,
      cmp_compare.sort_text,
      cmp_compare.score,
      cmp_compare.recently_used,
      cmp_compare.kind,
      cmp_compare.length,
      cmp_compare.order,
    },
  },

  sources = cmp.config.sources({
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = 'luasnip' },
  { name = "nvim_lua" },
  { name = "path" },
  }, {
    { name = "buffer" },
    }),

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
    },
  },

  experimental = {
    ghost_text = false,
  },
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
  { name = "cmp_git" },
  }, {
    { name = "buffer" },
    })
})

-- cmp.setup.cmdline("/", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "nvim_lsp_document_symbol" }
--   }, {
--     { name = "buffer" }
--   })
-- })

-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--   { name = "path" }
--   }, {
--     { name = "cmdline" }
--     })
-- })

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done({
    map_char = {
      go = "(",
      tex = ","
    }
  })
)
