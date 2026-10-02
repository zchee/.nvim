---@diagnostic disable: undefined-global
-- Regression spec for lsp/markdown_oxide.lua.
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
--     only source of the root markers and the daily-note commands that used
--     to come from nvim-lspconfig's lsp/markdown_oxide.lua; both must stay
--     inlined (the commands in lua/lsp/on_attach.lua, the on_attach every
--     server shares) or they silently disappear.
--   * It indexes files that git ignores. That is the whole reason marksman was
--     rejected: the agent memory trees live under a git-ignored
--     claude/projects/, invisible to a server that honours .gitignore.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  -- lsp/markdown_oxide.lua lives in the native runtimepath form at the repo
  -- root.
  vim.fn.getcwd() .. "/?.lua",
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
-- A per-server on_attach would replace the shared one (tbl_deep_extend "force"
-- does not merge functions), so the daily notes are an entry of the shared one.
assert_equal(nil, config.on_attach, "lsp/markdown_oxide.lua must not replace the shared on_attach")
do
  local on_attach = require("lsp.on_attach")
  local buf = vim.api.nvim_create_buf(false, true)
  local executed = {}
  local fake = {
    name = "markdown_oxide",
    exec_cmd = function(_, command, ctx)
      executed[#executed + 1] = { command = command.command, argument = command.arguments[1], bufnr = ctx.bufnr }
    end,
  }
  on_attach(fake, buf)
  local commands = vim.api.nvim_buf_get_commands(buf, {})
  for _, day in ipairs({ "Today", "Tomorrow", "Yesterday" }) do
    assert_true(
      commands["Lsp" .. day] ~= nil,
      ("the shared on_attach must create :Lsp%s for markdown_oxide"):format(day)
    )
  end
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("LspTomorrow")
  end)
  assert_equal("jump", executed[1] and executed[1].command, ":LspTomorrow must run the server's jump command")
  assert_equal("tomorrow", executed[1].argument, ":LspTomorrow must ask for tomorrow's note")
  vim.api.nvim_buf_delete(buf, { force = true })
end
assert_true(type(config.root_markers) == "table", "the root markers were inlined from nvim-lspconfig")
assert_true(
  vim.tbl_contains(config.root_markers, ".git"),
  "the .git marker is what roots a vault that carries no .moxide.toml"
)

-- vim.lsp tries root_markers in list order, so precedence is only real if the
-- vault markers sit ahead of .git. Checked on a tree rather than by reading
-- the list: a vault inside a repository must root at the vault, a note with
-- no vault marker at the repository.
do
  local tree = vim.fs.joinpath(vim.fn.tempname(), "repo")
  vim.fn.mkdir(vim.fs.joinpath(tree, ".git"), "p")
  vim.fn.mkdir(vim.fs.joinpath(tree, "moxide", "notes"), "p")
  vim.fn.mkdir(vim.fs.joinpath(tree, "obsidian", ".obsidian"), "p")
  vim.fn.mkdir(vim.fs.joinpath(tree, "plain"), "p")
  vim.fn.writefile({}, vim.fs.joinpath(tree, "moxide", ".moxide.toml"))
  local function root_of(...)
    return vim.fs.root(vim.fs.joinpath(tree, ...), config.root_markers)
  end
  assert_equal(
    vim.fs.joinpath(tree, "moxide"),
    root_of("moxide", "notes", "a.md"),
    "a vault's .moxide.toml must root it ahead of the repository .git"
  )
  assert_equal(
    vim.fs.joinpath(tree, "obsidian"),
    root_of("obsidian", "b.md"),
    "an .obsidian vault must root at itself ahead of the repository .git"
  )
  assert_equal(tree, root_of("plain", "c.md"), "a note outside any vault roots at the repository .git")
  vim.fn.delete(vim.fs.dirname(tree), "rf")
end

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
