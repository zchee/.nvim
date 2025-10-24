local M = {}

---@return string
M.version = jit.version
---@return string
M.version_num = jit.version_num
---@return 'Windows'|'Linux'|'OSX'|'BSD'|'POSIX'|'Other'
M.os = jit.os
---@return 'x86'|'x64'|'arm'|'arm64'|'arm64be'|'ppc'|'ppc64'|'ppc64le'|'mips'|'mipsel'|'mips64'|'mips64el'|string
M.arch = jit.arch

---@param func       function|boolean
---@param recursive? boolean
function M.on(func, recursive)
  jit.on(func, recursive)
end

---@param func       function|boolean
---@param recursive? boolean
function M.off(func, recursive)
  jit.off(func, recursive)
end

---@overload fun(tr: number)
---@param func       function|boolean
---@param recursive? boolean
function M.flush(func, recursive)
  jit.flush(func, recursive)
end

---@return boolean status
---@return string ...
---@nodiscard
function M.status()
  return jit.status()
end

---@param ... any flags
function M.opt.start(...)
  jit.opt.start(...)
end

return M
