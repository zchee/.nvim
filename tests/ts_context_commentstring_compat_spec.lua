---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local compat = require("plugins.ts_context_commentstring_compat")

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
  local parser = {}

  assert_equal(
    parser,
    compat.resolve_parser(12, {
      get_parser = function(bufnr)
        assert_equal(12, bufnr, "resolve_parser should pass through the target buffer")
        return parser
      end,
    }),
    "resolve_parser should return the parser object when Treesitter is available"
  )

  assert_equal(
    nil,
    compat.resolve_parser(7, {
      get_parser = function()
        return nil
      end,
    }),
    "resolve_parser should treat nil parser results as unavailable"
  )

  assert_equal(
    nil,
    compat.resolve_parser(9, {
      get_parser = function()
        error("parser missing")
      end,
    }),
    "resolve_parser should suppress get_parser exceptions"
  )
end

do
  local parser = {}
  local utils = {}

  compat.patch_utils(utils, {
    get_parser = function(bufnr)
      if bufnr == 3 then
        return parser
      end

      return nil
    end,
  })

  assert_truthy(utils._zchee_nil_parser_guard_patched, "patch_utils should mark the utils table as patched")
  assert_truthy(utils.is_treesitter_active(3), "patched utils should report active buffers with a real parser")
  assert_falsy(utils.is_treesitter_active(4), "patched utils should reject nil parser results")
end

do
  local utils = {}

  compat.patch_utils(utils, {
    get_parser = function()
      return nil
    end,
  })

  local patched = utils.is_treesitter_active

  compat.patch_utils(utils, {
    get_parser = function()
      return {}
    end,
  })

  assert_equal(patched, utils.is_treesitter_active, "patch_utils should be idempotent")
  assert_falsy(utils.is_treesitter_active(1), "idempotent patch should preserve the original guard behavior")
end
