local npairs = require("nvim-autopairs")
local npairs_rule = require('nvim-autopairs.rule')
local ts_conds = require('nvim-autopairs.ts-conds')
local remap = vim.api.nvim_set_keymap

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

-- go
npairs.add_rules({
  npairs_rule('"', "'", "'", "go"):with_pair(ts_conds.is_ts_node({ "string" })),
  npairs_rule("'", '"', '"', "go"):with_pair(ts_conds.is_ts_node({ "string" })),
})

-- lua
npairs.add_rules({
  npairs_rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
  npairs_rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
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

remap("i", "<BS>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
remap("i", "<CR>", "v:lua.MUtils.CR()", { expr = true, noremap = true })
remap("i", "<ESC>", [[pumvisible() ? "<C-e><ESC>" : "<ESC>"]], { expr = true, noremap = true })
remap("i", "<Tab>", [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true, noremap = true })
remap("i", "<S-Tab>", [[pumvisible() ? "<C-p>" : "<BS>"]], { expr = true, noremap = true })
remap("i", "<C-c>", [[pumvisible() ? "<C-e><C-c>" : "<C-c>"]], { expr = true, noremap = true })
remap("i", "<C-u>", "pumvisible() ? '<C-e><C-u>' : '<C-u>'", { expr = true, noremap = true })
remap("i", "<C-w>", "pumvisible() ? '<C-e><C-w>' : '<C-w>'", { expr = true, noremap = true })
