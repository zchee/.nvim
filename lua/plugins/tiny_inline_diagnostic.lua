require("tiny-inline-diagnostic").setup({
  preset = "modern", -- "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
  transparent_bg = true,
  transparent_cursorline = true,
  hi = {
    error = "DiagnosticError",
    warn = "DiagnosticWarn",
    info = "DiagnosticInfo",
    hint = "DiagnosticHint",
    arrow = "NonText",
    background = "CursorLine", -- Background color for diagnostics. Can be a highlight group or a hexadecimal color (#RRGGBB)
    mixing_color = "Normal", -- Color blending option for the diagnostic background. Use "None" or a hexadecimal color (#RRGGBB) to blend with another color
  },
  options = {
    show_source = {
      enabled = true,
      if_many = true,
    },
    use_icons_from_diagnostic = true,
    set_arrow_to_diag_color = false,
    add_messages = true, -- Add messages to diagnostics when multiline diagnostics are enabled. If set to false, only signs will be displayed
    throttle = 20, -- milliseconds
    softwrap = 200, -- Minimum message length before wrapping to a new line
    multilines = {
      enabled = true,
      always_show = true,
      trim_whitespaces = true,
      tabstop = 4,
    },
    show_all_diags_on_cursorline = false,
    enable_on_insert = false,
    enable_on_select = false,
    overflow = {
      mode = "wrap", -- "wrap" - Split long messages into multiple lines, "none" - Do not truncate messages, "oneline" - Keep the message on a single line, even if it's long
      padding = 5, -- Trigger wrapping to occur this many characters earlier when mode == "wrap".
    },
    break_line = {
      enabled = false,
      after = 200, -- Number of characters after which to break the line
    },
    -- format = function(diagnostic)
    --   return diagnostic.message .. " [" .. diagnostic.source .. "]"
    -- end
    format = nil,
    virt_texts = {
      priority = 2048,
    },
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    },
    overwrite_events = nil, -- Events to attach diagnostics to buffers. You should not change this unless the plugin does not work with your configuration
  },
  disabled_ft = {}, -- List of filetypes to disable the plugin
})
