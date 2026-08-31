local M = {}

function _G.dump(...)
  vim.print(vim.inspect(...))
end

function M.cmp_or(val, default)
  if val == nil then
    return default
  end
  return val
end

--- Dynamically builds an ultra-fast if-elseif dispatch function.
---
--- @param default_code string Lua code snippet for the default (fallback) case.
--- @param cases_config table A table mapping keys to their target Lua code snippets.
--- @return function The generated optimized function.
---
---```lua
---local my_fast_switch = util.switch(
---  "return 0", -- default case
---  {
---    ["add"] = "local a, b = ...; return a + b",
---    ["sub"] = "local a, b = ...; return a - b",
---    ["mul"] = "local a, b = ...; return a * b"
---  }
---)
---
---local function calculate(operation, x, y)
---  return my_fast_switch(operation, x, y)
---end
---
---print(calculate("add", 100, 50)) -- 150
---print(calculate("sub", 100, 50)) -- 50
---```
function M.fast_switch(default_code, cases_config)
  -- Initialize the function signature (accepts varargs ...)
  local code_lines = { "return function(key, ...)" }
  local is_first = true

  for k, v in ipairs(cases_config) do
    -- Handle quotes based on the key's type
    local condition = type(k) == "string" and ('"' .. k .. '"') or tostring(k)

    if is_first then
      table.insert(code_lines, "  if key == " .. condition .. " then")
      is_first = false
    else
      table.insert(code_lines, "  elseif key == " .. condition .. " then")
    end
    -- Inline the execution block
    table.insert(code_lines, "    " .. v)
  end

  if not is_first then
    table.insert(code_lines, "  else")
    table.insert(code_lines, "    " .. default_code)
    table.insert(code_lines, "  end")
  end
  table.insert(code_lines, "end")

  -- Concatenate the lines into a single Lua code string
  local final_code = table.concat(code_lines, "\n")

  -- Compile into bytecode using loadstring and return the generated function
  local chunk = assert(loadstring(final_code), "Failed to compile switch")
  return chunk()
end

--- [Switch returns function instead of table](https://lua-users.org/wiki/SwitchStatement)
--- Usage:
--- ```lua
--- for case = 1,4 do
---   switch(case) {
---     [1] = function() print("one") end,
---     [2] = print,
---     default = function(x) print("default",x) end,
---   }
--- end
--- ```
---
---@param case any
---@return function
function M.switch(case)
  return function(codetbl)
    local f = codetbl[case] or codetbl.default
    if f then
      if type(f) == "function" then
        return f(case)
      else
        error("case " .. tostring(case) .. " not a function")
      end
    end
  end
end

---@param path string
---@return boolean
function M.is_exists(path)
  local file = io.open(path, "r")
  if file ~= nil then
    io.close(file)
    return true
  else
    return false
  end
end

--- Returns true if the given table contains the specified element string,
--- false otherwise.
---
---@param tbl string[]
---@param element string
---@return boolean
function M.contains(tbl, element)
  for _, value in pairs(tbl) do
    if value == element then
      return true
    end
  end
  return false
end

--- Returns the value of the process environment variable `varname`.
---
---@param varname string
---@return string?
---@nodiscard
function M.getenv(varname)
  return tostring(os.getenv(varname))
end

--- Expands env path and reads symbolic link.
---
---@param path string
---@return string
function M.readlink(path)
  return vim.uv.fs_readlink(path) or ""
end

--- Return the XDG base directory `varname` names, symbolic links resolved.
---
--- fs_realpath, not fs_readlink: readlink answers only for a path that is
--- itself a symlink and nil for anything else, so on a machine where only
--- ~/.config is a link -- ~/.cache real, ~/.local/{share,state} reached
--- through a linked ~/.local -- three of the four callers below collapsed to
--- "". vim.fs.joinpath drops that empty leading segment, which turned every
--- built path relative: the go-build filetype pattern never matched again.
---
--- Falls back to the XDG default under $HOME when the variable is unset, and
--- to the unresolved path when it does not exist yet, so the answer is always
--- absolute. It may still name a path that is not there -- callers handing it
--- to a tool that hard-errors on an unreadable path must stat it first.
---
---
--- Memoized per varname: fs_realpath is a stat per call and
--- xdg_cache_home() runs while filetype.lua is sourced at startup. The cache
--- lives in a module-local, so a module reload (as the filetype specs do)
--- starts fresh.
---
---@type table<string, string>
local xdg_home_cache = {}

---@param varname string
---@param default string relative to $HOME, per the XDG base directory spec
---@return string
local function xdg_home(varname, default)
  local cached = xdg_home_cache[varname]
  if cached then
    return cached
  end
  local dir = os.getenv(varname)
  if dir == nil or dir == "" then
    dir = vim.fs.joinpath(vim.uv.os_homedir(), default)
  end
  dir = vim.uv.fs_realpath(dir) or dir
  xdg_home_cache[varname] = dir
  return dir
end

--- Return XDG_CACHE_HOME env path with symbolic links resolved.
---
---@return string
function M.xdg_cache_home()
  return xdg_home("XDG_CACHE_HOME", ".cache")
end

--- Return XDG_CONFIG_HOME env path with symbolic links resolved.
---
---@return string
function M.xdg_config_home()
  return xdg_home("XDG_CONFIG_HOME", ".config")
end

--- Return XDG_DATA_HOME env path with symbolic links resolved.
---
---@return string
function M.xdg_data_home()
  return xdg_home("XDG_DATA_HOME", ".local/share")
end

--- Return XDG_STATE_HOME env path with symbolic links resolved.
---
---@return string
function M.xdg_state_home()
  return xdg_home("XDG_STATE_HOME", ".local/state")
end

---@param ... string
---@return string
function M.go_path(...)
  return vim.fs.joinpath(vim.uv.os_homedir(), "go", ...)
end

---@param ... string
---@return string
function M.src_path(...)
  return vim.fs.joinpath(vim.uv.os_homedir(), "src", ...)
end

-- The machine never changes within a session and os_uname() allocates a full
-- uname table per call; resolve it once for the prefix helpers below.
local machine = vim.uv.os_uname()["machine"]

local unix_prefix
if machine == "x86_64" then
  unix_prefix = "/usr/local"
elseif machine == "arm64" then
  unix_prefix = "/opt/local"
end
unix_prefix = tostring(unix_prefix)

--- Returns the UNIX prefix directory according to the macOS cpu architecture.
---
---@param ... string
---@return string
function M.prefix(...)
  return vim.fs.joinpath(unix_prefix, ...)
end

---@type string?
local homebrew_prefix_cache

--- Returns the Homebrew prefix directory according to the macOS cpu architecture.
---
---@return string
function M.homebrew_prefix()
  if homebrew_prefix_cache then
    return homebrew_prefix_cache
  end

  local prefix = os.getenv("HOMEBREW_PREFIX")

  -- fallback
  if not prefix then
    if machine == "x86_64" then
      prefix = "/usr/local"
    elseif machine == "arm64" then
      prefix = "/opt/homebrew"
    end
  end

  homebrew_prefix_cache = tostring(prefix)
  return homebrew_prefix_cache
end

---@param binary string binary name
---@return string
function M.homebrew_portable_ruby(binary)
  local prefix = M.homebrew_prefix()
  return vim.fs.joinpath(prefix, "Library/Homebrew/vendor/portable-ruby/current/bin", binary)
end

--- Returns the Homebrew binary path for the given formula and binary name.
---
---@param formula string homebrew formula name
---@param binary string binary name
---@return string
function M.homebrew_binary(formula, binary)
  return vim.fs.joinpath(M.homebrew_prefix(), "opt", formula, "bin", binary)
end

--- Returns the bun binary path for the given binary name.
---
---@param binary string binary name
---@return string
function M.bun_prefix(binary)
  return tostring(vim.fs.joinpath(os.getenv("BUN_INSTALL"), "bin", binary))
end

--- Returns the pnpm binary path for the given binary name.
---
---@param binary string binary name
---@return string
function M.pnpm_prefix(binary)
  return tostring(vim.fs.joinpath(os.getenv("PNPM_HOME"), binary))
end

--- Returns the rbenv binary path for the given binary name.
---
---@param binary string binary name
---@return string
function M.rbenv_prefix(binary)
  return tostring(vim.fs.joinpath(os.getenv("RBENV_ROOT"), "shims", binary))
end

--- Registers a callback function to be executed when the "VeryLazy" event is triggered.
---
---@param fn fun()
M.on_very_lazy = function(fn)
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("Lazy", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

--- Loads the specified modules either immediately or lazily based on whether a file is opened at startup.
---
---@param modules string[] modules like "autocmds" | "options" | "keymaps"
M.lazy_load = function(modules)
  -- when no file is opened at startup
  if vim.fn.argc(-1) == 0 then
    -- autocmds and keymaps can wait to load
    -- always load lazyvim, then user file
    M.on_very_lazy(function()
      for i = 1, #modules do
        require(modules[i])
      end
    end)
  else
    -- load them now so they affect the opened buffers
    for i = 1, #modules do
      require(modules[i])
    end
  end
end

--- Registers a callback function to be executed when an LSP client attaches to a buffer.
---
---@param on_attach fun(client, bufnr)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

return M
