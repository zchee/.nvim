-- Loaded from the LuaSnip spec's config in lua/plugins/init.lua.
--
-- Split out of plugins/blink.lua (round-3 plan W1.2) so the warmup's LuaSnip
-- tick pays for setup and the snippet-directory registration instead of the
-- terminal blink.cmp tick. Attached to the plugin's own spec config, the
-- pure-lazy InsertEnter dependency chain runs the exact same code, so both
-- load paths stay identical.
local ls = require("luasnip")
local ls_loader_lua = require("luasnip.loaders.from_lua")

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
