local mcphub = require("mcphub")
local mcphub_hl = require("mcphub.utils.highlights")

--- @type MCPHub.Config
mcphub.setup({
  port = 37373,
  config = vim.fs.joinpath(vim.fn.stdpath('config'), "mcp/servers.json"),
  shutdown_delay = 10 * 60 * 1000, -- 10 minutes
  ---@type table<string, NativeServerDef>
  native_servers = {},
  auto_approve = true,            -- Auto approve mcp tool calls
  auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
  use_bundled_binary = false,     -- Whether to use bundled mcp-hub binary
  ---@type string?
  cmd = "mcp-hub",
  ---@type table?
  cmdArgs = nil, -- will be set based on system if not provided
  ---@type LogConfig
  log = {
    level = vim.log.levels.ERROR,
    to_file = true,
    file_path = vim.fs.joinpath(vim.fn.stdpath("log"), "mcphub.log"),
    prefix = "MCPHub"
  },
  ---@type MCPHub.UIConfig
  ui = {
    window = {
      width = 0.85,       -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      height = 0.85,      -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
      border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
      relative = "editor",
      zindex = 50,
    },
    ---@type table?
    wo = { -- window-scoped options (vim.wo)
      winhl = "Normal:" .. mcphub_hl.groups.window_normal .. ",FloatBorder:" .. mcphub_hl.groups.window_border,
    },
  },
  extensions = {
    ---@type MCPHubAvanteConfig
    avante = {
      enabled = true,
      make_slash_commands = true,
    },
  },
  on_ready = function() end,
  ---@param msg string
  on_error = function(msg) _ = msg end,
})
