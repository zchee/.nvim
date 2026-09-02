---@diagnostic disable: undefined-global
-- Every file under lua/luasnippets/ must load cleanly.
--
-- A snippet file is only ever executed when its filetype is first entered
-- (plugins/luasnip.lua registers non-driver sets on their first InsertEnter),
-- so a broken one stays invisible until someone opens that filetype and finds
-- the whole set missing. The class of breakage that motivated this spec: fmta
-- reads "<>" as its placeholder delimiters, so a literal ">" in the template
-- must be doubled (">>"), and an unescaped one throws at load time.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local snippet_root = vim.fs.joinpath(vim.fn.getcwd(), "lua", "luasnippets")

-- LuaSnip lives in lazy's plugin dir, which -u NONE does not put on the rtp.
local luasnip_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "lazy", "LuaSnip")
if not vim.uv.fs_stat(luasnip_dir) then
  print("SKIP: LuaSnip is not installed at " .. luasnip_dir)
  return
end
vim.opt.runtimepath:append(luasnip_dir)

local ok_require, err_require = pcall(require, "luasnip")
if not ok_require then
  error("failed to load LuaSnip from " .. luasnip_dir .. ": " .. tostring(err_require))
end

local files = {}
for name, ty in vim.fs.dir(snippet_root) do
  if ty == "file" and name:match("%.lua$") then
    files[#files + 1] = name
  end
end
table.sort(files)
if #files == 0 then
  error("no snippet files found under " .. snippet_root)
end

local failures = {}
for _, name in ipairs(files) do
  -- Both shapes are in use and both are valid for the from_lua loader: a file
  -- may RETURN its snippet table (python.lua) or register imperatively with
  -- ls.add_snippets and return nothing (go.lua). Only a raised error is a bug.
  local ok, err = pcall(dofile, vim.fs.joinpath(snippet_root, name))
  if not ok then
    failures[#failures + 1] = string.format("%s: %s", name, tostring(err):gsub("\n", " "))
  end
end

if #failures > 0 then
  error(string.format("%d snippet file(s) failed to load:\n%s", #failures, table.concat(failures, "\n")))
end

print(string.format("luasnippets: %d files load cleanly (%s)", #files, table.concat(files, ", ")))
