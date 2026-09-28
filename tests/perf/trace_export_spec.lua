-- script/perf-trace.lua -- the Perfetto/Chrome trace-event exporter
-- (round-3.5 plan item 2, acceptance criterion 3). Runs the exporter
-- end-to-end (it spawns its own full-config child, so this spec's -u NONE
-- session stays clean) and pins the output contract: the file round-trips
-- through vim.json.decode, carries the trace-event top level, every event
-- has the required fields, ts values are sane microseconds, ts is
-- non-decreasing per tid, and every source (startuptime log, lazy.nvim,
-- warmup ticks, and the --ui-latency ingestion fed by a real
-- script/ui-latency.lua --json run) contributed at least one event.
-- Durations are never asserted -- wall-clock numbers belong to
-- script/perf-report.sh. Every pair of complete slices on a tid must be
-- nested or disjoint (checked here, and on a synthetic case that defeated
-- the first nesting sweep); when util.prefix("perfetto",
-- "trace_processor_shell") exists the trace must also import with zero
-- spilled complete events. The lazy.nvim anchors must be on the log's
-- wall-clock axis (args.clock = "wall"), not lazy.stats()'s CPU time.
--
-- Run from the repo root: nvim --headless -u NONE -l tests/perf/trace_export_spec.lua

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local function assert_truthy(value, message)
  if not value then
    error(message, 2)
  end
end

local function assert_equal(actual, expected, message)
  if actual ~= expected then
    error(("%s: expected %s, got %s"):format(message, vim.inspect(expected), vim.inspect(actual)), 2)
  end
end

--- Asserts every pair of X slices sharing a tid is nested or disjoint.
local function assert_nested_or_disjoint(events, label)
  local by_tid = {}
  for _, event in ipairs(events) do
    if event.ph == "X" then
      by_tid[event.tid] = by_tid[event.tid] or {}
      table.insert(by_tid[event.tid], event)
    end
  end
  for tid, list in pairs(by_tid) do
    for i = 1, #list do
      local a = list[i]
      for j = i + 1, #list do
        local b = list[j]
        local a_end, b_end = a.ts + a.dur, b.ts + b.dur
        local disjoint = a_end <= b.ts or b_end <= a.ts
        local nested = (a.ts <= b.ts and b_end <= a_end) or (b.ts <= a.ts and a_end <= b_end)
        assert_truthy(
          disjoint or nested,
          ("%s: tid %d slices partially overlap: %s [%d,%d] and %s [%d,%d]"):format(
            label,
            tid,
            a.name,
            a.ts,
            a_end,
            b.name,
            b.ts,
            b_end
          )
        )
      end
    end
  end
end

-- Synthetic nesting case: B pokes out of A and is shifted to A's end, past
-- C's start. The first sweep pushed B's end on the stack before visiting C,
-- so C [60,150] passed as nested in B [100,250] while it starts inside A
-- [0,100] and ends inside B -- partial overlaps with both. Durations must
-- survive the repair.
do
  local enforce_nesting = dofile(vim.fs.joinpath(vim.fn.getcwd(), "script", "lib", "trace_nesting.lua"))
  local events = {
    { name = "A", ph = "X", tid = 1, ts = 0, dur = 100 },
    { name = "B", ph = "X", tid = 1, ts = 50, dur = 150 },
    { name = "C", ph = "X", tid = 1, ts = 60, dur = 90 },
    { name = "D", ph = "X", tid = 2, ts = 10, dur = 5 },
    { name = "i", ph = "i", tid = 1, ts = 70 },
  }
  enforce_nesting(events)
  assert_nested_or_disjoint(events, "synthetic")
  local by_name = {}
  for _, event in ipairs(events) do
    by_name[event.name] = event
  end
  assert_equal(by_name.B.dur, 150, "synthetic B keeps its duration")
  assert_equal(by_name.C.dur, 90, "synthetic C keeps its duration")
  assert_equal(by_name.B.ts, 100, "synthetic B moves to A's end")
  assert_equal(by_name.B.args.ts_shift_us, 50, "synthetic B records its shift")
  assert_equal(by_name.D.ts, 10, "a slice alone on its tid is untouched")
  assert_equal(by_name.i.ts, 70, "instant events are untouched")
end

local out_path = vim.fn.tempname() .. "-trace.json"
local ui_json_path = vim.fn.tempname() .. "-ui-latency.json"

-- Real ui-latency measurement first (round-4 V0.3): the embed client's
-- --json output feeds the exporter's --ui-latency track below.
do
  local cmd = { vim.v.progpath, "-l", "script/ui-latency.lua", "--clean", "--socket-free", "--json", ui_json_path }
  local ui = vim.system(cmd, { text = true }):wait(60000)
  assert_equal(
    ui.code,
    0,
    "ui-latency exit code (stdout: " .. tostring(ui.stdout) .. ", stderr: " .. tostring(ui.stderr) .. ")"
  )
end

-- End-to-end exporter run. The exporter's own full-config child accounts
-- for most of the wall time (warmup delay + ticks + settle, ~2 s); the
-- 60 s bound only guards against a hung child.
local result
do
  local cmd = {
    vim.v.progpath,
    "-l",
    "script/perf-trace.lua",
    "--out",
    out_path,
    "--ui-latency",
    ui_json_path,
  }
  result = vim.system(cmd, { text = true }):wait(60000)
  assert_equal(
    result.code,
    0,
    "exporter exit code (stdout: " .. tostring(result.stdout) .. ", stderr: " .. tostring(result.stderr) .. ")"
  )
end

-- The file must round-trip through vim.json.decode.
local decoded
do
  local f = assert(io.open(out_path, "r"), "exporter wrote no file at " .. out_path)
  local body = f:read("*a")
  f:close()
  local ok, value = pcall(vim.json.decode, body)
  assert_truthy(ok, "output is not valid JSON: " .. tostring(value))
  decoded = value
end

-- Top-level trace-event contract.
do
  assert_equal(type(decoded), "table", "decoded top level")
  assert_equal(decoded.displayTimeUnit, "ms", "displayTimeUnit")
  assert_truthy(vim.islist(decoded.traceEvents), "traceEvents must be an array")
  assert_truthy(#decoded.traceEvents > 0, "traceEvents must not be empty")
end

-- Required fields on every event, µs sanity, per-tid ordering, sources.
do
  local last_ts_per_tid = {}
  local sources = { startuptime = 0, lazy = 0, warmup = 0, ui_latency = 0 }
  local ui_latency_tids = {}
  for i, event in ipairs(decoded.traceEvents) do
    local where = "event #" .. i .. " (" .. tostring(event.name) .. ")"
    assert_equal(type(event.name), "string", where .. " name")
    assert_equal(type(event.ph), "string", where .. " ph")
    assert_equal(type(event.ts), "number", where .. " ts")
    assert_equal(type(event.pid), "number", where .. " pid")
    assert_equal(type(event.tid), "number", where .. " tid")
    -- µs sanity: 0 <= ts < 10^9 (a run under ~17 minutes; this one runs
    -- for seconds).
    assert_truthy(event.ts >= 0 and event.ts < 1e9, where .. " ts out of µs range: " .. event.ts)
    if event.ph == "X" then
      assert_equal(type(event.dur), "number", where .. " dur (X events must have one)")
      assert_truthy(event.dur >= 0, where .. " dur must be non-negative")
    end
    local last = last_ts_per_tid[event.tid]
    assert_truthy(
      last == nil or event.ts >= last,
      ("%s: ts %d decreases on tid %d (previous %s)"):format(where, event.ts, event.tid, tostring(last))
    )
    last_ts_per_tid[event.tid] = event.ts
    local source = type(event.args) == "table" and event.args.source or nil
    if source ~= nil and sources[source] ~= nil then
      sources[source] = sources[source] + 1
    end
    if source == "ui_latency" then
      ui_latency_tids[event.tid] = true
      assert_equal(event.ph, "X", where .. " ui_latency events must be complete slices")
    end
  end
  for source, count in pairs(sources) do
    assert_truthy(count > 0, "no event from source " .. source)
  end
  -- ui-latency contract: attach + insert + 10 keystrokes, all on one
  -- dedicated track (the embed client's own timeline).
  assert_truthy(sources.ui_latency >= 12, "expected >=12 ui_latency events, got " .. sources.ui_latency)
  assert_equal(vim.tbl_count(ui_latency_tids), 1, "ui_latency events must share one tid")
  assert_nested_or_disjoint(decoded.traceEvents, "exported trace")
  print(
    ("trace_export_spec: OK %s (%d events: %d startuptime, %d lazy, %d warmup, %d ui-latency)"):format(
      out_path,
      #decoded.traceEvents,
      sources.startuptime,
      sources.lazy,
      sources.warmup,
      sources.ui_latency
    )
  )
end

-- Wall-clock anchors: the lazy.nvim slice and the UIEnter instant must sit
-- on the log's axis (the child's hrtime stamps), not lazy.stats()'s process
-- CPU time, which drifts a few ms either way. Ordering truths only, with
-- 1 ms of slack for the anchor: lazy finishes before startup ends, and the
-- UIEnter the child fires from the main loop comes after it.
do
  local lazy_slice, uienter, started
  for _, event in ipairs(decoded.traceEvents) do
    if event.name:find("^lazy%.nvim startup") then
      lazy_slice = event
    elseif event.name == "UIEnter" then
      uienter = event
    elseif event.name == "--- NVIM STARTED ---" then
      started = event
    end
  end
  assert_truthy(lazy_slice and uienter and started, "trace lacks the lazy slice, UIEnter or NVIM STARTED")
  assert_equal(lazy_slice.args.clock, "wall", "lazy slice clock (the child's anchors were not found)")
  assert_equal(uienter.args.clock, "wall", "UIEnter clock")
  local started_end = started.ts + started.dur
  assert_truthy(
    lazy_slice.ts + lazy_slice.dur <= started_end + 1000,
    ("lazy slice ends at %d us, after startup ended at %d us"):format(lazy_slice.ts + lazy_slice.dur, started_end)
  )
  assert_truthy(
    uienter.ts >= started_end - 1000,
    ("UIEnter at %d us precedes the end of startup at %d us"):format(uienter.ts, started_end)
  )
end

-- Import health (round-4 V0.2): when native Perfetto tooling is installed,
-- the trace must import with zero spilled (partially overlapping) complete
-- events -- the exporter's nesting repair guarantees it. Guarded on the
-- binary so the spec stays portable; the skip prints so it is visible.
do
  local shell = require("util").prefix("perfetto", "trace_processor_shell")
  if vim.uv.fs_stat(shell) then
    local sql_path = vim.fn.tempname() .. "-stats.sql"
    local sql = assert(io.open(sql_path, "w"))
    sql:write("SELECT value FROM stats WHERE name='slice_spill_overlapping_complete_event';\n")
    sql:close()
    local tp = vim.system({ shell, "-q", sql_path, out_path }, { text = true }):wait(60000)
    os.remove(sql_path)
    assert_equal(tp.code, 0, "trace_processor_shell exit code (stderr: " .. tostring(tp.stderr) .. ")")
    local value = tostring(tp.stdout):match("(%d+)%s*$")
    assert_truthy(value, "stats query output unparsable: " .. tostring(tp.stdout))
    assert_equal(tonumber(value), 0, "slice_spill_overlapping_complete_event")
    print("trace_export_spec: import health OK (0 overlapping complete events)")
  else
    print("trace_export_spec: NOTE " .. shell .. " not installed; import-health assertion skipped")
  end
end

os.remove(out_path)
os.remove(ui_json_path)
