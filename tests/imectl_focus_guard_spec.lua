-- lua/config/autocmd.lua -- the FocusGained imectl guard. vim.fn.executable()
-- returns 0/1 and 0 is truthy in Lua, so the pre-fix guard spawned a failing
-- imectl process on every focus gain when the binary was absent. The callback
-- factory takes executable/jobstart as injected deps: this spec drives the
-- truth table (0 -> never jobstart, 1 -> jobstart every time) and pins the
-- probe-once cache (executable() called at most once across repeated events).
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local autocmd = require("config.autocmd")

local function assert_equal(got, want, msg)
  if got ~= want then
    error(("%s: got %s, want %s"):format(msg, vim.inspect(got), vim.inspect(want)), 2)
  end
end

do -- executable() == 0: no jobstart, ever, and only one probe
  local probe_count, job_count = 0, 0
  local cb = autocmd.make_imectl_callback(function(name)
    probe_count = probe_count + 1
    assert_equal(name, "imectl", "probe must ask for the imectl binary")
    return 0
  end, function()
    job_count = job_count + 1
    return 1
  end)

  for _ = 1, 5 do
    cb()
  end

  assert_equal(job_count, 0, "executable()==0 must never reach jobstart")
  assert_equal(probe_count, 1, "executable() must be probed exactly once across repeated FocusGained")
end

do -- executable() == 1: jobstart on every focus gain, still one probe
  local probe_count, job_count = 0, 0
  local seen_cmd, seen_opts
  local cb = autocmd.make_imectl_callback(function()
    probe_count = probe_count + 1
    return 1
  end, function(cmd, opts)
    job_count = job_count + 1
    seen_cmd, seen_opts = cmd, opts
    return 1
  end)

  for _ = 1, 3 do
    cb()
  end

  assert_equal(job_count, 3, "executable()==1 must jobstart on every FocusGained")
  assert_equal(probe_count, 1, "cached verdict must not re-probe executable()")
  assert_equal(seen_cmd, "imectl set com.apple.keylayout.ABC", "jobstart command changed")
  assert_equal(seen_opts.detach, true, "imectl job must stay detached")
end

do -- the registered FocusGained autocmd exists in the AutocmdUser group
  local aus = vim.api.nvim_get_autocmds({ group = "AutocmdUser", event = "FocusGained" })
  assert_equal(#aus, 1, "exactly one FocusGained autocmd must be registered in AutocmdUser")
end
