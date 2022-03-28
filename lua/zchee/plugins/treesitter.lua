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
    url = "~/src/github.com/zchee/tree-sitter-sql",
    files = { "src/parser.c" },
    requires_generate_from_grammar = false,
  },
}

treesitter.setup {
  ensure_installed = {
    "bash",
    -- "beancount",
    -- "bibtex",
    "c",
    -- "c_sharp",
    -- "clojure",
    "cmake",
    -- "comment",
    -- "commonlisp",
    "cpp",
    -- "css",
    -- "cuda",
    -- "d",
    -- "dart",
    -- "devicetree",
    "dockerfile",
    "dot",
    -- "eex",
    -- "elixir",
    -- "elm",
    -- "erlang",
    -- "fennel",
    -- "fish",
    -- "foam",
    -- "fortran",
    -- "fusion",
    -- "gdscript",
    -- "gleam",
    -- "glimmer",
    "glsl",
    "go",
    -- "godot_resource",
    "gomod",
    "gowork",
    "graphql",
    -- "hack",
    -- "haskell",
    "hcl",
    -- "heex",
    -- "hjson",
    -- "hocon",
    -- "html",
    "http",
    -- "java",
    "javascript",
    -- "jsdoc",
    "json",
    "json5",
    "jsonc",
    -- "julia",
    -- "kotlin",
    -- "lalrpop",
    -- "latex",
    -- "ledger",
    "llvm",
    "lua",
    -- "make",
    "markdown",
    "ninja",
    -- "nix",
    -- "norg",
    "objc",
    -- "ocaml",
    -- "ocaml_interface",
    -- "ocamllex",
    -- "pascal",
    -- "perl",
    -- "php",
    -- "phpdoc",
    -- "pioasm",
    -- "prisma",
    -- "pug",
    "python",
    "proto",
    "ql",
    "query",
    -- "r",
    -- "rasi",
    "regex",
    -- "rst",
    "ruby",
    "rust",
    -- "scala",
    -- "scss",
    -- "sparql",
    "sql",
    -- "supercollider",
    -- "surface",
    -- "svelte",
    "swift",
    -- "teal",
    -- "tlaplus",
    -- "todotxt",
    "toml",
    -- "tsx",
    -- "turtle",
    "typescript",
    -- "vala",
    -- "verilog",
    "vim",
    -- "vue",
    "yaml",
    -- "yang",
    -- "zig",
  },
  highlight = {
    enable = true,
    disable = {  -- function(lang, _)
      -- "bash",
      "dockerfile",
      "go",
      -- "vim",
    },
    additional_vim_regex_highlighting = {
      "toml",
      "proto",
    },
    set_custom_captures = {},
  };
  indent = {
    enable = true,
    disable = {
      "go",
      "json",
      "yaml",
    },
  };
  incremental_selection = {
    enable = true,
    disable = { },
    keymaps = {
      init_selection = "gnn",
      node_decremental = "grm",
      node_incremental = "grn",
      scope_incremental = "grc"
    },
  };
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
}
