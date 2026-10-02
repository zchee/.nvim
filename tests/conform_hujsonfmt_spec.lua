---@diagnostic disable: undefined-global
-- Regression spec for the hujson formatter wiring in lua/plugins/conform.lua.
--
-- hujsonfmt (github.com/tailscale/hujson/cmd/hujsonfmt) owns filetype hujson.
-- jsonls would also format these buffers without damage, but to a different
-- layout, so the entry pins lsp_format = "never": a machine without hujsonfmt
-- must format nothing rather than rewrite the whole file in jsonls's layout on
-- the next save. The live half runs the real binary through conform.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local conform_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "conform.nvim")
assert(
  vim.uv.fs_stat(conform_dir),
  ("conform.nvim is not installed at %s -- run: nvim --headless '+Lazy! sync' +qa"):format(conform_dir)
)
vim.opt.runtimepath:append(conform_dir)

local conform = require("conform")
local opts = require("plugins.conform")
conform.setup(opts)

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

do
  local hujson = opts.formatters_by_ft.hujson
  assert_equal("table", type(hujson), "hujson must have a formatters_by_ft entry")
  assert_equal("hujsonfmt", hujson[1], "hujsonfmt must be the hujson formatter")
  assert_equal(1, #hujson, "hujsonfmt must be the only hujson formatter")
  assert_equal("never", hujson.lsp_format, "an unavailable hujsonfmt must not fall through to jsonls")
end

local command = require("util").go_path("bin", "hujsonfmt")

do
  -- hujsonfmt exits 1 on input with no value, so a blank buffer is routed
  -- through cat instead; anything else, a comment-only buffer included, gets
  -- the real binary from the Go bin dir, where `go install` puts it.
  local cases = {
    { lines = { '{"a": 1}' }, expect = command, what = "a document" },
    { lines = { "", "  ", '{"a": 1}' }, expect = command, what = "leading blanks" },
    { lines = { "// only a comment" }, expect = command, what = "a comment" },
    { lines = { "" }, expect = "cat", what = "an empty buffer" },
    { lines = { "", " \t", "" }, expect = "cat", what = "whitespace-only lines" },
  }
  for _, case in ipairs(cases) do
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, case.lines)
    assert_equal(
      case.expect,
      opts.formatters.hujsonfmt.command(opts.formatters.hujsonfmt, { buf = bufnr }),
      "command for " .. case.what
    )
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

do
  -- format_on_save supplies lsp_format itself, so it must read the pin back.
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = "hujson"
  assert_equal("never", opts.format_on_save(bufnr).lsp_format, "hujson must not reach the LSP formatter on save")
  vim.api.nvim_buf_delete(bufnr, { force = true })
end

-- The live half.
if vim.fn.executable(command) ~= 1 then
  print(
    "SKIP: hujsonfmt is not installed at "
      .. command
      .. " (go install github.com/tailscale/hujson/cmd/hujsonfmt@latest)"
  )
  return
end

---conform.format's return value only says a formatter was attempted; the
---outcome arrives through the callback, which runs before a sync call returns.
---@param lines string[]
---@return string? err
---@return boolean? did_edit
---@return string[] result
local function format(lines)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = "hujson"
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  local done, err, did_edit = false, nil, nil
  conform.format({ bufnr = bufnr, async = false, timeout_ms = 5000, quiet = true }, function(e, edited)
    done, err, did_edit = true, e, edited
  end)
  assert(done, "a sync conform.format should call back before returning")
  local result = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  vim.api.nvim_buf_delete(bufnr, { force = true })
  return err, did_edit, result
end

do
  local err, did_edit, result = format({
    "// top",
    "{",
    '"a":   [1,2,],',
    '  /* b */ "b": {"c":true,},',
    '    "long": [1, 2, 3],',
    "}",
  })
  assert_equal(nil, err, "hujsonfmt should format valid HuJSON without error")
  assert_equal(true, did_edit, "conform should report the hujson format as an edit")
  assert_equal(
    table.concat({
      "// top",
      "{",
      '\t"a":    [1, 2],',
      '\t/* b */ "b":    {"c": true},',
      '\t"long": [1, 2, 3],',
      "}",
    }, "\n"),
    table.concat(result, "\n"),
    "hujsonfmt should tab-indent, align values, keep comments, and drop single-line trailing commas"
  )
end

do
  local broken = { '{"a": 1 "b": 2}' }
  local err, _, result = format(broken)
  assert(
    type(err) == "string" and err:find("invalid character", 1, true),
    "a parse error should surface hujsonfmt's own message, got " .. vim.inspect(err)
  )
  assert_equal(broken[1], result[1], "a parse error must leave the buffer untouched")
end

do
  -- The first :w of a new file: no error, no edit.
  local err, did_edit, result = format({ "" })
  assert_equal(nil, err, "an empty buffer must not fail to format")
  assert_equal(false, did_edit == true, "an empty buffer must not be edited")
  assert_equal("", table.concat(result, "\n"), "an empty buffer must stay empty")
end
