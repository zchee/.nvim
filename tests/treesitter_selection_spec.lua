---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local sel = require("plugins.treesitter_selection")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_truthy(value, message)
  if not value then
    error(message)
  end
end

-- scratch lua buffer using the bundled lua parser
local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(buf)
vim.api.nvim_buf_set_lines(buf, 0, -1, true, {
  "local function foo()",
  "  local x = 1 + 2",
  "end",
})
vim.bo[buf].filetype = "lua"
vim.treesitter.start(buf, "lua")

local function marks()
  local s = vim.api.nvim_buf_get_mark(buf, "<")
  local e = vim.api.nvim_buf_get_mark(buf, ">")
  return { s[1], s[2], e[1], e[2] }
end

-- cursor on the "1" literal
vim.api.nvim_win_set_cursor(0, { 2, 12 })

sel.init_selection()
-- note: mode transitions from :normal! gv are not reliably observable in
-- headless -l scripts; the '<'/'>' marks are the behavioral contract here
local first = marks()
assert_equal(2, first[1], "init: start row on literal line")
assert_equal(12, first[2], "init: start col on literal")

sel.node_incremental()
local second = marks()
assert_truthy(
  second[4] > first[4] or second[3] > first[3] or second[2] < first[2],
  "node_incremental must widen the selection"
)

sel.node_incremental()
local third = marks()
assert_truthy(third[2] <= second[2] and third[4] >= second[4], "second node_incremental must not shrink the selection")

sel.node_decremental()
local back = marks()
assert_equal(second[1], back[1], "node_decremental: start row restored")
assert_equal(second[2], back[2], "node_decremental: start col restored")
assert_equal(second[3], back[3], "node_decremental: end row restored")
assert_equal(second[4], back[4], "node_decremental: end col restored")

-- scope_incremental walks scope-ish ancestors: first the inner block, then
-- the enclosing function spanning all three lines
sel.scope_incremental()
local scope1 = marks()
assert_truthy(scope1[2] <= back[2] and scope1[4] >= back[4], "first scope_incremental must not shrink the selection")
sel.scope_incremental()
local scope2 = marks()
assert_equal(1, scope2[1], "second scope_incremental: reaches the function start")
assert_equal(3, scope2[3], "second scope_incremental: reaches the function end")

print("OK: treesitter_selection incremental selection behaves")
