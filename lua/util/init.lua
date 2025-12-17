local M = {}

function _G.dump(...)
  vim.print(vim.inspect(...))
end

function M.cmp_or(val, default)
  if val == nil then return default end
  return val
end

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

---@param path string
---@return boolean
function M.is_exists(path)
  local file = io.open(path, "r")
  if (file ~= nil) then
    io.close(file)
    return true
  else
    return false
  end
end

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

---
---Returns the value of the process environment variable `varname`.
---
---@param varname string
---@return string?
---@nodiscard
function M.getenv(varname)
  return tostring(os.getenv(varname))
end

---
---expands env path and reads symbolic link.
---
---@param path string
---@return string
function M.readlink(path)
  return vim.uv.fs_readlink(path) or ""
end

---
---Return XDG_CACHE_HOME
---
---@return string
function M.xdg_cache_home()
  return tostring(M.readlink(tostring(os.getenv("XDG_CACHE_HOME"))))
end

---
---Return XDG_CONFIG_HOME
---
---@return string
function M.xdg_config_home()
  return tostring(M.readlink(tostring(os.getenv("XDG_CONFIG_HOME"))))
end

---
---Return XDG_DATA_HOME
---
---@return string
function M.xdg_data_home()
  return tostring(M.readlink(tostring(os.getenv("XDG_DATA_HOME"))))
end

---
---Return XDG_STATE_HOME
---
---@return string
function M.xdg_state_home()
  return tostring(M.readlink(tostring(os.getenv("XDG_STATE_HOME"))))
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
---Returns the UNIX prefix directory according to the macOS cpu architecture.
---
---@param ... string
---@return string
function M.prefix(...)
  local machine = vim.uv.os_uname()["machine"]
  local prefix
  if machine == "x86_64" then
    prefix = "/usr/local"
  elseif machine == "arm64" then
    prefix = "/opt/local"
  end

  return vim.fs.joinpath(tostring(prefix), ...)
end

---
---Returns the Homebrew prefix directory according to the macOS cpu architecture.
---
---@return string
function M.homebrew_prefix()
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

  return tostring(prefix)
end

---@param binary string binary name
---@return string
function M.homebrew_portable_ruby(binary)
  local prefix = M.homebrew_prefix()
  return vim.fs.joinpath(prefix, "Library/Homebrew/vendor/portable-ruby/current/bin", binary)
end

---@param formula string homebrew formula name
---@param binary string binary name
---@return string
function M.homebrew_binary(formula, binary)
  return vim.fs.joinpath(M.homebrew_prefix(), "opt", formula, "bin", binary)
end

---@param binary string binary name
---@return string
function M.bun_prefix(binary)
  return tostring(vim.fs.joinpath(os.getenv("BUN_INSTALL"), "bin", binary))
end

---@param binary string binary name
---@return string
function M.pnpm_prefix(binary)
  return tostring(vim.fs.joinpath(os.getenv("PNPM_HOME"), binary))
end

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
