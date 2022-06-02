local treesitter = require("nvim-treesitter.configs")
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername

-- jsonschema
ft_to_parser.json = "jsonschema"
ft_to_parser.bash = "zsh"

-- objc
parser_config.objc = {
  filetype = "objc",
  install_info = {
    url = "https://github.com/merico-dev/tree-sitter-objc",
    branch = "master",
    files = { "src/parser.c" },
    generate_requires_npm = true,
    requires_generate_from_grammar = true,
  },
}

-- protobuf
parser_config.proto = {
  filetype = "proto",
  install_info = {
    url = "https://github.com/mitchellh/tree-sitter-proto",
    branch = "main",
    files = { "src/parser.c" },
    generate_requires_npm = true,
    requires_generate_from_grammar = true,
  },
}

-- sql
parser_config.sql = {
  filetype = "sql",
  filetype_to_parsername = { "mysql" },
  install_info = {
    url =  "https://github.com/m-novikov/tree-sitter-sql",
    branch = "main",
    files = { "src/parser.c" },
    generate_requires_npm = true,
    requires_generate_from_grammar = true,
  },
}

treesitter.setup {
  ensure_installed = {
    --   "astro",             -- [✗] not installed
    "bash",              -- [✓] installed
    --   "beancount",         -- [✗] not installed
    --   "bibtex",            -- [✗] not installed
    "c",                 -- [✓] installed
    --   "c_sharp",           -- [✗] not installed
    --   "clojure",           -- [✗] not installed
    "cmake",             -- [✓] installed
    --   "comment",           -- [✗] not installed
    --   "commonlisp",        -- [✗] not installed
    --   "cooklang",          -- [✗] not installed
    "cpp",               -- [✓] installed
    --   "css",               -- [✗] not installed
    --   "cuda",              -- [✗] not installed
    --   "d",                 -- [✗] not installed
    --   "dart",              -- [✗] not installed
    --   "devicetree",        -- [✗] not installed
    "dockerfile",        -- [✓] installed
    --   "dot",               -- [✓] installed
    --   "eex",               -- [✗] not installed
    --   "elixir",            -- [✗] not installed
    --   "elm",               -- [✗] not installed
    --   "elvish",            -- [✗] not installed
    --   "embedded_template", -- [✗] not installed
    --   "erlang",            -- [✗] not installed
    --   "fennel",            -- [✗] not installed
    --   "fish",              -- [✗] not installed
    --   "foam",              -- [✗] not installed
    --   "fortran",           -- [✗] not installed
    --   "fusion",            -- [✗] not installed
    --   "gdscript",          -- [✗] not installed
    --   "gleam",             -- [✗] not installed
    --   "glimmer",           -- [✗] not installed
    --   "glsl",              -- [✓] installed
    "go",                -- [✓] installed
    --   "godot_resource",    -- [✗] not installed
    "gomod",             -- [✓] installed
    "gowork",            -- [✓] installed
    "graphql",           -- [✓] installed
    --   "hack",              -- [✗] not installed
    --   "haskell",           -- [✗] not installed
    "hcl",               -- [✓] installed
    --   "heex",              -- [✗] not installed
    --   "help",              -- [✗] not installed
    --   "hjson",             -- [✗] not installed
    --   "hocon",             -- [✗] not installed
    --   "html",              -- [✗] not installed
    --   "http",              -- [✓] installed
    "java",              -- [✗] not installed
    "javascript",        -- [✓] installed
    --   "jsdoc",             -- [✗] not installed
    "json",              -- [✓] installed
    "json5",             -- [✓] installed
    "jsonc",             -- [✓] installed
    --   "julia",             -- [✗] not installed
    --   "kotlin",            -- [✗] not installed
    --   "lalrpop",           -- [✗] not installed
    --   "latex",             -- [✗] not installed
    --   "ledger",            -- [✗] not installed
    "llvm",              -- [✓] installed
    "lua",               -- [✓] installed
    --   "m68k",              -- [✗] not installed
    "make",              -- [✗] not installed
    "markdown",          -- [✓] installed
    "ninja",             -- [✓] installed
    --   "nix",               -- [✗] not installed
    --   "norg",              -- [✗] not installed
    "objc",              -- [✓] installed
    --   "ocaml",             -- [✗] not installed
    --   "ocaml_interface",   -- [✗] not installed
    --   "ocamllex",          -- [✗] not installed
    --   "org",               -- [✗] not installed
    --   "pascal",            -- [✗] not installed
    --   "perl",              -- [✗] not installed
    --   "php",               -- [✗] not installed
    --   "phpdoc",            -- [✗] not installed
    --   "pioasm",            -- [✗] not installed
    --   "prisma",            -- [✗] not installed
    "proto",             -- [✓] installed
    "pug",               -- [✗] not installed
    "python",            -- [✓] installed
    "ql",                -- [✓] installed
    "query",             -- [✓] installed
    --   "r",                 -- [✗] not installed
    --   "rasi",              -- [✗] not installed
    "regex",             -- [✓] installed
    "rego",              -- [✗] not installed
    --   "rst",               -- [✗] not installed
    "ruby",              -- [✓] installed
    "rust",              -- [✓] installed
    --   "scala",             -- [✗] not installed
    --   "scheme",            -- [✗] not installed
    --   "scss",              -- [✗] not installed
    --   "slint",             -- [✗] not installed
    --   "solidity",          -- [✗] not installed
    --   "sparql",            -- [✗] not installed
    "sql",               -- [✓] installed
    --   "supercollider",     -- [✗] not installed
    --   "surface",           -- [✗] not installed
    --   "svelte",            -- [✗] not installed
    "swift",             -- [✓] installed
    --   "teal",              -- [✗] not installed
    --   "tlaplus",           -- [✗] not installed
    --   "todotxt",           -- [✗] not installed
    "toml",              -- [✓] installed
    --   "tsx",               -- [✗] not installed
    --   "turtle",            -- [✗] not installed
    "typescript",        -- [✓] installed
    --   "vala",              -- [✗] not installed
    --   "verilog",           -- [✗] not installed
    "vim",               -- [✓] installed
    --   "vue",               -- [✗] not installed
    --   "wgsl",              -- [✗] not installed
    "yaml",              -- [✗] installed
    --   "yang",              -- [✗] not installed
    --   "zig",               -- [✗] not installed
  },
  highlight = {
    enable = true,
    disable = {  -- function(lang, _)
      "bash",
      "dockerfile",
      "go",
      "make",
      "vim",
    },
    additional_vim_regex_highlighting = {
      -- "go",
      "proto",
      "toml",
    },
    set_custom_captures = {},
  },
  indent = {
    enable = true,
    disable = {
      "go",
      "json",
      "yaml",
    },
  },
  incremental_selection = {
    enable = true,
    disable = { },
    keymaps = {
      init_selection = "gnn",
      node_decremental = "grm",
      node_incremental = "grn",
      scope_incremental = "grc"
    },
  },
  -- nvim-treesitter/playground
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {
      "BufWrite",
      "CursorHold",
    },
  },
  -- nvim-treesitter/nvim-treesitter-refactor
  refactor = {
    highlight_definitions = {
      enable = false,
      clear_on_cursor_move = true,
    },
    highlight_current_scope = {
      enable = false,
    },
    smart_rename = {
      enable = false,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
  autopairs = {
    enable = true,
  },
  matchup = {
    enable = true,
    disable = {
      "c",
      "ruby",
    },
  },
  context_commentstring = {
    enable = true
  },
}
