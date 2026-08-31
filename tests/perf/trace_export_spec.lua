-- script/perf-trace.lua -- the Perfetto/Chrome trace-event exporter
-- (round-3.5 plan item 2, acceptance criterion 3). Runs the exporter
-- end-to-end (it spawns its own full-config child, so this spec's -u NONE
-- session stays clean) and pins the output contract: the file round-trips
-- through vim.json.decode, carries the trace-event top level, every event
-- has the required fields, ts values are sane microseconds, ts is
-- non-decreasing per tid, and every source (startuptime log, lazy.nvim,
-- warmup ticks) contributed at least one event. Durations are never
-- asserted -- wall-clock numbers belong to script/perf-report.sh.
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

local out_path = vim.fn.tempname() .. "-trace.json"

-- End-to-end exporter run. The exporter's own full-config child accounts
-- for most of the wall time (warmup delay + ticks + settle, ~2 s); the
-- 60 s bound only guards against a hung child.
local result
do
  local cmd = { vim.v.progpath, "-l", "script/perf-trace.lua", "--out", out_path }
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
  local sources = { startuptime = 0, lazy = 0, warmup = 0 }
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
  end
  for source, count in pairs(sources) do
    assert_truthy(count > 0, "no event from source " .. source)
  end
  print(
    ("trace_export_spec: OK %s (%d events: %d startuptime, %d lazy, %d warmup)"):format(
      out_path,
      #decoded.traceEvents,
      sources.startuptime,
      sources.lazy,
      sources.warmup
    )
  )
end

os.remove(out_path)
