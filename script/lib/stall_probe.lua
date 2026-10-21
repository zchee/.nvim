-- Main-thread stall detector: the longest single event-loop turn.
--
--   local stall_probe = dofile("<repo>/script/lib/stall_probe.lua")
--   local stall = { max_ms = -1 }
--   local stop = stall_probe(stall) -- stall.max_ms grows while it runs
--   ...
--   stop()
--
-- libuv fires check handles right after the poll returns and prepare handles
-- right before the next poll blocks, so the gap from a check timestamp to the
-- next prepare fire is one loop turn's active (non-poll) stretch -- a
-- main-thread busy stall, measured with no timer grid under it (a timer puts
-- its period as a floor on detection and is itself loop load).
--
-- script/perf-report.sh runs it in its pty probe;
-- tests/perf/metrics_probe_spec.lua checks that it registers a synthetic
-- busy-loop.

--- Starts the detector, which raises `stall.max_ms` (milliseconds) in place.
--- @param stall { max_ms: number }
--- @return fun() stop closes the prepare and check handles
return function(stall)
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
  return function()
    prep:stop()
    prep:close()
    check:stop()
    check:close()
  end
end
