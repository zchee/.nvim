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
      search_by = "path", -- "title",
      sync_with_nvim_tree = true, -- default false
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),
    },
  },
})

telescope.load_extension("file_browser")
telescope.load_extension("ghq")
telescope.load_extension("grep_app")
telescope.load_extension("live_grep_args")
telescope.load_extension("ui-select")
