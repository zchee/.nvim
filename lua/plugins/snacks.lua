local snacks = require("snacks")
local util   = require("util")

---@class snacks.Config: snacks.plugins.Config
snacks.setup({
  animate      = { enabled = false },
  bigfile      = { enabled = true },
  dashboard    = { enabled = false },
  dim          = { enabled = false },
  explorer     = { enabled = false },
  gitbrowse    = { enabled = false },
  image        = {
    formats = {
      "png",
      "jpg",
      "jpeg",
      "gif",
      "bmp",
      "webp",
      "tiff",
      "heic",
      "avif",
      "mp4",
      "mov",
      "avi",
      "mkv",
      "webm",
      "pdf",
    },
    force = false,
    doc = {
      enabled = true,
      inline = true,
      float = true,
      max_width = 80,
      max_height = 40,
      ---@param lang string tree-sitter language
      ---@param type snacks.image.Type image type
      conceal = function(lang, type)
        _ = lang
        return type == "math"
      end,
    },
    img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
    wo = {
      wrap = false,
      number = false,
      relativenumber = false,
      cursorcolumn = false,
      signcolumn = "no",
      foldcolumn = "0",
      list = false,
      spell = false,
      statuscolumn = "",
    },
    cache = vim.fn.stdpath("cache") .. "/snacks/image",
    debug = {
      request = false,
      convert = false,
      placement = false,
    },
    env = {},
    icons = {
      math = "󰪚 ",
      chart = "󰄧 ",
      image = " ",
    },
    ---@class snacks.image.convert.Config
    convert = {
      notify = true,
      ---@type snacks.image.args
      mermaid = function()
        local theme = vim.o.background == "light" and "neutral" or "dark"
        return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
      end,
      ---@type table<string,snacks.image.args>
      magick = {
        default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
        vector = { "-density", 192, "{src}[0]" },         -- used by vector images like svg
        math = { "-density", 192, "{src}[0]", "-trim" },
        pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
      },
    },
    math = {
      enabled = true,
      -- in the templates below, `${header}` comes from any section in your document,
      -- between a start/end header comment. Comment syntax is language-specific.
      -- * start comment: `// snacks: header start`
      -- * end comment:   `// snacks: header end`
      typst = {
        tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
      },
      latex = {
        font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
        -- for latex documents, the doc packages are included automatically,
        -- but you can add more packages here. Useful for markdown documents.
        packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
        tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
      },
    },
  },
  indent       = { enabled = false },
  input        = { enabled = false },
  layout       = { enabled = false },
  lazygit      = {
    configure = true,
    config = {
      os = { editPreset = "nvim-remote" },
      gui = {
        nerdFontsVersion = "3",
      },
    },
    theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yaml"),
    -- Theme for lazygit
    theme = {
      [241]                      = { fg = "Special" },
      activeBorderColor          = { fg = "MatchParen", bold = true },
      cherryPickedCommitBgColor  = { fg = "Identifier" },
      cherryPickedCommitFgColor  = { fg = "Function" },
      defaultFgColor             = { fg = "Normal" },
      inactiveBorderColor        = { fg = "FloatBorder" },
      optionsTextColor           = { fg = "Function" },
      searchingActiveBorderColor = { fg = "MatchParen", bold = true },
      selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
      unstagedChangesColor       = { fg = "DiagnosticError" },
    },
    win = {
      style = "lazygit",
    },
  },
  notifier     = {
    enabled = true,
    timeout = 10000,
    width = { min = 100, max = 0.6 },
    height = { min = 1, max = 0.6 },
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true, -- add 1 cell of left/right padding to the notification window
    sort = { "added", "level" },
    level = vim.log.levels.WARN,
    icons = {
      error = " ",
      warn = " ",
      info = " ",
      debug = " ",
      trace = " ",
    },
    keep = function()
      return vim.fn.getcmdpos() > 0
    end,
    ---@type snacks.notifier.style
    style = "fancy",
    top_down = true,    -- place notifications from top to bottom
    date_format = "%R", -- time format for notifications
    -- format for footer when more lines are available
    -- `%d` is replaced with the number of lines.
    -- only works for styles with a border
    ---@type string|boolean
    more_format = " ↓ %d lines ",
    ---@type fun(notif: snacks.notifier.Notif): boolean # filter our unwanted notifications (return false to hide)
    filter = function(notif)
      local is_gopls = string.find(notif.msg, "gopls")
      if is_gopls and string.find(notif.msg, "context canceled") or string.find(notif.msg, "timeout") or string.find(notif.msg, "pull diagnostics not supported for this file kind") then
        return false
      end
      return true
    end,
    refresh = 100,
  },
  notify       = {
    enabled = true,
    history = true,
  },
  picker       = {
    enabled = true,
    formatters = {
      text = {
        ft = nil, ---@type string? filetype for highlighting
      },
      file = {
        filename_first = false, -- display filename before the file path
        truncate = 100,         -- truncate the file path to (roughly) this length
        filename_only = false,  -- only show the filename
        icon_width = 2,         -- width of the icon (in characters)
        git_status_hl = true,   -- use the git status highlight group for the filename
      },
      selected = {
        show_always = true, -- only show the selected column when there are multiple selections
        unselected = true,  -- use the unselected icon for unselected items
      },
      severity = {
        icons = true,  -- show severity icons
        level = false, -- show severity level
        ---@type "left"|"right"
        pos = "right", -- position of the diagnostics
      },
    },
  },
  profiler     = {
    autocmds = true,
    runtime = vim.env.VIMRUNTIME, ---@type string
    -- thresholds for buttons to be shown as info, warn or error
    -- value is a tuple of [warn, error]
    thresholds = {
      time = { 2, 10 },
      pct = { 10, 20 },
      count = { 10, 100 },
    },
    on_stop = {
      highlights = true, -- highlight entries after stopping the profiler
      pick = true,       -- show a picker after stopping the profiler (uses the `on_stop` preset)
    },
    ---@type snacks.profiler.Highlights
    highlights = {
      min_time = 0,   -- only highlight entries with time > min_time (in ms)
      max_shade = 20, -- time in ms for the darkest shade
      badges = { "time", "pct", "count", "trace" },
      align = 80,
    },
    pick = {
      picker = "snacks", ---@type snacks.profiler.Picker
      ---@type snacks.profiler.Badge.type[]
      badges = { "time", "count", "name" },
      ---@type snacks.profiler.Highlights
      preview = {
        badges = { "time", "pct", "count" },
        align = "right",
      },
    },
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      after = true,       -- stop the profiler **after** the event. When false it stops **at** the event
      pattern = nil,      -- pattern to match for the autocmd
      pick = true,        -- show a picker after starting the profiler (uses the `startup` preset)
    },
    ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick?>
    presets = {
      startup = { min_time = 1, sort = false },
      on_stop = {},
      filter_by_plugin = function()
        return { filter = { def_plugin = vim.fn.input("Filter by plugin: ") } }
      end,
    },
    ---@type string[]
    globals = {
      -- "vim",
      -- "vim.api",
      -- "vim.keymap",
      -- "Snacks.dashboard.Dashboard",
    },
    filter_mod = {
      default = true,
      ["^vim%."] = false,
      ["mason-core.functional"] = false,
      ["mason-core.functional.data"] = false,
      ["mason-core.optional"] = false,
      ["which-key.state"] = false,
    },
    filter_fn = {
      default = true,
      ["^.*%._[^%.]*$"] = false,
      ["trouble.filter.is"] = false,
      ["trouble.item.__index"] = false,
      ["which-key.node.__index"] = false,
      ["smear_cursor.draw.wo"] = false,
      ["^ibl%.utils%."] = false,
    },
    icons = {
      time    = " ",
      pct     = " ",
      count   = " ",
      require = "󰋺 ",
      modname = "󰆼 ",
      plugin  = " ",
      autocmd = "⚡",
      file    = " ",
      fn      = "󰊕 ",
      status  = "󰈸 ",
    },
  },
  quickfile    = { enabled = true },
  scope        = { enabled = false },
  scratch      = { enabled = false },
  scroll       = { enabled = false },
  statuscolumn = { enabled = false },
  terminal     = { enabled = false },
  toggle       = { enabled = false },
  win          = { enabled = false },
  words        = { enabled = false },
  zen          = { enabled = false },
})
