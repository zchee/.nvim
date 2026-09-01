#!/usr/bin/env bash
# Perf report (round-2 plan R0.1): the timing half of the startup budget.
#
# Prints, on the current machine:
#   - same-session floor: median-of-3 `nvim --clean` --startuptime totals,
#     headless AND pty, plus floor-relative deltas (full - clean) per path
#   - median TUI lazy.stats().startuptime over 3 quiet pty runs
#   - stall probe: between UIEnter+100 ms and +5.1 s, the loop busy fraction
#     from uv metrics (loop_configure("metrics_idle_time")) and the max
#     single loop-turn stall from a prepare/check handle pair -- no timer
#     grid, so there is no 8 ms detection floor and no probe-timer noise
#   - embed UI latency: attach->first-flush and input->flush from a direct
#     msgpack-RPC UI client (script/ui-latency.lua), clean vs full config
#   - perfetto trace export: one full-config startup merged into a Chrome
#     trace-event JSON by script/perf-trace.lua, written outside the tmp
#     dir for ui.perfetto.dev
#   - first-insert probe: wall time of the InsertEnter dispatch fed at
#     UIEnter+3 s and whether blink.cmp was already loaded before it
#   - burst vs warmup split: plugins tagged in vim.g.warmup_loaded (by a
#     future warmup module) are reported apart from the untagged burst
#
# pty note: under `script -q /dev/null` a ~100 ms DSR/termresponse artifact
# inflates wall times for BOTH clean and full runs, so pty absolutes are
# inflated but the pty delta (full - clean, same method both sides) is
# meaningful. lazy.stats().startuptime exists only in the full config, so
# the pty floor comparison uses the --startuptime "NVIM STARTED" line on
# both sides instead.
#
# Timing lives here, NOT in tests/perf/*.lua -- wall-clock numbers depend on
# machine load, so they are reported, never pass/fail. Run on a quiet
# machine; do not run concurrently with the spec suite.
set -euo pipefail

runs=3
run_timeout_s=90
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Runs one nvim inside a pty (script(1)) with a kill-after timeout.
run_pty() {
  script -q /dev/null nvim "$@" </dev/null >/dev/null 2>&1 &
  local pid=$!
  for _ in $(seq 1 $((run_timeout_s * 2))); do
    kill -0 "$pid" 2>/dev/null || break
    sleep 0.5
  done
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid" 2>/dev/null || true
    echo "warning: pty nvim timed out after ${run_timeout_s}s" >&2
  fi
  wait "$pid" 2>/dev/null || true
}

probe="$tmp/probe.lua"
cat >"$probe" <<'EOF'
-- Full-config pty probe: stall watch from UIEnter+100 ms for 5 s, passive
-- (no probe timer ticks), then at 6.5 s idle snapshot lazy startuptime,
-- per-plugin load times, warmup tags, and the stall numbers; write JSON
-- and quit.
--
-- Busy fraction: loop_configure("metrics_idle_time") makes libuv account
-- time blocked in the kernel poll; busy = (wall - idle delta) / wall over
-- the window (metrics_idle_time is nanoseconds on this build).
--
-- Max loop-turn stall: libuv fires check handles right after the poll
-- returns and prepare handles right before the next poll blocks, so the
-- gap from a check timestamp to the next prepare fire is one loop turn's
-- active (non-poll) stretch -- a main-thread busy stall, measured with no
-- timer grid under it (the old 8 ms uv timer put an 8 ms floor on
-- detection and was itself loop load).
local stall = { ran = false, max_ms = -1, busy_fraction = -1, loop_count = -1, events = -1 }
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      stall.ran = true
      local metrics_ok = vim.uv.loop_configure("metrics_idle_time") == 0
      local wall0 = vim.uv.hrtime()
      local idle0 = metrics_ok and vim.uv.metrics_idle_time() or 0
      local info0 = vim.uv.metrics_info()
      local prep = assert(vim.uv.new_prepare())
      local check = assert(vim.uv.new_check())
      local t_active -- hrtime when the current loop turn's active phase began
      prep:start(function()
        if t_active then
          local gap = (vim.uv.hrtime() - t_active) / 1e6
          if gap > stall.max_ms then
            stall.max_ms = gap
          end
          t_active = nil
        end
      end)
      check:start(function()
        t_active = vim.uv.hrtime()
      end)
      local stop_timer = assert(vim.uv.new_timer())
      stop_timer:start(5000, 0, function()
        prep:stop()
        prep:close()
        check:stop()
        check:close()
        stop_timer:stop()
        stop_timer:close()
        local wall = vim.uv.hrtime() - wall0
        if metrics_ok and wall > 0 then
          local idle = vim.uv.metrics_idle_time() - idle0
          stall.busy_fraction = math.max(wall - idle, 0) / wall
        end
        local info = vim.uv.metrics_info()
        stall.loop_count = info.loop_count - info0.loop_count
        stall.events = info.events - info0.events
      end)
    end, 100)
  end,
})

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
    warmup_loaded = vim.g.warmup_loaded or vim.empty_dict(),
    stall_ran = stall.ran,
    stall_max_ms = stall.max_ms,
    busy_fraction = stall.busy_fraction,
    loop_count = stall.loop_count,
    events = stall.events,
  }))
  f:close()
  vim.cmd("qa!")
end, 6500)
EOF

insert_probe="$tmp/insert_probe.lua"
cat >"$insert_probe" <<'EOF'
-- First-insert probe: at UIEnter+3 s enter insert mode in a real buffer.
-- feedkeys with "x" would block until insert mode exits, so instead an
-- InsertEnter autocmd is registered right before feeding "i": it runs
-- after lazy's own InsertEnter handler (registered at startup, so earlier
-- in the list) has loaded the insert stack, and its vim.schedule callback
-- runs once the whole event dispatch returns to the main loop -- so
-- t0..schedule brackets the full synchronous InsertEnter stall including
-- lazy plugin loads.
vim.defer_fn(function()
  vim.cmd("qa!")
end, 30000) -- watchdog: never hang the report harness
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      local buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_set_current_buf(buf)
      local blink_pre = package.loaded["blink.cmp"] ~= nil
      local t0
      vim.api.nvim_create_autocmd("InsertEnter", {
        once = true,
        callback = function()
          vim.schedule(function()
            local insert_ms = (vim.uv.hrtime() - t0) / 1e6
            vim.cmd("stopinsert")
            local f = assert(io.open(vim.g.perf_insert_out, "w"))
            f:write(vim.json.encode({
              insert_ms = insert_ms,
              blink_preloaded = blink_pre,
              blink_loaded_after = package.loaded["blink.cmp"] ~= nil,
            }))
            f:close()
            vim.cmd("qa!")
          end)
        end,
      })
      t0 = vim.uv.hrtime()
      vim.api.nvim_feedkeys("i", "n", false)
    end, 3000)
  end,
})
EOF

quit_soon='lua vim.defer_fn(function() vim.cmd("qa!") end, 500)'

for i in $(seq 1 "$runs"); do
  nvim --clean --headless --startuptime "$tmp/clean_headless$i.log" +qa \
    >/dev/null 2>&1 || true
  nvim --headless --startuptime "$tmp/full_headless$i.log" +qa \
    >/dev/null 2>&1 || true
done

for i in $(seq 1 "$runs"); do
  run_pty --clean --startuptime "$tmp/clean_pty$i.log" -c "$quit_soon"
done

for i in $(seq 1 "$runs"); do
  out="$tmp/run$i.json"
  run_pty --startuptime "$tmp/full_pty$i.log" \
    --cmd "lua vim.g.perf_report_out='$out'" -c "luafile $probe"
  [ -s "$out" ] || echo "warning: pty run $i wrote no report" >&2
done

run_pty --cmd "lua vim.g.perf_insert_out='$tmp/insert.json'" \
  -c "luafile $insert_probe"
[ -s "$tmp/insert.json" ] || echo "warning: insert probe wrote no report" >&2

report="$tmp/report.lua"
cat >"$report" <<'EOF'
-- Aggregates the raw run files from the tmp dir (arg[1]) into the report.
local tmp = arg[1]

--- Parses the total from a --startuptime log ("NVIM STARTED" / embedded).
local function startuptime_total(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local total
  for line in f:lines() do
    local t = line:match("^(%d+%.%d+)%s+%d+%.%d+: %-%-%- embedded")
      or line:match("^(%d+%.%d+)%s.*NVIM STARTED")
    if t then
      total = tonumber(t)
    end
  end
  f:close()
  return total
end

local function collect_totals(prefix)
  local totals = {}
  for i = 1, 3 do
    local t = startuptime_total(string.format("%s/%s%d.log", tmp, prefix, i))
    if t then
      totals[#totals + 1] = t
    end
  end
  table.sort(totals)
  return totals
end

local function median(sorted)
  if #sorted == 0 then
    return nil
  end
  return sorted[math.ceil(#sorted / 2)]
end

local function fmt_runs(sorted)
  local parts = {}
  for _, v in ipairs(sorted) do
    parts[#parts + 1] = string.format("%.1f", v)
  end
  return table.concat(parts, " / ")
end

local function fmt_median(sorted)
  local m = median(sorted)
  if not m then
    return "n/a"
  end
  return string.format("median %.1f ms over %d runs (%s)", m, #sorted, fmt_runs(sorted))
end

local clean_headless = collect_totals("clean_headless")
local full_headless = collect_totals("full_headless")
local clean_pty = collect_totals("clean_pty")
local full_pty = collect_totals("full_pty")

local function delta(full, clean)
  local mf, mc = median(full), median(clean)
  if not (mf and mc) then
    return "delta n/a"
  end
  return string.format("delta (full - clean) %+.1f ms", mf - mc)
end

print("== floor: nvim --clean --startuptime ==")
print("  headless: " .. fmt_median(clean_headless))
print("  pty:      " .. fmt_median(clean_pty))
print("")
print("== full config: --startuptime ==")
print("  headless: " .. fmt_median(full_headless) .. " | " .. delta(full_headless, clean_headless))
print("  pty:      " .. fmt_median(full_pty) .. " | " .. delta(full_pty, clean_pty))

-- lazy probe runs (full-config pty): stats, jitter, burst/warmup split
local probe_runs = {}
for i = 1, 3 do
  local f = io.open(string.format("%s/run%d.json", tmp, i), "r")
  if f then
    local body = f:read("*a")
    f:close()
    local ok, decoded = pcall(vim.json.decode, body)
    if ok then
      probe_runs[#probe_runs + 1] = decoded
    end
  end
end
if #probe_runs == 0 then
  io.stderr:write("no pty probe run produced a report\n")
  os.exit(1)
end
table.sort(probe_runs, function(a, b)
  return a.startuptime < b.startuptime
end)
local median_run = probe_runs[math.ceil(#probe_runs / 2)]

local stats_times = {}
for _, run in ipairs(probe_runs) do
  stats_times[#stats_times + 1] = run.startuptime
end
print(
  string.format(
    "  TUI lazy.stats().startuptime: median %.1f ms over %d runs (%s)",
    median_run.startuptime,
    #probe_runs,
    fmt_runs(stats_times)
  )
)

print("")
print("== stall probe: UIEnter+100ms..+5.1s, uv metrics + prepare/check (no timer grid) ==")
local stall_vals, busy_vals = {}, {}
local turn_counts, event_counts = {}, {}
for _, run in ipairs(probe_runs) do
  if run.stall_ran then
    if run.stall_max_ms and run.stall_max_ms >= 0 then
      stall_vals[#stall_vals + 1] = run.stall_max_ms
    end
    if run.busy_fraction and run.busy_fraction >= 0 then
      busy_vals[#busy_vals + 1] = run.busy_fraction * 100
    end
    if run.loop_count and run.loop_count >= 0 then
      turn_counts[#turn_counts + 1] = run.loop_count
      event_counts[#event_counts + 1] = run.events
    end
  end
end
table.sort(stall_vals)
table.sort(busy_vals)
table.sort(turn_counts)
table.sort(event_counts)
if #busy_vals == 0 then
  print("  loop busy fraction: n/a (probe did not run)")
else
  print(
    string.format(
      "  loop busy fraction:  median %.1f%% over %d runs (%s)",
      median(busy_vals),
      #busy_vals,
      fmt_runs(busy_vals)
    )
  )
end
if #stall_vals == 0 then
  print("  max loop-turn stall: n/a (probe did not run)")
else
  print(
    string.format(
      "  max loop-turn stall: median %.1f ms over %d runs (%s)",
      median(stall_vals),
      #stall_vals,
      fmt_runs(stall_vals)
    )
  )
end
if #turn_counts > 0 then
  print(
    string.format(
      "  loop turns / uv events over the window: median %d / %d",
      median(turn_counts),
      median(event_counts)
    )
  )
end

print("")
print("== first-insert probe: InsertEnter fed at UIEnter+3s ==")
local insert_f = io.open(tmp .. "/insert.json", "r")
if insert_f then
  local body = insert_f:read("*a")
  insert_f:close()
  local ok, insert = pcall(vim.json.decode, body)
  if ok then
    print(
      string.format(
        "  InsertEnter dispatch: %.1f ms | blink.cmp preloaded before: %s | loaded after: %s",
        insert.insert_ms,
        tostring(insert.blink_preloaded),
        tostring(insert.blink_loaded_after)
      )
    )
  else
    print("  n/a (insert report unreadable)")
  end
else
  print("  n/a (insert probe wrote no report)")
end

-- burst vs warmup split from the median probe run: warmup-tagged plugins
-- (vim.g.warmup_loaded, appended by the future warmup module) are excluded
-- from the burst; until warmup exists the tagged set is empty.
local warmup_set = {}
for _, name in ipairs(median_run.warmup_loaded or {}) do
  warmup_set[name] = true
end
local burst, warmup = {}, {}
local burst_sum, warmup_sum = 0, 0
for _, plugin in ipairs(median_run.plugins) do
  if warmup_set[plugin.name] then
    warmup[#warmup + 1] = plugin
    warmup_sum = warmup_sum + plugin.ms
  else
    burst[#burst + 1] = plugin
    burst_sum = burst_sum + plugin.ms
  end
end

print("")
print("== burst vs warmup split (median pty run, snapshot at 6.5s idle) ==")
print(string.format("  burst (untagged):  %d plugins, load-time sum %.1f ms", #burst, burst_sum))
if #warmup == 0 then
  print("  warmup (tagged):   0 plugins, load-time sum 0.0 ms (no warmup module yet)")
else
  print(string.format("  warmup (tagged):   %d plugins, load-time sum %.1f ms", #warmup, warmup_sum))
  for _, plugin in ipairs(warmup) do
    print(string.format("    - %-40s %7.2f ms", plugin.name, plugin.ms))
  end
end
print("  top 15 burst per-plugin load times:")
for i = 1, math.min(15, #burst) do
  print(string.format("  %2d. %-40s %7.2f ms", i, burst[i].name, burst[i].ms))
end
EOF

nvim -u NONE --headless -l "$report" "$tmp"

# Embed UI latency (round-3.5 item 3): a direct msgpack-RPC UI client
# measures attach->first-flush and input->flush against `nvim --embed`,
# clean and full config. Unlike the pty runs above these numbers carry no
# `script -q` DSR/termresponse artifact (the pty runs stay because the
# probe JSON rides on them and the pty delta is still a valid comparison).
echo ""
echo "== embed UI latency: msgpack-RPC client, no pty/DSR artifact =="
ui_clean="$tmp/ui_clean.txt"
ui_full="$tmp/ui_full.txt"
if nvim -l script/ui-latency.lua --clean --socket-free >|"$ui_clean" 2>&1; then
  sed 's/^/  [clean] /' "$ui_clean"
else
  echo "  [clean] ui-latency failed:"
  sed 's/^/    /' "$ui_clean"
fi
if nvim -l script/ui-latency.lua --full --socket-free --json "$tmp/ui_full.json" >|"$ui_full" 2>&1; then
  sed 's/^/  [full]  /' "$ui_full"
else
  echo "  [full]  ui-latency failed:"
  sed 's/^/    /' "$ui_full"
fi
awk -F= '
  FNR == NR && /^attach_to_first_flush_ms=/ { clean_attach = $2 }
  FNR == NR && /^input_to_flush_ms_median=/ { clean_input = $2 }
  FNR != NR && /^attach_to_first_flush_ms=/ { full_attach = $2 }
  FNR != NR && /^input_to_flush_ms_median=/ { full_input = $2 }
  END {
    if (clean_attach != "" && full_attach != "")
      printf "  delta (full - clean): attach %+.3f ms | input median %+.3f ms\n",
        full_attach - clean_attach, full_input - clean_input
  }
' "$ui_clean" "$ui_full"

# Perfetto trace export (round-3.5 item 2): merge one full-config startup
# into a Chrome trace-event JSON, reusing a --startuptime log this report
# already produced. The file lands OUTSIDE $tmp so it survives this
# script's cleanup trap; open it at ui.perfetto.dev.
echo ""
echo "== perfetto trace export: script/perf-trace.lua =="
trace_out="${TMPDIR:-/tmp}/nvim-perf-trace.json"
trace_args=(--out "$trace_out" --startuptime "$tmp/full_headless2.log")
# The full-config ui-latency samples ride along as their own trace track
# when that measurement succeeded (round-4 V0.3).
[ -s "$tmp/ui_full.json" ] && trace_args+=(--ui-latency "$tmp/ui_full.json")
if nvim -l script/perf-trace.lua "${trace_args[@]}" >/dev/null 2>&1; then
  echo "  trace written: $trace_out (open in ui.perfetto.dev)"
else
  echo "  trace export failed (non-fatal)"
fi
