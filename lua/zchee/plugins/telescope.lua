local telescope = require("telescope")
local telescope_utils = require("telescope.utils")
local lga_actions = require("telescope-live-grep-args.actions")
local icons = require("nvim-nonicons")

local function get_pickers(actions)
  return {
    find_files = {
      hidden = true,
      previewer = false,
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "!**/.git/*",
      },
      -- find_command = {
      --   "fd",
      --   "--type",
      --   "f",
      --   "--color",
      --   "never",
      -- },
      search_dirs = {
        vim.lsp.buf.list_workspace_folders()[1],
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
      previewer = false,
      initial_mode = "normal",
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
      initial_mode = "normal",
    },
    lsp_definitions = {
      initial_mode = "normal",
    },
    lsp_declarations = {
      initial_mode = "normal",
    },
    lsp_implementations = {
      initial_mode = "normal",
    },
  }
end

local ok, actions = pcall(require, "telescope.actions")
if not ok then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-Down>"] = require("telescope.actions").cycle_history_next,
        ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
      },
    },
    prompt_prefix = "  " .. icons.get("telescope") .. "  ",
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
      "--hidden",
      "--mmap",
      "--follow",
      "--no-ignore-vcs",
      "--glob=!.git/",             -- git
      "--glob=!.hg/",              -- mercurial
      "--glob=!.idea/",            -- JetBrains
      "--glob=!.next/",            -- Next.js
      "--glob=!.svn",              -- subversion
      "--glob=!node_modules/",     -- Node.js
      "--glob=!storybook-static/", -- storybook
      "--glob=!*.egg-info/",       -- Python egg
      "--glob=!*venv/",            -- Python virtualenv
      "--glob=!*.min.css",         -- minify
      "--glob=!*.min.js",          -- minify
      "--glob=!*.bundle.js",       -- webpack
      "--glob=!*.recording",       -- asciinema
    },
  },
  pickers = get_pickers(actions),
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case", -- "smart_case", "ignore_case", "respect_case"
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
        },
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
-- telescope.load_extension("notify")
