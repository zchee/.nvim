-- lua/config/autocmd.lua -- the pager-window autocmds: u/d page in quickfix
-- and read-only help, but stay undo/delete in a help file opened for editing;
-- closing the last file window quits a tab left holding only quickfix, but
-- <C-w>T on quickfix keeps its new tab, closing a focused float in a qf-only
-- tab keeps that tab, and a refused :quit is one message.
--
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

local function assert_equal(want, got, msg)
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
    -- fires, so a modifiable gate would drop these maps
    vim.fn.setqflist({ { filename = "x", lnum = 1, text = "t" } })
    vim.cmd("copen")
    assert_equal("qf", vim.bo.filetype, "copen opens the quickfix window")
    assert_equal("<C-u>", buf_map("u"), "qf u pages up")
    assert_equal("<C-d>", buf_map("d"), "qf d pages down")
    assert_equal("<Cmd>q<CR>", buf_map("q"), "qf q closes")
    vim.cmd("cclose")
  end

  do -- a help file being written keeps u = undo and d = delete
    vim.cmd("enew")
    vim.bo.filetype = "help"
    assert_equal(true, vim.bo.modifiable, "spec precondition: the help buffer is modifiable")
    assert_equal("", buf_map("u"), "writable help keeps u unmapped")
    assert_equal("", buf_map("d"), "writable help keeps d unmapped")
    assert_equal("<Cmd>q<CR>", buf_map("q"), "writable help still closes on q")
    vim.cmd("bwipeout!")
  end

  do -- :help (read-only) pages on u/d
    vim.cmd("help help")
    assert_equal("help", vim.bo.filetype, ":help opens a help buffer")
    assert_equal(false, vim.bo.modifiable, "spec precondition: :help is read-only")
    assert_equal("<C-u>", buf_map("u"), "read-only help u pages up")
    assert_equal("<C-d>", buf_map("d"), "read-only help d pages down")
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
    assert_equal(nil, vim.v.errmsg:find("stack traceback", 1, true), "no Lua traceback in v:errmsg")
    local messages = vim.api.nvim_exec2("messages", { output = true }).output
    assert_equal(true, messages:find("E37: No write since last change", 1, true) ~= nil, "the refusal is reported")
    assert_equal(nil, messages:find("stack traceback", 1, true), "no Lua traceback in :messages")
    vim.cmd("silent! %bwipeout!")
    assert_equal(1, #vim.api.nvim_list_wins(), "cleanup leaves one window")
  end

  do -- <C-w>T moves quickfix into a new tab holding one qf window; that tab
    -- stays (the old window closed is quickfix itself, not a file window)
    vim.cmd("copen")
    vim.cmd("wincmd T")
    drain()
    assert_equal(2, #vim.api.nvim_list_tabpages(), "<C-w>T keeps the new tab")
    assert_equal("qf", vim.bo.filetype, "the new tab shows quickfix")
    vim.cmd("tabclose")
    drain()
    assert_equal(1, #vim.api.nvim_list_tabpages(), "cleanup leaves one tab")
    assert_equal(1, #vim.api.nvim_list_wins(), "cleanup leaves one window")
  end

  do -- a focused float closed in the <C-w>T tab is not a file window
    -- closing: the hover preview's own q keeps the qf tab
    vim.cmd("copen")
    vim.cmd("wincmd T")
    drain()
    local _, float = vim.lsp.util.open_floating_preview({ "hover" }, "markdown", { focus_id = "qf_help_spec" })
    vim.api.nvim_set_current_win(float)
    vim.api.nvim_feedkeys("q", "x", false)
    drain()
    assert_equal(false, vim.api.nvim_win_is_valid(float), "the preview's q closes the float")
    assert_equal(2, #vim.api.nvim_list_tabpages(), "closing a focused float keeps the qf tab")
    assert_equal("qf", vim.bo.filetype, "the qf tab still shows quickfix")
    vim.cmd("tabclose")
    drain()
    assert_equal(1, #vim.api.nvim_list_tabpages(), "cleanup leaves one tab")
  end

  do -- the same for an entered float in a tab holding only quickfix (:only)
    vim.cmd("tabnew")
    vim.cmd("copen")
    vim.cmd("only")
    local float = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
      relative = "editor",
      row = 1,
      col = 1,
      width = 10,
      height = 2,
    })
    vim.api.nvim_win_close(float, true)
    drain()
    assert_equal(2, #vim.api.nvim_list_tabpages(), "closing an entered float keeps the qf-only tab")
    assert_equal("qf", vim.bo.filetype, "the qf-only tab still shows quickfix")
    vim.cmd("tabclose")
    drain()
    assert_equal(1, #vim.api.nvim_list_tabpages(), "cleanup leaves one tab")
    assert_equal(1, #vim.api.nvim_list_wins(), "cleanup leaves one window")
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
