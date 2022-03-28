local cmp = require("cmp")
local cmp_types = require("cmp.types")
local cmp_compare = require('cmp.config.compare')
local luasnip = require("luasnip")

luasnip.snippets = require("luasnip_snippets").load_snippets()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {
    keyword_length = 1,
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  mapping = {
    ['<Down>']    = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }), { 'i', 'c' }),
    ['<Up>']      = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }), { 'i', 'c' }),
    ['<C-b>']     = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>']     = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>']     = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>']     = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>']      = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

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
    priority_weight = 2,
    -- comparators = {
    --   cmp_compare.recently_used,
    --   cmp_compare.offset,
    --   cmp_compare.exact,
    --   cmp_compare.score,
    --   cmp_compare.kind,
    --   cmp_compare.sort_text,
    --   cmp_compare.length,
    --   cmp_compare.order,
    -- },
  },

  sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'nvim_lua' },
  { name = 'cmp_git' },
  { name = 'zsh' },
  { name = 'cmp_git' },
  { name = 'zsh' },
  { name = 'path' },
  }, {
    { name = 'buffer' },
    }),

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

  experimental = {
    ghost_text = false,
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
  { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
    })
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
  { name = 'path' }
  }, {
    { name = 'cmdline' }
    })
})

cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})
