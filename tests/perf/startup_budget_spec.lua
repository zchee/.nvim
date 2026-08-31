---@diagnostic disable: undefined-global
-- Startup budget spec (plan Phase 4.1; acceptance criteria 2-4).
--
-- Boots the FULL user config inside real pty sessions (jobstart with
-- pty = true) and asserts the lazy-loading budget invariants:
--
--   1. no file + 3 s idle: schemastore absent from package.loaded;
--      blink.cmp / copilot may be present ONLY via the tagged cooperative
--      warmup (round-2 R2 loads the insert stack at UIEnter+800ms, one
--      plugin per tick, tagging each in vim.g.warmup_loaded) -- an untagged
--      load means the InsertEnter laziness broke; and nvim-lspconfig is not
--      even a lazy spec (the plugin is uninstalled -- servers are native
--      lsp/ configs).
--   2. opening a Go fixture: gopls attaches while blink.cmp stays off the
--      InsertEnter path (unloaded, or loaded only by the tagged warmup).
--   3. opening a JSON fixture: schemastore loads (the catalog materializes
--      only when jsonls resolves).
--
-- Timing thresholds are deliberately NOT asserted here -- wall-clock numbers
-- are machine-load dependent and belong to script/perf-report.sh. This spec
-- pins the load-graph shape, which is deterministic.
--
-- gopls note: the config runs gopls in forwarder mode
-- (-remote=unix;/tmp/gopls.sock), which exits unless a daemon serves the
-- socket. The spec starts one when the socket is absent and stops only a
-- daemon it started itself.
--
-- Run from the repo root: nvim --headless -u NONE -l tests/perf/startup_budget_spec.lua

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local util = require("util")

local function fail(message)
  io.stderr:write(message .. "\n")
  error(message)
end

-- The probe runs inside the full-config session: it waits for the scenario's
-- condition (or its timeout), snapshots the lazy plugin graph plus
-- package.loaded, writes the snapshot as JSON, and quits. Parameterized via
-- vim.g so one probe file serves every scenario.
local probe_source = [[
local out = vim.g.perf_probe_out
local mode = vim.g.perf_probe_mode
local done = false

local function collect_and_quit()
  if done then
    return
  end
  done = true
  local specs, loaded_plugins, load_sum = {}, {}, 0
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if ok then
    for name, plugin in pairs(lazy_config.plugins) do
      specs[#specs + 1] = name
      local state = plugin._ and plugin._.loaded
      if state and state.time then
        local ms = state.time / 1e6
        load_sum = load_sum + ms
        loaded_plugins[#loaded_plugins + 1] = { name = name, ms = ms }
      end
    end
  end
  table.sort(loaded_plugins, function(a, b)
    return a.ms > b.ms
  end)
  local clients = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    clients[#clients + 1] = client.name
  end
  local lazy_ok, lazy = pcall(require, "lazy")
  local report = {
    startuptime = lazy_ok and lazy.stats().startuptime or -1,
    load_sum_ms = load_sum,
    loaded_plugins = loaded_plugins,
    spec_names = specs,
    package_loaded = {
      blink = package.loaded["blink.cmp"] ~= nil,
      copilot = package.loaded["copilot"] ~= nil,
      schemastore = package.loaded["schemastore"] ~= nil,
    },
    lsp_clients = clients,
    warmup_loaded = vim.g.warmup_loaded or {},
    messages = vim.fn.execute("messages"),
  }
  local f = assert(io.open(out, "w"))
  f:write(vim.json.encode(report))
  f:close()
  vim.cmd("qa!")
end

local conditions = {
  idle = nil, -- plain 3 s idle, no condition
  gopls = function()
    return #vim.lsp.get_clients({ name = "gopls" }) > 0
  end,
  schemastore = function()
    return package.loaded["schemastore"] ~= nil
  end,
}

local condition = conditions[mode]
if condition == nil then
  vim.defer_fn(collect_and_quit, 3000)
else
  local waited = 0
  local timeout = vim.g.perf_probe_timeout or 20000
  vim.fn.timer_start(250, function()
    waited = waited + 250
    if condition() or waited >= timeout then
      -- settle one more tick so a just-attached client finishes wiring
      vim.defer_fn(collect_and_quit, 500)
    end
  end, { ["repeat"] = -1 })
end
]]

local probe_path = vim.fn.tempname() .. "_probe.lua"
do
  local f = assert(io.open(probe_path, "w"))
  f:write(probe_source)
  f:close()
end

--- Runs one full-config Neovim inside a pty and returns the probe's report.
--- @param mode string "idle" | "gopls" | "schemastore"
--- @param file string|nil file argument for the session
--- @param budget_ms integer host-side wall-clock budget for the whole session
local function run_pty(mode, file, budget_ms)
  local out = vim.fn.tempname() .. "_report.json"
  local cmd = {
    "nvim",
    "--cmd",
    string.format("lua vim.g.perf_probe_out=%q vim.g.perf_probe_mode=%q", out, mode),
    "-c",
    "luafile " .. probe_path,
  }
  if file then
    cmd[#cmd + 1] = file
  end
  local job = vim.fn.jobstart(cmd, {
    pty = true,
    width = 120,
    height = 40,
    env = { TERM = "xterm-256color" },
  })
  if job <= 0 then
    fail("failed to start pty nvim for scenario " .. mode)
  end
  local exited = vim.fn.jobwait({ job }, budget_ms)[1]
  if exited == -1 then
    vim.fn.jobstop(job)
    fail(string.format("scenario %s: session did not finish within %d ms", mode, budget_ms))
  end
  local f =
    assert(io.open(out, "r"), string.format("scenario %s: probe wrote no report (session died before collect)", mode))
  local body = f:read("*a")
  f:close()
  os.remove(out)
  return vim.json.decode(body)
end

local function has(list, want)
  for _, item in ipairs(list) do
    if item == want then
      return true
    end
  end
  return false
end

local function plugin_loaded(report, name)
  for _, plugin in ipairs(report.loaded_plugins) do
    if plugin.name == name then
      return true
    end
  end
  return false
end

-- A plugin loaded by the cooperative warmup (lua/config/warmup.lua) is
-- tagged in vim.g.warmup_loaded; a load that is neither absent nor tagged
-- came through the InsertEnter path this spec must keep lazy.
local function warmup_tagged(report, name)
  return has(report.warmup_loaded or {}, name)
end

-- Round-2 R1 demotion set: none of these may load in a no-file idle session.
-- Each entry names the real trigger it was moved to.
local idle_absent = {
  "vim-wakatime", -- BufReadPost/BufNewFile/InsertEnter
  "trouble.nvim", -- cmd Trouble
  "dropbar.nvim", -- BufReadPost
  "fidget.nvim", -- LspAttach
  "gitsigns.nvim", -- BufReadPre/BufNewFile
  "satellite.nvim", -- BufReadPost
  "yanky.nvim", -- TextYankPost
  "hbac.nvim", -- BufAdd
  "chowcho.nvim", -- module-loader only (no live entry point)
  "open-browser.vim", -- <Plug>(openbrowser-smart-search) stub
  "switch.vim", -- cmd Switch
  "vim-operator-replace", -- <Plug> stub
  "vim-operator-surround", -- <Plug> stubs
  "vim-operator-convert-case", -- <Plug> stub
  "vim-operator-user", -- dependency of the operator that loads first
  "oil.nvim", -- cmd/keys + dir-argv init
  "edgy.nvim", -- ft snacks_terminal
}

-- Opening a real file must bring the file-shaped demotions back in
-- (fidget needs the LspAttach that the gopls scenario provides).
local first_file_present = {
  "gitsigns.nvim",
  "dropbar.nvim",
  "satellite.nvim",
  "vim-wakatime",
  "fidget.nvim",
}

-- gopls daemon: forwarder-mode gopls needs a live socket; start a daemon only
-- when none is serving, and stop only what this spec started.
local daemon_job
if not vim.uv.fs_stat("/tmp/gopls.sock") then
  daemon_job = vim.fn.jobstart({ util.go_path("bin", "gopls"), "-listen=unix;/tmp/gopls.sock", "serve" })
  assert(daemon_job > 0, "failed to start the gopls daemon for attach checks")
  vim.wait(1500)
end

local go_dir = vim.fn.tempname() .. "_gomod"
vim.fn.mkdir(go_dir, "p")
do
  local f = assert(io.open(go_dir .. "/go.mod", "w"))
  f:write("module perfspec\n\ngo 1.24\n")
  f:close()
  f = assert(io.open(go_dir .. "/main.go", "w"))
  f:write('package main\n\nfunc main() {\n\tprintln("perf")\n}\n')
  f:close()
end
local json_fixture = vim.fn.tempname() .. ".json"
do
  local f = assert(io.open(json_fixture, "w"))
  f:write('{\n  "name": "perfspec"\n}\n')
  f:close()
end

local ok, err = pcall(function()
  -- scenario 1: no file, 3 s idle
  do
    local report = run_pty("idle", nil, 30000)
    assert(
      not report.package_loaded.blink or warmup_tagged(report, "blink.cmp"),
      "blink.cmp may load in a no-file idle session only through the tagged warmup path"
    )
    assert(
      not report.package_loaded.copilot or warmup_tagged(report, "copilot.lua"),
      "copilot may load in a no-file idle session only through the tagged warmup path"
    )
    assert(not report.package_loaded.schemastore, "schemastore must stay unloaded during a no-file idle session")
    assert(
      not has(report.spec_names, "nvim-lspconfig"),
      "nvim-lspconfig must not exist as a lazy spec (servers are native lsp/ configs)"
    )
    for _, name in ipairs(idle_absent) do
      assert(
        not plugin_loaded(report, name),
        name .. " must stay unloaded during a no-file idle session (round-2 demotion)"
      )
    end
    print(
      string.format(
        "idle: startuptime=%.1fms plugins_loaded=%d load_sum=%.1fms",
        report.startuptime,
        #report.loaded_plugins,
        report.load_sum_ms
      )
    )
  end

  -- scenario 2: Go fixture -> gopls attaches, blink.cmp still lazy
  do
    local report = run_pty("gopls", go_dir .. "/main.go", 45000)
    assert(
      has(report.lsp_clients, "gopls"),
      "gopls must attach to the Go fixture (clients: " .. table.concat(report.lsp_clients, ",") .. ")"
    )
    assert(
      not report.package_loaded.blink or warmup_tagged(report, "blink.cmp"),
      "blink.cmp must stay off the InsertEnter path with LSP up (unloaded, or loaded only by the tagged warmup)"
    )
    assert(
      not report.package_loaded.schemastore,
      "schemastore must stay unloaded in a Go session (jsonls never resolves)"
    )
    for _, name in ipairs(first_file_present) do
      assert(plugin_loaded(report, name), name .. " must load once a real file is open with an LSP client attached")
    end
  end

  -- scenario 3: JSON fixture -> schemastore materializes
  do
    local report = run_pty("schemastore", json_fixture, 30000)
    assert(report.package_loaded.schemastore, "schemastore must load once a JSON buffer resolves jsonls")
  end
end)

if daemon_job then
  vim.fn.jobstop(daemon_job)
end
vim.fn.delete(go_dir, "rf")
os.remove(json_fixture)
os.remove(probe_path)

if not ok then
  error(err)
end
