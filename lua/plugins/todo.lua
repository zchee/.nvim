local todo = require("todo")

todo.setup({
  signs = {
    enable = false,
    priority = 8,
  },
  keywords = {
    TODO = {
      icon = " ",
      color = "todo_link",
    },
    Deprecated = {
      icon = " ",
      color = "warning",
    },
    FIX = {
      icon = " ",
      color = "error",
    },
    WARN = {
      icon = " ",
      color = "warning",
      alt = { "WARNING" },
    },
    NOTE = {
      icon = " ",
      color = "hint",
      alt = { "INFO" },
    },
  },
  merge_keywords = true,
  highlight = {
    before = "",
    keyword = "fg",
    after = "",
    pattern = {
      [[.*<(KEYWORDS):]],
      [[.*<(KEYWORDS)\(.*\):]],
    },
    comments_only = true,
    max_line_len = 400,
    exclude = {},
  },
  colors = {
    todo_link = { "Todo" },
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
  },
  search = {
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
  },
})
