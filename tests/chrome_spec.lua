---@diagnostic disable: undefined-global
-- Regression spec for lua/config/chrome.lua, the hand-rolled statusline +
-- tabline that stands in for lualine.nvim + bufferline.nvim. No plugin
-- manager, rtp extended to the repo. Asserts the parity surface: component
-- presence, buffer-id numbers, modified marker, diagnostics strings,
-- insert-after-current ordering, and the click handler's button
-- discrimination.
--
-- Exits 0 only after its last assertion: a VimLeavePre guard turns any
-- earlier exit into exit 1.

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local api = vim.api
local scratch = vim.fs.joinpath(vim.uv.os_tmpdir(), "chrome-spec-" .. vim.uv.os_getpid())
vim.uv.fs_mkdir(scratch, 448)

local finished = false
api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.fn.delete(scratch, "rf")
    if not finished then
      io.stderr:write("FAIL: chrome_spec exited before its last assertion\n")
      os.exit(1)
    end
  end,
})

local function fail(msg)
  io.stderr:write("FAIL: " .. msg .. "\n")
  finished = true -- reported here; the VimLeavePre guard need not repeat it
  vim.fn.delete(scratch, "rf")
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

--- Run `fn` while Neovim is really in Insert mode, then leave it. An -l
--- script cannot enter Insert mode and carry on: startinsert and nvim_input
--- take effect only once the script yields to the main loop, and feedkeys
--- "x!" returns only when Insert mode ends. So `fn` runs from a callback
--- scheduled onto the Insert-mode input loop, and feeds the <Esc> itself.
---@param fn fun()
local function in_insert_mode(fn)
  local err
  vim.schedule(function()
    local ok, e = pcall(fn)
    if not ok then
      err = e
    end
    api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end)
  api.nvim_feedkeys("i", "x!", false)
  if err then
    fail(tostring(err))
  end
end

--- The tabline text of one buffer's entry (between its %N@ and %X).
---@param tal string
---@param buf integer
---@return string
local function tab_entry(tal, buf)
  return tal:match("%%" .. buf .. "@(.-)%%X") or ""
end

-- 1. module load budget: the first require in a fresh process must stay
-- under 1.5 ms. A busy machine misses that now and then, so a sample over
-- budget is taken again in up to 5 fresh processes, one require each, and the
-- minimum decides. A repeat require in this process is not that quantity: it
-- costs about a third of a first load.
local load_budget_ms = 1.5
local load_children = 5
local t0 = vim.uv.hrtime()
local chrome = require("config.chrome")
local load_ms = (vim.uv.hrtime() - t0) / 1e6
if arg[1] == "--load-sample" then
  -- a child of the loop below: it ran this file up to the same require
  io.stdout:write(string.format("%.6f", load_ms))
  finished = true
  vim.fn.delete(scratch, "rf")
  os.exit(0)
end
local load_samples = { load_ms }
while load_samples[#load_samples] > load_budget_ms and #load_samples <= load_children do
  -- cwd and environment are inherited, so the child resolves the same tree
  local child = vim
    .system({ vim.v.progpath, "--headless", "-u", "NONE", "-i", "NONE", "-l", arg[0], "--load-sample" }, { text = true })
    :wait(30000)
  local child_ms = child.code == 0 and tonumber(child.stdout)
  if not child_ms then
    fail(string.format("module load child exited %d: %s%s", child.code, child.stdout, child.stderr))
  end
  load_samples[#load_samples + 1] = child_ms
end
local load_min_ms = math.min(unpack(load_samples))
print(string.format(
  "chrome.lua require: %.3f ms (samples: %s)",
  load_min_ms,
  table.concat(
    vim.tbl_map(function(ms)
      return string.format("%.3f", ms)
    end, load_samples),
    ", "
  )
))
if load_min_ms > load_budget_ms then
  fail(
    string.format(
      "module load %.3f ms exceeds the %.1f ms budget (minimum of %d fresh-process samples)",
      load_min_ms,
      load_budget_ms,
      #load_samples
    )
  )
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
-- lualine progress: cursor-based Top / Bot / NN% (never %P's "All")
assert_contains(stl, " Top ", "lualine progress shows Top on line 1")
do
  local saved = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" })
  vim.api.nvim_win_set_cursor(0, { 10, 0 })
  assert_contains(chrome.statusline(), " Bot ", "lualine progress shows Bot on last line")
  vim.api.nvim_win_set_cursor(0, { 5, 0 })
  assert_contains(chrome.statusline(), "50%%", "lualine progress shows percent mid-buffer")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, saved)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.bo.modified = false
end
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
assert_contains(stl, "󰅚 1", "error count with lualine error icon")
assert_contains(stl, "󰀪 2", "warn count with lualine warn icon")

-- 7. tabline: buffer ids, click regions, modified marker, diagnostics string
vim.o.columns = 200 -- four 20-cell entries must fit the overflow window
vim.bo[buf_b].modified = true
vim.diagnostic.set(ns, buf_d, {
  { lnum = 0, col = 0, severity = vim.diagnostic.severity.WARN, message = "w1" },
  { lnum = 0, col = 1, severity = vim.diagnostic.severity.HINT, message = "h1" },
})
local tal = chrome.tabline()
for _, buf in ipairs({ buf_a, buf_b, buf_c, buf_d }) do
  assert_contains(tal, "%" .. buf .. "@v:lua.Chrome_click@", "click region for buffer " .. buf)
  assert_contains(tal, " " .. buf .. " ", "buffer-id number for buffer " .. buf)
end
assert_contains(tal, "●", "modified marker on modified buffer")
assert_contains(tal, "alpha.txt", "buffer name rendered")
-- bufferline hands diagnostics_indicator ONE count (the total over every
-- severity) and the highest level, and lua/plugins/bufferline.lua draws
-- U+F05C for an error, U+F071 otherwise: 1 error + 2 warnings is one
-- " \u{f05c} 3", never a count per severity.
assert_contains(tab_entry(tal, buf_a), "alpha.txt \u{f05c} 3", "error + warnings: error icon and the total")
assert_not_contains(tab_entry(tal, buf_a), "2", "no separate per-severity warn count")
assert_contains(tab_entry(tal, buf_d), "delta.txt \u{f071}2", "warning + hint: the other icon and the total")
assert_not_contains(tab_entry(tal, buf_d), "\u{f05c}", "no error icon without an error")
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
vim.diagnostic.set(ns, buf_d, {})

-- 8. diagnostics do not churn while in insert mode (bufferline parity)
vim.diagnostic.set(ns, buf_c, {})
api.nvim_set_current_buf(buf_c)
local insert_ran = false
in_insert_mode(function()
  assert_eq("i", api.nvim_get_mode().mode, "the body runs in insert mode")
  vim.diagnostic.set(ns, buf_c, {
    { lnum = 0, col = 0, severity = vim.diagnostic.severity.ERROR, message = "late" },
  })
  assert_not_contains(chrome.statusline(), "ChromeDiagError", "insert mode defers diagnostic updates")
  insert_ran = true
end)
assert_eq(true, insert_ran, "the insert-mode body ran")
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

-- 9b. name truncation follows bufferline: the budget is the NAME's alone
-- (tab_size minus the modified icon and both padding cells -- the buffer id
-- and diagnostics are separate components), an over-budget name loses its
-- extension when the stem fits, otherwise it is cut by cell, and either way
-- the result carries an ellipsis instead of a silent hard cut.
do
  local saved_columns = vim.o.columns
  vim.o.columns = 320
  local trunc_bufs = {}
  for _, name in ipairs({
    "metafrastis.lua", -- exactly 15 cells: must survive intact
    "startup_budget_spec.lua", -- stem 19 cells: over budget too -> cell cut
    "aaaaaaaaaaaaaaaaaaaaaaaa", -- no extension: cell cut
    "chrome_specs.luaaaa", -- stem 12 cells: extension drop wins
    ".averyveryverylongrc", -- dotfile: empty stem, so the cell cut
  }) do
    vim.cmd.edit(scratch .. "/" .. name)
    trunc_bufs[#trunc_bufs + 1] = api.nvim_get_current_buf()
  end
  tal = chrome.tabline()
  assert_contains(tal, "metafrastis.lua", "a name inside the budget is never truncated")
  assert_contains(tal, "startup_budget…", "over-budget stem falls through to the cell cut")
  assert_contains(tal, "aaaaaaaaaaaaaa…", "extension-less name is cut by cell")
  assert_contains(tal, "chrome_specs…", "extension is dropped when the stem fits")
  assert_contains(tal, ".averyveryvery…", "a long dotfile is cut by cell, not reduced to a bare ellipsis")
  for _, b in ipairs(trunc_bufs) do
    vim.cmd("bdelete! " .. b)
  end
  vim.o.columns = saved_columns
end

-- 10. click handler: left switches, right force-deletes, middle no-ops
api.nvim_set_current_buf(buf_a)
chrome.click(buf_b, 1, "l", "")
assert_eq(buf_b, api.nvim_get_current_buf(), "left click switches buffer")
chrome.click(buf_c, 1, "m", "")
assert_eq(true, api.nvim_buf_is_valid(buf_c) and vim.bo[buf_c].buflisted, "middle click is a no-op")
vim.bo[buf_c].modified = true -- force path: bdelete! parity
chrome.click(buf_c, 1, "r", "")
assert_eq(true, api.nvim_buf_is_valid(buf_c), "right click is :bdelete!, not a wipeout")
assert_eq(false, vim.bo[buf_c].buflisted, "right click unlists the buffer")
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

-- 13. file icons survive :colorscheme. It clears the ChromeIcon* groups the
-- cached "%#group#icon " prefixes name, so ColorScheme must empty the cache
-- and let the next draw define them again. The provider is the installed
-- nvim-web-devicons; chrome asks lazy's plugin table whether it has loaded,
-- so that one table is stood in for (and removed again).
do
  local devicons_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "lazy", "nvim-web-devicons")
  if not vim.uv.fs_stat(devicons_dir) then
    print("SKIP section 13 (nvim-web-devicons not installed)")
  else
    vim.opt.runtimepath:prepend(devicons_dir)
    package.loaded["lazy.core.config"] = { plugins = { ["nvim-web-devicons"] = { _ = { loaded = {} } } } }
    api.nvim_set_current_buf(buf_a)
    vim.bo[buf_a].filetype = "lua"
    assert_contains(chrome.statusline(), "ChromeIconBlua", "lua buffers get a devicons prefix")
    assert_eq(true, api.nvim_get_hl(0, { name = "ChromeIconBlua" }).fg ~= nil, "icon group defined")
    vim.cmd.colorscheme("default")
    chrome.statusline()
    assert_eq(
      true,
      api.nvim_get_hl(0, { name = "ChromeIconBlua" }).fg ~= nil,
      "icon group defined again after :colorscheme"
    )
    package.loaded["lazy.core.config"] = nil
    vim.bo[buf_a].filetype = ""
  end
end

-- 14. the %@ click handler is global only while chrome owns the tabline
chrome.teardown()
assert_eq(nil, _G.Chrome_click, "teardown() withdraws the global click handler")
chrome.setup()
assert_eq("function", type(_G.Chrome_click), "setup() publishes it again")

finished = true
vim.fn.delete(scratch, "rf")
print("ALL PASS: chrome_spec")
os.exit(0)
