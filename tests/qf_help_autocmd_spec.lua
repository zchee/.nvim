-- lua/config/autocmd.lua -- the pager-window autocmds: u/d page in quickfix
-- and read-only help, but stay undo/delete in a help file opened for editing;
-- closing the last file window quits a tab left holding only quickfix, but
-- <C-w>T on quickfix keeps its new tab, and a refused :quit is one message.
--
-- Run: nvim --headless -u NONE -i NONE -l tests/qf_help_autocmd_spec.lua
-- Exits 0 only after printing "ALL PASS": the last case ends Nvim through
-- the auto-quit itself, and a VimLeavePre guard turns any other exit into
-- exit 1.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

require("config.autocmd")

local function assert_equal(got, want, msg)
  if got ~= want then
    error(("%s: got %s, want %s"):format(msg, vim.inspect(got), vim.inspect(want)), 2)
  end
end

---@param lhs string
---@return string rhs of the buffer-local normal-mode mapping, "" if none
local function buf_map(lhs)
  local map = vim.fn.maparg(lhs, "n", false, true)
  return map.buffer == 1 and map.rhs or ""
end

local finished = false
local expect_autoquit = false
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if finished then
      return
    end
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if expect_autoquit and #wins == 1 and vim.bo.filetype == "qf" then
      print("ALL PASS: qf_help_autocmd_spec")
      return
    end
    io.stderr:write("FAIL: qf_help_autocmd_spec exited before its last assertion\n")
    os.exit(1)
  end,
})

---Let scheduled callbacks (the auto-quit) run.
local function drain()
  vim.wait(50, function()
    return false
  end)
end

local ok, err = pcall(function()
  do -- quickfix pages on u/d: its buffer is still modifiable when FileType
    -- fires, so a modifiable gate dropped these maps (a0c9cc1)
    vim.fn.setqflist({ { filename = "x", lnum = 1, text = "t" } })
    vim.cmd("copen")
    assert_equal(vim.bo.filetype, "qf", "copen opens the quickfix window")
    assert_equal(buf_map("u"), "<C-u>", "qf u pages up")
    assert_equal(buf_map("d"), "<C-d>", "qf d pages down")
    assert_equal(buf_map("q"), "<Cmd>q<CR>", "qf q closes")
    vim.cmd("cclose")
  end

  do -- a help file being written keeps u = undo and d = delete
    vim.cmd("enew")
    vim.bo.filetype = "help"
    assert_equal(vim.bo.modifiable, true, "spec precondition: the help buffer is modifiable")
    assert_equal(buf_map("u"), "", "writable help keeps u unmapped")
    assert_equal(buf_map("d"), "", "writable help keeps d unmapped")
    assert_equal(buf_map("q"), "<Cmd>q<CR>", "writable help still closes on q")
    vim.cmd("bwipeout!")
  end

  do -- :help (read-only) pages on u/d
    vim.cmd("help help")
    assert_equal(vim.bo.filetype, "help", ":help opens a help buffer")
    assert_equal(vim.bo.modifiable, false, "spec precondition: :help is read-only")
    assert_equal(buf_map("u"), "<C-u>", "read-only help u pages up")
    assert_equal(buf_map("d"), "<C-d>", "read-only help d pages down")
    vim.cmd("helpclose")
  end

  do -- a refused auto-quit (a hidden buffer is modified) is one E37 line,
    -- not a Lua traceback from the scheduled callback
    vim.o.hidden = true
    vim.cmd("enew")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "dirty" })
    vim.cmd("copen")
    vim.cmd("wincmd p")
    vim.v.errmsg = ""
    vim.cmd("quit")
    drain()
    assert_equal(vim.v.errmsg:find("stack traceback", 1, true), nil, "no Lua traceback in v:errmsg")
    local messages = vim.api.nvim_exec2("messages", { output = true }).output
    assert_equal(messages:find("E37: No write since last change", 1, true) ~= nil, true, "the refusal is reported")
    assert_equal(messages:find("stack traceback", 1, true), nil, "no Lua traceback in :messages")
    vim.cmd("silent! %bwipeout!")
    assert_equal(#vim.api.nvim_list_wins(), 1, "cleanup leaves one window")
  end

  do -- <C-w>T moves quickfix into a new tab holding one qf window; that tab
    -- stays (the old window closed is quickfix itself, not a file window)
    vim.cmd("copen")
    vim.cmd("wincmd T")
    drain()
    assert_equal(#vim.api.nvim_list_tabpages(), 2, "<C-w>T keeps the new tab")
    assert_equal(vim.bo.filetype, "qf", "the new tab shows quickfix")
    vim.cmd("tabclose")
    drain()
    assert_equal(#vim.api.nvim_list_tabpages(), 1, "cleanup leaves one tab")
    assert_equal(#vim.api.nvim_list_wins(), 1, "cleanup leaves one window")
  end
end)

if not ok then
  io.stderr:write("FAIL: " .. tostring(err) .. "\n")
  finished = true -- reported here; the VimLeavePre guard need not repeat it
  os.exit(1)
end

-- Last: closing the only file window leaves quickfix alone, so the auto-quit
-- ends Nvim; the VimLeavePre guard prints ALL PASS and the exit status is 0.
vim.cmd("copen")
vim.cmd("wincmd p")
expect_autoquit = true
vim.cmd("quit")
drain()
io.stderr:write("FAIL: :q from the last file window did not quit the qf-only tab\n")
finished = true
os.exit(1)
