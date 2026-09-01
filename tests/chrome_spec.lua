---@diagnostic disable: undefined-global
-- Regression spec for lua/config/chrome.lua (round-3 W3.2), the hand-rolled
-- statusline + tabline that replaces lualine.nvim + bufferline.nvim.
-- Runs under `nvim --headless -u NONE -l tests/chrome_spec.lua`: no plugins,
-- rtp stubbed to the repo. Asserts the parity surface from
-- .omc/plans/round3-chrome-parity.md: component presence, buffer-id numbers,
-- modified marker, diagnostics strings, insert-after-current ordering, and
-- the click handler's button discrimination.

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local function fail(msg)
  io.stderr:write("FAIL: " .. msg .. "\n")
  os.exit(1)
end

local function assert_contains(haystack, needle, message)
  if not haystack:find(needle, 1, true) then
    fail(string.format("%s: %q not found in %q", message, needle, haystack))
  end
end

local function assert_not_contains(haystack, needle, message)
  if haystack:find(needle, 1, true) then
    fail(string.format("%s: %q unexpectedly found in %q", message, needle, haystack))
  end
end

local function assert_eq(expected, actual, message)
  if expected ~= actual then
    fail(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local api = vim.api
local scratch = vim.fs.joinpath(vim.uv.os_tmpdir(), "chrome-spec-" .. vim.uv.os_getpid())
vim.uv.fs_mkdir(scratch, 448)

-- 1. module load budget: plain require must stay under 1.5 ms
local t0 = vim.uv.hrtime()
local chrome = require("config.chrome")
local load_ms = (vim.uv.hrtime() - t0) / 1e6
print(string.format("chrome.lua require: %.3f ms", load_ms))
if load_ms > 1.5 then
  fail(string.format("module load %.3f ms exceeds the 1.5 ms budget", load_ms))
end

chrome.setup()

assert_contains(vim.o.statusline, "v:lua.require'config.chrome'.statusline()", "vim.o.statusline wired")
assert_contains(vim.o.tabline, "v:lua.require'config.chrome'.tabline()", "vim.o.tabline wired")
assert_eq("function", type(_G.Chrome_click), "global click handler registered")

-- 2. insert_after_current ordering via real :edit BufAdd events
vim.cmd.edit(scratch .. "/alpha.txt") -- renames the initial buffer
local buf_a = api.nvim_get_current_buf()
vim.cmd.edit(scratch .. "/beta.txt")
local buf_b = api.nvim_get_current_buf()
vim.cmd.edit(scratch .. "/gamma.txt")
local buf_c = api.nvim_get_current_buf()
api.nvim_set_current_buf(buf_a)
vim.cmd.edit(scratch .. "/delta.txt") -- new buffer while A is current
local buf_d = api.nvim_get_current_buf()

local expected_order = { buf_a, buf_d, buf_b, buf_c }
local got_order = chrome.buffer_order()
if not vim.deep_equal(expected_order, got_order) then
  fail(
    string.format(
      "insert_after_current order: expected %s, got %s",
      vim.inspect(expected_order),
      vim.inspect(got_order)
    )
  )
end

-- 3. statusline: mode word, [New] flag, filename, native items, sections
api.nvim_set_current_buf(buf_a)
local stl = chrome.statusline()
assert_contains(stl, "NORMAL", "mode word rendered")
assert_contains(stl, "ChromeANormal", "normal-mode highlight group used")
assert_contains(stl, "alpha.txt", "filename rendered")
assert_contains(stl, "[New]", "BufNewFile flag renders [New]")
assert_contains(stl, "%3l:%-2c", "location item present")
assert_contains(stl, "%P", "progress item present")
assert_contains(stl, "unix", "fileformat text present")
assert_contains(stl, "utf-8", "encoding present")
assert_contains(stl, "%=", "middle divider present")

-- renders through the real statusline machinery without errors
local ok, rendered = pcall(api.nvim_eval_statusline, stl, {})
if not ok then
  fail("nvim_eval_statusline rejected the statusline: " .. tostring(rendered))
end
assert_contains(rendered.str, "NORMAL", "evaluated statusline carries the mode word")

-- 4. modified marker beats [New]; readonly renders [-]
vim.bo[buf_a].modified = true
assert_contains(chrome.statusline(), "[+]", "modified renders [+]")
vim.bo[buf_a].modified = false
vim.bo[buf_a].readonly = true
assert_contains(chrome.statusline(), "[-]", "readonly renders [-]")
vim.bo[buf_a].readonly = false

-- 5. gitsigns-fed branch and diff segments
vim.b[buf_a].gitsigns_head = "optimize"
vim.b[buf_a].gitsigns_status_dict = { added = 3, changed = 2, removed = 1 }
stl = chrome.statusline()
assert_contains(stl, "optimize", "branch from vim.b.gitsigns_head")
assert_contains(stl, "+3", "diff added count")
assert_contains(stl, "~2", "diff changed count")
assert_contains(stl, "-1", "diff removed count")

-- 6. diagnostics: cached on DiagnosticChanged, error icon only on errors
local ns = api.nvim_create_namespace("chrome_spec")
vim.diagnostic.set(ns, buf_a, {
  { lnum = 0, col = 0, severity = vim.diagnostic.severity.ERROR, message = "boom" },
  { lnum = 0, col = 1, severity = vim.diagnostic.severity.WARN, message = "meh" },
  { lnum = 0, col = 2, severity = vim.diagnostic.severity.WARN, message = "meh2" },
})
stl = chrome.statusline()
assert_contains(stl, "ChromeDiagError", "error diagnostics segment present")
assert_contains(stl, " 1", "error count with lualine error icon")
assert_contains(stl, " 2", "warn count with lualine warn icon")

-- 7. tabline: buffer ids, click regions, modified marker, diagnostics string
vim.o.columns = 200 -- four 20-cell entries must fit the overflow window
vim.bo[buf_b].modified = true
local tal = chrome.tabline()
for _, buf in ipairs({ buf_a, buf_b, buf_c, buf_d }) do
  assert_contains(tal, "%" .. buf .. "@v:lua.Chrome_click@", "click region for buffer " .. buf)
  assert_contains(tal, " " .. buf .. " ", "buffer-id number for buffer " .. buf)
end
assert_contains(tal, "●", "modified marker on modified buffer")
assert_contains(tal, "alpha.txt", "buffer name rendered")
assert_contains(tal, "  1", "bufferline diagnostics string: error icon + count")
assert_contains(tal, " 2", "bufferline diagnostics string: bare warn count")
assert_contains(tal, "", "bufferline slant left edge (U+E0BC) present")
assert_contains(tal, "", "bufferline slant right edge (U+E0BE) present")
assert_contains(tal, "ChromeTabSel", "selected-entry highlight present")
assert_contains(tal, "ChromeTabFill", "Pmenu-blended fill highlight present")

ok, rendered = pcall(api.nvim_eval_statusline, tal, { use_tabline = true })
if not ok then
  fail("nvim_eval_statusline rejected the tabline: " .. tostring(rendered))
end
assert_contains(rendered.str, "alpha.txt", "evaluated tabline renders buffer names")
vim.bo[buf_b].modified = false

-- 8. diagnostics do not churn while in insert mode (bufferline parity)
vim.diagnostic.set(ns, buf_c, {})
api.nvim_set_current_buf(buf_c)
api.nvim_feedkeys("i", "x!", false) -- enter and stay in insert mode
assert_eq("i", api.nvim_get_mode().mode, "feedkeys entered insert mode")
vim.diagnostic.set(ns, buf_c, {
  { lnum = 0, col = 0, severity = vim.diagnostic.severity.ERROR, message = "late" },
})
assert_not_contains(chrome.statusline(), "ChromeDiagError", "insert mode defers diagnostic updates")
api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
assert_eq("n", api.nvim_get_mode().mode, "back to normal mode")
assert_contains(chrome.statusline(), "ChromeDiagError", "InsertLeave flushes deferred diagnostics")
vim.diagnostic.set(ns, buf_c, {})

-- 9. dedup prefixes for same-named files in different directories
vim.uv.fs_mkdir(scratch .. "/one", 448)
vim.uv.fs_mkdir(scratch .. "/two", 448)
vim.cmd.edit(scratch .. "/one/same.txt")
local buf_s1 = api.nvim_get_current_buf()
vim.cmd.edit(scratch .. "/two/same.txt")
tal = chrome.tabline()
assert_contains(tal, "one/same.txt", "dedup prefix for first collision")
assert_contains(tal, "two/same.txt", "dedup prefix for second collision")
vim.cmd("bdelete! " .. buf_s1)
vim.cmd("bdelete! " .. api.nvim_get_current_buf())

-- 10. click handler: left switches, right force-deletes, middle no-ops
api.nvim_set_current_buf(buf_a)
chrome.click(buf_b, 1, "l", "")
assert_eq(buf_b, api.nvim_get_current_buf(), "left click switches buffer")
chrome.click(buf_c, 1, "m", "")
assert_eq(true, api.nvim_buf_is_valid(buf_c) and vim.bo[buf_c].buflisted, "middle click is a no-op")
vim.bo[buf_c].modified = true -- force path: bdelete! parity
chrome.click(buf_c, 1, "r", "")
assert_eq(false, api.nvim_buf_is_valid(buf_c) and vim.bo[buf_c].buflisted, "right click force-deletes buffer")
assert_not_contains(table.concat(chrome.buffer_order(), ","), tostring(buf_c), "deleted buffer left the order")

-- 11. statusline suppressed in the snacks picker input
vim.bo[buf_d].filetype = "snacks_picker_input"
api.nvim_set_current_buf(buf_d)
assert_eq("", chrome.statusline(), "snacks_picker_input blanks the statusline")
vim.bo[buf_d].filetype = ""

-- 12. % in a buffer name is escaped in statusline and tabline
vim.cmd({ cmd = "edit", args = { scratch .. "/we%ird.txt" }, magic = { file = false } })
local buf_p = api.nvim_get_current_buf()
assert_contains(chrome.statusline(), "we%%ird.txt", "statusline escapes % in filenames")
assert_contains(chrome.tabline(), "we%%ird.txt", "tabline escapes % in filenames")
vim.cmd("bdelete! " .. buf_p)

print("ALL PASS: chrome_spec")
os.exit(0)
