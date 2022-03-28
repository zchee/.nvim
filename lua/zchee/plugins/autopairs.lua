local npairs = require("nvim-autopairs")

npairs.setup({
  check_ts = true,
  disable_filetype = {
    "TelescopePrompt",
  },
  fast_wrap = {},
  map_bs = false,
  map_cr = false,
  ts_config = {
    lua = { "string" },
    go = { "string" },
  },
})

_G.MUtils = {}
local remap = vim.api.nvim_set_keymap
local npairs_rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")

-- go
npairs.add_rules({
  npairs_rule('"', "'", "'", 'go')
    :with_pair(ts_conds.is_ts_node({ 'string' })),
  npairs_rule("'", '"', '"', 'go')
    :with_pair(ts_conds.is_ts_node({ 'string' })),
})

-- lua
npairs.add_rules({
  npairs_rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({ "string", "comment" })),
  npairs_rule("$", "$", "lua")
    :with_pair(ts_conds.is_not_ts_node({ "function" }))
})

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
-- ms-jpq/coq_nvim default
-- remap("i", "<BS>", "pumvisible() ? "<c-e><bs>" : "<bs>"", { expr = true, noremap = true })
-- remap("i", "<CR>", "pumvisible() ? (complete_info(["selected"]).selected == -1 ? "<c-e><cr>" : "<c-y>") : "<cr>"", { expr = true, noremap = true })
remap("i", "<ESC>", [[pumvisible() ? "<C-e><ESC>" : "<ESC>"]], { expr = true, noremap = true })
remap("i", "<Tab>", [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true, noremap = true })
remap("i", "<S-Tab>", [[pumvisible() ? "<C-p>" : "<BS>"]], { expr = true, noremap = true })
remap("i", "<C-c>", [[pumvisible() ? "<C-e><C-c>" : "<C-c>"]], { expr = true, noremap = true })
-- ms-jpq/coq_nvim default
remap("i", "<C-u>", "pumvisible() ? '<C-e><C-u>' : '<C-u>'", { expr = true, noremap = true })
remap("i", "<C-w>", "pumvisible() ? '<C-e><C-w>' : '<C-w>'", { expr = true, noremap = true })
