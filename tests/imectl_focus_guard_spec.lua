-- lua/config/autocmd.lua -- the FocusGained imectl guard. vim.fn.executable()
-- returns 0/1 and 0 is truthy in Lua, so the pre-fix guard spawned a failing
-- imectl process on every focus gain when the binary was absent. The callback
-- factory takes executable/jobstart as injected deps: this spec drives the
-- truth table (0 -> never jobstart, 1 -> jobstart every time) and pins the
-- probe-once cache (executable() called at most once across repeated events).
-- The binary is util.prefix("bin", "imectl"), started as an argv list: no
-- shell, no $PATH lookup.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local autocmd = require("config.autocmd")
local imectl = require("util").prefix("bin", "imectl")

local function assert_equal(want, got, msg)
  if got ~= want then
    error(("%s: got %s, want %s"):format(msg, vim.inspect(got), vim.inspect(want)), 2)
  end
end

do -- executable() == 0: no jobstart, ever, and only one probe
  local probe_count, job_count = 0, 0
  local cb = autocmd.make_imectl_callback(function(name)
    probe_count = probe_count + 1
    assert_equal(imectl, name, "probe must ask for the util.prefix imectl binary")
    return 0
  end, function()
    job_count = job_count + 1
    return 1
  end)

  for _ = 1, 5 do
    cb()
  end

  assert_equal(0, job_count, "executable()==0 must never reach jobstart")
  assert_equal(1, probe_count, "executable() must be probed exactly once across repeated FocusGained")
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

  assert_equal(3, job_count, "executable()==1 must jobstart on every FocusGained")
  assert_equal(1, probe_count, "cached verdict must not re-probe executable()")
  assert_equal(
    true,
    vim.deep_equal(seen_cmd, { imectl, "set", "com.apple.keylayout.ABC" }),
    "jobstart must get an argv list: " .. vim.inspect(seen_cmd)
  )
  assert_equal(true, seen_opts.detach, "imectl job must stay detached")
end

do -- the registered FocusGained autocmd exists in the AutocmdUser group
  local aus = vim.api.nvim_get_autocmds({ group = "AutocmdUser", event = "FocusGained" })
  assert_equal(1, #aus, "exactly one FocusGained autocmd must be registered in AutocmdUser")
end
