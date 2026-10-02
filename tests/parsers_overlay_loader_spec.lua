---@diagnostic disable: undefined-global
-- Regression spec for the nvim-treesitter parsers overlay under vim.loader.
--
-- init.lua enables vim.loader, which patches loadfile() to serve bytecode
-- from its cache. The overlay module lua/nvim-treesitter/parsers.lua shadows
-- the plugin's registry via runtimepath order and must load the shadowed base
-- file by reading its source text directly -- a loadfile() there dies with
-- "wrong mode" once the loader owns it. This spec runs with vim.loader
-- enabled, exactly like a real startup, and asserts the overlay still
-- resolves: base registry entries present, custom grammars merged on top.
vim.loader.enable()

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

-- The overlay loads the plugin's own registry through nvim_get_runtime_file,
-- so the installed plugin must be on the runtimepath, after the repo root
-- (the repo's copy has to shadow it).
local ts_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "lazy", "nvim-treesitter")
assert(vim.uv.fs_stat(ts_dir), "nvim-treesitter plugin should be installed at " .. ts_dir)
vim.opt.runtimepath:append(ts_dir)

local parsers = require("nvim-treesitter.parsers")

-- the plugin's base registry actually loaded underneath the overlay
assert(parsers.go ~= nil, "base registry entry (go) should survive the overlay load")
assert(parsers.lua ~= nil, "base registry entry (lua) should survive the overlay load")

-- custom grammar merged by the overlay
assert(parsers.goasm ~= nil, "custom goasm grammar should be registered by the overlay")
assert_equal(
  "https://github.com/zchee/tree-sitter-goasm",
  parsers.goasm.install_info.url,
  "goasm entry should carry the custom grammar URL"
)

-- fork replacing an upstream entry
assert_equal(
  "https://github.com/zchee/tree-sitter-dockerfile",
  parsers.dockerfile.install_info.url,
  "dockerfile entry should be the overlay's fork, not upstream's"
)
