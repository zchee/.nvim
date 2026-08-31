-- Warmup chunker spec (round-2 plan R2.3d).
--
-- lua/config/warmup.lua -- the cooperative insert-stack warmup: unit/plugin
-- order, one-load-per-scheduled-tick discipline, the InsertEnter abort flag,
-- the already-loaded skip/stop paths (idempotency), gate deferral and
-- timeout, non-fatal prewarm units, tagging into vim.g.warmup_loaded, and
-- the UIEnter arming. All deps (lazy.load, is_loaded, the scheduler, the
-- tagger) are injected recorders, so this is headless-safe and loads no
-- real plugin.
--
-- Run from the repo root: nvim --headless -u NONE -l tests/perf/warmup_spec.lua

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local warmup = require("config.warmup")

local function assert_equal(got, want, message)
  if got ~= want then
    error(string.format("%s: got %s, want %s", message, vim.inspect(got), vim.inspect(want)))
  end
end

local function assert_deep_equal(got, want, message)
  if not vim.deep_equal(got, want) then
    error(string.format("%s: got %s, want %s", message, vim.inspect(got), vim.inspect(want)))
  end
end

--- Builds recorder deps around a mutable `loaded` set plus manual tick and
--- defer queues, so a spec drives the scheduler synchronously and can
--- observe how many loads each tick performed.
local function fake_deps(loaded)
  local rec = { loads = {}, tags = {}, queue = {}, defers = {} }
  rec.deps = {
    load = function(name)
      rec.loads[#rec.loads + 1] = name
      loaded[name] = true
    end,
    is_loaded = function(name)
      return loaded[name] == true
    end,
    schedule = function(fn)
      rec.queue[#rec.queue + 1] = fn
    end,
    defer = function(fn)
      rec.defers[#rec.defers + 1] = fn
    end,
    tag = function(name)
      rec.tags[#rec.tags + 1] = name
    end,
  }
  return rec
end

--- Runs queued ticks until the queue drains or `limit` ticks ran; asserts
--- the one-load-per-tick budget on every step.
local function drain(rec, limit)
  local steps = 0
  while #rec.queue > 0 do
    if limit and steps >= limit then
      return steps
    end
    local before = #rec.loads
    local tick = table.remove(rec.queue, 1)
    assert_equal(#rec.queue, 0, "warmup must queue at most one pending tick")
    tick()
    assert(#rec.loads - before <= 1, "a single tick must perform at most one plugin load")
    steps = steps + 1
  end
  return steps
end

-- unit/order shape: the 7-plugin insert stack in dependency order, blink.cmp
-- terminal; every unit does exactly one kind of work
do
  assert_deep_equal(
    warmup.order,
    { "mini.icons", "blink.lib", "copilot.lua", "blink-copilot", "nvim-autopairs", "LuaSnip", "blink.cmp" },
    "warmup.order must be the insert stack, leaves first, blink.cmp last"
  )
  for _, unit in ipairs(warmup.units) do
    assert(unit.name, "every unit must carry a tick label")
    assert(
      (unit.plugin ~= nil) ~= (unit.prewarm ~= nil),
      "a unit must be exactly one of plugin or prewarm: " .. unit.name
    )
  end
end

-- full run over the real units: plugins load in order, one per tick, all
-- tagged; prewarm units run under pcall (the real prewarms touch lazy/rtp
-- state that does not exist headless, which must not break the run)
do
  local rec = fake_deps({})
  local state = warmup.run(rec.deps, { aborted = false, index = 1 })
  drain(rec)
  assert_deep_equal(rec.loads, warmup.order, "plugin loads must follow warmup.order exactly")
  assert_deep_equal(rec.tags, warmup.order, "every warmup-loaded plugin must be tagged")
  assert_equal(state.done, true, "a completed run must mark itself done")
end

-- pre-aborted (InsertEnter beat the timer): zero loads
do
  local rec = fake_deps({})
  local state = warmup.run(rec.deps, { aborted = true, index = 1 })
  drain(rec)
  assert_equal(#rec.loads, 0, "an aborted warmup must not load anything")
  assert_equal(state.done, true, "an aborted warmup must still settle as done")
end

-- mid-flight abort: InsertEnter between ticks stops the remaining loads
do
  local rec = fake_deps({})
  local state = { aborted = false, index = 1 }
  local units = {}
  for _, name in ipairs(warmup.order) do
    units[#units + 1] = { name = name, plugin = name }
  end
  warmup.run(rec.deps, state, units)
  drain(rec, 2) -- first tick inline + 2 drained ticks = 3 plugins loaded
  state.aborted = true
  drain(rec)
  assert_equal(#rec.loads, 3, "an abort between ticks must stop further loads")
  assert_deep_equal(
    rec.loads,
    { warmup.order[1], warmup.order[2], warmup.order[3] },
    "the pre-abort loads must be the leading slice of the order"
  )
end

-- idempotency: plugins the burst already loaded are skipped, never re-loaded
-- or claimed by the warmup tag
do
  local rec = fake_deps({ ["mini.icons"] = true, ["LuaSnip"] = true })
  warmup.run(rec.deps, { aborted = false, index = 1 })
  drain(rec)
  assert_deep_equal(
    rec.loads,
    { "blink.lib", "copilot.lua", "blink-copilot", "nvim-autopairs", "blink.cmp" },
    "already-loaded plugins must be skipped"
  )
  assert_deep_equal(rec.tags, rec.loads, "skipped plugins must not be tagged as warmup loads")
end

-- terminal short-circuit: blink.cmp already in means the lazy path won; stop
do
  local rec = fake_deps({ ["blink.cmp"] = true })
  local state = warmup.run(rec.deps, { aborted = false, index = 1 })
  assert_equal(#rec.loads, 0, "a loaded blink.cmp must stop the warmup before any load")
  assert_equal(state.done, true, "the short-circuit must settle as done")
end

-- gate: a closed gate defers the tick without work; it reopens on the flag
-- and the unit then runs in the deferred tick
do
  local rec = fake_deps({})
  local open = false
  local units = {
    { name = "a", plugin = "a" },
    {
      name = "b",
      plugin = "b",
      gate = function()
        return open
      end,
      gate_timeout_ms = 60000,
    },
    { name = "c", plugin = "c" },
  }
  warmup.run(rec.deps, { aborted = false, index = 1 }, units)
  drain(rec)
  assert_deep_equal(rec.loads, { "a" }, "a closed gate must hold the gated unit and everything after")
  assert_equal(#rec.defers, 1, "a closed gate must re-check via defer")
  open = true
  table.remove(rec.defers, 1)()
  drain(rec)
  assert_deep_equal(rec.loads, { "a", "b", "c" }, "an opened gate must release the held units")
end

-- gate timeout: a gate that never opens falls through once its deadline
-- passes, so the warmup always completes
do
  local rec = fake_deps({})
  local units = {
    {
      name = "stuck",
      plugin = "stuck",
      gate = function()
        return false
      end,
      gate_timeout_ms = 0,
    },
  }
  local state = warmup.run(rec.deps, { aborted = false, index = 1 }, units)
  drain(rec)
  assert_deep_equal(rec.loads, { "stuck" }, "an expired gate must fall through to the unit's work")
  assert_equal(state.done, true, "the run must complete past an expired gate")
  assert_equal(#rec.defers, 0, "a zero-timeout gate must never defer")
end

-- prewarm failure is non-fatal: the run continues to the remaining units
do
  local rec = fake_deps({})
  local units = {
    { name = "a", plugin = "a" },
    {
      name = "boom",
      prewarm = function()
        error("boom")
      end,
    },
    { name = "b", plugin = "b" },
  }
  local state = warmup.run(rec.deps, { aborted = false, index = 1 }, units)
  drain(rec)
  assert_deep_equal(rec.loads, { "a", "b" }, "a throwing prewarm must not stop the run")
  assert_equal(state.done, true, "the run must complete past a throwing prewarm")
end

-- plugin load failure: abort, keep the error, load nothing further
do
  local rec = fake_deps({})
  local failing = vim.tbl_extend("force", rec.deps, {
    load = function(name)
      if name == "blink.lib" then
        error("boom")
      end
      rec.loads[#rec.loads + 1] = name
    end,
  })
  local state = { aborted = false, index = 1 }
  local saved_notify = vim.notify
  vim.notify = function() end -- the abort path warns by design; keep the pass silent
  warmup.run(failing, state)
  drain(rec)
  vim.notify = saved_notify
  assert_equal(state.aborted, true, "a failing load must abort the warmup")
  assert(state.error and state.error:find("boom", 1, true), "the abort must keep the load error")
  assert_deep_equal(rec.loads, { "mini.icons" }, "nothing after the failing plugin may load")
end

-- R2.2 tag shape: appends whole-list re-assignments into vim.g.warmup_loaded
do
  vim.g.warmup_loaded = nil
  warmup.tag("mini.icons")
  warmup.tag("LuaSnip")
  assert_deep_equal(vim.g.warmup_loaded, { "mini.icons", "LuaSnip" }, "tag must append to the vim.g list")
  vim.g.warmup_loaded = nil
end

-- W1.5 both-paths parity + per-tick budget (round-3 plan, acceptance
-- criteria 1 and 4). Two full-config headless child sessions load the
-- insert stack -- one by driving warmup.run with real deps, one via
-- lazy.load exactly as the InsertEnter chain would -- and must end in the
-- same state: identical Go quote-swap maps, autopairs BS/CR maps, snippet
-- counts, and a loaded blink.cmp. The warmup child also reports M.tick_ms;
-- every tick must fit the 8 ms budget. Wall-clock is machine-load
-- dependent, so the budget takes the per-tick MINIMUM over up to three
-- child runs (config execution cost is deterministic; load spikes are
-- not) -- a tick whose minimum still exceeds the budget regressed
-- structurally, which is exactly what this must catch (e.g. a blink.cmp
-- update moving cost from module load into setup()).
local parity_probe_source = [[
local report = { ok = true }
local run_ok, run_err = pcall(function()
  pcall(vim.lsp.enable, "gopls", false)
  if vim.g.parity_mode == "warmup" then
    local warmup = require("config.warmup")
    local lazy = require("lazy")
    local plugins = require("lazy.core.config").plugins
    local state = warmup.run({
      load = function(name)
        lazy.load({ plugins = { name } })
      end,
      is_loaded = function(name)
        local plugin = plugins[name]
        return plugin ~= nil and plugin._ ~= nil and plugin._.loaded ~= nil
      end,
      schedule = function(fn)
        vim.defer_fn(fn, 1)
      end,
      defer = vim.defer_fn,
      tag = warmup.tag,
    }, { aborted = false, index = 1 })
    vim.wait(30000, function()
      return state.done == true
    end, 10)
    if not state.done then
      error("warmup run did not complete: " .. vim.inspect(state))
    end
    report.tick_ms = warmup.tick_ms
  else
    require("lazy").load({ plugins = { "blink.cmp", "nvim-autopairs" } })
  end
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = "go"
  vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
  local ls = require("luasnip")
  report.quote_desc = vim.fn.maparg('"', "i", false, true).desc
  report.apos_desc = vim.fn.maparg("'", "i", false, true).desc
  report.has_bs = vim.fn.maparg("<BS>", "i") ~= ""
  report.has_cr = vim.fn.maparg("<CR>", "i") ~= ""
  report.snips_go = #ls.get_snippets("go")
  report.snips_all = #ls.get_snippets("all")
  report.blink_loaded = package.loaded["blink.cmp"] ~= nil
end)
if not run_ok then
  report.ok = false
  report.err = tostring(run_err)
end
local f = assert(io.open(vim.g.parity_out, "w"))
f:write(vim.json.encode(report))
f:close()
vim.cmd("qa!")
]]

local parity_probe_path = vim.fn.tempname() .. "_parity.lua"
do
  local f = assert(io.open(parity_probe_path, "w"))
  f:write(parity_probe_source)
  f:close()
end

--- Runs one full-config headless child in the given mode, returns its report.
local function run_parity_child(mode)
  local out = vim.fn.tempname() .. "_parity.json"
  local job = vim.fn.jobstart({
    "nvim",
    "--headless",
    "--cmd",
    string.format("lua vim.g.parity_mode=%q vim.g.parity_out=%q", mode, out),
    "-c",
    "luafile " .. parity_probe_path,
  })
  assert(job > 0, "failed to start the " .. mode .. " parity child")
  local exited = vim.fn.jobwait({ job }, 60000)[1]
  if exited == -1 then
    vim.fn.jobstop(job)
    error(mode .. " parity child did not finish within 60s")
  end
  local f = assert(io.open(out, "r"), mode .. " parity child wrote no report")
  local body = f:read("*a")
  f:close()
  os.remove(out)
  local report = vim.json.decode(body)
  assert(report.ok, mode .. " parity child failed: " .. tostring(report.err))
  return report
end

do
  local tick_budget_ms = 8
  local warmup_report = run_parity_child("warmup")
  local lazy_report = run_parity_child("lazy")

  for _, field in ipairs({ "quote_desc", "apos_desc", "has_bs", "has_cr", "snips_go", "snips_all", "blink_loaded" }) do
    assert_equal(
      warmup_report[field],
      lazy_report[field],
      "both-paths parity: " .. field .. " must match between the warmup and lazy load paths"
    )
  end
  assert_equal(warmup_report.quote_desc, "Pair '' inside Go strings", "the Go quote-swap map must exist")
  assert_equal(warmup_report.blink_loaded, true, "blink.cmp must be loaded on both paths")
  assert(warmup_report.snips_go > 0, "go snippets must be registered on both paths")
  assert(warmup_report.snips_all > 0, "all-filetype snippets must be registered on both paths")

  -- per-tick budget: min over up to 3 warmup children; extra children run
  -- only when a tick misses on the earlier attempt (fast path: one child)
  local best = {}
  for name, ms in pairs(warmup_report.tick_ms) do
    best[name] = ms
  end
  for _ = 1, 2 do
    local over = false
    for _, ms in pairs(best) do
      if ms > tick_budget_ms then
        over = true
        break
      end
    end
    if not over then
      break
    end
    local retry = run_parity_child("warmup")
    for name, ms in pairs(retry.tick_ms) do
      if best[name] == nil or ms < best[name] then
        best[name] = ms
      end
    end
  end
  for name, ms in pairs(best) do
    assert(
      ms <= tick_budget_ms,
      string.format("warmup tick %s costs %.2f ms; the per-tick budget is %d ms (min of 3 runs)", name, ms, tick_budget_ms)
    )
  end
end

os.remove(parity_probe_path)

-- setup arming: UIEnter starts the timer; an InsertEnter before it fires
-- aborts without touching deps (headless sessions never even reach here,
-- so the autocmds are exercised via exec_autocmds)
do
  local rec = fake_deps({})
  local saved_delay = warmup.delay_ms
  warmup.delay_ms = 5
  warmup.setup(rec.deps)
  vim.api.nvim_exec_autocmds("UIEnter", {})
  vim.api.nvim_exec_autocmds("InsertEnter", {})
  vim.wait(200, function()
    return warmup.state ~= nil and warmup.state.done == true
  end)
  assert_equal(warmup.state.aborted, true, "InsertEnter before the timer must abort")
  assert_equal(#rec.loads, 0, "an aborted armed warmup must not load anything")

  -- and the undisturbed path runs to completion on the real scheduler
  local rec2 = fake_deps({})
  rec2.deps.schedule = vim.schedule
  rec2.deps.defer = vim.defer_fn
  warmup.setup(rec2.deps)
  vim.api.nvim_exec_autocmds("UIEnter", {})
  vim.wait(2000, function()
    return warmup.state ~= nil and warmup.state.done == true
  end)
  assert_equal(warmup.state.done, true, "an undisturbed armed warmup must finish")
  assert_deep_equal(rec2.loads, warmup.order, "the armed run must load the whole stack in order")
  warmup.delay_ms = saved_delay
end
