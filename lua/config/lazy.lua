local cache_dir = tostring(vim.fn.stdpath("cache"))
local data_dir = tostring(vim.fn.stdpath("data"))
local state_dir = tostring(vim.fn.stdpath("state"))

---@type LazyConfig
---@diagnostic disable-next-line
local lazy_config = {
  root = vim.fs.joinpath(data_dir, "lazy"),
  defaults = {
    lazy = true,
  },
  spec = nil,
  lockfile = vim.fs.joinpath(cache_dir, "lazy-lock.json"),
  ---@diagnostic disable-next-line
  concurrency = (vim.uv.available_parallelism() * 2) or nil,
  git = {
    log = { "-8" },
    timeout = 120,
    url_format = "https://github.com/%s.git",
    filter = true,
    throttle = {
      enabled = false,
    },
  },
  pkg = {
    enabled = false,
  },
  rocks = {
    enabled = false,
  },
  -- dev = {
  --   -- directory where you store your local plugin projects
  --   path = "~/projects",
  --   ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
  --   patterns = {},    -- For example {"folke"}
  --   fallback = false, -- Fallback to git when local plugin doesn't exist
  -- },
  install = {
    missing = true,
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "none",
    backdrop = 60,
    title = nil, ---@type string only works when border is not "none"
    title_pos = "center",
    pills = true,
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
    browser = nil,
    throttle = 1000 / 30,
  },
  headless = {
    process = true,
    log = true,
    task = true,
    colors = true,
  },
  diff = {
    cmd = "diffview.nvim",
  },
  checker = {
    enabled = false,
    concurrency = nil,
    notify = true,
    frequency = 3600,
    check_pinned = false,
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {
        vim.fs.joinpath(data_dir, "lazy", "plenary.nvim"),
      },
      disabled_plugins = {
        "editorconfig",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logiPat",
        "matchit",
        "matchparen",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "rplugin",
        "rrhelper",
        "spellfile",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        -- "man",
        -- "nvim",
        "osc52",
      },
    },
  },
  state = vim.fs.joinpath(state_dir, "lazy", "state.json"),
  profiling = {
    loader = false,
    require = false,
  },
}

require("lazy").setup(require("plugins"), lazy_config)
