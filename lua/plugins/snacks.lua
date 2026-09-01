local compat = require("plugins.snacks_compat")
local snacks = require("snacks")

-- Inject lazy wrappers for the patch's filetype/treesitter deps: letting the
-- patcher resolve its defaults eagerly loads the deferred vim.filetype and
-- vim.treesitter modules (~1.6 ms) during the startup burst, but they are not
-- needed until the first quickfile render on BufReadPost.
compat.patch_quickfile_module(require("snacks.quickfile"), {
  match_filetype = function(args)
    return vim.filetype.match(args)
  end,
  get_lang = function(ft)
    return vim.treesitter.language.get_lang(ft)
  end,
})

---@class snacks.Config: snacks.plugins.Config
snacks.setup({
  ---@type table<string, snacks.win.Config>
  styles = {
    help = {
      position = "float",
      backdrop = false,
      border = "top",
      row = -1,
      width = 0,
      height = 0.3,
    },
    notification = {
      border = true,
      zindex = 100,
      ft = "markdown",
      wo = {
        winblend = 5,
        wrap = false,
        conceallevel = 2,
        colorcolumn = "",
      },
      bo = { filetype = "snacks_notif" },
    },
    terminal = {
      bo = {
        filetype = "snacks_terminal",
      },
      wo = {},
      stack = true,
      keys = {
        q = "hide",
        gf = function(self)
          local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
          if f == "" then
            Snacks.notify.warn("No file under cursor")
          else
            self:hide()
            vim.schedule(function()
              vim.cmd("e " .. f)
            end)
          end
        end,
        term_normal = {
          "<esc>",
          function(self)
            self.esc_timer = self.esc_timer or vim.uv.new_timer()
            if self.esc_timer:is_active() then
              self.esc_timer:stop()
              vim.cmd("stopinsert")
            else
              self.esc_timer:start(200, 0, function() end)
              return "<esc>"
            end
          end,
          mode = "t",
          expr = true,
          desc = "Double escape to normal mode",
        },
      },
    },
  },
  animate = { enabled = false },
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  dim = { enabled = false },
  explorer = { enabled = false },
  gitbrowse = { enabled = false },
  image = {
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
      -- Keep image conversion/manual features available, but disable automatic
      -- document attachment because Snacks terminal detection can leak Kitty's
      -- terminal-response sequence into Markdown buffers.
      -- ref: https://sw.kovidgoyal.net/kitty/mapping/#conditional-mappings-depending-on-the-state-of-the-focused-window
      enabled = false,
      inline = true,
      float = true,
      max_width = 80,
      max_height = 40,
      ---@param lang string tree-sitter language
      ---@param type snacks.image.Type image type
      conceal = function(lang, type)
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
        vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
        math = { "-density", 192, "{src}[0]", "-trim" },
        pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
      },
    },
    math = {
      enabled = false,
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
  indent = { enabled = false },
  input = { enabled = false },
  layout = { enabled = false },
  lazygit = {
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
      [241] = { fg = "Special" },
      activeBorderColor = { fg = "MatchParen", bold = true },
      cherryPickedCommitBgColor = { fg = "Identifier" },
      cherryPickedCommitFgColor = { fg = "Function" },
      defaultFgColor = { fg = "Normal" },
      inactiveBorderColor = { fg = "FloatBorder" },
      optionsTextColor = { fg = "Function" },
      searchingActiveBorderColor = { fg = "MatchParen", bold = true },
      selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
      unstagedChangesColor = { fg = "DiagnosticError" },
    },
    win = {
      style = "lazygit",
    },
  },
  notifier = {
    enabled = true,
    timeout = 10000,
    width = { min = 100, max = 0.8 },
    height = { min = 1, max = 0.8 },
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
    top_down = true, -- place notifications from top to bottom
    date_format = "%R", -- time format for notifications
    -- format for footer when more lines are available
    -- `%d` is replaced with the number of lines.
    -- only works for styles with a border
    ---@type string|boolean
    more_format = " ↓ %d lines ",

    ---@type fun(notif: snacks.notifier.Notif): boolean # filter our unwanted notifications (return false to hide)
    filter = function(notif)
      local is_gopls = string.find(notif.msg, "gopls")
      if
        is_gopls and string.find(notif.msg, "context canceled")
        or string.find(notif.msg, "timeout")
        or string.find(notif.msg, "pull diagnostics not supported for this file kind")
      then
        return false
      end

      if string.find(notif.msg, "vim%-illuminate: An internal error") then
        return false
      end

      return true
    end,
    refresh = 100,
  },

  notify = {
    enabled = true,
    history = true,
  },
  picker = {
    -- Deferred: upstream's UIEnter setup only installs the vim.ui.select
    -- override, but requiring the picker tree for it costs ~3.4 ms on the UI
    -- thread right as the UI opens. The override is replicated lazily below;
    -- everything else about the picker already loads on demand.
    enabled = false,
    formatters = {
      text = {
        ft = nil, ---@type string? filetype for highlighting
      },
    },
    sources = {
      file = {
        filename_first = false, -- display filename before the file path
        truncate = 100, -- truncate the file path to (roughly) this length
        filename_only = false, -- only show the filename
        icon_width = 2, -- width of the icon (in characters)
        git_status_hl = true, -- use the git status highlight group for the filename
        hidden = true,
      },
      selected = {
        show_always = true, -- only show the selected column when there are multiple selections
        unselected = true, -- use the unselected icon for unselected items
      },
      grep = { hidden = true },
      buffers = { current = false },
      severity = {
        -- icons = true, -- show severity icons
        level = false, -- show severity level
        pos = "right", -- position of the diagnostics, "left"|"right"
      },
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
        },
      },
    },
  },
  profiler = {
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
      pick = true, -- show a picker after stopping the profiler (uses the `on_stop` preset)
    },
    ---@type snacks.profiler.Highlights
    highlights = {
      min_time = 0, -- only highlight entries with time > min_time (in ms)
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
      after = true, -- stop the profiler **after** the event. When false it stops **at** the event
      pattern = nil, -- pattern to match for the autocmd
      pick = true, -- show a picker after starting the profiler (uses the `startup` preset)
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
      time = " ",
      pct = " ",
      count = " ",
      require = "󰋺 ",
      modname = "󰆼 ",
      plugin = " ",
      autocmd = "⚡",
      file = " ",
      fn = "󰊕 ",
      status = "󰈸 ",
    },
  },
  quickfile = {
    enabled = true,
    exclude = { "latex", "ruby" },
  },
  scope = { enabled = false },
  scratch = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  terminal = {
    bo = {
      filetype = "snacks_terminal",
    },
    win = {
      max_width = 300,
      max_height = 300,
      position = "float",
    },
  },
  toggle = { enabled = false },
  win = { enabled = false },
  words = {
    -- replaces vim-illuminate: its treesitter provider required the
    -- nvim-treesitter locals Lua module, which the main branch removed
    enabled = true,
    debounce = 100, -- parity with illuminate's delay = 100
  },
  zen = { enabled = false },
})

-- parity with the picker's skipped UIEnter setup (ui_select defaults to
-- true): install the vim.ui.select override without loading the picker tree
vim.ui.select = function(...)
  return require("snacks.picker").select(...)
end

-- reference navigation, parity with vim-illuminate's default <a-n>/<a-p>
vim.keymap.set("n", "<M-n>", function()
  require("snacks").words.jump(vim.v.count1, true)
end, { silent = true, desc = "Next reference" })
vim.keymap.set("n", "<M-p>", function()
  require("snacks").words.jump(-vim.v.count1, true)
end, { silent = true, desc = "Prev reference" })
