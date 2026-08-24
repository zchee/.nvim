---@diagnostic disable: undefined-global
-- Regression spec for the json5 formatter wiring in lua/plugins/conform.lua.
--
-- Write-time formatting used to reach vscode-json-language-server through
-- conform's LSP fallback, and that server has no JSON5 mode: on ganja-code's
-- .github/renovate.json5 it injected a space inside 'https://...' -- corrupting
-- a string literal, because a single-quoted string is not a string to it. oxfmt
-- owns the filetype now. Two properties keep that safe, and both are easy to
-- break by accident:
--   * the name handed to --stdin-filepath must carry an extension oxfmt can
--     infer a JSON dialect from, or it exits 1 ("Unsupported file type");
--   * a --config must always be passed, because oxfmt's own upward search
--     fails silently into defaults that rewrite every single-quoted string.
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

local opts = require("plugins.conform")
require("conform").setup(opts)

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

---Runs the oxfmt entry's args function the way conform would.
---@param filename string
---@param dirname string?
---@return table<string, string> flag -> value
local function oxfmt_args(filename, dirname)
  local args = opts.formatters.oxfmt.args(nil, {
    filename = filename,
    dirname = dirname or vim.fs.dirname(filename),
    buf = 0,
    shiftwidth = 2,
  })
  local flags = {}
  for i = 1, #args - 1, 2 do
    flags[args[i]] = args[i + 1]
  end
  return flags
end

do
  -- The formatter list itself. "oxfmt" alone is not enough: the pinned
  -- lsp_format is what keeps an unavailable oxfmt from falling through to the
  -- server that caused the corruption.
  local json5 = opts.formatters_by_ft.json5
  assert_equal("table", type(json5), "json5 must have a formatters_by_ft entry")
  assert_equal("oxfmt", json5[1], "oxfmt must be the json5 formatter")
  assert_equal(1, #json5, "json5 should run oxfmt and nothing else")
  assert_equal("never", json5.lsp_format, "json5 must never fall back to LSP formatting")
end

do
  -- --stdin-filepath is oxfmt's only parser signal; it has no --parser flag.
  local cases = {
    { name = "/tmp/p/renovate.json5", expect = "/tmp/p/renovate.json5", what = "a .json5 name passes through" },
    { name = "/tmp/p/tsconfig.json", expect = "/tmp/p/tsconfig.json", what = "a .json name passes through" },
    { name = "/tmp/p/settings.jsonc", expect = "/tmp/p/settings.jsonc", what = "a .jsonc name passes through" },
    { name = "/tmp/p/CONFIG.JSON", expect = "/tmp/p/CONFIG.JSON", what = "extension match is case-insensitive" },
    -- filetype.lua maps this extensionless file to json5; oxfmt exits 1 on it.
    { name = "/tmp/p/.renovaterc", expect = "/tmp/p/.renovaterc.json5", what = "an extensionless name gains .json5" },
  }
  for _, case in ipairs(cases) do
    assert_equal(case.expect, oxfmt_args(case.name)["--stdin-filepath"], case.what)
  end
end

do
  -- A project config wins and is passed explicitly rather than left to oxfmt's
  -- own search, which starts at the process CWD rather than at the file.
  local root = vim.fn.tempname()
  local nested = vim.fs.joinpath(root, "a", "b")
  assert(vim.fn.mkdir(nested, "p") == 1, "temp project should be created")
  local project_config = vim.fs.joinpath(root, ".oxfmtrc.json")
  vim.fn.writefile({ "{}" }, project_config)

  local ok, flags = pcall(oxfmt_args, vim.fs.joinpath(nested, "renovate.json5"), nested)
  vim.fn.delete(root, "rf")
  assert(ok, flags)
  assert_equal(project_config, flags["--config"], "a project .oxfmtrc.json found upward must be used")
end

do
  -- No project config: the personal one, so oxfmt never runs on its defaults.
  local original = vim.env.XDG_CONFIG_HOME
  local root = vim.fn.tempname()
  assert(vim.fn.mkdir(root, "p") == 1, "temp dir should be created")
  vim.env.XDG_CONFIG_HOME = root

  local ok, flags = pcall(oxfmt_args, vim.fs.joinpath(root, "renovate.json5"), root)
  vim.env.XDG_CONFIG_HOME = original
  vim.fn.delete(root, "rf")
  assert(ok, flags)
  assert_equal(
    vim.fs.joinpath(root, "oxfmt", ".oxfmtrc.jsonc"),
    flags["--config"],
    "without a project config the personal one must be passed"
  )
  assert(flags["--config"] ~= nil, "--config must never be omitted")
end

do
  -- format_on_save has to read the pinned lsp_format back: conform only
  -- consults formatters_by_ft for keys the caller left nil, and this function
  -- supplies one, so a literal here would silently discard the "never".
  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.bo[bufnr].filetype = "json5"
  assert_equal("never", opts.format_on_save(bufnr).lsp_format, "json5 must not reach the LSP formatter on save")

  vim.bo[bufnr].filetype = "json"
  assert_equal("fallback", opts.format_on_save(bufnr).lsp_format, "real JSON keeps its LSP fallback")

  vim.bo[bufnr].filetype = "python"
  assert_equal(
    "fallback",
    opts.format_on_save(bufnr).lsp_format,
    "a formatters_by_ft function entry must not break the lookup"
  )

  vim.api.nvim_buf_delete(bufnr, { force = true })
end
