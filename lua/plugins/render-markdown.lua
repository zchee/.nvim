local render_markdown = require("render-markdown")

---@module 'render-markdown'
---@class render.md.UserConfig: render.md.buffer.UserConfig
render_markdown.setup({
  preset = "lazy",
  file_types = {
    "markdown",
    "Avante",
  },
  completions = {
    blink = {
      enabled = true,
    },
  },
  code = {
    enabled = true,
    render_modes = true,
    sign = true,
    style = "full",
    position = "right",
    language_pad = 0,
    language_icon = true,
    language_name = true,
    disable_background = { "diff", "mermaid" },
    width = "full",
    left_margin = 0,
    left_pad = 0,
    right_pad = 0,
    min_width = 0,
    border = "thick",
    above = "▄",
    below = "▀",
    inline_left = "",
    inline_right = "",
    inline_pad = 0,
    highlight = "None",       -- "RenderMarkdownCode",
    highlight_language = nil,
    highlight_border = false, --"RenderMarkdownCodeBorder",
    highlight_inline = "RenderMarkdownCodeInline",
  },
})
