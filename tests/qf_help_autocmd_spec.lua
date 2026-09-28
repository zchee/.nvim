-- lua/config/autocmd.lua -- the pager-window autocmds: u/d page in quickfix
-- and read-only help, but stay undo/delete in a help file opened for editing.
--
-- Run: nvim --headless -u NONE -i NONE -l tests/qf_help_autocmd_spec.lua
-- Exits 0 only after printing "ALL PASS".
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
end)

if not ok then
  io.stderr:write("FAIL: " .. tostring(err) .. "\n")
  os.exit(1)
end

print("ALL PASS: qf_help_autocmd_spec")
os.exit(0)
