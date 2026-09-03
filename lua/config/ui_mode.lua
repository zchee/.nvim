-- Which module draws the statusline and tabline: the hand-rolled
-- lua/config/chrome.lua (default), or the lualine.nvim + bufferline.nvim
-- pair it replaced in round-3 W3.2. "plugins" exists to compare the two by
-- eye and to fall back whole if a parity gap turns up.
--
-- Resolution order, cheapest first, so the default case reads no file:
--   $NVIM_UI_MODE  one-shot override for a single nvim invocation
--   vim.g.ui_mode  set before require("config") in init.lua
--   state file     written by :UiMode, survives restarts
--   "chrome"
--
-- lua/plugins/init.lua asks uses_plugins() while lazy.nvim evaluates its
-- spec table, which happens before require("config"), so this module has to
-- stand alone: no config.* requires at load time.

local M = {}

local MODES = { chrome = true, plugins = true }
local PLUGIN_NAMES = { "lualine.nvim", "bufferline.nvim" }
local PLUGIN_CONFIGS = { "plugins.lualine", "plugins.bufferline" }

local state_file = vim.fs.joinpath(tostring(vim.fn.stdpath("state")), "ui-mode")

local resolved ---@type string?
-- Their setup() has run, so lazy.load() is a no-op and re-taking the
-- statusline/tabline options means re-running the spec configs.
local plugins_applied = false

local function read_state()
  local fd = io.open(state_file, "r")
  if not fd then
    return nil
  end
  local line = fd:read("l")
  fd:close()
  return line and MODES[line] and line or nil
end

local function write_state(mode)
  local fd, err = io.open(state_file, "w")
  if not fd then
    -- only reachable when the state dir was pruned; nvim creates it at start
    vim.fn.mkdir(vim.fs.dirname(state_file), "p")
    fd, err = io.open(state_file, "w")
    if not fd then
      return false, err
    end
  end
  fd:write(mode, "\n")
  fd:close()
  return true
end

--- Active mode, resolved once per session.
---@return "chrome"|"plugins"
function M.current()
  if resolved then
    return resolved
  end
  local want = vim.env.NVIM_UI_MODE or vim.g.ui_mode
  if not (want and MODES[want]) then
    want = read_state()
  end
  resolved = want or "chrome"
  return resolved
end

---@return boolean
function M.uses_plugins()
  return M.current() == "plugins"
end

--- Names lazy.nvim has a spec for but no clone on disk yet. Switching into
--- plugins mode before `:Lazy install` would otherwise leave the session
--- with neither renderer.
local function missing_plugins()
  local ok, cfg = pcall(require, "lazy.core.config")
  local root = ok and cfg.options and cfg.options.root
  if not root then
    return PLUGIN_NAMES
  end
  local missing = {}
  for _, name in ipairs(PLUGIN_NAMES) do
    if not vim.uv.fs_stat(vim.fs.joinpath(root, name)) then
      missing[#missing + 1] = name
    end
  end
  return missing
end

local function to_chrome()
  -- lualine holds the statusline through a refresh timer, so dropping the
  -- option is not enough: hide() is its own way to hand it back. bufferline
  -- only ever writes vim.o.tabline at setup time, so chrome.setup() taking
  -- the option back is all that is needed there.
  pcall(function()
    require("lualine").hide({ place = { "statusline", "tabline", "winbar" } })
  end)
  require("config.chrome").setup()
end

local function to_plugins()
  if package.loaded["config.chrome"] then
    require("config.chrome").teardown()
  end
  if plugins_applied then
    pcall(function()
      require("lualine").hide({ place = { "statusline", "tabline", "winbar" }, unhide = true })
    end)
    for _, mod in ipairs(PLUGIN_CONFIGS) do
      package.loaded[mod] = nil
      require(mod)
    end
  else
    require("lazy").load({ plugins = PLUGIN_NAMES })
    plugins_applied = true
  end
end

--- Switch renderers now and (unless opts.persist == false) for later
--- sessions. Returns false plus a reason when the switch cannot be made.
---@param mode string
---@param opts? { persist?: boolean }
---@return boolean ok, string? err
function M.set(mode, opts)
  opts = opts or {}
  if not MODES[mode] then
    return false, string.format("unknown mode %q (chrome|plugins)", tostring(mode))
  end
  if mode == "plugins" then
    local missing = missing_plugins()
    if #missing > 0 then
      return false, table.concat(missing, ", ") .. " is not installed yet -- run :Lazy install"
    end
  end
  if mode ~= M.current() then
    if mode == "plugins" then
      to_plugins()
    else
      to_chrome()
    end
    resolved = mode
  end
  if opts.persist ~= false then
    local ok, err = write_state(mode)
    if not ok then
      return false, "switched, but could not persist the choice: " .. tostring(err)
    end
  end
  return true
end

--- Arm the active renderer. chrome runs here, synchronously, so the default
--- statusline never flashes; in plugins mode the two specs carry a VeryLazy
--- trigger instead and the flash is theirs to have (it is why chrome won).
function M.setup()
  if M.uses_plugins() then
    plugins_applied = true
    return
  end
  require("config.chrome").setup()
end

return M
