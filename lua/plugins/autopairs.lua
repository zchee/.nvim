-- Loaded from the nvim-autopairs spec's config in lua/plugins/init.lua.
--
-- Split out of plugins/blink.lua (round-3 plan W1.1) so the warmup's
-- nvim-autopairs tick pays for this setup instead of piling it onto the
-- terminal blink.cmp tick. Attached to the plugin's own spec config, the
-- pure-lazy InsertEnter dependency chain runs the exact same code, so both
-- load paths stay identical.
local np = require("nvim-autopairs")
local np_rule = require("nvim-autopairs.rule")
local np_ts_conds = require("nvim-autopairs.ts-conds")

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
  np_rule("[", "]", "go"):with_pair(np_ts_conds.is_ts_node({ "string", "comment" })),
})

-- Inside a Go interpreted string the quote keys swap: `"` inserts a `''` pair
-- and `'` inserts a `""` one, because a bare `"` cannot appear there anyway.
--
-- This cannot be a Rule. autopairs_map inserts the key that was typed and only
-- appends the closing half, so no Rule can make one key produce a different
-- character -- and the built-in quote rules refuse to pair at all inside an
-- existing quote (not_add_quote_inside_quote), which is exactly where this has
-- to fire. Hence a mapping that builds the key sequence itself.
--
-- The node names come from the grammar as it stands: a cursor inside `"ab"`
-- reports interpreted_string_literal_content, and inside `""` the literal
-- itself. Neither is the plain "string" that ts_config above still names.
local go_string_nodes = {
  interpreted_string_literal = true,
  interpreted_string_literal_content = true,
}

---@param keys string
---@return string
local function esc(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

-- Per-buffer parser cache. vim.treesitter.get_parser re-resolves the
-- language from the filetype on every call -- real work on every `"`/`'`
-- keystroke -- while parse() on an up-to-date tree is nearly free, so only
-- the lookup is hoisted. `false` marks a buffer with no parser so the failed
-- lookup is not retried per keystroke. Entries drop when the parser detaches
-- and on the FileType re-map below (a filetype change replaces the parser).
---@type table<integer, vim.treesitter.LanguageTree|false>
local parser_cache = {}

---@param bufnr integer
---@return vim.treesitter.LanguageTree?
local function cached_parser(bufnr)
  local cached = parser_cache[bufnr]
  if cached ~= nil then
    return cached or nil
  end
  local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
  parser_cache[bufnr] = parser or false
  if parser then
    parser:register_cbs({
      on_detach = function()
        parser_cache[bufnr] = nil
      end,
    })
  end
  return parser
end

---@return boolean
local function in_go_string()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = cached_parser(bufnr)
  if not parser then
    return false
  end
  parser:parse()
  -- vim.treesitter.get_node() equivalent (cursor position, named node,
  -- injections ignored), minus its internal get_parser lookup.
  local pos = vim.api.nvim_win_get_cursor(0)
  local node = parser:named_node_for_range({ pos[1] - 1, pos[2], pos[1] - 1, pos[2] })
  return node ~= nil and go_string_nodes[node:type()] == true
end

---@param typed string key being pressed
---@param other string quote inserted in its place inside a string
---@return fun(): string
local function swap_quote(typed, other)
  return function()
    if not in_go_string() then
      return np.autopairs_map(vim.api.nvim_get_current_buf(), typed)
    end
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if vim.api.nvim_get_current_line():sub(col + 1, col + 1) == other then
      -- closing half already sits under the cursor: step over it
      return esc("<C-g>U<Right>")
    end
    return esc("<C-g>u") .. other .. other .. esc("<C-g>U<Left><C-g>u")
  end
end

---@param bufnr integer
local function map_go_quotes(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "go" then
    return
  end
  local opts = { buffer = bufnr, expr = true, replace_keycodes = false, noremap = true }
  vim.keymap.set("i", '"', swap_quote('"', "'"), vim.tbl_extend("force", opts, { desc = "Pair '' inside Go strings" }))
  vim.keymap.set("i", "'", swap_quote("'", '"'), vim.tbl_extend("force", opts, { desc = 'Pair "" inside Go strings' }))
end

-- nvim-autopairs re-creates its buffer-local quote maps from on_attach on every
-- FileType/BufEnter/BufWinEnter. Autocommands run in definition order, and this
-- group is defined after np.setup() registered its own, so these maps land last
-- and win. The direct call covers the buffer that triggered this lazy load,
-- whose FileType has already fired.
vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("autopairs_go_quotes", { clear = true }),
  callback = function(args)
    if args.event == "FileType" then
      parser_cache[args.buf] = nil
    end
    map_go_quotes(args.buf)
  end,
})
map_go_quotes(vim.api.nvim_get_current_buf())
