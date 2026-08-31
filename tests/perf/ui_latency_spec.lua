-- Embed UI latency client smoke spec (round-3.5 plan item 3, acceptance
-- criterion 4).
--
-- Runs script/ui-latency.lua against `nvim --embed -u NONE -i NONE`
-- (--clean) end to end: the child spawns, the msgpack-RPC UI attaches,
-- both latency numbers come back finite and sane, and the script exits 0
-- without hanging. Bounds are deliberately generous ((0, 5000) ms) --
-- this machine is never idle, so the spec is a smoke falsifier for the
-- RPC framing and the deadline plumbing, never a timing assertion.
-- Timing numbers are reported by script/perf-report.sh, not asserted
-- here.
--
-- Run from the repo root:
--   nvim --headless -u NONE -l tests/perf/ui_latency_spec.lua

local function assert_truthy(got, message)
  if not got then
    error(string.format("%s: got %s", message, vim.inspect(got)))
  end
end

local result = vim
  .system({
    vim.v.progpath,
    "-l",
    "script/ui-latency.lua",
    "--clean",
    "--socket-free",
  }, { text = true, timeout = 60000 })
  :wait()

assert_truthy(
  result.code == 0,
  string.format(
    "ui-latency.lua --clean must exit 0, got %d\nstdout:\n%s\nstderr:\n%s",
    result.code,
    result.stdout or "",
    result.stderr or ""
  )
)

local attach_ms = tonumber((result.stdout or ""):match("attach_to_first_flush_ms=([%d%.]+)"))
local input_ms = tonumber((result.stdout or ""):match("input_to_flush_ms_median=([%d%.]+)"))

assert_truthy(attach_ms, "stdout must carry attach_to_first_flush_ms=<float>\n" .. (result.stdout or ""))
assert_truthy(input_ms, "stdout must carry input_to_flush_ms_median=<float>\n" .. (result.stdout or ""))
assert_truthy(
  attach_ms > 0 and attach_ms < 5000,
  string.format("attach_to_first_flush_ms must be in (0, 5000), got %.3f", attach_ms)
)
assert_truthy(
  input_ms > 0 and input_ms < 5000,
  string.format("input_to_flush_ms_median must be in (0, 5000), got %.3f", input_ms)
)
