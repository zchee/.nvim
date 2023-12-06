-- local go_path = join_path(vim.uv.os_homedir(), "go")

local mason_core_path = require("mason-core.path")

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
local dap = require("dap")
local dapui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")
local dap_go = require("dap-go")

dap_go.setup()

dap.adapters.lldb = {
  type = "executable",
  command = "/opt/llvm/devel/bin/lldb-vscode",
  name = "lldb",
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host, port = config.port })
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    -- command = join_path(go_path, "bin", "dlv"),
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug Package",
    request = "launch",
    program = "${fileDirname}",
  },
  {
    type = "go",
    name = "Attach",
    mode = "local",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
  {
    type = "go",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  {
    type = "go",
    name = "Debug test (legacy?)",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable:", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
    -- postRunCommands = {'process handle -p true -s false -n false SIGWINCH'},
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.sh = {
  {
    type = "executable",
    command = mason_core_path.bin_prefix("bash-debug-adapter"),
    request = "launch",
    name = "Bash-Debug (simplest configuration)",
    program = "${file}",
  },
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input("Host [127.0.0.1]:")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port:"))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap_virtual_text.setup({
  enabled = true,
  enabled_commands = true,
  all_frames = false,
  commented = false,
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  show_stop_reason = true,
  only_first_definition = true,
  all_references = false,
  -- text_prefix = '',
  -- separator = ',',
  -- error_prefix = '  ',
  -- info_prefix = '  ',
  -- position of virtual text, see `:h nvim_buf_set_extmark()`
  virt_text_pos = "eol",
  virt_lines = false,
  virt_lines_above = true,
  virt_text_win_col = nil,               -- position the virtual text at a fixed window column (starting from the first text column) ,
  filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
  --- A callback that determines how a variable is displayed or whether it should be omitted
  --- param variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
  --- @param buf number
  --- param stackframe https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
  --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
  --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
  --- @diagnostic disable-next-line: unused-local
  display_callback = function(variable, buf, stackframe, node)
    return variable.name .. " = " .. variable.value
  end,
})

dapui.setup({
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.25,
        },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 00.25 },
      },
      size = 300,
      position = "right", -- "left", "right", "top", "bottom"
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
  },
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
  floating = {
    max_height = nil,
    max_width = nil,
    border = "rounded", -- "single", "double", "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
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

vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>dp",
  "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<LocalLeader>dc",
  "<cmd>lua require'dap'.continue()<CR>",
  { noremap = true, silent = true }
)
