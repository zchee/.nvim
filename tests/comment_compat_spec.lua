---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local compat = require("plugins.comment_compat")

local LINEWISE = 1

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

local function new_ft(mappings)
  mappings = mappings or {}

  return {
    get = function(lang, ctype)
      local tuple = mappings[lang]
      if tuple == nil then
        return nil
      end

      if ctype == nil then
        return vim.deepcopy(tuple)
      end

      return tuple[ctype]
    end,
    contains = function()
      error("contains should not run without a parser")
    end,
  }
end

do
  vim.bo.filetype = "kitty"

  local ft = new_ft()
  compat.patch_ft(ft, {
    get_parser = function()
      return nil
    end,
  })

  assert_truthy(ft._zchee_nil_parser_guard_patched, "patch_ft should mark the table as patched")
  assert_equal(
    nil,
    ft.calculate({
      ctype = LINEWISE,
      range = { srow = 1, scol = 0, erow = 1, ecol = 0 },
    }),
    "patch_ft should return nil instead of crashing when get_parser returns nil"
  )
end

do
  vim.bo.filetype = "lua"

  local ft = new_ft({
    lua = { "--%s", "--[[%s]]" },
  })
  compat.patch_ft(ft, {
    get_parser = function()
      error("parser missing")
    end,
  })

  assert_equal(
    "--%s",
    ft.calculate({
      ctype = LINEWISE,
      range = { srow = 2, scol = 3, erow = 4, ecol = 5 },
    }),
    "patch_ft should fall back to the filetype commentstring when get_parser errors"
  )
end

do
  vim.bo.filetype = "markdown"

  local expected_range = { 4, 2, 6, 8 }
  local parser = {
    lang = function()
      return "lua"
    end,
  }
  local ft = new_ft({
    lua = { "--%s", "--[[%s]]" },
    markdown = { "<!--%s-->" },
  })

  ft.contains = function(actual_parser, actual_range)
    assert_equal(parser, actual_parser, "patch_ft should pass the parser to contains")
    assert_equal(expected_range[1], actual_range[1], "patch_ft should translate srow to 0-based")
    assert_equal(expected_range[2], actual_range[2], "patch_ft should preserve scol")
    assert_equal(expected_range[3], actual_range[3], "patch_ft should translate erow to 0-based")
    assert_equal(expected_range[4], actual_range[4], "patch_ft should preserve ecol")
    return parser
  end

  compat.patch_ft(ft, {
    get_parser = function(bufnr)
      assert_equal(vim.api.nvim_get_current_buf(), bufnr, "patch_ft should inspect the current buffer")
      return parser
    end,
  })

  assert_equal(
    "--%s",
    ft.calculate({
      ctype = LINEWISE,
      range = { srow = 5, scol = 2, erow = 7, ecol = 8 },
    }),
    "patch_ft should keep language-aware commentstring resolution when a parser exists"
  )
end

do
  local ft = new_ft({
    lua = { "--%s", "--[[%s]]" },
  })

  compat.patch_ft(ft, {
    get_parser = function()
      return nil
    end,
  })
  local patched = ft.calculate

  compat.patch_ft(ft, {
    get_parser = function()
      return {}
    end,
  })

  assert_equal(patched, ft.calculate, "patch_ft should be idempotent")
end
