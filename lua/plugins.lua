require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '-i',
      '--no-config',
      '--no-ignore-vcs',
      '--threads=20',
      '--mmap',
      '--hidden',
      '--no-heading',
      '--vimgrep',
      '--glob=!.git',
      '--glob=!node_modules',
      '--color=never',
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
      preview_width = 0.5,
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.5,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.3,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}

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

require'nvim-web-devicons'.setup {
  default = true;
  -- override = {
  --   zsh = {
  --     icon = "",
  --     color = "#428850",
  --     name = "Zsh"
  --   }
  -- };
}
