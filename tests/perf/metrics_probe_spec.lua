-- uv-metrics stall probe spec.
--
-- script/perf-report.sh's stall probe is built on
-- vim.uv.loop_configure("metrics_idle_time") (busy fraction from the idle
-- delta) and script/lib/stall_probe.lua, a prepare/check handle pair (max
-- single loop-turn stall). This spec pins the uv guarantees the busy
-- fraction relies on, and runs that same stall_probe.lua against a known
-- stall. If a nightly bump breaks any of these guarantees, the probe's
-- numbers are garbage and this spec is what says so.

local function assert_truthy(got, message)
  if not got then
    error(string.format("%s: got %s", message, vim.inspect(got)))
  end
end

-- loop_configure("metrics_idle_time") succeeds (returns 0) on this build.
local configure_rc = vim.uv.loop_configure("metrics_idle_time")
assert_truthy(
  configure_rc == 0,
  string.format("loop_configure(metrics_idle_time) must return 0, got %s", tostring(configure_rc))
)

-- metrics_idle_time accumulates (in nanoseconds) while the loop blocks in
-- the kernel poll: an idle 200 ms vim.wait must grow it.
do
  local idle0 = vim.uv.metrics_idle_time()
  vim.wait(200, function()
    return false
  end, 50)
  local delta = vim.uv.metrics_idle_time() - idle0
  assert_truthy(
    delta > 0,
    string.format("metrics_idle_time must increase across an idle 200ms wait, delta %d ns", delta)
  )
end

-- metrics_info is present and counts loop turns, so the probe's
-- loop_count/events context numbers mean something.
do
  local info = vim.uv.metrics_info()
  assert_truthy(type(info) == "table" and type(info.loop_count) == "number", "metrics_info() must return loop_count")
end

-- The prepare/check stall detector sees a synthetic 30 ms main-thread
-- busy-loop (hot spin on hrtime inside a timer callback, which runs
-- between one turn's check and the next turn's prepare) as >= 25 ms.
do
  local stall_probe = dofile(vim.fs.joinpath(vim.fn.getcwd(), "script", "lib", "stall_probe.lua"))
  local stall = { max_ms = -1 }
  local stop_probe = stall_probe(stall)

  local stalled = false
  vim.defer_fn(function()
    local deadline = vim.uv.hrtime() + 30e6
    while vim.uv.hrtime() < deadline do
    end
    stalled = true
  end, 50)

  vim.wait(2000, function()
    return stalled and stall.max_ms >= 25
  end, 10)

  stop_probe()

  assert_truthy(stalled, "the synthetic 30ms busy-loop never ran")
  assert_truthy(
    stall.max_ms >= 25,
    string.format("a 30ms busy-loop must register as a >=25ms loop-turn stall, got %.2f ms", stall.max_ms)
  )
end
