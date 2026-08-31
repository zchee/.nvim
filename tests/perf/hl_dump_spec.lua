---@diagnostic disable: undefined-global
-- hl-dump determinism spec (round-2 plan R0.3).
--
-- script/hl-dump.lua is the colorscheme-parity falsifier for R3.1: its
-- output must be byte-identical across runs on an unchanged config, or a
-- pre/post diff proves nothing. This spec runs the dump twice against the
-- full config and asserts identical, non-trivial output.
--
-- Run from the repo root: nvim --headless -u NONE -l tests/perf/hl_dump_spec.lua

local function fail(message)
  io.stderr:write(message .. "\n")
  error(message)
end

--- Runs one full-config hl-dump into a temp file and returns its bytes.
local function dump()
  local out = vim.fn.tempname() .. "_hl.txt"
  local result = vim.system({ "nvim", "--headless", "-l", "script/hl-dump.lua", out }, { timeout = 60000 }):wait()
  if result.code ~= 0 then
    fail(string.format("hl-dump exited %d: %s", result.code, result.stderr or ""))
  end
  local f = assert(io.open(out, "r"), "hl-dump wrote no output file")
  local body = f:read("*a")
  f:close()
  os.remove(out)
  return body
end

local first = dump()
local second = dump()

assert(#first > 0, "hl-dump produced an empty dump")
assert(first:find("\nNormal ", 1, true), "hl-dump is missing the Normal group")
assert(
  first:find("\nBlinkCmpMenu ", 1, true),
  "hl-dump is missing config.highlight overrides (VeryLazy deferral regressed)"
)
assert(first == second, "hl-dump output differs between two runs on an unchanged config")

local _, groups = first:gsub("\n", "")
print(string.format("hl-dump deterministic: %d bytes, %d groups", #first, groups))
