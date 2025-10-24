local github_preview = require("github-preview")

---@type github_preview_config
github_preview.setup({
  host = "127.0.0.1",
  port = 6041, -- p(15) r(17) e(4)
  theme = {
    name = "system",
    high_contrast = true,
  },
  single_file = false,
  details_tags_open = true, -- define how to render <details> tags on init/content-change. true: <details> tags are rendered open, false: <details> tags are rendered closed
  cursor_line = {
    color = "#4c4e52",
    opacity = 0.1,
  },
  scroll = {
    top_offset_pct = 30,
  },
  log_level = nil, -- nil | "debug" | "verbose"
})
