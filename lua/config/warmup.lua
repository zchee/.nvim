-- Cooperative insert-stack warmup (round-2 plan R2).
--
-- Round 1 moved blink.cmp and its whole dependency stack onto a single
-- synchronous first-InsertEnter load, which the r0 baseline measured as a
-- 40-50 ms stall. This module retires that stall off the interactive path:
-- starting at UIEnter + delay_ms it works through M.units one unit per
-- event-loop tick (spaced by a 1 ms timer so the loop breathes between
-- units), so no single main-thread stall exceeds one frame, and
-- aborts the moment a real InsertEnter fires -- the normal lazy path then
-- owns the load, and lazy.load on an already-loaded plugin is a no-op, so
-- nothing double-configures in either race direction. UIEnter never fires
-- in --headless sessions, so specs and scripts see no behavior change
-- unless they run a UI (pty) session on purpose.
--
-- Two plugin loads are too heavy for one frame on their own, so they are
-- sub-chunked (measured on the r0 machine):
--   * copilot.lua (~30-68 ms): almost all of it is copilot.setup()
--     synchronously waiting on `node --version` (copilot.lsp.nodejs caches
--     it in node_version). A prewarm unit runs that probe through async
--     vim.system and seeds the cache; the copilot tick gates on the seed.
--   * blink.cmp (~19-21 ms): mostly require()s of blink.cmp/luasnip/
--     autopairs modules inside plugins/blink.lua. Prewarm units pull those
--     module graphs in earlier ticks, leaving the setup() calls.

local M = {}

-- Quiet window between UIEnter and the first tick.
M.delay_ms = 800

-- Per-unit tick cost of the last run, unit name -> ms. Diagnostic only
-- (read by perf probes and humans), never consulted at runtime.
M.tick_ms = {}

-- State of the armed/running warmup ({ aborted, index, done }), published
-- for probes and specs; nil until UIEnter arms it.
M.state = nil

--- Appends one plugin name to the harness tag list. vim.g values are copies,
--- so the table must be re-assigned whole, never mutated in place.
---@param name string
function M.tag(name)
  local tagged = vim.g.warmup_loaded or {}
  tagged[#tagged + 1] = name
  vim.g.warmup_loaded = tagged
end

--- Requires modules of a not-yet-loaded lazy plugin WITHOUT triggering
--- lazy.nvim's module autoloader, which would otherwise load the whole
--- plugin -- config included -- inside this tick. The autoloader sits at
--- package.loaders[3], ahead of the package.path searcher, so it is swapped
--- for a no-op while the plugin's lua/ dir fronts package.path; the requires
--- then resolve as plain files (their intra-plugin requires too), and the
--- later lazy.load tick pays only for code not already in package.loaded.
--- Modules of plugins already loaded resolve off the rtp as usual.
---@param plugin_name string lazy plugin name
---@param mods string[] module names to require
local function prerequire(plugin_name, mods)
  local lazy_config = package.loaded["lazy.core.config"]
  local lazy_loader = package.loaded["lazy.core.loader"]
  local plugin = lazy_config and lazy_config.plugins[plugin_name]
  if not plugin or (plugin._ and plugin._.loaded) then
    return
  end
  local saved_path = package.path
  package.path = table.concat({
    plugin.dir .. "/lua/?.lua",
    plugin.dir .. "/lua/?/init.lua",
    package.path,
  }, ";")
  local autoload_index
  if lazy_loader then
    for i, loader in ipairs(package.loaders) do
      if loader == lazy_loader.loader then
        autoload_index = i
        break
      end
    end
  end
  if autoload_index then
    package.loaders[autoload_index] = function() end
  end
  for _, mod in ipairs(mods) do
    local before = {}
    for name in pairs(package.loaded) do
      before[name] = true
    end
    if not pcall(require, mod) then
      -- A failed require (Lua 5.1 semantics) leaves a userdata sentinel in
      -- package.loaded for every module that was mid-load, and any later
      -- require of those names dies with "loop or previous error" -- which
      -- would break the plugin's REAL config. Clear the poison; completed
      -- modules (tables/functions) stay cached.
      for name, value in pairs(package.loaded) do
        if not before[name] and type(value) == "userdata" then
          package.loaded[name] = nil
        end
      end
    end
  end
  if autoload_index then
    package.loaders[autoload_index] = lazy_loader.loader
  end
  package.path = saved_path
end

-- copilot.setup() blocks on `node --version` (copilot.lsp.nodejs caches the
-- result in node_version). This seed runs the same probe through async
-- vim.system and fills that cache off the main thread; the copilot unit's
-- gate waits for done (bounded by its gate_timeout_ms, after which the tick
-- proceeds and eats the synchronous probe -- slower, never wrong).
local seed = { done = false }

local function seed_copilot_node()
  prerequire("copilot.lua", { "copilot.lsp.nodejs" })
  local nodejs = package.loaded["copilot.lsp.nodejs"]
  if not nodejs or nodejs.node_version then
    seed.done = true
    return
  end
  local node = require("util").homebrew_binary("node", "node")
  local ok = pcall(vim.system, { node, "--version" }, { text = true }, function(result)
    -- may run in a fast event context: plain Lua field writes only
    local version = result.stdout and result.stdout:match("^v(%S+)")
    local major = version and tonumber(version:match("^(%d+)%."))
    if result.code == 0 and major and major >= 22 then
      -- matches the cache copilot's own get_node_version() would set; a
      -- too-old or unparsable node stays unseeded so copilot's synchronous
      -- path re-probes and reports its usual error
      nodejs.node_version = version
    end
    seed.done = true
  end)
  if not ok then
    seed.done = true
  end
end

---@class WarmupUnit
---@field name string tick label for tick_ms
---@field plugin string? lazy plugin to load (and tag) in this tick
---@field prewarm fun()? cache-warming work run under pcall (never fatal)
---@field gate (fun(): boolean)? tick waits (10 ms defers) until true
---@field gate_timeout_ms integer? bound on the gate wait (default 500)

-- One unit per tick. Plugin units keep the stack's dependency order
-- (leaves first) so the final blink.cmp tick pays only for its own config.
---@type WarmupUnit[]
M.units = {
  { name = "mini.icons", plugin = "mini.icons" },
  { name = "LuaSnip", plugin = "LuaSnip" },
  { name = "blink.lib", plugin = "blink.lib" },
  { name = "copilot-node-seed", prewarm = seed_copilot_node },
  {
    name = "vim.lsp",
    prewarm = function()
      -- copilot.client pulls the whole vim.lsp stack; also useful overlap
      -- while the node probe runs
      require("vim.lsp")
    end,
  },
  {
    name = "copilot.lua",
    plugin = "copilot.lua",
    gate = function()
      return seed.done
    end,
  },
  { name = "blink-copilot", plugin = "blink-copilot" },
  { name = "nvim-autopairs", plugin = "nvim-autopairs" },
  {
    name = "insert-modules",
    prewarm = function()
      -- plugins/blink.lua (and the snippet loader it calls) require these;
      -- their plugins are loaded by the ticks above, so these are plain rtp
      -- requires. The luasnip.* set is what from_lua.load() pulls in.
      require("luasnip")
      require("nvim-autopairs")
      require("nvim-autopairs.rule")
      require("nvim-autopairs.ts-conds")
      require("luasnip.loaders.from_lua")
      require("luasnip.loaders.util")
      require("luasnip.nodes.snippet")
      require("luasnip.util.jsregexp")
      require("luasnip.extras.fmt")
    end,
  },
  {
    name = "blink-modules-1",
    prewarm = function()
      -- blink.cmp's import graph plus the light submodules its setup()
      -- requires. The fuzzy/native modules are deliberately NOT here: they
      -- load the Rust matcher, which only resolves at real plugin load.
      prerequire("blink.cmp", {
        "blink.cmp",
        "blink.cmp.keymap",
        "blink.cmp.highlights",
        "blink.cmp.sources.lib",
      })
    end,
  },
  {
    name = "blink-modules-2",
    prewarm = function()
      -- the completion/signature subsystems setup() wires up
      prerequire("blink.cmp", {
        "blink.cmp.completion",
        "blink.cmp.signature",
        "blink.cmp.completion.windows.menu",
        "blink.cmp.fuzzy",
      })
    end,
  },
  { name = "blink.cmp", plugin = "blink.cmp" },
}

-- The plugin subset of M.units in order; the terminal entry doubles as the
-- "lazy path already won" short-circuit check.
---@type string[]
M.order = {}
for _, unit in ipairs(M.units) do
  if unit.plugin then
    M.order[#M.order + 1] = unit.plugin
  end
end

---@class WarmupDeps
---@field load fun(name: string) loads one plugin, running its config
---@field is_loaded fun(name: string): boolean
---@field schedule fun(fn: function) queues the next tick
---@field defer fun(fn: function, ms: integer) re-checks a gated tick later
---@field tag fun(name: string) records a plugin this warmup loaded

---@return WarmupDeps
local function real_deps()
  local lazy = require("lazy")
  local plugins = require("lazy.core.config").plugins
  return {
    load = function(name)
      lazy.load({ plugins = { name } })
    end,
    is_loaded = function(name)
      local plugin = plugins[name]
      return plugin ~= nil and plugin._ ~= nil and plugin._.loaded ~= nil
    end,
    schedule = function(fn)
      -- NOT vim.schedule: queued schedule callbacks drain as one batch, so
      -- back-to-back ticks would coalesce into a single main-thread stall
      -- (measured 23-28 ms against the 16 ms jitter budget). A 1 ms timer
      -- re-enters through the loop's timer phase, letting input, redraw,
      -- and other timers run between ticks.
      vim.defer_fn(fn, 1)
    end,
    defer = vim.defer_fn,
    tag = M.tag,
  }
end

--- Runs the warmup: one unit per scheduled tick, checking the abort flag
--- and the terminal plugin at the top of every tick. Deps and units are
--- injectable so specs can drive the scheduler synchronously.
---@param deps WarmupDeps
---@param state { aborted: boolean, index: integer, done: boolean?, error: string?, gate_deadline: integer? }
---@param units WarmupUnit[]?
---@return table state
function M.run(deps, state, units)
  units = units or M.units
  local last = M.order[#M.order]
  local function tick()
    -- InsertEnter fired, or the lazy path already brought the stack in:
    -- everything this warmup would load is loaded (or about to be), stop.
    if state.aborted or deps.is_loaded(last) then
      state.done = true
      return
    end
    local unit = units[state.index]
    if unit == nil then
      state.done = true
      return
    end
    if unit.gate then
      local now = vim.uv.hrtime()
      if not state.gate_deadline then
        state.gate_deadline = now + (unit.gate_timeout_ms or 500) * 1e6
      end
      if not unit.gate() and now < state.gate_deadline then
        deps.defer(tick, 10) -- idle wait, no main-thread work this tick
        return
      end
      state.gate_deadline = nil
    end
    state.index = state.index + 1
    if unit.plugin then
      if not deps.is_loaded(unit.plugin) then
        local t0 = vim.uv.hrtime()
        local ok, err = pcall(deps.load, unit.plugin)
        M.tick_ms[unit.name] = (vim.uv.hrtime() - t0) / 1e6
        if not ok then
          state.aborted = true
          state.error = tostring(err)
          vim.notify(string.format("config.warmup: loading %s failed: %s", unit.plugin, err), vim.log.levels.WARN)
          return
        end
        -- Tag only what this warmup actually brought in; a plugin the burst
        -- or lazy path loaded stays attributed to them.
        if deps.is_loaded(unit.plugin) then
          deps.tag(unit.plugin)
        end
      end
    elseif unit.prewarm then
      local t0 = vim.uv.hrtime()
      pcall(unit.prewarm) -- prewarm is an optimization; failure is never fatal
      M.tick_ms[unit.name] = (vim.uv.hrtime() - t0) / 1e6
    end
    deps.schedule(tick)
  end
  tick()
  return state
end

--- Arms the warmup on UIEnter. The InsertEnter abort autocmd is registered
--- before the timer starts, so an insert that beats the delay (or lands
--- between ticks) always hands the load to the normal lazy path.
---@param deps WarmupDeps? spec injection point; defaults to lazy.nvim
function M.setup(deps)
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      local state = { aborted = false, index = 1 }
      M.state = state
      vim.api.nvim_create_autocmd("InsertEnter", {
        once = true,
        callback = function()
          state.aborted = true
        end,
      })
      vim.defer_fn(function()
        if state.aborted then
          state.done = true
          return
        end
        M.run(deps or real_deps(), state)
      end, M.delay_ms)
    end,
  })
end

return M
