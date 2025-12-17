local metafrastis = require("metafrastis")

---@type MetafrastisConfig
metafrastis.setup({
  provider = "deepl",
  source_lang = "en",
  target_lang = "ja",
  max_chars = 8000,
  ui = {
    win = {
      width = 150, -- fixed width (auto-sizes if omitted)
      -- height = 12, -- optional fixed height
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      padding = {
        top = 1,
        bottom = 1,
        left = 5,
        right = 5,
      },
      row = 2,
      col = 1,
      wo = { wrap = false },
    },
  },
  cache = {
    enabled = true,
    ttl = 7 * 24 * 3600,
    max_estimated_cost = 1.0, -- USD per call guard
    memory_enabled = true,
    memory_max_entries = 512,
    memory_skip_disk_ttl = 5,
  },
  -- http = {
  --   backend = "plenary", -- default: Plenary job-based curl; set to "curl" to force vim.system
  -- },
  -- providers = {
  --   echo = {
  --     suffix = "[echo]",
  --   },
  --   google = {
  --     api_key = vim.env.GOOGLE_API_KEY or vim.env.GOOGLE_TRANSLATE_KEY,
  --     model = "v2",
  --     base_url = "https://translation.googleapis.com/language/translate/v2",
  --     price_per_million_chars = 20.0,
  --   },
  --   deepl = {
  --     api_key = vim.env.DEEPL_AUTH_KEY,
  --     base_url = "https://api.deepl.com/v2/translate",
  --     price_per_million_chars = 25.0,
  --   },
  --   openai = {
  --     api_key = vim.env.OPENAI_API_KEY,
  --     model = "gpt-5.1",
  --     base_url = "https://api.openai.com/v1/chat/completions",
  --     input_per_million = 0.15,
  --     output_per_million = 0.60,
  --   },
  --   gemini = {
  --     api_key = vim.env.GOOGLE_GENAI_KEY or vim.env.GOOGLE_API_KEY,
  --     model = "gemini-2.5-flash",
  --     base_url = "https://generativelanguage.googleapis.com/v1beta/models",
  --     input_per_million = 0.30,
  --     output_per_million = 2.50,
  --   },
  --   openrouter = {
  --     api_key = vim.env.OPENROUTER_API_KEY,
  --     model = "openrouter/auto",
  --     base_url = "https://openrouter.ai/api/v1/chat/completions",
  --     input_per_million = 0.15,
  --     output_per_million = 0.60,
  --     referer = "https://github.com/zchee/metafrastis.nvim",
  --   },
  -- },
})
