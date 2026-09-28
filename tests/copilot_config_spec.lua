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
-- package name, and bun links the package's bin into <install root>/bin;
-- build a fake install with both so the config's executable check passes.
local uname = vim.uv.os_uname()
local platform = ({ Darwin = "darwin", Linux = "linux" })[uname.sysname]
  .. "-"
  .. ({ arm64 = "arm64", aarch64 = "arm64", x86_64 = "x64" })[uname.machine]
local bun_install = vim.fn.tempname()
local server_dir = bun_install .. "/install/global/node_modules/@github/copilot-language-server-" .. platform
local server_path = server_dir .. "/copilot-language-server"
for _, file in ipairs({ server_path, bun_install .. "/bin/copilot-language-server" }) do
  vim.fn.mkdir(vim.fs.dirname(file), "p")
  vim.fn.writefile({ "#!/bin/sh" }, file)
  vim.uv.fs_chmod(file, tonumber("755", 8))
end

-- $PATH without the real bun install, so util.bun_prefix's $PATH fallback
-- cannot find this machine's copilot-language-server behind the fakes.
local bare_path = "/usr/bin:/bin"
local saved_path = vim.env.PATH

--- Loads plugins.copilot afresh with BUN_INSTALL and PATH as given (nil
--- unsets BUN_INSTALL); returns the notifications it raised.
local function load_config(dir, path)
  captured_config = nil
  package.loaded["plugins.copilot"] = nil
  vim.env.BUN_INSTALL = dir
  vim.env.PATH = path
  local notes = {}
  local saved_notify = vim.notify
  vim.notify = function(msg, level)
    notes[#notes + 1] = { msg = msg, level = level }
  end
  local ok, err = pcall(require, "plugins.copilot")
  vim.notify = saved_notify
  vim.env.PATH = saved_path
  assert(ok, "plugins.copilot must not throw: " .. tostring(err))
  return notes
end

--- Returns the ERROR-level notifications among `notes`.
local function errors(notes)
  return vim.tbl_filter(function(note)
    return note.level == vim.log.levels.ERROR
  end, notes)
end

-- a missing native server fails fast: one ERROR naming the absolute path it
-- expected, and no setup() that would let copilot.lua download its own build
do
  local empty = vim.fn.tempname()
  local errs = errors(load_config(empty, bare_path))
  assert(captured_config == nil, "setup must not run without the native server binary")
  assert(#errs == 1, "a missing binary must raise one ERROR")
  assert(
    errs[1].msg:find(empty .. "/install/global/node_modules/@github/copilot-language-server-" .. platform, 1, true),
    "the ERROR must name the expected absolute path: " .. errs[1].msg
  )
end

-- $BUN_INSTALL unset and nothing under bun's default ~/.bun: the package's
-- bin link on $PATH still leads to the install root
do
  local errs = errors(load_config(nil, bun_install .. "/bin:" .. bare_path))
  assert(#errs == 0, "an unset BUN_INSTALL must resolve through $PATH: " .. vim.inspect(errs))
  assert(captured_config ~= nil, "setup must run when the binary resolves through $PATH")
  assert(
    captured_config.server.custom_server_filepath == server_path,
    "the $PATH fallback must find the same native binary: " .. tostring(captured_config.server.custom_server_filepath)
  )
end

local notes = load_config(bun_install, bare_path)
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
