local treesitter = require("nvim-treesitter.configs")
local treesitter_parsers = require("nvim-treesitter.parsers")

vim.treesitter.language.register("jsonschema", "json")
vim.treesitter.language.register("zsh", "bash")

-- protobuf
---@class ParserInfo
treesitter_parsers.get_parser_configs().protobuf = {
  ---@class InstallInfo
  install_info = {
    url = "https://github.com/zchee/tree-sitter-protobuf",
    files = { "src/parser.c" },
    branch = "main",
    generate_requires_npm = true,
    requires_generate_from_grammar = false,
  },
  filetype = "proto",
  maintainers = { "@zchee" },
}

require("ts_context_commentstring").setup {}
vim.g.skip_ts_context_commentstring_module = true

-- :'<,'>s/\(\[[✗|✓]\] \z[not] installed\)/-- \1/g
local parsers = {
  -- "ada",                 -- [✗] not installed
  -- "agda",                -- [✗] not installed
  -- "apex",                -- [✗] not installed
  -- "arduino",             -- [✗] not installed
  -- "astro",               -- [✗] not installed
  -- "authzed",             -- [✗] not installed
  "awk",                    -- [✓] installed
  "bash",                   -- [✓] installed
  -- "bass",                -- [✗] not installed
  -- "beancount",           -- [✗] not installed
  -- "bibtex",              -- [✗] not installed
  -- "bicep",               -- [✗] not installed
  -- "bitbake",             -- [✗] not installed
  -- "blueprint",           -- [✗] not installed
  "c",                      -- [✓] installed
  -- "c_sharp",             -- [✗] not installed
  -- "cairo",               -- [✗] not installed
  "capnp",                  -- [✗] not installed
  -- "chatito",             -- [✗] not installed
  -- "clojure",             -- [✗] not installed
  "cmake",                  -- [✓] installed
  "comment",                -- [✓] installed
  -- "commonlisp",          -- [✗] not installed
  -- "cooklang",            -- [✗] not installed
  -- "corn",                -- [✗] not installed
  -- "cpon",                -- [✗] not installed
  "cpp",                    -- [✓] installed
  -- "css",                 -- [✗] not installed
  "csv",                 -- [✗] not installed
  "cuda",                   -- [✓] installed
  "cue",                    -- [✓] installed
  -- "d",                   -- [✗] not installed
  -- "dart",                -- [✗] not installed
  "devicetree",             -- [✓] installed
  -- "dhall",               -- [✗] not installed
  "diff",                   -- [✓] installed
  "dockerfile",             -- [✓] installed
  "dot",                    -- [✗] not installed
  "doxygen",                -- [✓] installed
  "dtd",                    -- [✓] installed
  "ebnf",                   -- [✓] installed
  -- "eds",                 -- [✗] not installed
  -- "eex",                 -- [✗] not installed
  -- "elixir",              -- [✗] not installed
  -- "elm",                 -- [✗] not installed
  -- "elsa",                -- [✗] not installed
  -- "elvish",              -- [✗] not installed
  "embedded_template",      -- [✓] installed
  -- "erlang",              -- [✗] not installed
  -- "fennel",              -- [✗] not installed
  -- "firrtl",              -- [✗] not installed
  -- "fish",                -- [✗] not installed
  -- "foam",                -- [✗] not installed
  -- "forth",               -- [✗] not installed
  -- "fortran",             -- [✗] not installed
  -- "fsh",                 -- [✗] not installed
  -- "func",                -- [✗] not installed
  -- "fusion",              -- [✗] not installed
  -- "gdscript",            -- [✗] not installed
  "git_config",             -- [✓] installed
  "git_rebase",             -- [✓] installed
  "gitattributes",          -- [✓] installed
  "gitcommit",              -- [✓] installed
  "gitignore",              -- [✓] installed
  -- "gleam",               -- [✗] not installed
  -- "glimmer",             -- [✗] not installed
  "glsl",                   -- [✓] installed
  "go",                     -- [✓] installed
  -- "godot_resource",      -- [✗] not installed
  -- "gomod",                  -- [✓] installed
  "gosum",                  -- [✓] installed
  "gowork",                 -- [✓] installed
  "gpg",                    -- [✓] installed
  "graphql",                -- [✓] installed
  -- "groovy",              -- [✗] not installed
  -- "hack",                -- [✗] not installed
  -- "hare",                -- [✗] not installed
  -- "haskell",             -- [✗] not installed
  -- "haskell_persistent",  -- [✗] not installed
  "hcl",                    -- [✓] installed
  -- "heex",                -- [✗] not installed
  "hjson",               -- [✗] not installed
  -- "hlsl",                -- [✗] not installed
  -- "hocon",               -- [✗] not installed
  -- "hoon",                -- [✗] not installed
  -- "html",                -- [✗] not installed
  -- "htmldjango",          -- [✗] not installed
  "http",                   -- [✗] not installed
  -- "hurl",                -- [✗] not installed
  "ini",                    -- [✓] installed
  "ispc",                   -- [✗] not installed
  -- "janet_simple",        -- [✗] not installed
  "java",                   -- [✓] installed
  "javascript",             -- [✓] installed
  "jq",                     -- [✓] installed
  "jsdoc",                  -- [✓] installed
  "json",                   -- [✓] installed
  "json5",                  -- [✓] installed
  "jsonc",                  -- [✓] installed
  "jsonnet",                -- [✓] installed
  -- "julia",               -- [✗] not installed
  "kconfig",                -- [✗] not installed
  -- "kdl",                 -- [✗] not installed
  "kotlin",                 -- [✓] installed
  -- "lalrpop",             -- [✗] not installed
  -- "latex",               -- [✗] not installed
  -- "ledger",              -- [✗] not installed
  -- "liquidsoap",          -- [✗] not installed
  "llvm",                   -- [✓] installed
  "lua",                    -- [✓] installed
  "luadoc",                 -- [✓] installed
  "luap",                -- [✗] not installed
  "luau",                -- [✗] not installed
  -- "m68k",                -- [✗] not installed
  "make",                   -- [✓] installed
  "markdown",               -- [✓] installed
  "markdown_inline",        -- [✓] installed
  "matlab",                 -- [✓] installed
  -- "menhir",              -- [✗] not installed
  "mermaid",                -- [✓] installed
  "meson",                  -- [✓] installed
  "mlir",                   -- [✓] installed
  "nasm",                   -- [✗] not installed
  -- "nickel",              -- [✗] not installed
  "ninja",                  -- [✓] installed
  "nix",                    -- [✓] installed
  -- "norg",                -- [✗] not installed
  -- "nqc",                 -- [✗] not installed
  "objc",                   -- [✓] installed
  -- "ocaml",               -- [✗] not installed
  -- "ocaml_interface",     -- [✗] not installed
  -- "ocamllex",            -- [✗] not installed
  -- "odin",                -- [✗] not installed
  -- "org",                 -- [✗] not installed
  -- "pascal",              -- [✗] not installed
  "passwd",                 -- [✓] installed
  "pem",                    -- [✓] installed
  "perl",                   -- [✓] installed
  -- "php",                 -- [✗] not installed
  -- "phpdoc",              -- [✗] not installed
  "pioasm",                 -- [✓] installed
  -- "po",                  -- [✗] not installed
  -- "poe_filter",          -- [✗] not installed
  -- "pony",                -- [✗] not installed
  "prisma",              -- [✗] not installed
  "promql",                 -- [✗] not installed
  "proto",               -- [✗] not installed
  -- "protobuf",               -- [✓] installed
  -- "prql",                -- [✗] not installed
  -- "psv",                 -- [✗] not installed
  "pug",                    -- [✓] installed
  -- "puppet",              -- [✗] not installed
  "pymanifest",             -- [✓] installed
  "python",                 -- [✓] installed
  "ql",                     -- [✓] installed
  -- "qmldir",              -- [✗] not installed
  -- "qmljs",               -- [✗] not installed
  "query",                  -- [✓] installed
  -- "r",                   -- [✗] not installed
  -- "racket",              -- [✗] not installed
  -- "rasi",                -- [✗] not installed
  "re2c",                   -- [✓] installed
  "regex",                  -- [✓] installed
  "rego",                   -- [✓] installed
  "requirements",           -- [✗] not installed
  -- "rnoweb",              -- [✗] not installed
  -- "robot",               -- [✗] not installed
  -- "ron",                 -- [✗] not installed
  "rst",                    -- [✓] installed
  "ruby",                   -- [✓] installed
  "rust",                   -- [✓] installed
  -- "scala",               -- [✗] not installed
  -- "scfg",                -- [✗] not installed
  "scheme",                 -- [✓] installed
  -- "scss",                -- [✗] not installed
  -- "slint",               -- [✗] not installed
  -- "smali",               -- [✗] not installed
  -- "smithy",              -- [✗] not installed
  -- "snakemake",           -- [✗] not installed
  "solidity",            -- [✗] not installed
  -- "soql",                -- [✗] not installed
  -- "sosl",                -- [✗] not installed
  -- "sparql",              -- [✗] not installed
  "sql",                    -- [✓] installed
  -- "squirrel",            -- [✗] not installed
  "ssh_config",          -- [✗] not installed
  "starlark",               -- [✓] installed
  "strace",                 -- [✗] not installed
  -- "supercollider",       -- [✗] not installed
  -- "surface",             -- [✗] not installed
  -- "svelte",              -- [✗] not installed
  "swift",                  -- [✓] installed
  -- "sxhkdrc",             -- [✗] not installed
  -- "systemtap",           -- [✗] not installed
  -- "t32",                 -- [✗] not installed
  "tablegen",               -- [✓] installed
  "teal",                   -- [✗] not installed
  "terraform",              -- [✓] installed
  "textproto",           -- [✗] not installed
  "thrift",                 -- [✗] not installed
  -- "tiger",               -- [✗] not installed
  -- "tlaplus",             -- [✗] not installed
  "todotxt",                -- [✓] installed
  "toml",                   -- [✓] installed
  "tsv",                    -- [✗] not installed
  "tsx",                    -- [✓] installed
  -- "turtle",              -- [✗] not installed
  -- "twig",                -- [✗] not installed
  "typescript",             -- [✓] installed
  -- "ungrammar",           -- [✗] not installed
  -- "unison",              -- [✗] not installed
  -- "usd",                 -- [✗] not installed
  -- "uxntal",              -- [✗] not installed
  -- "v",                   -- [✗] not installed
  "vala",                   -- [✗] not installed
  -- "verilog",             -- [✗] not installed
  -- "vhs",                 -- [✗] not installed
  "vim",                    -- [✓] installed
  "vimdoc",                 -- [✓] installed
  -- "vue",                 -- [✗] not installed
  -- "wgsl",                -- [✗] not installed
  -- "wgsl_bevy",           -- [✗] not installed
  -- "wing",                -- [✗] not installed
  "xml",                    -- [✓] installed
  "yaml",                   -- [✓] installed
  -- "yang",                -- [✗] not installed
  -- "yuck",                -- [✗] not installed
  "zig",                    -- [✓] installed
}

-- treesitter_parsers.proto = {
--   install_info = {
--     url = "https://github.com/zchee/tree-sitter-protobuf",
--     files = { "src/parser.c" },
--     branch = "main",
--     generate_requires_npm = true,
--     requires_generate_from_grammar = false,
--   },
--   maintainers = { '@zchee' },
--   tier = 3,
-- }
-- treesitter_parsers.proto = proto
-- table.insert(treesitter_parsers, protobuf)

-- treesitter.setup({
--   auto_install = false,
--   ensure_install = parsers,
--   ignore_install = { "unsupported" },
--   install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "tree-sitter"),
-- })

---------- old? config ----------

vim.opt.runtimepath:append(vim.fs.joinpath(vim.fn.stdpath("data"), "tree-sitter"))
-- :TSInstallInfo
-- :'<,'>s/\[/  -- [/g
-- :'<,'>s/\(\s*--\) \[/",\1 [/g
-- :'<,'>s/\(-- \)\(\w\)/\1"\2/g
treesitter.setup({
  parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "tree-sitter"),
  ensure_installed = parsers,
  highlight = {
    enable = true,
    disable = {
      "go",
      "make",
      "vim",
    },
    additional_vim_regex_highlighting = {
      "diff",
      "gitcommit",
      "make",
      "toml",
    },
    set_custom_captures = {},
  },
  indent = {
    enable = true,
    disable = {
      "go",
      "gomod",
      "json",
      "python",
      "yaml",
    },
  },
  incremental_selection = {
    enable = true,
    disable = {
      -- "go",
    },
    keymaps = {
      init_selection = "gnn",
      node_decremental = "grm",
      node_incremental = "grn",
      scope_incremental = "grc",
    },
  },
  -- nvim-treesitter/nvim-tree-docs
  tree_docs = {
    enable = true,
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
    disable = {},
    disable_virtual_text = {},
    -- include_match_wor = { "/* */" },
    additional_vim_regex_highlighting = {
      "go",
    },
  },
})
