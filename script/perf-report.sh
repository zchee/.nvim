#!/usr/bin/env bash
# Perf report (plan Phase 4.1): the timing half of the startup budget.
#
# Prints, on the current machine:
#   - median TUI lazy.stats().startuptime over 3 quiet pty runs
#   - headless --startuptime total
#   - top-15 per-plugin lazy load times from the median run
#
# Timing lives here, NOT in tests/perf/startup_budget_spec.lua -- wall-clock
# numbers depend on machine load, so they are reported, never pass/fail.
# Run on a quiet machine; do not run concurrently with the spec suite.
set -euo pipefail

runs=3
run_timeout_s=90
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

probe="$tmp/probe.lua"
cat >"$probe" <<'EOF'
-- after 3 s idle: snapshot lazy startuptime + per-plugin load times, quit
vim.defer_fn(function()
  local plugins = {}
  for name, plugin in pairs(require("lazy.core.config").plugins) do
    local state = plugin._ and plugin._.loaded
    if state and state.time then
      plugins[#plugins + 1] = { name = name, ms = state.time / 1e6 }
    end
  end
  table.sort(plugins, function(a, b)
    return a.ms > b.ms
  end)
  local f = assert(io.open(vim.g.perf_report_out, "w"))
  f:write(vim.json.encode({
    startuptime = require("lazy").stats().startuptime,
    plugins = plugins,
  }))
  f:close()
  vim.cmd("qa!")
end, 3000)
EOF

for i in $(seq 1 "$runs"); do
  out="$tmp/run$i.json"
  script -q /dev/null nvim --cmd "lua vim.g.perf_report_out='$out'" \
    -c "luafile $probe" </dev/null >/dev/null 2>&1 &
  pid=$!
  for _ in $(seq 1 $((run_timeout_s * 2))); do
    kill -0 "$pid" 2>/dev/null || break
    sleep 0.5
  done
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid" 2>/dev/null || true
    echo "warning: pty run $i timed out after ${run_timeout_s}s" >&2
  fi
  wait "$pid" 2>/dev/null || true
  [ -s "$out" ] || echo "warning: pty run $i wrote no report" >&2
done

headless_log="$tmp/headless.log"
nvim --headless --startuptime "$headless_log" +qa >/dev/null 2>&1 || true

report="$tmp/report.lua"
cat >"$report" <<'EOF'
-- aggregate the run JSONs: median startuptime + the median run's top-15 table
local headless_log = arg[1]
local runs = {}
for i = 2, #arg do
  local f = io.open(arg[i], "r")
  if f then
    local body = f:read("*a")
    f:close()
    local ok, decoded = pcall(vim.json.decode, body)
    if ok then
      runs[#runs + 1] = decoded
    end
  end
end
if #runs == 0 then
  io.stderr:write("no pty run produced a report\n")
  os.exit(1)
end
table.sort(runs, function(a, b)
  return a.startuptime < b.startuptime
end)
local median = runs[math.ceil(#runs / 2)]

local times = {}
for _, run in ipairs(runs) do
  times[#times + 1] = string.format("%.1f", run.startuptime)
end
print(string.format("TUI lazy.stats().startuptime: median %.1f ms over %d runs (%s)", median.startuptime, #runs, table.concat(times, " / ")))

local headless = "n/a"
local f = io.open(headless_log, "r")
if f then
  for line in f:lines() do
    local total = line:match("^(%d+%.%d+)%s+%d+%.%d+: %-%-% embedded") or line:match("^(%d+%.%d+)%s.*NVIM STARTED")
    if total then
      headless = total .. " ms"
    end
  end
  f:close()
end
print("headless --startuptime total:  " .. headless)

local sum = 0
for _, plugin in ipairs(median.plugins) do
  sum = sum + plugin.ms
end
print(string.format("\nlazy plugins loaded at 3 s idle: %d, load-time sum %.1f ms", #median.plugins, sum))
print("top 15 per-plugin load times (median run):")
for i = 1, math.min(15, #median.plugins) do
  print(string.format("  %2d. %-40s %7.2f ms", i, median.plugins[i].name, median.plugins[i].ms))
end
EOF

nvim -u NONE --headless -l "$report" "$headless_log" "$tmp"/run*.json
