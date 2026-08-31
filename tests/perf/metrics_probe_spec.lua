-- uv-metrics stall probe spec (round-3.5 plan item 1, acceptance
-- criterion 2).
--
-- script/perf-report.sh embeds a stall probe built on
-- vim.uv.loop_configure("metrics_idle_time") (busy fraction from the idle
-- delta) and a prepare/check handle pair (max single loop-turn stall).
-- The probe lives in a bash heredoc and cannot be require()d, so this
-- spec pins the mechanism itself with the identical wiring: check fires
-- right after the kernel poll returns and prepare right before the next
-- poll blocks, so check -> next prepare brackets one loop turn's active
-- (non-poll) stretch. If a nightly bump breaks any of these guarantees,
-- the probe's numbers are garbage and this spec is what says so.
--
-- Run from the repo root:
--   nvim --headless -u NONE -l tests/perf/metrics_probe_spec.lua

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
  local prep = assert(vim.uv.new_prepare())
  local check = assert(vim.uv.new_check())
  local t_active
  local max_stall_ms = -1
  prep:start(function()
    if t_active then
      local gap = (vim.uv.hrtime() - t_active) / 1e6
      if gap > max_stall_ms then
        max_stall_ms = gap
      end
      t_active = nil
    end
  end)
  check:start(function()
    t_active = vim.uv.hrtime()
  end)

  local stalled = false
  vim.defer_fn(function()
    local deadline = vim.uv.hrtime() + 30e6
    while vim.uv.hrtime() < deadline do
    end
    stalled = true
  end, 50)

  vim.wait(2000, function()
    return stalled and max_stall_ms >= 25
  end, 10)

  prep:stop()
  prep:close()
  check:stop()
  check:close()

  assert_truthy(stalled, "the synthetic 30ms busy-loop never ran")
  assert_truthy(
    max_stall_ms >= 25,
    string.format("a 30ms busy-loop must register as a >=25ms loop-turn stall, got %.2f ms", max_stall_ms)
  )
end
