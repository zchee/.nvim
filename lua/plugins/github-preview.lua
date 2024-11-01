local github_preview = require("github-preview")

github_preview.setup({
  host = "localhost",
  port = 15174,        -- p(15) r(17) e(4)
  single_file = false, -- set to "true" to force single-file mode & disable repository mode
  theme = {
    name = "system",   -- "system" | "light" | "dark"
    high_contrast = false,
  },
  details_tags_open = true, -- define how to render <details> tags on init/content-change. true: <details> tags are rendered open, false: <details> tags are rendered closed
  cursor_line = {
    disable = false,
    color = "#4c4e52", -- CSS color. if you provide an invalid value, cursorline will be invisible
    opacity = 0.1,
  },
  scroll = {
    disable = false,
    top_offset_pct = 70, -- Between 0 and 100 VERY LOW and VERY HIGH numbers might result in cursorline out of screen
  },
  log_level = nil,       -- nil | "debug" | "verbose"
})
