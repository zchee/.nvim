local root = vim.fn.getcwd()

vim.opt.runtimepath:append(root)
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local captured_config
package.loaded["copilot"] = nil

package.preload["copilot"] = function()
  return {
    setup = function(config)
      assert(captured_config == nil, "copilot.setup should only be called once")
      captured_config = config
    end,
  }
end

-- The native server lives in bun's global install under the npm platform
-- package name; build a fake one so the config's executable check passes.
local uname = vim.uv.os_uname()
local platform = ({ Darwin = "darwin", Linux = "linux" })[uname.sysname]
  .. "-"
  .. ({ arm64 = "arm64", aarch64 = "arm64", x86_64 = "x64" })[uname.machine]
local bun_install = vim.fn.tempname()
local server_dir = bun_install .. "/install/global/node_modules/@github/copilot-language-server-" .. platform
local server_path = server_dir .. "/copilot-language-server"
vim.fn.mkdir(server_dir, "p")
vim.fn.writefile({ "#!/bin/sh" }, server_path)
vim.uv.fs_chmod(server_path, tonumber("755", 8))

--- Loads plugins.copilot afresh with BUN_INSTALL set to `dir`; returns the
--- notifications it raised.
local function load_config(dir)
  captured_config = nil
  package.loaded["plugins.copilot"] = nil
  vim.fn.setenv("BUN_INSTALL", dir)
  local notes = {}
  local saved_notify = vim.notify
  vim.notify = function(msg, level)
    notes[#notes + 1] = { msg = msg, level = level }
  end
  local ok, err = pcall(require, "plugins.copilot")
  vim.notify = saved_notify
  assert(ok, "plugins.copilot must not throw: " .. tostring(err))
  return notes
end

-- a missing native server fails fast: one ERROR naming the path, and no
-- setup() that would let copilot.lua download its own server build
do
  local notes = load_config(vim.fn.tempname())
  assert(captured_config == nil, "setup must not run without the native server binary")
  assert(#notes == 1 and notes[1].level == vim.log.levels.ERROR, "a missing binary must raise one ERROR")
  assert(notes[1].msg:find("copilot-language-server-" .. platform, 1, true), "the ERROR must name the expected path")
end

local notes = load_config(bun_install)
assert(#notes == 0, "a resolvable binary must not notify: " .. vim.inspect(notes))
assert(captured_config ~= nil, "plugins.copilot should call copilot.setup")
assert(captured_config.server.type == "binary", "copilot must run the native server, not node")
assert(
  captured_config.server.custom_server_filepath == server_path,
  "custom_server_filepath must be the bun-installed native binary: "
    .. tostring(captured_config.server.custom_server_filepath)
)
assert(captured_config.copilot_node_command == nil, "the binary server needs no copilot_node_command")

-- should_attach: ["*"] stays, but buffers with no file or a special buftype
-- get no client
do
  local should_attach = captured_config.should_attach
  assert(type(should_attach) == "function", "should_attach must be configured")
  local named = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(named, vim.fn.tempname() .. ".go")
  assert(should_attach(named, vim.api.nvim_buf_get_name(named)) == true, "a named file buffer must attach")
  local unnamed = vim.api.nvim_create_buf(true, false)
  assert(should_attach(unnamed, "") == false, "an unnamed [No Name] buffer must not attach")
  local nofile = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(nofile, "scratch-view")
  vim.bo[nofile].buftype = "nofile"
  assert(should_attach(nofile, vim.api.nvim_buf_get_name(nofile)) == false, "a nofile buffer must not attach")
end
assert(captured_config.panel.enabled == false, "copilot panel should stay disabled for cmp-owned UI")
assert(captured_config.suggestion.enabled == false, "inline suggestion UI should stay disabled for cmp-owned UI")

local settings = captured_config.server_opts_overrides and captured_config.server_opts_overrides.settings
local advanced = settings and settings.advanced

assert(type(advanced) == "table", "Copilot advanced settings should be configured")
assert(
  not (settings.github and settings.github.copilot and settings.github.copilot.advanced),
  "advanced completion settings must use copilot.lua's settings.advanced shape, not VS Code's github.copilot shape"
)
assert(
  type(advanced.inlineSuggestCount) == "number" and advanced.inlineSuggestCount > 0,
  "inlineSuggestCount must be positive because copilot-cmp triggers getCompletions"
)
assert(
  type(advanced.listCount) == "number" and advanced.listCount > 0,
  "listCount should remain positive for list/panel completion compatibility"
)

vim.fn.delete(bun_install, "rf")
print("copilot_config_spec: ALL PASS")
