---@diagnostic disable: undefined-global, unused-local
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local compat = require("plugins.illuminate_compat")

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

local function assert_falsy(value, message)
  if value then
    error(message)
  end
end

do
  assert_truthy(
    compat.is_treesitter_locals_error(
      ".../nvim-treesitter/lua/nvim-treesitter/locals.lua:286: attempt to call method 'parent' (a nil value)"
    ),
    "matcher should detect the known nvim-treesitter locals failure"
  )

  assert_falsy(compat.is_treesitter_locals_error("plain error"), "matcher should ignore unrelated errors")

  assert_truthy(
    compat.is_invalid_line_error("Vim:E966: Invalid line number: 240"),
    "matcher should detect stale cursor line failures"
  )

  assert_falsy(
    compat.is_invalid_line_error("E21: Cannot make changes, 'modifiable' is off"),
    "invalid line matcher should ignore unrelated errors"
  )
end

do
  local line_count_calls = 0
  local line_length_calls = 0
  local cursor = compat.normalize_cursor(5, { 240, 7 }, {
    get_line_count = function(bufnr)
      line_count_calls = line_count_calls + 1
      assert_equal(5, bufnr, "normalize_cursor should ask for the target buffer line count")
      return 3
    end,
    get_lines = function(bufnr, start, finish, strict)
      line_length_calls = line_length_calls + 1
      assert_equal(5, bufnr, "normalize_cursor should ask for the target buffer line")
      assert_equal(2, start, "normalize_cursor should clamp before reading the line")
      assert_equal(3, finish, "normalize_cursor should request exactly one line")
      assert_falsy(strict, "normalize_cursor should read lines without strict indexing")
      return { "abcde" }
    end,
  })

  assert_equal(1, line_count_calls, "normalize_cursor should query the line count once")
  assert_equal(1, line_length_calls, "normalize_cursor should query the line text once")
  assert_equal(2, cursor[1], "normalize_cursor should clamp the line to the last buffer line")
  assert_equal(5, cursor[2], "normalize_cursor should clamp the column to the line length")
end

do
  local references = compat.sanitize_references(8, {
    {
      { 95, 10 },
      { 96, 30 },
      vim.lsp.protocol.DocumentHighlightKind.Text,
    },
    { "bad", "shape" },
  }, {
    get_line_count = function()
      return 95
    end,
    get_lines = function(_bufnr, start, _finish, _strict)
      if start == 94 then
        return { "tail" }
      end
      return { "ignored" }
    end,
  })

  assert_equal(1, #references, "sanitize_references should drop malformed entries")
  assert_equal(94, references[1][1][1], "sanitize_references should clamp the start line")
  assert_equal(4, references[1][1][2], "sanitize_references should clamp the start column")
  assert_equal(94, references[1][2][1], "sanitize_references should clamp the finish line")
  assert_equal(4, references[1][2][2], "sanitize_references should clamp the finish column")
end

do
  local changedtick = 41
  local cursor = { 8, 3 }
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, _cursor)
      error(
        ".../nvim-treesitter/lua/nvim-treesitter/locals.lua:286: attempt to call method 'parent' (a nil value)"
      )
    end,
  }

  compat.patch_treesitter_provider(provider, {
    get_changedtick = function()
      return changedtick
    end,
    get_cursor_pos = function()
      return { cursor[1], cursor[2] }
    end,
    get_line_count = function()
      return 100
    end,
    get_lines = function()
      return { string.rep("x", 100) }
    end,
  })

  assert_equal(nil, provider.get_references(7, cursor), "known treesitter failure should be suppressed")
  assert_falsy(provider.is_ready(7), "provider should be skipped for the same buffer state")

  cursor = { 9, 3 }
  assert_truthy(provider.is_ready(7), "provider should recover after the cursor moves")
end

do
  local changedtick = 9
  local cursor = { 240, 0 }
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, _cursor)
      error("Vim:E966: Invalid line number: 240")
    end,
  }

  compat.patch_treesitter_provider(provider, {
    get_changedtick = function()
      return changedtick
    end,
    get_cursor_pos = function()
      return { cursor[1], cursor[2] }
    end,
    get_line_count = function()
      return 4
    end,
    get_lines = function()
      return { "tail" }
    end,
  })

  assert_equal(nil, provider.get_references(3, cursor), "invalid cursor treesitter errors should be suppressed")
  assert_falsy(provider.is_ready(3), "treesitter provider should be skipped until cursor state changes")

  cursor = { 1, 0 }
  assert_truthy(provider.is_ready(3), "treesitter provider should recover once the cursor is valid again")
end

do
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, cursor)
      return {
        {
          { cursor[1], cursor[2] },
          { cursor[1], cursor[2] + 10 },
          vim.lsp.protocol.DocumentHighlightKind.Read,
        },
      }
    end,
  }

  compat.patch_treesitter_provider(provider, {
    get_changedtick = function()
      return 1
    end,
    get_cursor_pos = function()
      return { 1, 0 }
    end,
    get_line_count = function()
      return 2
    end,
    get_lines = function(_bufnr, start, _finish, _strict)
      if start == 1 then
        return { "abc" }
      end
      return { "abcdef" }
    end,
  })

  local refs = provider.get_references(3, { 1, 5 })
  assert_equal(1, refs[1][1][1], "treesitter references should keep the normalized line")
  assert_equal(3, refs[1][1][2], "treesitter references should clamp the start column")
  assert_equal(3, refs[1][2][2], "treesitter references should clamp the finish column")
end

do
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, _cursor)
      error("unexpected failure")
    end,
  }

  compat.patch_treesitter_provider(provider, {
    get_changedtick = function()
      return 1
    end,
    get_cursor_pos = function()
      return { 1, 0 }
    end,
  })

  local ok, err = pcall(provider.get_references, 3, { 1, 0 })
  assert_falsy(ok, "unknown provider failures must still propagate")
  assert_truthy(type(err) == "string" and err:find("unexpected failure", 1, true) ~= nil, "error should be preserved")
end

do
  local provider = {
    is_ready = function(_bufnr)
      error("Vim:E966: Invalid line number: 240")
    end,
    get_references = function(_bufnr, _cursor)
      return {}
    end,
  }

  compat.patch_regex_provider(provider)
  assert_falsy(provider.is_ready(11), "regex provider should treat invalid-line readiness failures as not ready")
end

do
  local seen_cursor
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, cursor)
      seen_cursor = { cursor[1], cursor[2] }
      return {
        {
          { cursor[1], cursor[2] },
          { cursor[1], cursor[2] + 1 },
          vim.lsp.protocol.DocumentHighlightKind.Text,
        },
      }
    end,
  }

  compat.patch_regex_provider(provider, {
    get_line_count = function()
      return 5
    end,
    get_lines = function(_bufnr, start, _finish, _strict)
      if start == 4 then
        return { "four" }
      end
      return { "" }
    end,
  })

  local refs = provider.get_references(13, { 240, 40 })
  assert_equal(4, seen_cursor[1], "regex provider should clamp the cursor line before reading references")
  assert_equal(4, seen_cursor[2], "regex provider should clamp the cursor column before reading references")
  assert_equal(4, refs[1][1][1], "regex provider should use the normalized cursor in returned references")
  assert_equal(4, refs[1][1][2], "regex provider should sanitize the start column")
end

do
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, _cursor)
      error("Vim:E966: Invalid line number: 240")
    end,
  }

  compat.patch_regex_provider(provider)
  assert_equal(
    nil,
    provider.get_references(17, { 240, 0 }),
    "regex provider should suppress invalid-line reference failures"
  )
end

do
  local provider = {
    is_ready = function(_bufnr)
      return true
    end,
    get_references = function(_bufnr, _cursor)
      error("unexpected failure")
    end,
  }

  compat.patch_regex_provider(provider)
  local ok, err = pcall(provider.get_references, 19, { 0, 0 })
  assert_falsy(ok, "regex provider should still surface unrelated failures")
  assert_truthy(
    type(err) == "string" and err:find("unexpected failure", 1, true) ~= nil,
    "regex error should be preserved"
  )
end

do
  local seen_references
  local reference_module = {
    buf_set_references = function(_bufnr, references)
      seen_references = references
    end,
  }

  compat.patch_reference_module(reference_module, {
    get_line_count = function()
      return 95
    end,
    get_lines = function(_bufnr, start, _finish, _strict)
      if start == 94 then
        return { "tail" }
      end
      return { "abcdef" }
    end,
  })

  reference_module.buf_set_references(23, {
    {
      { 95, 10 },
      { 96, 30 },
      vim.lsp.protocol.DocumentHighlightKind.Write,
    },
  })

  assert_equal(94, seen_references[1][1][1], "reference module should clamp the stored start line")
  assert_equal(4, seen_references[1][1][2], "reference module should clamp the stored start column")
  assert_equal(94, seen_references[1][2][1], "reference module should clamp the stored finish line")
  assert_equal(4, seen_references[1][2][2], "reference module should clamp the stored finish column")
end
