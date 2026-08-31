-- Colorscheme-parity falsifier (round-2 plan R0.2 / R3.1).
--
--   nvim --headless -l script/hl-dump.lua [outfile] [--reapply]
--
-- Serializes the complete global highlight namespace -- every group with
-- all attributes including links, cterm, blend, and default flags -- in
-- canonical sorted order (stable group and key ordering, deterministic
-- formatting), to stdout or the outfile argument. Two dumps of an
-- unchanged config must be byte-identical; that diff is the falsifier for
-- the R3.1 colorscheme port.
--
-- `nvim -l` script mode never loads the user config ('loadplugins' is off
-- and init.lua is skipped), so the startup paint is replayed here
-- explicitly by applying the colorscheme, which since R3.1 carries the
-- former config.highlight overrides too. Running headless with the full
-- config instead would drown the dump in plugin-defined groups.
--
-- --reapply re-issues :colorscheme after the startup paint, simulating a
-- user re-applying it mid-session; the dump must not change (round-1's
-- known gap was overrides lost on re-apply).

vim.cmd.colorscheme("equinusocio_material")

local outfile
for _, a in ipairs(_G.arg or {}) do
  if a == "--reapply" then
    vim.cmd.colorscheme("equinusocio_material")
  else
    outfile = a
  end
end

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

if outfile then
  local f = assert(io.open(outfile, "w"))
  f:write(body)
  f:close()
else
  io.write(body)
end
