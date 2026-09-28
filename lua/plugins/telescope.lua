local util = require("util")

local telescope = require("telescope")

local live_grep_args = require("telescope-live-grep-args.actions")
local nonicons = require("nvim-nonicons")

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
    },
    file_browser = {
      date = true,
      size = {
        width = "70%",
        hl = "ErrorMsg",
      },
    },
    live_grep = {
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
  vim.notify("plugins.telescope: setup skipped, telescope.actions failed to load: " .. actions, vim.log.levels.ERROR)
  return
end

telescope.setup({
  defaults = {
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 120,
        prompt_position = "top",
      },
      center = {
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5,
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
      },
      horizontal = {
        height = 0.9,
        preview_cutoff = 120,
        prompt_position = "bottom",
        width = 0.8,
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        prompt_position = "bottom",
        width = 0.8,
      },
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
      "--glob=!.git/", -- git
      "--glob=!.idea/", -- JetBrains
      "--glob=!.next/", -- Next.js
      -- "--glob=!node_modules/",     -- Node.js
      "--glob=!storybook-static/", -- storybook
      "--glob=!*.egg-info/", -- Python egg
      "--glob=!*venv/", -- Python virtualenv
      "--glob=!*.min.css", -- minify
      "--glob=!*.min.js", -- minify
      "--glob=!*.bundle.js", -- webpack
      "--glob=!*.recording", -- asciinema
      "--glob=!.aider*", -- aider
    },
  },
  pickers = get_pickers(actions),
  extensions = {
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
    },
    ghq = {
      bin = util.go_path("bin", "ghq"),
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
      search_by = "path", -- "title",
    },
  },
})

telescope.load_extension("file_browser")
telescope.load_extension("ghq")
telescope.load_extension("grep_app")
telescope.load_extension("live_grep_args")

-- find_files and live_grep run in the buffer's first LSP workspace folder.
-- Picker config values are fixed when telescope loads, which would pin the
-- folder of whatever buffer was current then, so the lookup happens per call
-- by wrapping the builtins; :Telescope <picker> dispatches through this same
-- table. find_files takes it as cwd, not search_dirs: fd refuses a search
-- path together with the --strip-cwd-prefix its find_command passes. An
-- explicit cwd from the caller (the <C-g> git-root grep) still wins.
local builtin = require("telescope.builtin")
for _, name in ipairs({ "find_files", "live_grep" }) do
  local picker = builtin[name]
  builtin[name] = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.lsp.buf.list_workspace_folders()[1]
    return picker(opts)
  end
end
