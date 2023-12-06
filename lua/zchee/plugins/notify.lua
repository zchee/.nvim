local notify = require("notify")

notify.setup({
  level = vim.log.levels.INFO,
  timeout = 5000,
  max_width = nil,
  max_height = nil,
  stages = "fade_in_slide_out",
  render = "default",
  background_colour = "#010101",
  on_open = nil,
  on_close = nil,
  minimum_width = 50,
  fps = 30,
  top_down = true,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})
