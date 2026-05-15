---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local original_path = vim.env.PATH

local function assert_deep_equal(expected, actual, message)
  if vim.inspect(expected) ~= vim.inspect(actual) then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function write_executable(path, lines)
  vim.fn.writefile(lines, path)
  assert(vim.uv.fs_chmod(path, 493), "chmod should make fake rustup executable")
end

local function with_fake_rustup(lines, callback)
  local dir = vim.fn.tempname()
  assert(vim.fn.mkdir(dir, "p") == 1, "temp rustup bin directory should be created")
  write_executable(vim.fs.joinpath(dir, "rustup"), lines)

  package.loaded["lsp.rust_analyzer"] = nil
  vim.env.PATH = dir .. ":" .. original_path

  local ok, err = pcall(callback)

  package.loaded["lsp.rust_analyzer"] = nil
  vim.env.PATH = original_path
  vim.fn.delete(dir, "rf")

  if not ok then
    error(err)
  end
end

with_fake_rustup({
  "#!/bin/sh",
  'if [ "$1" = default ]; then',
  "  printf '%s\\n' '1.93.0-aarch64-apple-darwin (default)'",
  "  exit 0",
  "fi",
  "exit 1",
}, function()
  local config = require("lsp.rust_analyzer")
  assert_deep_equal(
    { "rustup", "run", "1.93.0-aarch64-apple-darwin", "rust-analyzer" },
    config.cmd,
    "rust-analyzer cmd should use the first token from rustup default"
  )
end)

with_fake_rustup({
  "#!/bin/sh",
  'if [ "$1" = default ]; then',
  "  printf '%s\\n' 'error: no default toolchain configured' >&2",
  "  exit 1",
  "fi",
  "exit 1",
}, function()
  local config = require("lsp.rust_analyzer")
  assert_deep_equal({ "rust-analyzer" }, config.cmd, "rust-analyzer cmd should fall back when rustup default fails")
end)

with_fake_rustup({
  "#!/bin/sh",
  'if [ "$1" = default ]; then',
  "  exit 0",
  "fi",
  "exit 1",
}, function()
  local config = require("lsp.rust_analyzer")
  assert_deep_equal(
    { "rust-analyzer" },
    config.cmd,
    "rust-analyzer cmd should fall back when rustup default prints no toolchain"
  )
end)
