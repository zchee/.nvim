-- Loaded from the LuaSnip spec's config in lua/plugins/init.lua.
--
-- Split out of plugins/blink.lua (round-3 plan W1.2) so the warmup's LuaSnip
-- tick pays for setup instead of the terminal blink.cmp tick. Attached to
-- the plugin's own spec config, the pure-lazy InsertEnter dependency chain
-- runs the exact same code, so both load paths stay identical.
local ls = require("luasnip")
local ls_loader_lua = require("luasnip.loaders.from_lua")

local M = {}

local snippet_root = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "lua", "luasnippets")

-- Registering the whole collection costs ~6-8 ms -- the 8 ms warmup tick
-- budget with nothing else in the tick -- and go.lua alone (28 snippets)
-- costs as much as every other snippet file combined. So the scan is two
-- half-collections over the same root, disjoint by filetype, each its own
-- warmup tick (W1.2 fallback clause); the lazy path runs both back-to-back,
-- which is exactly the single-scan cost it always paid. include/exclude use
-- the same ft list, so a snippet file added later lands in the exclude half
-- automatically.
local first_half_fts = { "go" }

local halves = {
  { done = false, opts = { include = first_half_fts } },
  { done = false, opts = { exclude = first_half_fts } },
}

--- Registers one half of the lua/luasnippets collection; every caller past
--- the first is a no-op, so each half registers exactly once on every path.
---@param index integer 1 or 2
function M.load_snippets_half(index)
  local half = halves[index]
  if half.done then
    return
  end
  half.done = true
  --- @type LuaSnip.Loaders.LoadOpts
  ls_loader_lua.load(vim.tbl_extend("force", {
    lazy_paths = { snippet_root },
    fs_event_providers = {
      libuv = true,
    },
  }, half.opts))
end

--- Registers whatever is still missing of the collection (both halves).
function M.load_snippets()
  M.load_snippets_half(1)
  M.load_snippets_half(2)
end

ls.setup({
  region_check_events = "InsertEnter",
  history = true,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})

-- A live warmup run owns the scan: its luasnip-snippets tick (right after
-- this config's tick) calls load_snippets, keeping this tick to setup()
-- cost. Every other loader -- the pure-lazy InsertEnter chain, headless
-- sessions where UIEnter never arms the warmup, a warmup already settled --
-- scans inline. The warmup-abort race (insert lands after this tick but
-- before the snippets tick) is covered by plugins/blink.lua calling
-- load_snippets as an idempotent safety net at the end of either chain.
local warmup = package.loaded["config.warmup"]
local warmup_owns_scan = warmup ~= nil
  and warmup.state ~= nil
  and not warmup.state.done
  and not warmup.state.aborted
if not warmup_owns_scan then
  M.load_snippets()
end

return M
