local M = {}

--- Print every argument through vim.inspect, one per line, nils included.
--- vim.inspect(...) alone read the second argument as its options table.
function _G.dump(...)
  local inspected = {}
  for i = 1, select("#", ...) do
    inspected[i] = vim.inspect((select(i, ...)))
  end
  vim.print(table.concat(inspected, "\n"))
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

--- Returns the value of the process environment variable `varname`, or nil
--- when it is unset or empty. Not tostring()'d: the string "nil" is truthy,
--- so a caller could not fall back, and it joined into a relative path.
---
---@param varname string
---@return string?
---@nodiscard
function M.getenv(varname)
  local value = os.getenv(varname)
  if value == "" then
    return nil
  end
  return value
end

--- Memoized per varname: fs_realpath is a stat per call and
--- xdg_cache_home() runs while filetype.lua is sourced at startup. The cache
--- lives in a module-local, so a module reload (as the filetype specs do)
--- starts fresh.
---
---@type table<string, string>
local xdg_home_cache = {}

--- Return the XDG base directory `varname` names, symbolic links resolved.
---
--- fs_realpath, not fs_readlink: readlink answers only for a path that is
--- itself a symlink and nil for anything else, and vim.fs.joinpath drops an
--- empty leading segment, which makes every path built on it relative.
---
--- Falls back to the XDG default under $HOME when the variable is unset, and
--- to the unresolved path when it does not exist yet, so the answer is always
--- absolute. It may still name a path that is not there -- callers handing it
--- to a tool that hard-errors on an unreadable path must stat it first.
---
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

--- Returns the Homebrew binary path for the given formula and binary name.
---
---@param formula string homebrew formula name
---@param binary string binary name
---@return string
function M.homebrew_binary(formula, binary)
  return vim.fs.joinpath(M.homebrew_prefix(), "opt", formula, "bin", binary)
end

---@type table<string, true>
local warned = {}

--- Return `candidate` when it is an executable file, else `binary` from
--- $PATH, else `candidate` anyway -- warning once per helper and binary in
--- both fallback cases.
---
--- The prefix helpers feed `cmd` tables, where a relative or missing path
--- fails at spawn time with an error that does not name the toolchain
--- variable that was wrong. Every answer is absolute: when neither the
--- candidate nor $PATH has the binary, nothing can be run, and the absolute
--- candidate makes the spawn error name the place it was expected.
---
---@param helper string helper name, for the warning
---@param candidate string absolute path the helper derived
---@param binary string binary name
---@param problem string? why `candidate` is not to be trusted; skips the check
---@return string
local function executable_or_exepath(helper, candidate, binary, problem)
  if not problem and vim.uv.fs_access(candidate, "X") then
    return candidate
  end
  local found = vim.fn.exepath(binary)
  local key = helper .. "\0" .. binary
  if not warned[key] then
    warned[key] = true
    vim.notify(
      string.format(
        "util.%s: %s; %s",
        helper,
        problem or (candidate .. " is not executable"),
        found ~= "" and ("using " .. found .. " from $PATH") or (binary .. " is not on $PATH either")
      ),
      vim.log.levels.WARN
    )
  end
  if found ~= "" then
    return found
  end
  return candidate
end

--- Returns the bun global binary path for the given binary name:
--- `$BUN_INSTALL/bin/<binary>`, with bun's own default `~/.bun` when
--- $BUN_INSTALL is unset. Falls back to $PATH (one WARN) when that file is not
--- executable.
---
---@param binary string binary name
---@return string
function M.bun_prefix(binary)
  local root = M.getenv("BUN_INSTALL") or vim.fs.joinpath(vim.uv.os_homedir(), ".bun")
  return executable_or_exepath("bun_prefix", vim.fs.joinpath(root, "bin", binary), binary)
end

--- Returns the binary path inside nodenv's globally selected node version.
---
--- Deliberately not the shim. A shim resolves its version from the process
--- cwd, and a language server is spawned in its root_dir, so any project
--- pinning a version this machine has not installed kills the server outright
--- -- with the nodenv-nvmrc hook in play, an .nvmrc at a monorepo root even
--- wins over a nearer .node-version. The node a language server runs on is
--- not a project concern, so resolve it once from $NODENV_ROOT/version
--- ($NODENV_ROOT defaults to ~/.nodenv, as in nodenv itself).
---
--- Falls back to $PATH (one WARN) when the version file is unreadable or the
--- version it names has no such binary; that $PATH answer may be the
--- cwd-dependent shim, which is still better than a path that does not exist.
---
---@param binary string binary name
---@return string
function M.nodenv_prefix(binary)
  local root = M.getenv("NODENV_ROOT") or vim.fs.joinpath(vim.uv.os_homedir(), ".nodenv")
  local fd = io.open(vim.fs.joinpath(root, "version"), "r")
  local version = fd and fd:read("l")
  if fd then
    fd:close()
  end
  if version and version ~= "" then
    return executable_or_exepath("nodenv_prefix", vim.fs.joinpath(root, "versions", version, "bin", binary), binary)
  end
  local problem = "cannot read " .. vim.fs.joinpath(root, "version")
  return executable_or_exepath("nodenv_prefix", vim.fs.joinpath(root, "shims", binary), binary, problem)
end

return M
