local M = {}

---Expands env path and reads symbolic link.
---It's equivalent to readlink(2) syscall.
---
---@param env string
---@return string | nil
function M.readlink(env)
  local expenv = os.getenv(env)
  return vim.uv.fs_readlink(tostring(expenv)) or ""
end

---@param formula string The url to request
---@param binary string
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

return M
