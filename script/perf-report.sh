#!/usr/bin/env bash
# Perf report (round-2 plan R0.1): the timing half of the startup budget.
#
# Prints, on the current machine:
#   - same-session floor: median-of-3 `nvim --clean` --startuptime totals,
#     headless AND pty, plus floor-relative deltas (full - clean) per path
#   - median TUI lazy.stats().startuptime over 3 quiet pty runs
#   - jitter probe: max main-thread gap seen by an 8 ms uv timer between
#     UIEnter+100 ms and +5.1 s (acceptance criterion 2, threshold 16 ms)
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
-- Full-config pty probe: jitter watch from UIEnter+100 ms (8 ms uv timer
-- for 5 s recording hrtime gaps -- a delayed tick means the main thread
-- stalled), then at 6.5 s idle snapshot lazy startuptime, per-plugin load
-- times, warmup tags, and the jitter maximum; write JSON and quit.
local jitter = { max_ms = -1, ran = false }
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      jitter.ran = true
      local timer = assert(vim.uv.new_timer())
      local last = vim.uv.hrtime()
      local deadline = last + 5e9
      timer:start(8, 8, function()
        local now = vim.uv.hrtime()
        local gap = (now - last) / 1e6
        if gap > jitter.max_ms then
          jitter.max_ms = gap
        end
        last = now
        if now >= deadline then
          timer:stop()
          timer:close()
        end
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
    jitter_max_ms = jitter.max_ms,
    jitter_ran = jitter.ran,
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
print("== jitter probe: UIEnter+100ms..+5.1s, 8ms uv timer (threshold 16ms) ==")
local jitter_vals = {}
for _, run in ipairs(probe_runs) do
  if run.jitter_ran and run.jitter_max_ms and run.jitter_max_ms >= 0 then
    jitter_vals[#jitter_vals + 1] = run.jitter_max_ms
  end
end
table.sort(jitter_vals)
if #jitter_vals == 0 then
  print("  max main-thread gap: n/a (probe did not run)")
else
  print(
    string.format(
      "  max main-thread gap: median %.1f ms over %d runs (%s)",
      median(jitter_vals),
      #jitter_vals,
      fmt_runs(jitter_vals)
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
