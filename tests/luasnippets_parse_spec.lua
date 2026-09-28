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

-- go.lua gates its in-function and test-only snippets behind conditions.
-- They must reach the snippet itself (ls.s opts), not fmt()/fmta(), whose
-- third argument is fmt's own options table and silently drops them. The
-- scratch buffer below is neither inside a function nor a _test.go file, so
-- every gated snippet must be hidden and refuse to expand there, while an
-- ungated one stays available.
do
  local ls = require("luasnip")
  local gated = {
    -- in a function
    len = 1,
    iterseq = 1,
    iterseq2 = 1,
    ff = 1,
    fl = 1,
    iferr = 1,
    errnil = 1,
    -- in a test file / test function; "ft" exists in both sets
    ft = 2,
    tf = 1,
    test = 1,
    diff = 1,
    bench = 1,
    benchp = 1,
  }
  local ungated = { "tabwriter", "isASCII", "doc_string" }
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(true, false))
  local by_trig = {}
  for _, snip in ipairs(ls.get_snippets("go")) do
    by_trig[snip.trigger] = by_trig[snip.trigger] or {}
    table.insert(by_trig[snip.trigger], snip)
  end
  local problems = {}
  for trig, count in pairs(gated) do
    local snips = by_trig[trig] or {}
    if #snips ~= count then
      problems[#problems + 1] = string.format("%s: want %d snippet(s), got %d", trig, count, #snips)
    end
    for _, snip in ipairs(snips) do
      if snip.show_condition(trig) ~= false then
        problems[#problems + 1] = trig .. ": shown outside its context (show_condition missing)"
      end
      if snip:resolveExpandParams(trig, trig, {}) ~= nil then
        problems[#problems + 1] = trig .. ": expands outside its context (condition missing)"
      end
    end
  end
  for _, trig in ipairs(ungated) do
    local snip = (by_trig[trig] or {})[1]
    if not snip then
      problems[#problems + 1] = trig .. ": ungated control snippet is missing"
    elseif snip.show_condition(trig) ~= true or snip:resolveExpandParams(trig, trig, {}) == nil then
      problems[#problems + 1] = trig .. ": ungated snippet must stay available"
    end
  end
  if #problems > 0 then
    error("go snippet conditions:\n" .. table.concat(problems, "\n"))
  end
end

print(string.format("luasnippets: %d files load cleanly (%s)", #files, table.concat(files, ", ")))
