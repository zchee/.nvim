require('telescope').setup{
  -- defaults = {
  --   -- vimgrep_arguments = {
  --   --   -- 'ugrep',
  --   --   -- '--color=never',
  --   --   -- '--no-heading',
  --   --   -- '--hidden',
  --   --   -- '--ignore-binary',
  --   --   -- '--ignore-case',
  --   --   -- '--no-ignore-files',
  --   --   -- '--column-number',
  --   --   -- '--mmap',
  --   --   -- '--line-number',
  --   --   -- '--no-group-separator',
  --   --   -- '--recursive',
  --   --   -- '--tabs=1',
  --   --   -- '-J20'
  --   --   'rg',
  --   --   '-i',
  --   --   '--no-config',
  --   --   '--no-ignore-vcs',
  --   --   '--threads=20',
  --   --   '--mmap',
  --   --   '--hidden',
  --   --   '--no-heading',
  --   --   '--vimgrep',
  --   --   '--glob=!.git',
  --   --   '--glob=!node_modules',
  --   --   '--color=never',
  --   --   '--with-filename',
  --   --   '--line-number',
  --   --   '--column',
  --   --   '--smart-case'
  --   -- },
  --   -- prompt_position = "bottom",
  --   -- prompt_prefix = "> ",
  --   -- scroll_strategy = "limit",
  --   -- selection_caret = "> ",
  --   -- entry_prefix = "  ",
  --   -- initial_mode = "insert",
  --   -- selection_strategy = "reset",
  --   -- sorting_strategy = "descending",
  --   -- layout_strategy = "horizontal",
  --   -- layout_defaults = {
  --   --   horizontal = {
  --   --     mirror = false,
  --   --   },
  --   --   vertical = {
  --   --     mirror = false,
  --   --   },
  --   --   preview_width = 0.5,
  --   -- },
  --   -- file_sorter =  require'telescope.sorters'.get_fuzzy_file,
  --   -- file_ignore_patterns = {},
  --   -- generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
  --   -- shorten_path = true,
  --   -- winblend = 0,
  --   -- width = 0.5,
  --   -- preview_cutoff = 120,
  --   -- results_height = 1,
  --   -- results_width = 0.3,
  --   -- border = {},
  --   -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  --   color_devicons = true,
  --   -- use_less = true,
  --   set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
  --   -- file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
  --   -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
  --   -- qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  -- 
  --   -- Developer configurations: Not meant for general override
  --   -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  -- }
  defaults = {
    vimgrep_arguments = {
      '/usr/local/rust/cargo/bin/rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      }
    }
  }
}

-- local dropdown_theme = require('telescope.themes').get_dropdown({
--   results_height = 20;
--   winblend = 20;
--   width = 0.8;
--   prompt_title = '';
--   prompt_prefix = 'Files>';
--   previewer = false;
--   borderchars = {
--     prompt = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
--     results = {' ', '▐', '▄', '▌', '▌', '▐', '▟', '▙' };
--     preview = {'▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
--   };
-- })

-- extensions
require('telescope').load_extension('gh')
require('telescope').load_extension('ghq')
require('telescope').load_extension('fzf')
-- require('telescope').load_extension('project')
-- require('telescope').load_extension('dap')
-- require('telescope').load_extension('fzy_native')

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- local dap = require('dap')
-- dap.adapters.go = function(callback, config)
--   local handle
--   local pid_or_err
--   local port = 38697
--   handle, pid_or_err =
--   vim.loop.spawn(
--   "dlv",
--   {
--     args = {"dap", "-l", "127.0.0.1:" .. port},
--     detached = true
--   },
--   function(code)
--     handle:close()
--     print("Delve exited with exit code: " .. code)
--   end
--   )
--   ----should we wait for delve to start???
--   --vim.defer_fn(
--   --function()
--   --dap.repl.open()
--   --callback({type = "server", host = "127.0.0.1", port = port})
--   --end,
--   --100)
-- 
--   callback({type = "server", host = "127.0.0.1", port = port})
-- end
-- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
--   {
--     type = "go",
--     name = "Debug",
--     request = "launch",
--     program = "${file}"
--   }
-- }

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash",
    "c",
    -- "c_sharp",
    -- "clojure",
    "cpp",
    "css",
    -- "dart",
    -- "elm",
    -- "erlang",
    -- "fennel",
    -- "gdscript",
    "go",
    "graphql",
    -- "haskell",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    -- "julia",
    -- "kotlin",
    -- "ledger",
    "lua",
    -- "nix",
    -- "ocaml",
    -- "ocaml_interface",
    -- "ocamllex",
    -- "php",
    "python",
    -- "ql",
    "query",
    "regex",
    -- "rst",
    "ruby",
    "rust",
    -- "scala",
    -- "sparql",
    "swift",
    -- "teal",
    "toml",
    "tsx",
    -- "turtle",
    "typescript",
    -- "verilog",
    -- "vue",
    -- "yaml"
  };
  highlight = {
    enable = true,
    disable = { 'bash', 'go' }  -- , 'typescript'
  };
  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = "gnn",
      node_decremental = "grm",
      node_incremental = "grn",
      scope_incremental = "grc"
    },
  };
  indent = {
    enable = true,
    disable = { "json", 'go' }  -- , 'go'
  };
  refactor = {
    highlight_definitions = {
      enable = false,
    },
    highlight_current_scope = {
      enable = false,
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "<leader>tr"
      }
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "<leader>td",
        list_definitions = "<leader>tl"
      }
    }
  };
  textobjects = {
    enable = false,
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- Or you can define your own textobjects like this
        ["iF"] = {
          -- c = "(function_definition) @function",
          -- cpp = "(function_definition) @function",
          -- go = "(function_definition) @function",
          -- java = "(method_declaration) @function",
          -- python = "(function_definition) @function",
        },
      },
    },
    swap = {
      enable = false,
      swap_next = {
        ["<leader>al"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>ah"] = "@parameter.inner",
      },
    },
    move = {
      enable = false,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  };
  playground = {
    enable = false,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false -- Whether the query persists across vim sessions
  };
  rainbow = {
    enable = true,
    disable = { 'bash', 'defx', 'go' }  -- , 'go'
  };
}

-- require'nvim-web-devicons'.setup {
--   default = true;
-- }
