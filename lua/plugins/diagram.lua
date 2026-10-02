require("diagram").setup({
  events = {
    render_buffer = { "BufWinEnter", "InsertLeave", "TextChanged" },
    clear_buffer = { "BufLeave" },
  },
  integrations = {
    require("diagram.integrations.markdown"),
  },
  renderer_options = {
    mermaid = {
      background = "#010101",
      theme = "dark",
      scale = 2,
      width = 800, -- nil | 800 | 400 | ...
      height = 600, -- nil | 600 | 300 | ...
    },
    plantuml = {
      charset = "utf-8",
    },
    d2 = {
      theme_id = 1,
      dark_theme_id = nil,
      scale = nil,
      layout = nil,
      sketch = nil,
    },
    gnuplot = {
      font = nil, -- nil | "Arial,12" | ...
      theme = "dark",
      size = "800,600",
    },
  },
})
