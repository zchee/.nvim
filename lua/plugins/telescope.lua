local telescope = require("telescope")

local nonicons = require("nvim-nonicons")
local live_grep_args = require("telescope-live-grep-args.actions")

-- local telescope_utils = require("telescope.utils")
-- local project_actions = require("telescope._extensions.project.actions")
-- local project_actions = require("telescope._extensions.project.actions")

local function get_pickers(actions)
  return {
    find_files = {
      hidden = true,
      previewer = false,
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        "--no-ignore",
        "--exclude=.git",
        "--exclude=_tmp",
        "--exclude=.aider.chat.history.md",
      },
      search_dirs = {
        vim.lsp.buf.list_workspace_folders()[0],
      },
    },
    file_browser = {
      date = true,
      size = {
        width = "70%",
        hl = "ErrorMsg",
      },
    },
    live_grep = {
      cwd = vim.lsp.buf.list_workspace_folders()[0],
      only_sort_text = true,
    },
    grep_string = {
      only_sort_text = true,
    },
    buffers = {
      previewer = true,
      initial_mode = "insert",
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["dd"] = actions.delete_buffer,
        },
      },
    },
    planets = {
      show_pluto = true,
      show_moon = true,
    },
    git_files = {
      hidden = true,
      previewer = false,
      show_untracked = true,
    },
    lsp_references = {
      initial_mode = "insert",
    },
    lsp_definitions = {
      initial_mode = "insert",
    },
    lsp_declarations = {
      initial_mode = "insert",
    },
    lsp_implementations = {
      initial_mode = "insert",
    },
  }
end

local ok, actions = pcall(require, "telescope.actions")
if not ok then
  return
end

-- local layout = require "telescope.pickers.layout"
telescope.setup({
  defaults = {
    -- create_layout = function(picker)
    --   local function create_window(enter, width, height, row, col, title)
    --     local bufnr = vim.api.nvim_create_buf(false, true)
    --     local winid = vim.api.nvim_open_win(bufnr, enter, {
    --       style = "minimal",
    --       -- relative = "win",
    --       width = width,
    --       height = height,
    --       row = row,
    --       col = col,
    --       border = "single",
    --       title = title,
    --     })
    --
    --     vim.wo[winid].winhighlight = "Normal:Normal"
    --
    --     return Layout.Window {
    --       bufnr = bufnr,
    --       winid = winid,
    --     }
    --   end
    --
    --   local function destory_window(window)
    --     if window then
    --       if vim.api.nvim_win_is_valid(window.winid) then
    --         vim.api.nvim_win_close(window.winid, true)
    --       end
    --       if vim.api.nvim_buf_is_valid(window.bufnr) then
    --         vim.api.nvim_buf_delete(window.bufnr, { force = true })
    --       end
    --     end
    --   end
    --
    --   local layout = Layout {
    --     picker = picker,
    --     mount = function(self)
    --       self.results = create_window(false, 60, 20, 0, 50, "Results")
    --       self.preview = create_window(false, 60, 23, 0, 42, "Preview")
    --       self.prompt = create_window(true, 60, 1, 22, 0, "Prompt")
    --     end,
    --     unmount = function(self)
    --       destory_window(self.results)
    --       destory_window(self.preview)
    --       destory_window(self.prompt)
    --     end,
    --     update = function(self)
    --       _ = self
    --     end,
    --   }
    --
    --   return layout
    -- end,
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 120,
        prompt_position = "top"
      },
      center = {
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8
      },
      horizontal = {
        height = 0.9,
        preview_cutoff = 120,
        prompt_position = "bottom",
        width = 0.8
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        prompt_position = "bottom",
        width = 0.8
      }
    },
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
    },
    prompt_prefix = "  " .. nonicons.get("telescope") .. "  ",
    selection_caret = " ❯ ",
    entry_prefix = "   ",
    set_env = { ["COLORTERM"] = "truecolor" },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--mmap",
      "--follow",
      "--no-ignore-vcs",
      "--no-config",
      "--glob=!.git/",             -- git
      "--glob=!.idea/",            -- JetBrains
      "--glob=!.next/",            -- Next.js
      -- "--glob=!node_modules/",     -- Node.js
      "--glob=!storybook-static/", -- storybook
      "--glob=!*.egg-info/",       -- Python egg
      "--glob=!*venv/",            -- Python virtualenv
      "--glob=!*.min.css",         -- minify
      "--glob=!*.min.js",          -- minify
      "--glob=!*.bundle.js",       -- webpack
      "--glob=!*.recording",       -- asciinema
      "--glob=!.aider*",           -- aider
    },
    -- vimgrep_arguments = {
    --   "ugrep",
    --   "--no-config",
    --   "--color=never",
    --   "--dereference-recursive",
    --   "--ignore-binary",
    --   "--line-number",
    --   "--column-number",
    --   "--smart-case",
    --   "--ungroup",
    --   "--tabs=1",
    --   "--no-ignore-files",
    --   "--exclude-dir='.next'",
    --   "--exclude-dir='node_modules'",
    --   "--exclude-dir='.egg-info'",
    --   "--exclude-dir='*venv'",
    --   "--exclude='*.recording'",
    -- },
  },
  pickers = get_pickers(actions),
  extensions = {
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      -- mappings = {
      --   ["i"] = {
      --     -- your custom insert mode mappings
      --   },
      --   ["n"] = {
      --     -- your custom normal mode mappings
      --   },
      -- },
    },
    -- fzf = {
    --   fuzzy = true,
    --   override_generic_sorter = false,
    --   override_file_sorter = false,
    --   case_mode = "smart_case", -- "smart_case", "ignore_case", "respect_case"
    -- },
    ghq = {
      bin = vim.fs.joinpath(vim.uv.os_homedir(), "go", "bin", "ghq"),
      cwd = vim.uv.cwd(),
    },
    grep_app = {
      open_browser_cmd = "chrome",
      word = false,
      regexp = true,
      max_results = 50,
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = live_grep_args.quote_prompt(),
        },
      },
    },
    project = {
      base_dirs = {
        { path = "~/go/src" },
        { path = "~/src" },
      },
      hidden_files = true, -- default: false
      theme = "dropdown",
      order_by = "asc",
      search_by = "path",         -- "title",
      sync_with_nvim_tree = true, -- default false
      -- default for on_project_selected = find project files
      -- on_project_selected = function(prompt_bufnr)
      --   -- Do anything you want in here. For example:
      --   project_actions.change_working_directory(prompt_bufnr, false)
      --   harpoon.ui.nav_file(1)
      --   -- harpoon.ui:toggle_quick_menu(harpoon:list())
      --   -- harpoon:list():append()
      -- end
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      },

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
  },
})

telescope.load_extension("dap")
telescope.load_extension("file_browser")
-- telescope.load_extension("fzf")
telescope.load_extension("ghq")
telescope.load_extension("grep_app")
telescope.load_extension("live_grep_args")
telescope.load_extension("textcase")
telescope.load_extension("ui-select")
-- telescope.load_extension("project")
