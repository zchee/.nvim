local a = require("plenary.async.async")
local uv_async = require("plenary.async.uv_async")

local function add(name, argc)
  local success, ret = pcall(a.wrap, vim.uv[name], argc)
  if not success then
    error("Failed to add function with name " .. name)
  end
  uv_async[name] = ret
end

add("cwd", 0)
add("os_homedir", 0)
add("os_uname", 0)
add("available_parallelism", 0)
