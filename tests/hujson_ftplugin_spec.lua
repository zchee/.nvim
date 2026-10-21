---@diagnostic disable: undefined-global
-- Regression spec for ftplugin/hujson.lua.
--
-- filetype.lua gives *.hujson its own filetype, and Nvim ships no ftplugin for
-- it, so 'commentstring' stayed empty and `gcc` failed with "Option
-- 'commentstring' is empty" -- when the extension still mapped to jsonc,
-- $VIMRUNTIME/ftplugin/jsonc.vim had set it. The ftplugin sources jsonc's
-- settings; this pins what a hujson buffer ends up with, including the
-- after/ftplugin/jsonc.lua indent options, and drives `gcc` both ways.
local cwd = vim.fn.getcwd()
vim.opt.runtimepath:prepend(cwd)
vim.opt.runtimepath:append(cwd .. "/after")
vim.cmd("filetype plugin on")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

do
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = "hujson"

  assert_equal("// %s", vim.bo[buf].commentstring, "hujson should take jsonc's commentstring")
  assert(
    vim.tbl_contains(vim.split(vim.bo[buf].comments, ","), "://"),
    "hujson 'comments' should know `//` line comments, got " .. vim.bo[buf].comments
  )
  assert(
    vim.tbl_contains(vim.split(vim.bo[buf].comments, ","), "s1:/*"),
    "hujson 'comments' should know `/* */` block comments, got " .. vim.bo[buf].comments
  )
  -- jsonc.vim's own `runtime! ftplugin/json[.]{vim,lua}` already reaches
  -- after/ftplugin/json.lua, which today sets the same indent options, so the
  -- option values alone cannot tell whether the jsonc one was sourced.
  local sourced = vim.tbl_map(function(script)
    return script.name
  end, vim.fn.getscriptinfo())
  assert(
    vim.iter(sourced):any(function(name)
      return vim.endswith(name, "/after/ftplugin/jsonc.lua")
    end),
    "hujson should source after/ftplugin/jsonc.lua, sourced: " .. vim.inspect(sourced)
  )
  assert_equal(2, vim.bo[buf].shiftwidth, "the jsonc indent options should reach hujson (shiftwidth)")
  assert_equal(2, vim.bo[buf].tabstop, "the jsonc indent options should reach hujson (tabstop)")
  -- after jsonc's expandtab, so hand-typed indents match hujsonfmt's tabs
  assert_equal(false, vim.bo[buf].expandtab, "hujson should indent with tabs like hujsonfmt")

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "{", '  "a": 1,', "}" })
  vim.api.nvim_win_set_cursor(0, { 2, 0 })
  vim.cmd("normal gcc")
  assert_equal('  // "a": 1,', vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1], "gcc should comment the line")
  vim.cmd("normal gcc")
  assert_equal('  "a": 1,', vim.api.nvim_buf_get_lines(buf, 1, 2, false)[1], "gcc should uncomment the line")
  vim.api.nvim_buf_delete(buf, { force = true })
end

do
  -- On a Tree-sitter buffer the `gc` operator resolves the commentstring by
  -- language through this call rather than reading the buffer option.
  assert_equal(
    "// %s",
    vim.filetype.get_option("hujson", "commentstring"),
    "vim.filetype.get_option should see the hujson ftplugin"
  )
end
