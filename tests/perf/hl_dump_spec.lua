---@diagnostic disable: undefined-global
-- Colorscheme-parity spec (round-2 plan R3.1, acceptance criterion 4).
--
-- tests/perf/fixtures/hl_baseline.txt froze the effective highlight state
-- of the pre-port pipeline (VimL colors/equinusocio_material.vim + the 97
-- lua/config/highlight.lua overrides). The Lua colorscheme that replaced
-- them must reproduce that state byte-for-byte, both on first paint and
-- when :colorscheme is re-applied mid-session (round 1 lost the overrides
-- on re-apply). The fixture pins nvim's default-derived values too (Spell*
-- guisp), so a nightly bump that changes defaults means regenerating the
-- fixture with: nvim --headless -l script/hl-dump.lua <fixture>
--
-- Run from the repo root: nvim --headless -u NONE -l tests/perf/hl_dump_spec.lua

local function fail(message)
  io.stderr:write(message .. "\n")
  error(message)
end

--- Runs one hl-dump into a temp file and returns its bytes.
--- @param reapply boolean re-issue :colorscheme before dumping
local function dump(reapply)
  local out = vim.fn.tempname() .. "_hl.txt"
  local cmd = { "nvim", "--headless", "-l", "script/hl-dump.lua", out }
  if reapply then
    cmd[#cmd + 1] = "--reapply"
  end
  local result = vim.system(cmd, { timeout = 60000 }):wait()
  if result.code ~= 0 then
    fail(string.format("hl-dump exited %d: %s", result.code, result.stderr or ""))
  end
  local f = assert(io.open(out, "r"), "hl-dump wrote no output file")
  local body = f:read("*a")
  f:close()
  os.remove(out)
  return body
end

local fixture_path = "tests/perf/fixtures/hl_baseline.txt"
local fixture_file = assert(io.open(fixture_path, "r"), "missing fixture " .. fixture_path)
local fixture = fixture_file:read("*a")
fixture_file:close()
assert(#fixture > 0, "fixture is empty")
assert(fixture:find("\nNormal ", 1, true), "fixture is missing the Normal group")

--- Reports the first differing line so a parity break is debuggable.
local function assert_matches(body, label)
  if body == fixture then
    return
  end
  local fixture_lines = vim.split(fixture, "\n", { plain = true })
  local body_lines = vim.split(body, "\n", { plain = true })
  for i = 1, math.max(#fixture_lines, #body_lines) do
    if fixture_lines[i] ~= body_lines[i] then
      fail(
        string.format(
          "%s dump diverges from %s at line %d:\n  fixture: %s\n  dump:    %s",
          label,
          fixture_path,
          i,
          fixture_lines[i] or "<eof>",
          body_lines[i] or "<eof>"
        )
      )
    end
  end
  fail(label .. " dump differs from fixture in length only (trailing bytes)")
end

local first = dump(false)
assert(first:find("\nBlinkCmpMenu ", 1, true), "hl-dump is missing the folded highlight overrides")
assert_matches(first, "colorscheme")

local reapplied = dump(true)
assert_matches(reapplied, ":colorscheme re-apply")

local _, groups = fixture:gsub("\n", "")
print(string.format("hl parity: %d bytes, %d groups, re-apply stable", #fixture, groups))
