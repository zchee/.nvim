local M = {}

--- @param data string
--- @param opts vim._watch.Opts?
--- @param callback vim._watch.Callback
local function fswatch_output_handler(data, opts, callback)
  local d = vim.split(data, '%s+')

  -- only consider the last reported event
  local fullpath, event = d[1], d[#d]

  if skip(fullpath, opts) then
    return
  end

  --- @type integer
  local change_type

  if event == 'Created' then
    change_type = M.FileChangeType.Created
  elseif event == 'Removed' then
    change_type = M.FileChangeType.Deleted
  elseif event == 'Updated' then
    change_type = M.FileChangeType.Changed
  elseif event == 'Renamed' then
    local _, staterr, staterrname = uv.fs_stat(fullpath)
    if staterrname == 'ENOENT' then
      change_type = M.FileChangeType.Deleted
    else
      assert(not staterr, staterr)
      change_type = M.FileChangeType.Created
    end
  end

  if change_type then
    callback(fullpath, change_type)
  end
end

--- @param path string The path to watch. Must refer to a directory.
--- @param opts vim._watch.Opts?
--- @param callback vim._watch.Callback Callback for new events
--- @return fun() cancel Stops the watcher
function M.fswatch(path, opts, callback)
  -- debounce isn't the same as latency but close enough
  local latency = 0.5 -- seconds
  if opts and opts.debounce then
    latency = opts.debounce / 1000
  end

  local obj = vim.system({
    'fswatch',
    '--event=Created',
    '--event=Removed',
    '--event=Updated',
    '--event=Renamed',
    '--event-flags',
    '--recursive',
    '--latency=' .. tostring(latency),
    '--exclude',
    '/.git/',
    path,
  }, {
    stderr = function(err, data)
      if err then
        error(err)
      end

      if data and #vim.trim(data) > 0 then
        vim.schedule(function()
          if vim.fn.has('linux') == 1 and vim.startswith(data, 'Event queue overflow') then
            data = 'inotify(7) limit reached, see :h fswatch-limitations for more info.'
          end

          vim.notify('fswatch: ' .. data, vim.log.levels.ERROR)
        end)
      end
    end,
    stdout = function(err, data)
      if err then
        error(err)
      end

      for line in vim.gsplit(data or '', '\n', { plain = true, trimempty = true }) do
        fswatch_output_handler(line, opts, callback)
      end
    end,
    -- --latency is locale dependent but tostring() isn't and will always have '.' as decimal point.
    env = { LC_NUMERIC = 'C' },
  })

  return function()
    obj:kill(2)
  end
end

return M
