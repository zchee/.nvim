local M = {}

---
---Return XDG_CACHE_HOME
---
---@return string
function M.xdg_cache_home()
  return tostring(os.getenv("XDG_CACHE_HOME"))
end

---
---Return XDG_CONFIG_HOME
---
---@return string
function M.xdg_config_home()
  return tostring(os.getenv("XDG_CONFIG_HOME"))
end

---
---Return XDG_DATA_HOME
---
---@return string
function M.xdg_data_home()
  return tostring(os.getenv("XDG_DATA_HOME"))
end

---
---Return XDG_STATE_HOME
---
---@return string
function M.xdg_state_home()
  return tostring(os.getenv("XDG_STATE_HOME"))
end

---@param ...string
---@return string
function M.go_path(...)
  return vim.fs.joinpath(vim.uv.os_homedir(), "go", ...)
end

---@param ...string
---@return string
function M.src_path(...)
  return vim.fs.joinpath(vim.uv.os_homedir(), "src", ...)
end

---@param ...string
---@return string
function M.src_path(...)
  return vim.fs.joinpath(vim.uv.os_homedir(), "src", ...)
end

---
---expands env path and reads symbolic link.
---
---@param path string? | nil
---@return string
function M.readlink(path)
  if path == nil then
    return ""
  end
  return vim.uv.fs_readlink(path) or ""
end

---@param formula string homebrew formula name
---@param binary string binary name
---@return string
function M.homebrew_binary(formula, binary)
  local prefix = os.getenv("HOMEBREW_PREFIX")
  -- fallback
  if not prefix then
    local machine = vim.uv.os_uname()["machine"]
    if machine == "x86_64" then
      prefix = "/usr/local"
    elseif machine == "arm64" then
      prefix = "/opt/homebrew"
    end
  end

  return vim.fs.joinpath(prefix, "opt", formula, "bin", binary)
end

return M
