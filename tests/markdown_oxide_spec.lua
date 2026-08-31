---@diagnostic disable: undefined-global
-- Regression spec for lua/lsp/markdown_oxide.lua.
--
-- markdown_oxide is the markdown server this config runs, and three properties
-- of that choice are easy to undo by accident:
--
--   * It never sends workspace/configuration. Measured against the real binary:
--     the server registers workspace/didChangeWatchedFiles and then asks for no
--     configuration section at all, so an LSP `settings` table would sit in the
--     config doing nothing while looking authoritative. Its knobs live in
--     `~/.config/moxide/settings.toml` or a per-vault `.moxide.toml`.
--   * Since nvim-lspconfig was removed from the dep tree, this config is the
--     only source of the root markers and the daily-note on_attach that used
--     to come from nvim-lspconfig's lsp/markdown_oxide.lua; both must stay
--     inlined here or they silently disappear.
--   * It indexes files that git ignores. That is the whole reason marksman was
--     rejected: the agent memory trees live under a git-ignored
--     claude/projects/, invisible to a server that honours .gitignore.
--
-- Run: nvim --headless -u NONE -l tests/markdown_oxide_spec.lua
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

local function assert_true(value, message)
  if not value then
    error(message)
  end
end

local config = require("lsp.markdown_oxide")

assert_equal("table", type(config.cmd), "cmd must be a command list")
assert_equal(1, #config.cmd, "cmd is the bare binary, subcommands start the daily-note CLI instead of the server")
assert_true(
  config.cmd[1]:match("/opt/markdown%-oxide/bin/markdown%-oxide$") ~= nil,
  ("cmd must resolve through util.homebrew_binary, got %s"):format(config.cmd[1])
)
assert_true(vim.uv.fs_stat(config.cmd[1]) ~= nil, ("markdown-oxide is not installed at %s"):format(config.cmd[1]))
assert_equal(1, #config.filetypes, "markdown_oxide serves markdown only (no mdx dialect support)")
assert_equal("markdown", config.filetypes[1], "filetype must be markdown")
assert_equal(nil, config.settings, "the server never pulls workspace/configuration, so settings would be dead weight")
assert_true(
  type(config.on_attach) == "function",
  "the daily-note on_attach was inlined from nvim-lspconfig and must not disappear"
)
assert_true(type(config.root_markers) == "table", "the root markers were inlined from nvim-lspconfig")
assert_true(
  vim.tbl_contains(config.root_markers, ".git"),
  "the .git marker is what roots a vault that carries no .moxide.toml"
)
assert_true(
  vim.tbl_contains(config.root_markers, ".moxide.toml"),
  "a per-vault .moxide.toml must still win over the repository .git"
)

-- The live half: a vault whose notes git ignores, which is the shape of the
-- agent memory trees this server exists to navigate.
local vault = vim.fs.joinpath(vim.fn.tempname(), "repo")
vim.fn.mkdir(vim.fs.joinpath(vault, ".git"), "p")
vim.fn.mkdir(vim.fs.joinpath(vault, "notes"), "p")
vim.fn.writefile({ "notes/" }, vim.fs.joinpath(vault, ".gitignore"))
local hub = vim.fs.joinpath(vault, "notes", "hub.md")
local target = vim.fs.joinpath(vault, "notes", "target.md")
vim.fn.writefile({ "- [Handoff](target.md)" }, hub)
vim.fn.writefile({ "# Target", "", "## Second heading" }, target)

vim.cmd.edit(hub)
local bufnr = vim.api.nvim_get_current_buf()
vim.bo[bufnr].filetype = "markdown"
local client_id = vim.lsp.start({
  name = "markdown_oxide",
  cmd = config.cmd,
  root_dir = vault,
}, { bufnr = bufnr })
assert_true(client_id ~= nil, "markdown_oxide failed to start")
local client = vim.lsp.get_client_by_id(client_id)
assert_true(
  vim.wait(30000, function()
    return client.initialized == true
  end, 50),
  "markdown_oxide never finished initialize"
)
assert_true(client.server_capabilities.definitionProvider ~= nil, "markdown_oxide must advertise definitionProvider")

local done, result = false, nil
client:request("textDocument/definition", {
  -- The link destination, not its display text: "- [Handoff](" is 12 columns.
  textDocument = { uri = vim.uri_from_fname(hub) },
  position = { line = 0, character = 12 },
}, function(_, res)
  result, done = res, true
end, bufnr)
assert_true(
  vim.wait(15000, function()
    return done
  end, 50),
  "textDocument/definition never came back"
)

local location = (type(result) == "table" and result[1]) and result[1] or result
assert_true(location ~= nil, "an inline link inside a git-ignored folder must still resolve")
local resolved = vim.uri_to_fname(location.uri or location.targetUri)
assert_equal(vim.uv.fs_realpath(target), vim.uv.fs_realpath(resolved), "definition must land on the linked file")

client:stop(true)
vim.fn.delete(vim.fs.dirname(vault), "rf")

print("OK: markdown_oxide config shape holds and definition resolves inside a git-ignored vault")
