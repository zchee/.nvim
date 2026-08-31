-- Colorscheme-parity falsifier (round-2 plan R0.2).
--
-- Run with the FULL config loaded (no -u NONE):
--   nvim --headless -l script/hl-dump.lua [outfile]
--
-- Serializes the complete global highlight namespace -- every group with
-- all attributes including links, cterm, blend, and default flags -- in
-- canonical sorted order (stable group and key ordering, deterministic
-- formatting), to stdout or the outfile argument. Two dumps of an
-- unchanged config must be byte-identical; that diff is the falsifier for
-- the R3.1 colorscheme port.
--
-- config.highlight is required explicitly because the config defers it to
-- VeryLazy, which never fires headless; firing the real VeryLazy event
-- would also load every VeryLazy plugin and pollute the dump with groups
-- unrelated to the colorscheme parity question, so only the highlight
-- override module is pulled in.

pcall(require, "config.highlight")

--- Canonical, deterministic rendering of one highlight attribute value.
local function fmt(value)
  local t = type(value)
  if t == "number" then
    if value % 1 == 0 then
      return string.format("%d", value)
    end
    return string.format("%.6f", value)
  elseif t == "boolean" then
    return tostring(value)
  elseif t == "string" then
    return string.format("%q", value)
  elseif t == "table" then
    local keys = {}
    for key in pairs(value) do
      keys[#keys + 1] = key
    end
    table.sort(keys, function(a, b)
      return tostring(a) < tostring(b)
    end)
    local parts = {}
    for _, key in ipairs(keys) do
      parts[#parts + 1] = tostring(key) .. "=" .. fmt(value[key])
    end
    return "{" .. table.concat(parts, ",") .. "}"
  end
  return tostring(value)
end

local hl = vim.api.nvim_get_hl(0, {})
local names = {}
for name in pairs(hl) do
  names[#names + 1] = name
end
table.sort(names)

local lines = {}
for _, name in ipairs(names) do
  lines[#lines + 1] = name .. " " .. fmt(hl[name])
end
local body = table.concat(lines, "\n") .. "\n"

local out = _G.arg and _G.arg[1]
if out then
  local f = assert(io.open(out, "w"))
  f:write(body)
  f:close()
else
  io.write(body)
end
