---@diagnostic disable: undefined-global
-- Regression spec for the taplo formatter wiring in lua/plugins/conform.lua.
--
-- Pins the parts that are easy to break by editing that file: the argument
-- order taplo needs (--config only works after the subcommand), and the rule
-- that a project's own .taplo.toml must win over the personal one. The
-- formatting behaviour itself belongs to taplo and ~/.config/taplo/taplo.toml,
-- and is exercised separately.
vim.opt.runtimepath:append(vim.fn.getcwd())
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

assert_truthy(vim.deep_equal(opts.formatters_by_ft.toml, { "taplo" }), "toml must be formatted by taplo")
assert_truthy(opts.formatters.tombi == nil, "tombi formatter must be gone; tombi is LSP-only now")

local taplo = opts.formatters.taplo
assert_truthy(taplo and type(taplo.args) == "function", "taplo formatter needs a computed arg list")

-- 1. no project config -> the personal one is passed, after the subcommand
local home = tostring(vim.uv.os_homedir())
local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(home, ".config")
local personal = vim.fs.joinpath(config_home, "taplo", "taplo.toml")

local args = taplo.args(taplo, { dirname = "/", filename = "/x.toml", buf = 0 })
assert_equal("format", args[1], "taplo requires the subcommand first")
local config_at
for i, a in ipairs(args) do
  if a == "--config" then
    config_at = i
  end
end
assert_truthy(config_at and config_at > 1, "--config must come after the subcommand, not be prepended")
assert_equal(personal, args[config_at + 1], "personal taplo config path")
assert_equal("-", args[#args], "stdin marker must be the final argument")
assert_equal("$FILENAME", args[#args - 1], "$FILENAME must precede the stdin marker")
assert_equal("--stdin-filepath", args[#args - 2], "--stdin-filepath must precede $FILENAME")

assert_equal(nil, taplo.cwd(taplo, { dirname = "/", filename = "/x.toml", buf = 0 }), "no project config, no cwd")

-- 2. a project shipping its own config keeps it, and taplo has to be run from
-- the directory holding that config. taplo resolves both config discovery and
-- its [[rule]] include globs against the process CWD -- not --stdin-filepath,
-- not the config file's location -- so running anywhere else silently drops
-- the project's rules and falls back to taplo's defaults (column_width = 80,
-- array_auto_expand = true), which is exactly what re-wrapped a long
-- single-line array in ~/src/github.com/zchee/agent.
local tmp = vim.fs.joinpath(vim.fn.tempname(), "proj", "nested")
vim.fn.mkdir(tmp, "p")
-- the config sits one level above the buffer, so this also covers the upward walk
local project_root = vim.fs.dirname(tmp)
local project_config = vim.fs.joinpath(project_root, ".taplo.toml")
assert_equal(0, vim.fn.writefile({ "[formatting]" }, project_config), "failed to write the fixture config")

local ctx = { dirname = tmp, filename = tmp .. "/x.toml", buf = 0 }
local project_args = taplo.args(taplo, ctx)
for _, a in ipairs(project_args) do
  assert_truthy(a ~= "--config", "a project .taplo.toml must not be overridden by --config")
end
assert_equal("format", project_args[1], "subcommand stays first without --config")
assert_equal("-", project_args[#project_args], "stdin marker stays last without --config")
assert_equal(project_root, taplo.cwd(taplo, ctx), "taplo must run from the project config's directory")

print("OK: conform_taplo_spec passed")
