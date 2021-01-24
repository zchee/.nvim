require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "go",
    "graphql",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    -- "kotlin",
    "lua",
    -- "ocaml",
    -- "ocaml_interface",
    -- "ocamllex",
    "python",
    "query",
    "regex",
    "rst",
    "ruby",
    "rust",
    "swift",
    "toml",
    "typescript"
    -- "yaml"
  };
  highlight = {
    enable = true,
    disable = { 'bash', 'go' }
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
    disable = { 'go', 'python' }
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
    enable = true,
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
      enable = true,
      swap_next = {
        ["<leader>al"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>ah"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
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
    disable = { 'bash', 'go' }
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
