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
-- (the header of lua/lsp/capabilities.lua carries the one-liner). It also
-- checks that init.lua's own completion overrides never switch on a feature
-- blink reports as unimplemented.
--
-- Run: nvim --headless -u NONE -i NONE -l tests/lsp_capabilities_snapshot_spec.lua
-- (under -u NONE the ~/.config/nvim symlink puts this repo on the rtp; to
-- test a copy's lua/lsp/init.lua, run it from the copy with XDG_CONFIG_HOME
-- pointed at an empty dir, as tests/AGENTS.md describes)
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

local live = require("blink.cmp").get_lsp_capabilities({}, false)
local snapshot = require("lsp.capabilities")

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

-- lua/lsp/init.lua layers its own overrides on top of the snapshot. Those may
-- narrow what blink offers (documentationFormat is cut to markdown), but must
-- never switch on a completion feature blink reports as unimplemented: a
-- server would then send commit characters or preselect flags that nothing
-- acts on. Load the module the way the config does, with lspkind stubbed and
-- vim.lsp.enable recorded instead of run, so no server config resolves here.
-- Then resolve every enabled config (and tsgo, registered but not enabled):
-- the lsp/*.lua files and lua/lsp/init.lua load in every session, so none of
-- them may look a binary up on disk or on $PATH before its server starts
-- (lua/lsp/AGENTS.md) -- the node servers' lookups live in a function cmd.
do
  package.loaded["lspkind"] = { init = function() end }
  local enable = vim.lsp.enable
  local enabled = {}
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.enable = function(names)
    vim.list_extend(enabled, type(names) == "table" and names or { names })
  end
  local util = require("util")
  local lookups = {}
  local originals = { bun_prefix = util.bun_prefix, nodenv_prefix = util.nodenv_prefix }
  for name, original in pairs(originals) do
    util[name] = function(binary)
      local info = debug.getinfo(2, "Sl")
      lookups[#lookups + 1] = ("util.%s(%q) at %s:%d"):format(name, binary, info.short_src, info.currentline)
      return original(binary)
    end
  end
  local exepath = vim.fn.exepath
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fn.exepath = function(binary)
    local info = debug.getinfo(2, "Sl")
    lookups[#lookups + 1] = ("vim.fn.exepath(%q) at %s:%d"):format(binary, info.short_src, info.currentline)
    return exepath(binary)
  end
  require("lsp")
  vim.lsp.enable = enable
  assert(#enabled > 0, "lua/lsp/init.lua must still enable its servers")
  for _, name in ipairs(vim.list_extend({ "tsgo" }, enabled)) do
    assert(vim.lsp.config[name] ~= nil, ("vim.lsp.config.%s must resolve"):format(name))
  end
  vim.fn.exepath = exepath
  for name, original in pairs(originals) do
    util[name] = original
  end
  assert(#lookups == 0, "server configs looked binaries up at load time:\n" .. table.concat(lookups, "\n"))

  local merged = vim.lsp.config["*"].capabilities.textDocument.completion.completionItem
  for key, value in pairs(live.textDocument.completion.completionItem) do
    if value == false then
      assert(
        merged[key] == false,
        ("lua/lsp/init.lua advertises completionItem.%s = %s, which blink.cmp does not implement"):format(
          key,
          vim.inspect(merged[key])
        )
      )
    end
  end
end

print(
  "OK: capabilities snapshot matches blink.cmp, the merged completionItem claims nothing blink lacks, and no server config looks a binary up at load time"
)
