-- Nesting repair for Chrome trace-event complete ("X") slices.
--
--   local enforce_nesting = dofile("<repo>/script/lib/trace_nesting.lua")
--   enforce_nesting(events) -- mutates ts in place
--
-- trace_processor renders a pair of slices on one tid only when they are
-- nested or disjoint; a partial overlap is counted as
-- slice_spill_overlapping_complete_event and lands on an ambiguous overflow
-- track. Reconstructed starts (script/perf-trace.lua) can overlap partially,
-- so on each tid this sweeps slices in (ts, -dur) order with a stack of open
-- slice ends: a slice that pokes out of the innermost open slice is moved to
-- that slice's end (duration kept, shift recorded in args.ts_shift_us) and
-- re-queued at its new sorted position. Re-queueing keeps the sweep visiting
-- starts in order, which is what makes the stack test sound: every accepted
-- slice either ends inside the slices still open or starts after the others
-- ended. Shifts only move forward, onto an existing slice end, so the sweep
-- terminates.

local function before(a, b)
  if a.ts ~= b.ts then
    return a.ts < b.ts
  end
  return (a.dur or 0) > (b.dur or 0)
end

--- Shifts partially overlapping X slices until every pair on a tid is nested or disjoint.
--- @param events table[] trace events; only ph == "X" entries are touched
return function(events)
  local by_tid = {}
  for _, event in ipairs(events) do
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
    table.sort(list, before)
    local open_ends = {}
    local i = 1
    while i <= #list do
      local event = list[i]
      local ts, dur = event.ts, event.dur or 0
      while #open_ends > 0 and open_ends[#open_ends] <= ts do
        open_ends[#open_ends] = nil
      end
      local enclosing_end = open_ends[#open_ends]
      if enclosing_end and ts + dur > enclosing_end then
        event.args = event.args or {}
        event.args.ts_shift_us = (event.args.ts_shift_us or 0) + (enclosing_end - ts)
        event.ts = enclosing_end
        table.remove(list, i)
        local j = i
        while j <= #list and before(list[j], event) do
          j = j + 1
        end
        table.insert(list, j, event)
      else
        open_ends[#open_ends + 1] = ts + dur
        i = i + 1
      end
    end
  end
end
