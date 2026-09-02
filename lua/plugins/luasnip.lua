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
-- costs as much as every other snippet file combined. Round-3 split the
-- scan into two half-collections; round-4 V3.1 narrows the eager set to
-- the daily drivers (go + the "all" set, one warmup tick each) and leaves
-- every other filetype to its own first InsertEnter via the autocmd this
-- config installs. include filters on the ft name, so a snippet file added
-- later needs no registration here -- its first InsertEnter picks it up.
M.driver_fts = { "go", "all" }

local loaded_fts = {}

--- Registers one filetype's snippet set ("all" included); every caller
--- past the first is a no-op, so each set registers exactly once on every
--- path.
---@param ft string
function M.load_snippets_ft(ft)
  if loaded_fts[ft] then
    return
  end
  loaded_fts[ft] = true
  --- @type LuaSnip.Loaders.LoadOpts
  ls_loader_lua.load({
    lazy_paths = { snippet_root },
    fs_event_providers = {
      libuv = true,
    },
    include = { ft },
  })
end

--- Registers the snippet sets of one buffer's filetype; compound "a.b"
--- filetypes register each component.
---@param buf integer
function M.load_buf_snippets(buf)
  local ft = vim.bo[buf].filetype
  if ft == "" then
    return
  end
  for part in vim.gsplit(ft, ".", { plain = true }) do
    M.load_snippets_ft(part)
  end
end

--- Registers what an interactive session needs right now: the driver sets,
--- plus the current buffer's sets -- on the pure-lazy path this runs from
--- inside the very InsertEnter that loaded the plugin, which fired before
--- the autocmd below existed, so the current buffer must be covered inline.
function M.load_snippets()
  for _, ft in ipairs(M.driver_fts) do
    M.load_snippets_ft(ft)
  end
  M.load_buf_snippets(vim.api.nvim_get_current_buf())
end

ls.setup({
  region_check_events = "InsertEnter",
  history = true,
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})

-- Non-driver filetypes register on their first InsertEnter. The autocmd is
-- installed at config time on both load paths; the one InsertEnter it can
-- miss -- the event that pulled this very config in on the pure-lazy chain
-- -- is covered by load_snippets scanning the current buffer inline from
-- plugins/blink.lua at that chain's end.
vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("luasnip_ft_snippets", { clear = true }),
  callback = function(ev)
    M.load_buf_snippets(ev.buf)
  end,
})

-- A live warmup run owns the driver scan: its luasnip-snippets ticks
-- (right after this config's tick) call load_snippets_ft per driver,
-- keeping this tick to setup() cost. Every other loader -- the pure-lazy
-- InsertEnter chain, headless sessions where UIEnter never arms the
-- warmup, a warmup already settled -- scans inline. The warmup-abort race
-- (insert lands after this tick but before the snippets ticks) is covered
-- by plugins/blink.lua calling load_snippets as an idempotent safety net
-- at the end of either chain.
local warmup = package.loaded["config.warmup"]
local warmup_owns_scan = warmup ~= nil and warmup.state ~= nil and not warmup.state.done and not warmup.state.aborted
if not warmup_owns_scan then
  M.load_snippets()
end

return M
