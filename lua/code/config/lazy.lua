local cache_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("cache")), "vscode")
local data_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "vscode")
local state_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("state")), "vscode")

---@type LazyConfig
local lazy_config = {
  root = vim.fs.joinpath(data_dir, "lazy"),
  defaults = {
    lazy = true,
  },
  spec = nil,
  lockfile = vim.fs.joinpath(cache_dir, "lazy-lock.json"),
  -- concurrency = jit.os:find("Windows") and (vim.uv.available_parallelism() * 2) or nil, ---@type number limit the maximum amount of concurrent tasks
  git = {
    log = { "-8" },
    timeout = 120,
    url_format = "https://github.com/%s.git",
    filter = true,
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
    title = nil, ---@type string only works when border is not "none"
    title_pos = "center", ---@type "center" | "left" | "right"
    pills = true, ---@type boolean
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
    browser = nil, ---@type string?
    throttle = 20,
    -- custom_keys = {
    --   ["<localleader>l"] = {
    --     function(plugin)
    --       require("lazy.util").float_term({ "lazygit", "log" }, {
    --         cwd = plugin.dir,
    --       })
    --     end,
    --     desc = "Open lazygit log",
    --   },
    --   ["<localleader>t"] = {
    --     function(plugin)
    --       require("lazy.util").float_term(nil, {
    --         cwd = plugin.dir,
    --       })
    --     end,
    --     desc = "Open terminal in plugin dir",
    --   },
    -- },
  },
  diff = {
    -- * browser: opens the github compare view. Note that this is always mapped to <K> as well, so you can have a different command for diff <d>
    -- * git: will run git diff and open a buffer with filetype git
    -- * terminal_git: will open a pseudo terminal with git diff
    -- * diffview.nvim: will open Diffview to show the diff
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
      ---@type string[]
      paths = {}, ---@type string[]
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
        -- "osc52",
      },
    },
  },
  state = vim.fs.joinpath(state_dir, "lazy", "state.json"),
  build = {
    warn_on_override = true,
  },
  profiling = {
    loader = false,
    require = false,
  },
}

require("lazy").setup(require("code.plugins"), lazy_config)
