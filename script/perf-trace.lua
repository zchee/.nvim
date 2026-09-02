-- Perfetto/Chrome trace-event exporter (round-3.5 plan item 2).
--
--   nvim -l script/perf-trace.lua [--out <trace.json>] [--startuptime <log>]
--                                 [--ui-latency <json>]
--
-- Merges one full-config startup into a single Chrome trace-event JSON
-- timeline: view it by opening https://ui.perfetto.dev and dragging the
-- output file onto the page (chrome://tracing also reads it).
--
-- `nvim -l` script mode never loads the user config, so this script is
-- two-phase: the driver (this mode) spawns one full-config child
-- (`nvim --headless --startuptime <tmp>`) that re-runs this same file as a
-- probe (selected by the vim.g.perf_trace_dump sentinel). The child fires
-- UIEnter manually -- headless sessions never fire it -- to arm
-- config.warmup, waits for the warmup to finish (bounded), then dumps
-- lazy.nvim and warmup data as JSON and quits. The driver merges that dump
-- with the --startuptime log into trace events. --startuptime <log>
-- substitutes an existing log for the child's own (the child still runs,
-- because lazy/warmup data only exist in-process).
--
-- Event mapping (times in the log are msec floats; trace ts/dur are µs):
--   * sourcing lines "clock self+sourced self: <label>" become ph="X"
--     complete events on tid 1 with ts = clock - self+sourced and
--     dur = self+sourced, so nested sourcing renders as nested slices.
--   * phase lines "clock elapsed: <label>" become ph="X" events on tid 2
--     with ts = clock - elapsed and dur = elapsed (each measures the time
--     since the previous startup event, i.e. a contiguous phase, so a
--     slice is truer than an instant).
--   * lazy.nvim: one "lazy startup" slice (LazyStart..LazyDone) plus one
--     ph="i" UIEnter instant; per-plugin load times come from
--     plugin._.loaded.time, which is a duration in NANOSECONDS (verified
--     on lazy.nvim 11.x here: {plugin|event=<trigger>, time=<ns>}; see
--     also script/perf-report.sh dividing it by 1e6). lazy records no
--     start timestamps, so plugin slices are laid end-to-end -- burst
--     (untagged) plugins on tid 3 from LazyStart, warmup-tagged ones
--     (vim.g.warmup_loaded) on tid 4 from UIEnter + warmup delay -- and
--     are therefore APPROXIMATE placements with real durations.
--   * warmup ticks (config.warmup M.tick_ms, unit order from M.units):
--     end-to-end ph="X" slices on tid 5 starting at UIEnter + M.delay_ms.
--     tick_ms holds durations only, so placement is approximate; the
--     thread_name metadata says so.
--   * --ui-latency <json> (script/ui-latency.lua --json output): each
--     event (attach flush, insert, keystrokes) becomes a ph="X" slice on
--     tid 6 at its REAL sent_ms offset with dur = latency_ms. The embed
--     client is a separate session, so tid 6 is its own timeline (t0 =
--     embed spawn, not this startup's origin); the track name says so.
--   * ph="M" process_name/thread_name metadata label every track.
--
-- Nesting repair (round-4 V0.2): reconstructed starts can partially
-- overlap on a tid -- the log's phase windows overlap by 1 µs at ms
-- precision, and end-to-end chains can overshoot their container slice --
-- which trace_processor reports as slice_spill_overlapping_complete_event
-- and renders on ambiguous overflow tracks. Before the final sort, a
-- per-tid sweep shifts any slice that pokes out of a still-open slice
-- forward to that slice's end (duration preserved, shift recorded in
-- args.ts_shift_us), so every pair of slices is nested or disjoint and
-- the import stat stays 0.
--
-- Every event carries args.source ("startuptime" | "lazy" | "warmup") so
-- consumers can filter by origin; tests/perf/trace_export_spec.lua pins
-- the whole contract.

local CHILD_DEADLINE_MS = 25000
local CHILD_SETTLE_MS = 500

local TID = {
  sourcing = 1,
  phases = 2,
  burst = 3,
  warmup_plugins = 4,
  warmup_ticks = 5,
  ui_latency = 6,
}

--------------------------------------------------------------------------
-- Child probe mode: runs inside the full-config nvim spawned by the driver.
--------------------------------------------------------------------------
if vim.g.perf_trace_dump then
  local dump_path = vim.g.perf_trace_dump

  local function dump_and_quit()
    local payload = { plugins = {}, ticks = {}, warmup_loaded = vim.g.warmup_loaded or {} }
    local ok_stats, lazy = pcall(require, "lazy")
    if ok_stats then
      payload.stats = lazy.stats()
    end
    local ok_cfg, lazy_config = pcall(require, "lazy.core.config")
    if ok_cfg then
      for name, plugin in pairs(lazy_config.plugins) do
        local loaded = plugin._ and plugin._.loaded
        if loaded and loaded.time then
          local reason = {}
          for key, value in pairs(loaded) do
            if key ~= "time" then
              reason[key] = tostring(value)
            end
          end
          payload.plugins[#payload.plugins + 1] = { name = name, time_ns = loaded.time, reason = reason }
        end
      end
    end
    local warmup = package.loaded["config.warmup"]
    if warmup then
      payload.warmup_delay_ms = warmup.delay_ms
      -- tick_ms is a name -> ms map with no order; M.units carries the
      -- execution order, so the dump preserves it as an array.
      for _, unit in ipairs(warmup.units or {}) do
        local ms = warmup.tick_ms[unit.name]
        if ms then
          payload.ticks[#payload.ticks + 1] = { name = unit.name, ms = ms }
        end
      end
    end
    local f = assert(io.open(dump_path, "w"))
    f:write(vim.json.encode(payload))
    f:close()
    vim.cmd("qa!")
  end

  -- Headless sessions never fire UIEnter, so config.warmup never arms;
  -- fire it manually to run the real warmup path in this child.
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("UIEnter", {})
  end)

  local deadline = vim.uv.hrtime() + CHILD_DEADLINE_MS * 1e6
  local poll = assert(vim.uv.new_timer())
  poll:start(
    200,
    200,
    vim.schedule_wrap(function()
      local warmup = package.loaded["config.warmup"]
      local warmup_done = warmup == nil or (warmup.state ~= nil and warmup.state.done)
      if warmup_done or vim.uv.hrtime() >= deadline then
        poll:stop()
        poll:close()
        vim.defer_fn(dump_and_quit, CHILD_SETTLE_MS)
      end
    end)
  )
  return
end

--------------------------------------------------------------------------
-- Driver mode: `nvim -l script/perf-trace.lua ...`
--------------------------------------------------------------------------
local out_path = "perf-trace.json"
local user_log
local ui_latency_path
do
  local args = _G.arg or {}
  local i = 1
  while i <= #args do
    if args[i] == "--out" and args[i + 1] then
      out_path = args[i + 1]
      i = i + 2
    elseif args[i] == "--startuptime" and args[i + 1] then
      user_log = args[i + 1]
      i = i + 2
    elseif args[i] == "--ui-latency" and args[i + 1] then
      ui_latency_path = args[i + 1]
      i = i + 2
    else
      io.stderr:write(("perf-trace: unknown argument %q\n"):format(tostring(args[i])))
      os.exit(2)
    end
  end
end

local function fail(msg)
  io.stderr:write("perf-trace: " .. msg .. "\n")
  os.exit(1)
end

-- Spawn the full-config child (this same file in probe mode).
local self_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p")
local child_log = vim.fn.tempname() .. "-startuptime.log"
local dump_path = vim.fn.tempname() .. "-perf-trace-dump.json"
-- Full-config child sessions write ShaDa on exit, and a round runs dozens of
-- them: they race for the main.shada.tmp.a-z namespace and any child killed
-- mid-write strands a temp file, until all 26 are taken and every later write
-- fails with E138 (the user's interactive nvim included). Point the child at a
-- throwaway copy instead -- seeded from the real file so its read cost stays
-- representative, empty (-i NONE) when there is nothing to copy.
local function throwaway_shada()
  local real = vim.fs.joinpath(tostring(vim.fn.stdpath("state")), "shada", "main.shada")
  if not vim.uv.fs_stat(real) then
    return "NONE"
  end
  local copy = vim.fn.tempname() .. ".shada"
  local ok = vim.uv.fs_copyfile(real, copy)
  return ok and copy or "NONE"
end

local cmd = { vim.v.progpath, "--headless", "-i", throwaway_shada() }
if not user_log then
  vim.list_extend(cmd, { "--startuptime", child_log })
end
vim.list_extend(cmd, {
  "--cmd",
  string.format("lua vim.g.perf_trace_dump=%q", dump_path),
  "-c",
  "luafile " .. vim.fn.fnameescape(self_path),
})
local result = vim.system(cmd, { text = true }):wait(CHILD_DEADLINE_MS + 20000)
if result.code ~= 0 then
  fail(("full-config child exited %d: %s"):format(result.code, result.stderr or ""))
end

local dump_file = assert(io.open(dump_path, "r"), "perf-trace: child wrote no dump at " .. dump_path)
local dump = vim.json.decode(dump_file:read("*a"))
dump_file:close()
os.remove(dump_path)

--------------------------------------------------------------------------
-- Build trace events.
--------------------------------------------------------------------------
local events = {}
local counts = { startuptime = 0, lazy = 0, warmup = 0, ui_latency = 0 }

local function us(ms)
  return math.floor(ms * 1000 + 0.5)
end

---@param source string
---@param event table
local function emit(source, event)
  event.pid = 1
  event.args = event.args or {}
  event.args.source = source
  counts[source] = counts[source] + 1
  events[#events + 1] = event
end

-- 1. --startuptime log.
local log_path = user_log or child_log
local log = assert(io.open(log_path, "r"), "perf-trace: cannot open startuptime log " .. log_path)
for line in log:lines() do
  -- "clock self+sourced self: label" (sourcing/require) before the
  -- two-number form, which would also match its prefix.
  local clock, total, self_ms, label = line:match("^(%d+%.%d+)%s+(%d+%.%d+)%s+(%d+%.%d+): (.+)$")
  if clock then
    emit("startuptime", {
      name = label,
      ph = "X",
      tid = TID.sourcing,
      ts = math.max(0, us(tonumber(clock) - tonumber(total))),
      dur = us(tonumber(total)),
      args = { self_ms = tonumber(self_ms) },
    })
  else
    -- "clock elapsed: label" (phase line; elapsed = time since the
    -- previous startup event).
    local pclock, elapsed, plabel = line:match("^(%d+%.%d+)%s+(%d+%.%d+): (.+)$")
    if pclock then
      emit("startuptime", {
        name = plabel,
        ph = "X",
        tid = TID.phases,
        ts = math.max(0, us(tonumber(pclock) - tonumber(elapsed))),
        dur = us(tonumber(elapsed)),
      })
    end
  end
end
log:close()
if not user_log then
  os.remove(child_log)
end

-- 2. lazy.nvim: startup slice, UIEnter instant, per-plugin load slices.
local stats = dump.stats or {}
local times = stats.times or {}
local uienter_ms = times.UIEnter or stats.startuptime or 0
if times.LazyStart and times.LazyDone then
  emit("lazy", {
    name = "lazy.nvim startup (LazyStart..LazyDone)",
    ph = "X",
    tid = TID.burst,
    ts = us(times.LazyStart),
    dur = us(times.LazyDone - times.LazyStart),
    args = { startuptime_ms = stats.startuptime, loaded = stats.loaded, count = stats.count },
  })
end
emit("lazy", {
  name = "UIEnter",
  ph = "i",
  s = "p",
  tid = TID.burst,
  ts = us(uienter_ms),
})

local warmup_tagged = {}
for _, name in ipairs(dump.warmup_loaded or {}) do
  warmup_tagged[name] = true
end
local warmup_start_ms = uienter_ms + (dump.warmup_delay_ms or 0)

local plugins = dump.plugins or {}
table.sort(plugins, function(a, b)
  if a.time_ns ~= b.time_ns then
    return a.time_ns > b.time_ns
  end
  return a.name < b.name
end)
-- lazy records durations only (no start timestamps), so slices are laid
-- end-to-end per track: real widths, approximate positions.
local cursor = { [TID.burst] = us(times.LazyStart or 0), [TID.warmup_plugins] = us(warmup_start_ms) }
for _, plugin in ipairs(plugins) do
  local tid = warmup_tagged[plugin.name] and TID.warmup_plugins or TID.burst
  local dur = math.floor(plugin.time_ns / 1000 + 0.5)
  emit("lazy", {
    name = plugin.name,
    ph = "X",
    tid = tid,
    ts = cursor[tid],
    dur = dur,
    args = { reason = plugin.reason, load_ms = plugin.time_ns / 1e6 },
  })
  cursor[tid] = cursor[tid] + dur
end

-- 3. warmup ticks: durations from tick_ms in M.units order, laid
-- end-to-end from UIEnter + delay_ms (no absolute tick timestamps exist).
local tick_ts = us(warmup_start_ms)
for _, tick in ipairs(dump.ticks or {}) do
  local dur = us(tick.ms)
  emit("warmup", {
    name = tick.name,
    ph = "X",
    tid = TID.warmup_ticks,
    ts = tick_ts,
    dur = dur,
    args = { tick_ms = tick.ms },
  })
  tick_ts = tick_ts + dur
end

-- 4. ui-latency events (script/ui-latency.lua --json): real positions on
-- the embed client's own timeline (t0 = embed spawn).
if ui_latency_path then
  local ui_file = assert(io.open(ui_latency_path, "r"), "perf-trace: cannot open ui-latency json " .. ui_latency_path)
  local ui = vim.json.decode(ui_file:read("*a"))
  ui_file:close()
  for _, event in ipairs(ui.events or {}) do
    emit("ui_latency", {
      name = event.name,
      ph = "X",
      tid = TID.ui_latency,
      ts = us(event.sent_ms),
      dur = us(event.latency_ms),
      args = { latency_ms = event.latency_ms, mode = ui.mode },
    })
  end
end

-- 5. Track labels. The "~" prefix marks tracks whose slice positions are
-- reconstructed from durations, not measured timestamps.
local track_names = {
  [TID.sourcing] = "startup: sourcing",
  [TID.phases] = "startup: phases",
  [TID.burst] = "lazy plugins: burst (~positions)",
  [TID.warmup_plugins] = "lazy plugins: warmup-tagged (~positions)",
  [TID.warmup_ticks] = "warmup ticks (~positions)",
  [TID.ui_latency] = "ui-latency: embed client (separate timeline)",
}
if not ui_latency_path then
  track_names[TID.ui_latency] = nil
end
events[#events + 1] = { name = "process_name", ph = "M", pid = 1, tid = 0, ts = 0, args = { name = "nvim startup" } }
for tid, name in pairs(track_names) do
  events[#events + 1] = { name = "thread_name", ph = "M", pid = 1, tid = tid, ts = 0, args = { name = name } }
end

-- Nesting repair: on each tid, sweep X slices in (ts, -dur) order with a
-- stack of open slice ends; a slice that pokes out of a still-open slice
-- shifts forward to that slice's end (re-checked against the whole stack,
-- so cascaded shifts stay proper). Durations are never touched.
local function enforce_nesting(evts)
  local by_tid = {}
  for _, event in ipairs(evts) do
    if event.ph == "X" then
      local list = by_tid[event.tid]
      if not list then
        list = {}
        by_tid[event.tid] = list
      end
      list[#list + 1] = event
    end
  end
  for _, list in pairs(by_tid) do
    table.sort(list, function(a, b)
      if a.ts ~= b.ts then
        return a.ts < b.ts
      end
      return (a.dur or 0) > (b.dur or 0)
    end)
    local open_ends = {}
    for _, event in ipairs(list) do
      local ts, dur = event.ts, event.dur or 0
      while true do
        while #open_ends > 0 and open_ends[#open_ends] <= ts do
          open_ends[#open_ends] = nil
        end
        if #open_ends > 0 and ts + dur > open_ends[#open_ends] then
          ts = open_ends[#open_ends]
        else
          break
        end
      end
      if ts ~= event.ts then
        event.args = event.args or {}
        event.args.ts_shift_us = ts - event.ts
        event.ts = ts
      end
      open_ends[#open_ends + 1] = ts + dur
    end
  end
end
enforce_nesting(events)

-- Global ts order makes every per-tid subsequence non-decreasing; equal-ts
-- slices sort wider-first so parents precede their children.
table.sort(events, function(a, b)
  if a.ts ~= b.ts then
    return a.ts < b.ts
  end
  return (a.dur or 0) > (b.dur or 0)
end)

local body = vim.json.encode({ traceEvents = events, displayTimeUnit = "ms" })
local out = assert(io.open(out_path, "w"), "perf-trace: cannot write " .. out_path)
out:write(body)
out:close()

print(
  ("perf-trace: wrote %s (%d events: %d startuptime, %d lazy, %d warmup, %d ui-latency)"):format(
    out_path,
    #events,
    counts.startuptime,
    counts.lazy,
    counts.warmup,
    counts.ui_latency
  )
)
