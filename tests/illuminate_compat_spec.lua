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
    compat.is_treesitter_locals_parent_error(
      ".../nvim-treesitter/lua/nvim-treesitter/locals.lua:286: attempt to call method 'parent' (a nil value)"
    ),
    "matcher should detect the known nvim-treesitter locals failure"
  )

  assert_falsy(
    compat.is_treesitter_locals_parent_error("plain error"),
    "matcher should ignore unrelated errors"
  )
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
  })

  assert_equal(nil, provider.get_references(7, cursor), "known treesitter failure should be suppressed")
  assert_falsy(provider.is_ready(7), "provider should be skipped for the same buffer state")

  cursor = { 9, 3 }
  assert_truthy(provider.is_ready(7), "provider should recover after the cursor moves")
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
