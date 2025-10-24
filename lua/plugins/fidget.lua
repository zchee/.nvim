local fidget = require("fidget")

-- local setup = {
--   text = {
--     spinner = "dots_snake", -- https://github.com/j-hui/fidget.nvim/blob/main/lua/fidget/spinners.lua
--     done = "✔", -- character shown when all tasks are complete
--     commenced = "Started", -- message shown when task starts
--     completed = "Completed", -- message shown when task completes
--   },
--   align = {
--     bottom = true,
--     right = true,
--   },
--   timer = {
--     spinner_rate = 125,  -- frame rate of spinner animation, in ms
--     fidget_decay = 2000, -- how long to keep around empty fidget, in ms
--     task_decay = 1000,   -- how long to keep around completed task, in ms
--   },
--   window = {
--     relative = "editor", -- "win", "editor"
--     blend = 100,
--     zindex = nil,
--   },
--   fmt = {
--     leftpad = true,       -- right-justify text in fidget box
--     stack_upwards = true, -- list of tasks grows upwards
--     max_width = 0,        -- maximum width of the fidget box
--     -- function to format fidget title
--     fidget = function(fidget_name, spinner)
--       return string.format("%s %s", spinner, fidget_name)
--     end,
--     -- function to format each task line
--     task = function(task_name, message, percentage)
--       return string.format(
--         "	%s%s [%s]",
--         message,
--         percentage and string.format(" (%s%%)", percentage) or "",
--         task_name
--       )
--     end,
--   },
--   sources = {
--     -- Sources to configure
--     ["*"] = {         -- Name of source
--       ignore = false, -- Ignore notifications from this source
--     },
--   },
--   debug = {
--     logging = false, -- whether to enable logging, for debugging
--     strict = false,  -- whether to interpret LSP strictly
--   },
-- }

fidget.setup({
  -- Options related to LSP progress subsystem
  progress = {
    poll_rate = 0,                -- How and when to poll for progress messages
    suppress_on_insert = false,   -- Suppress new messages while in insert mode
    ignore_done_already = false,  -- Ignore new tasks that are already complete
    ignore_empty_message = false, -- Ignore new tasks that don't contain a message
    -- Clear notification group when LSP server detaches
    clear_on_detach = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client and client.name or nil
    end,
    -- How to get a progress message's notification group key
    notification_group = function(msg)
      return msg.lsp_client.name
    end,
    ignore = {}, -- List of LSP servers to ignore

    -- Options related to how LSP progress messages are displayed as notifications
    display = {
      render_limit = 16, -- How many LSP messages to show at once
      done_ttl = 3, -- How long a message should persist after completion
      done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
      done_style = "Constant", -- Highlight group for completed LSP tasks
      progress_ttl = math.huge, -- How long a message should persist when in progress
      progress_icon = { pattern = "dots", period = 1 }, -- Icon shown when LSP progress tasks are in progress
      progress_style = "WarningMsg", -- Highlight group for in-progress LSP tasks
      group_style = "Title", -- Highlight group for group name (LSP server name)
      icon_style = "Question", -- Highlight group for group icons
      priority = 30, -- Ordering priority for LSP notification group
      format_message = require("fidget.progress.display").default_format_message, -- How to format a progress message
      format_annote = function(msg)
        return msg.title
      end, -- How to format a progress annotation
      format_group_name = function(group)
        return tostring(group)
      end, -- How to format a progress notification group's name
      -- Override options from the default notification config
      -- overrides = {
      --   rust_analyzer = { name = "rust-analyzer" },
      -- },
    },

    -- Options related to Neovim's built-in LSP client
    lsp = {
      progress_ringbuf_size = 3, -- Configure the nvim's LSP progress ring buffer size
    },
  },

  -- Options related to notification subsystem
  notification = {
    -- poll_rate = 10, -- How frequently to update and render notifications
    -- filter = vim.log.levels.INFO, -- Minimum notifications level
    override_vim_notify = false, -- Automatically override vim.notify() with Fidget
    -- configs = { default = require("fidget.notification").default_config }, -- How to configure notification groups when instantiated

    -- Options related to how notifications are rendered as text
    view = {
      stack_upwards = true,           -- Display notification items from bottom to top
      icon_separator = " ",           -- Separator between group name and icon
      group_separator = "---",        -- Separator between notification groups
      group_separator_hl = "Comment", -- Highlight group used for group separator
    },

    -- Options related to the notification window and buffer
    window = {
      normal_hl = "Comment", -- Base highlight group in the notification window
      winblend = 100,        -- Background color opacity in the notification window
      border = "none",       -- Border around the notification window
      zindex = 45,           -- Stacking priority of the notification window
      max_width = 0,         -- Maximum width of the notification window
      max_height = 0,        -- Maximum height of the notification window
      x_padding = 1,         -- Padding from right edge of window boundary
      y_padding = 0,         -- Padding from bottom edge of window boundary
      align = "bottom",      -- How to align the notification window
      relative = "editor",   -- What the notification window position is relative to
    },
  },

  -- Options related to integrating with other plugins
  integration = {
    ["nvim-tree"] = {
      enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
    },
  },

  -- Options related to logging
  logger = {
    level = vim.log.levels.OFF, -- Minimum logging level
    float_precision = 0.01,     -- Limit the number of decimals displayed for floats
    -- Where Fidget writes its logs to
    path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
  },
})

-- vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
--   group = vim.api.nvim_create_augroup("fidgetClose", { clear = true }),
--   callback = function()
--     fidget:close()
--   end,
-- })
