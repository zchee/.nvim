---@diagnostic disable: undefined-global
-- Regression spec for lua/lsp/capabilities.lua.
--
-- lua/lsp/init.lua merges a static snapshot of blink.cmp's LSP client
-- capabilities instead of requiring blink.cmp at load time, so blink keeps its
-- InsertEnter trigger. The snapshot can silently drift when blink.cmp updates:
-- a server could stop receiving a capability blink relies on (snippetSupport,
-- resolveSupport properties, ...) with no visible failure. This spec pins the
-- snapshot to the live output of get_lsp_capabilities({}, false) in both
-- directions, so any drift fails loudly. On failure, regenerate the snapshot
-- (the header of lua/lsp/capabilities.lua carries the one-liner).
--
-- Run: nvim --headless -u NONE -l tests/lsp_capabilities_snapshot_spec.lua
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

-- blink.cmp and its native runtime come from lazy.nvim's plugin root
-- (lua/config/lazy.lua roots it at stdpath("data")).
local lazy_root = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
for _, plugin in ipairs({ "blink.cmp", "blink.lib" }) do
  local dir = vim.fs.joinpath(lazy_root, plugin)
  assert(
    vim.uv.fs_stat(dir),
    ("%s is not installed at %s -- run: nvim --headless '+Lazy! sync' +qa"):format(plugin, dir)
  )
  vim.opt.runtimepath:append(dir)
end

local snapshot = require("lsp.capabilities")
local live = require("blink.cmp").get_lsp_capabilities({}, false)

---Reports the first differing path between two nested tables, so a failure
---names the capability rather than dumping both tables.
---@param a any
---@param b any
---@param path string
---@return string|nil
local function first_diff(a, b, path)
  if type(a) ~= type(b) then
    return ("%s: type %s vs %s"):format(path, type(a), type(b))
  end
  if type(a) ~= "table" then
    if a ~= b then
      return ("%s: %s vs %s"):format(path, vim.inspect(a), vim.inspect(b))
    end
    return nil
  end
  for key, value in pairs(a) do
    local diff = first_diff(value, b[key], ("%s.%s"):format(path, tostring(key)))
    if diff ~= nil then
      return diff
    end
  end
  for key in pairs(b) do
    if a[key] == nil then
      return ("%s.%s: missing in snapshot side"):format(path, tostring(key))
    end
  end
  return nil
end

do
  local diff = first_diff(snapshot, live, "capabilities")
  if diff ~= nil then
    error(
      ("lua/lsp/capabilities.lua drifted from blink.cmp's live get_lsp_capabilities: %s\nRegenerate the snapshot (see the header of lua/lsp/capabilities.lua)."):format(
        diff
      )
    )
  end
end

do
  assert(vim.deep_equal(snapshot, live), "snapshot and live capabilities must be deep-equal")
end
