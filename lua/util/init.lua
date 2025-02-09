local M = {}

---Switch returns function instead of table
---http://lua-users.org/wiki/SwitchStatement
---
---Usage:
--- for case = 1,4 do
---   switch(case) {
---     [1] = function() print("one") end,
---     [2] = print,
---     default = function(x) print("default",x) end,
---   }
--- end
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

----@param condition any
----@return function
-- function M.switch(condition)
--   return {
--     var = condition,
--
--     of = function(self, code)
--       local f
--       if (self.var) then
--         f = code[self.var] or code.default
--       else
--         f = code.default
--       end
--       if f then
--         if type(f) == "function" then
--           return f(self.var, self)
--         else
--           error("case " .. tostring(self.var) .. " not a function")
--         end
--       end
--     end
--   }
-- end

---
---Return XDG_CACHE_HOME
---
---@return string
function M.xdg_cache_home()
  return M.readlink(tostring(os.getenv("XDG_CACHE_HOME")))
end

---
---Return XDG_CONFIG_HOME
---
---@return string
function M.xdg_config_home()
  return M.readlink(tostring(os.getenv("XDG_CONFIG_HOME")))
end

---
---Return XDG_DATA_HOME
---
---@return string
function M.xdg_data_home()
  return M.readlink(tostring(os.getenv("XDG_DATA_HOME")))
end

---
---Return XDG_STATE_HOME
---
---@return string
function M.xdg_state_home()
  return M.readlink(tostring(os.getenv("XDG_STATE_HOME")))
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

---@param ... string
---@return string
function M.src_path(...)
  return vim.fs.joinpath(vim.uv.os_homedir(), "src", ...)
end

---
---expands env path and reads symbolic link.
---
---@param path string
---@return string
function M.readlink(path)
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
