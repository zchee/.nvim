---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local goasm = require("filetypes.goasm")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function with_buffer(lines, fn)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  local ok, err = pcall(fn, bufnr)
  vim.api.nvim_buf_delete(bufnr, { force = true })
  if not ok then
    error(err)
  end
end

local function mkdir(path)
  vim.fn.mkdir(path, "p")
end

do
  with_buffer({ '#include "textflag.h"', "TEXT ·x(SB), NOSPLIT, $0-0" }, function(bufnr)
    assert_equal("goasm", goasm.detect("/tmp/plain.s", bufnr), "Plan 9 assembly headers should select goasm")
  end)
end

do
  with_buffer({ "NOP" }, function(bufnr)
    assert_equal("goasm", goasm.detect("/tmp/add_amd64.s", bufnr), "Go architecture suffixes should select goasm")
    assert_equal("goasm", goasm.detect("/tmp/arm64.s", bufnr), "bare Go architecture names should select goasm")
  end)
end

do
  local dir = vim.fn.tempname()
  mkdir(dir)
  vim.fn.writefile({ "package p" }, dir .. "/p.go")
  with_buffer({ "NOP" }, function(bufnr)
    assert_equal("goasm", goasm.detect(dir .. "/x.s", bufnr), "assembly beside Go files should select goasm")
  end)
  vim.fn.delete(dir, "rf")
end

do
  local dir = vim.fn.tempname()
  mkdir(dir)
  with_buffer({ "global _start" }, function(bufnr)
    assert_equal("asm", goasm.detect(dir .. "/boot.s", bufnr), "plain assembly should keep asm filetype")
  end)
  vim.fn.delete(dir, "rf")
end
