require("codecov").setup({
  coverage = {
    enabled = true,
    autostart = false,
    colors = {
      covered = "#21B577", -- rgb(33,181,119)
      partial = "#F4B01B", -- rgb(244,176,27)
      missed = "#F52020", -- rgb(245,32,32)
    },
    signs = {
      covered = "▎",
      partial = "▎",
      missed = "▎",
    },
    priority = 10,
  },
  api = {
    git_provider = "github",
    url = "https://api.codecov.io",
    timeout_ms = 10000,
  },
  token = os.getenv("CODECOV_NVIM_API_TOKEN"),
  ---@type vim.log.levels
  log_level = 2,
})
