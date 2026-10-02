---@diagnostic disable: undefined-global
-- Regression spec for lua/config/ui_mode.lua, the switch between the
-- hand-rolled lua/config/chrome.lua and the lualine+bufferline pair it
-- replaced.
--
-- Two properties carry the whole design and are easy to break by accident:
-- the module must resolve a mode without requiring anything from config.*
-- (lua/plugins/init.lua asks it while lazy is still evaluating specs, before
-- require("config")), and chrome.setup() must be re-enterable, since a
-- switch back from the plugins runs it a second time in a live session.
--
-- XDG_STATE_HOME is redirected to a scratch dir before the module loads, so
-- the persisted choice never lands in the user's real state directory.

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local scratch = vim.fs.joinpath(vim.uv.os_tmpdir(), "ui-mode-spec-" .. vim.uv.os_getpid())

local function fail(msg)
  io.stderr:write("FAIL: " .. msg .. "\n")
  vim.fn.delete(scratch, "rf")
  os.exit(1)
end

local function assert_eq(expected, actual, message)
  if expected ~= actual then
    fail(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_contains(haystack, needle, message)
  if not tostring(haystack):find(needle, 1, true) then
    fail(string.format("%s: %q not found in %q", message, needle, tostring(haystack)))
  end
end

-- nightly ships a non-empty default 'statusline'; teardown restores it
local default_statusline = vim.o.statusline
local default_tabline = vim.o.tabline

vim.env.XDG_STATE_HOME = scratch
local state_file = vim.fs.joinpath(scratch, "nvim", "ui-mode")

--- Reload the module against a given environment; `resolved` is module-local
--- so a fresh require is the only way to re-run the resolution order.
---@param env { env?: string, g?: string }
local function reload(env)
  package.loaded["config.ui_mode"] = nil
  vim.env.NVIM_UI_MODE = env.env
  vim.g.ui_mode = env.g
  return require("config.ui_mode")
end

local function write_state(contents)
  vim.fn.mkdir(vim.fs.dirname(state_file), "p")
  local fd = assert(io.open(state_file, "w"))
  fd:write(contents)
  fd:close()
end

local function clear_state()
  vim.uv.fs_unlink(state_file)
end

-- 1. resolution order
do
  clear_state()
  assert_eq("chrome", reload({}).current(), "default with no env, no g and no state file")

  write_state("plugins\n")
  assert_eq("plugins", reload({}).current(), "state file is read when nothing overrides it")

  assert_eq("chrome", reload({ g = "chrome" }).current(), "vim.g.ui_mode outranks the state file")
  assert_eq("plugins", reload({ env = "plugins", g = "chrome" }).current(), "$NVIM_UI_MODE outranks vim.g")

  assert_eq("plugins", reload({ env = "lualine" }).current(), "an unknown $NVIM_UI_MODE falls through")
  write_state("bufferline\n")
  assert_eq("chrome", reload({}).current(), "an unknown state file value falls back to chrome")

  write_state("plugins\n")
  local ui_mode = reload({})
  assert_eq(true, ui_mode.uses_plugins(), "uses_plugins tracks current")
  clear_state()
  assert_eq("plugins", ui_mode.current(), "the mode is resolved once, not re-read per call")
end

-- 2. the module stands alone: lua/plugins/init.lua consults it before
-- require("config") has run, so resolving must not drag config.chrome in
do
  package.loaded["config.chrome"] = nil
  clear_state()
  local ui_mode = reload({})
  ui_mode.current()
  ui_mode.uses_plugins()
  assert_eq(nil, package.loaded["config.chrome"], "resolving a mode must not load config.chrome")
end

-- 3. set() rejects what it cannot do, without side effects
do
  clear_state()
  local ui_mode = reload({})

  local ok, err = ui_mode.set("lualine")
  assert_eq(false, ok, "an unknown mode is refused")
  assert_contains(err, "chrome|plugins", "the refusal names the valid modes")
  assert_eq(nil, vim.uv.fs_stat(state_file), "a refused mode is not persisted")

  -- no lazy.nvim under -u NONE, so neither plugin can be found on disk
  ok, err = ui_mode.set("plugins")
  assert_eq(false, ok, "switching to plugins is refused while they are not installed")
  assert_contains(err, ":Lazy install", "the refusal says how to fix it")
  assert_eq("chrome", ui_mode.current(), "a refused switch leaves the mode alone")
  assert_eq(default_statusline, vim.o.statusline, "a refused switch leaves the statusline alone")
  assert_eq(nil, vim.uv.fs_stat(state_file), "a refused switch is not persisted")
end

-- 4. persistence round-trip
do
  clear_state()
  local ui_mode = reload({})

  assert_eq(true, ui_mode.set("chrome", { persist = false }), "persist=false still reports success")
  assert_eq(nil, vim.uv.fs_stat(state_file), "persist=false writes no state file")

  assert_eq(true, ui_mode.set("chrome"), "setting the current mode succeeds")
  local fd = assert(io.open(state_file, "r"), "the state file was written")
  assert_eq("chrome", fd:read("l"), "the state file holds the bare mode name")
  fd:close()
  assert_eq("chrome", reload({}).current(), "a later session reads the persisted mode")
end

-- 5. setup() arms chrome, and chrome is re-enterable: config.ui_mode runs
-- setup() a second time when switching back from lualine+bufferline
do
  clear_state()
  local ui_mode = reload({})
  ui_mode.setup()
  assert_contains(vim.o.statusline, "config.chrome", "setup() wires the chrome statusline")
  assert_contains(vim.o.tabline, "config.chrome", "setup() wires the chrome tabline")

  local chrome = require("config.chrome")
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_exec_autocmds("BufAdd", { buffer = buf })
  local before = #chrome.buffer_order()

  chrome.setup()
  local seen = {}
  for _, b in ipairs(chrome.buffer_order()) do
    if seen[b] then
      fail("re-running chrome.setup() duplicated buffer " .. b .. " in the tabline order")
    end
    seen[b] = true
  end
  assert_eq(before, #chrome.buffer_order(), "re-running setup() rebuilds the order rather than appending")

  chrome.teardown()
  assert_eq(default_statusline, vim.o.statusline, "teardown() hands the statusline back")
  assert_eq(default_tabline, vim.o.tabline, "teardown() hands the tabline back")
  assert_eq(0, #chrome.buffer_order(), "teardown() drops the tabline order")
  local ok = pcall(vim.api.nvim_get_autocmds, { group = "config_chrome" })
  assert_eq(false, ok, "teardown() deletes the config_chrome augroup")
end

-- 6. round trips with the real lualine+bufferline: bufferline.setup() is not
-- re-entrant (each call adds another set of ungrouped BufEnter, BufReadPost,
-- SessionLoadPost and User autocmds), so after the first load a switch may
-- only show the pair again. Uses the installed plugins through lazy.nvim with
-- installs, checker, change detection and the rtp reset all off, and the
-- lockfile in the scratch dir; SKIPs when any of them is not installed.
do
  local root = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "lazy")
  local missing = {}
  for _, name in ipairs({ "lazy.nvim", "lualine.nvim", "bufferline.nvim", "nvim-web-devicons" }) do
    if not vim.uv.fs_stat(vim.fs.joinpath(root, name)) then
      missing[#missing + 1] = name
    end
  end
  if #missing > 0 then
    print("SKIP section 6 (not installed: " .. table.concat(missing, ", ") .. ")")
  else
    vim.opt.runtimepath:prepend(vim.fs.joinpath(root, "lazy.nvim"))
    -- -u NONE clears 'loadplugins', and lazy.setup() returns early without it.
    vim.go.loadplugins = true
    require("lazy").setup({
      {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("plugins.lualine")
        end,
      },
      {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("plugins.bufferline")
        end,
      },
    }, {
      root = root,
      lockfile = vim.fs.joinpath(scratch, "lazy-lock.json"),
      defaults = { lazy = true },
      install = { missing = false },
      checker = { enabled = false },
      change_detection = { enabled = false },
      rocks = { enabled = false },
      pkg = { enabled = false },
      readme = { enabled = false },
      performance = { cache = { enabled = false }, reset_packpath = false, rtp = { reset = false } },
    })

    clear_state()
    local ui_mode = reload({ g = "chrome" })
    ui_mode.setup()

    ---@return integer
    local function bufferline_bufenter()
      local n = 0
      for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "BufEnter" })) do
        if au.callback and debug.getinfo(au.callback, "S").source:find("bufferline.nvim/", 1, true) then
          n = n + 1
        end
      end
      return n
    end

    local switched, why = ui_mode.set("plugins", { persist = false })
    assert_eq(true, switched, "switching to the installed plugins succeeds (" .. tostring(why) .. ")")
    assert_contains(vim.o.tabline, "nvim_bufferline", "the first switch runs bufferline's setup")
    assert_eq(1, bufferline_bufenter(), "bufferline's first setup registers one BufEnter autocmd")
    local total = #vim.api.nvim_get_autocmds({})

    for trip = 1, 3 do
      assert_eq(true, ui_mode.set("chrome", { persist = false }), "trip " .. trip .. ": back to chrome")
      assert_contains(vim.o.statusline, "config.chrome", "trip " .. trip .. ": chrome takes the statusline")
      assert_contains(vim.o.tabline, "config.chrome", "trip " .. trip .. ": chrome takes the tabline")
      assert_eq(true, ui_mode.set("plugins", { persist = false }), "trip " .. trip .. ": back to the plugins")
      assert_contains(vim.o.tabline, "nvim_bufferline", "trip " .. trip .. ": bufferline's tabline is shown again")
      assert_contains(vim.o.statusline, "lualine", "trip " .. trip .. ": lualine's statusline is shown again")
    end
    assert_eq(1, bufferline_bufenter(), "3 round trips leave one BufEnter autocmd from bufferline")
    assert_eq(total, #vim.api.nvim_get_autocmds({}), "no autocmd accumulates across 3 round trips")
    assert_eq(nil, vim.uv.fs_stat(state_file), "persist=false switches write no state file")
  end
end

vim.fn.delete(scratch, "rf")
print("ALL PASS: ui_mode_spec")
