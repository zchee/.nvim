-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
local dap = require("dap")

dap.adapters.go = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = {nil, stdout},
    args = {"dap", "-l", "127.0.0.1:" .. port},
    detached = true
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print('dlv exited with code', code)
    end
  end)
  assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require('dap.repl').append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(
    function()
      callback({type = "server", host = "127.0.0.1", port = port})
    end,
    100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  },
  -- {
  --   type = "go",
  --   name = "Debug test",
  --   request = "launch",
  --   mode = "test",
  --   program = "${file}"
  -- },
}

local dapui = require("dapui")
dapui.setup({
  icons = {
    expanded = "▾",
    collapsed = "▸",
  },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = true,
  sidebar = {
    elements = {
      {
        id = "scopes",
        size = 0.25,
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 300,
    position = "right",  -- "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom",  -- "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "rounded",  -- "single", "double", "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = { 
    max_type_length = nil,
  }
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  local move = function()
    vim.api.nvim_feedkeys("lll", "n", false)
  end

  dapui.open("sidebar")
  vim.defer_fn(move, 500)
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close("sidebar")
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close("sidebar")
end
