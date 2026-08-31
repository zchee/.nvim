-- lua/plugins/lint.lua -- the nvim-lint trigger wiring: try_lint() fires only
-- for filetypes with a configured linter, FileType/BufWritePost stay
-- immediate, and InsertLeave is debounced trailing-edge per buffer (at most
-- one run per 500 ms quiet window). "lint" is stubbed via package.preload
-- with a counting try_lint before plugins.lint is required.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local try_lint_count = 0
local fake_lint = {
  linters = { golangcilint = {} },
  linters_by_ft = {},
  try_lint = function()
    try_lint_count = try_lint_count + 1
  end,
}
package.preload["lint"] = function()
  return fake_lint
end

local function assert_equal(got, want, msg)
  if got ~= want then
    error(("%s: got %s, want %s"):format(msg, vim.inspect(got), vim.inspect(want)), 2)
  end
end

require("plugins.lint")

assert_equal(fake_lint.linters_by_ft.go[1], "golangcilint", "plugins.lint must configure golangcilint for go")
assert_equal(try_lint_count, 0, "load in an empty no-filetype buffer must not lint")

local function fire_insert_leave(buf, times)
  for _ = 1, times do
    vim.api.nvim_exec_autocmds("InsertLeave", { buffer = buf })
  end
end

do -- filetypes without a configured linter never reach try_lint
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_option_value("filetype", "text", { buf = buf })
  vim.api.nvim_exec_autocmds("BufWritePost", { buffer = buf })
  fire_insert_leave(buf, 5)
  vim.wait(700)
  assert_equal(try_lint_count, 0, "unconfigured filetype (text) must never call try_lint")
  vim.api.nvim_buf_delete(buf, { force = true })
end

local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_win_set_buf(0, buf)

do -- FileType fires immediately for a configured filetype
  vim.api.nvim_set_option_value("filetype", "go", { buf = buf })
  assert_equal(try_lint_count, 1, "FileType go must lint immediately (no debounce)")
end

do -- InsertLeave burst collapses to exactly one debounced run
  local base = try_lint_count
  fire_insert_leave(buf, 10)
  assert_equal(try_lint_count, base, "InsertLeave must not lint synchronously (debounced)")
  vim.wait(2000, function()
    return try_lint_count > base
  end, 10)
  vim.wait(600) -- past a second full window: no straggler runs may arrive
  assert_equal(try_lint_count, base + 1, "an InsertLeave burst must produce exactly one try_lint")
end

do -- the timer re-arms: a later InsertLeave lints again
  local base = try_lint_count
  fire_insert_leave(buf, 1)
  vim.wait(2000, function()
    return try_lint_count > base
  end, 10)
  assert_equal(try_lint_count, base + 1, "a fresh InsertLeave after the window must lint once more")
end

do -- BufWritePost stays immediate
  local base = try_lint_count
  vim.api.nvim_exec_autocmds("BufWritePost", { buffer = buf })
  assert_equal(try_lint_count, base + 1, "BufWritePost must lint immediately (no debounce)")
end

do -- deleting the buffer cancels its pending debounce timer
  local scratch = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_option_value("filetype", "go", { buf = scratch })
  local base = try_lint_count
  fire_insert_leave(scratch, 3)
  vim.api.nvim_buf_delete(scratch, { force = true })
  vim.wait(800)
  assert_equal(try_lint_count, base, "a deleted buffer's pending debounce must never fire")
end
