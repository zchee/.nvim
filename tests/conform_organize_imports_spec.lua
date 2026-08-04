---@diagnostic disable: undefined-global
-- Regression spec for the lsp_organize_imports formatter in
-- lua/plugins/conform.lua.
--
-- The live gopls path cannot run here (gopls does not attach in headless
-- Neovim in this config, while lua_ls does), so the server response is
-- stubbed. What this actually pins down is the part that is easy to break by
-- editing conform.lua: the chain-order guard, the WorkspaceEdit extraction,
-- and the fact that the edits are applied to the returned lines rather than
-- to the buffer.
vim.opt.runtimepath:append(vim.fn.getcwd())
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/conform.nvim")
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

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

local opts = require("plugins.conform")
local formatter = opts.formatters.lsp_organize_imports
assert_truthy(formatter and formatter.format, "lsp_organize_imports formatter is missing")

-- Go must run organize-imports before goimports-rereviser: the formatter reads
-- edit positions from the buffer, which only matches the in-memory lines while
-- nothing has rewritten them yet.
assert_equal("lsp_organize_imports", opts.formatters_by_ft.go[1], "organize-imports must lead the Go chain")
assert_equal("goimports_rereviser", opts.formatters_by_ft.go[2], "rereviser must follow organize-imports")

local source = {
  "package main",
  "",
  "import (",
  '\t"example.com/org/sub"',
  ")",
  "",
  "func main() {",
  "\tfmt.Println(os.Args)",
  "\tsub.F()",
  "}",
}

local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_name(buf, "/tmp/conform_organize_imports_spec/main.go")
vim.api.nvim_buf_set_lines(buf, 0, -1, false, source)
vim.bo[buf].filetype = "go"

-- Stub a server that answers source.organizeImports with the two missing
-- std imports, in the inline-`edit` shape gopls uses.
local requested = {}
local orig_request_sync = vim.lsp.buf_request_sync
vim.lsp.buf_request_sync = function(bufnr, method, params, timeout)
  table.insert(requested, { method = method, only = params.context and params.context.only, timeout = timeout })
  return {
    [1] = {
      result = {
        {
          title = "Organize Imports",
          kind = "source.organizeImports",
          edit = {
            changes = {
              [vim.uri_from_bufnr(bufnr)] = {
                {
                  range = {
                    start = { line = 3, character = 0 },
                    ["end"] = { line = 3, character = 0 },
                  },
                  newText = '\t"fmt"\n\t"os"\n',
                },
              },
            },
          },
        },
      },
    },
  }
end

local ctx = { buf = buf, filename = vim.api.nvim_buf_get_name(buf), dirname = "/tmp/conform_organize_imports_spec" }

-- 1. happy path: lines match the buffer, so the edits are applied
local result
formatter.format(formatter, ctx, vim.deepcopy(source), function(err, lines)
  assert_truthy(not err, "formatter reported an error: " .. tostring(err))
  result = lines
end)
assert_truthy(result, "formatter never invoked its callback")
assert_equal('\t"fmt"', result[4], "missing fmt import was not inserted")
assert_equal('\t"os"', result[5], "missing os import was not inserted")
assert_equal('\t"example.com/org/sub"', result[6], "existing import was clobbered")
assert_equal("source.organizeImports", requested[1].only[1], "request did not ask for source.organizeImports")
assert_equal(
  table.concat(source, "\n"),
  table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"),
  "formatter must not edit the buffer; conform applies its own diff"
)

-- 2. guard: when a previous formatter already changed the text, the server's
-- positions are stale, so the input must pass through untouched
local stale = vim.deepcopy(source)
table.insert(stale, 2, "// inserted by an earlier formatter")
local guarded
formatter.format(formatter, ctx, vim.deepcopy(stale), function(err, lines)
  assert_truthy(not err, "guard path reported an error: " .. tostring(err))
  guarded = lines
end)
assert_equal(table.concat(stale, "\n"), table.concat(guarded, "\n"), "guard must return the input unchanged")

-- 3. an empty action list is a no-op, not an error
vim.lsp.buf_request_sync = function()
  return { [1] = { result = {} } }
end
local empty
formatter.format(formatter, ctx, vim.deepcopy(source), function(err, lines)
  assert_truthy(not err, "empty result reported an error: " .. tostring(err))
  empty = lines
end)
assert_equal(table.concat(source, "\n"), table.concat(empty, "\n"), "empty result must pass lines through")

-- 4. a server that never answers must not wedge the format chain
vim.lsp.buf_request_sync = function()
  return nil
end
local timed_out
formatter.format(formatter, ctx, vim.deepcopy(source), function(err, lines)
  assert_truthy(not err, "nil response reported an error: " .. tostring(err))
  timed_out = lines
end)
assert_equal(table.concat(source, "\n"), table.concat(timed_out, "\n"), "nil response must pass lines through")

vim.lsp.buf_request_sync = orig_request_sync
print("OK: conform_organize_imports_spec passed")
