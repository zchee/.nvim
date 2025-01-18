local ts_config = require("nvim-treesitter.configs")
-- local ts_utils = require("nvim-treesitter.utils")
local ts_parsers = require("nvim-treesitter.parsers")
local ts_context_commentstring = require("ts_context_commentstring")

-- local ts_install = require("nvim-treesitter.shell_command_selectors")
-- ts_install.select_compile_command = function(_, _, compile_location)
--   return {
--     cmd = vim.fn.exepath("tree-sitter"),
--     info = "Building wasm bindings...",
--     err = 'Error during "tree-sitter build --wasm"',
--     opts = {
--       args = { "build", "--wasm", "-o", "parser.so" },
--       cwd = compile_location,
--     },
--   }
-- end

vim.treesitter.language.register("starlark", "tiltfile")
vim.treesitter.language.register("json", "jsonschema")
-- vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("gotmpl", "helm")

---@class ParserInfo[]
local parsers_config = ts_parsers.get_parser_configs()
--- cel
parsers_config.cel = {
  ---@type InstallInfo
  install_info = {
    url = "https://github.com/bufbuild/tree-sitter-cel",
    branch = "main",
    files = { "src/parser.c" },
    generate_requires_npm = true,
    requires_generate_from_grammar = false,
  },
}
--- func
parsers_config.func = {
  ---@type InstallInfo
  install_info = {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-func",
    files = { "src/parser.c" },
    branch = "main",
  },
}
--- go fork
-- treesitter_parsers_config.go = {
--   ---@type InstallInfo
--   install_info = {
--     url = vim.fs.joinpath(src_dir, "github.com/tree-sitter/tree-sitter-go"),
--     files = { "src/parser.c" },
--     -- branch = "format-verbs",
--     generate_requires_npm = false,
--     requires_generate_from_grammar = false,
--   },
-- }
--- goasm
-- treesitter_parsers_config.goasm = {
--   ---@type InstallInfo
--   install_info = {
--     url = vim.fs.joinpath(src_dir, "github.com/zchee/nvim-goasm"),
--     files = { "src/parser.c" },
--     branch = "main",
--     generate_requires_npm = true,
--     requires_generate_from_grammar = false,
--   },
--   -- filetype = "goasm",
--   maintainers = { "@zchee" },
-- }
--- make
parsers_config.make = {
  ---@type InstallInfo
  install_info = {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-make",
    files = { "src/parser.c" },
    branch = "main",
  },
}
--- printf
parsers_config.printf = {
  ---@type InstallInfo
  install_info = {
    url = "github.com/tree-sitter-grammars/tree-sitter-printf",
    files = { "src/parser.c" },
  },
}
-- protobuf
parsers_config.protobuf = {
  ---@class InstallInfo
  install_info = {
    url = "https://github.com/Clement-Jean/tree-sitter-proto",
    files = { "src/parser.c" },
    branch = "main",
    generate_requires_npm = true,
    requires_generate_from_grammar = false,
  },
  filetype = "proto",
  maintainers = { "@Clement-Jean" },
}

--- zsh
---@class ParserInfo
parsers_config.zsh = {
  ---@type InstallInfo
  install_info = {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-zsh",
    files = { "src/parser.c" },
    branch = "master",
    generate_requires_npm = true,
    requires_generate_from_grammar = true,
  },
}

ts_context_commentstring.setup {
  commentary_integration = {},
  enable_autocmd = true,
  config = {},
  languages = {
    "go",
  },
}
vim.g.skip_ts_context_commentstring_module = true

-- $ nvim --headless -c 'lua vim.cmd[[TSInstallInfo]]' -c 'q'
-- :'<,'>s/^[]1337;SetUserVar=in_editor^G//g
-- :'<,'>s/\(\w*\)\s*\(\[\(✓\|✗\)\]\)/  "\1",  -- \2/g
-- :'<,'>s/  \("\w*"\,  -- \[✗\] not installed\)/  -- \1
-- :'<,'>EasyAlign /-- \[✗\]/
local parsers = {
  -- "ada",                -- [✗] not installed
  -- "agda",               -- [✗] not installed
  -- "angular",            -- [✗] not installed
  -- "apex",               -- [✗] not installed
  -- "arduino",            -- [✗] not installed
  "asm", -- [✓] installed
  -- "astro",              -- [✗] not installed
  -- "authzed",            -- [✗] not installed
  "awk",    -- [✓] installed
  "bash",   -- [✓] installed
  "bass",   -- [✓] installed
  -- "beancount",          -- [✗] not installed
  "bibtex", -- [✓] installed
  -- "bicep",              -- [✗] not installed
  -- "bitbake",            -- [✗] not installed
  -- "blueprint",          -- [✗] not installed
  -- "bp",                 -- [✗] not installed
  "c", -- [✓] installed
  -- "c_sharp",            -- [✗] not installed
  -- "cairo",              -- [✗] not installed
  "capnp", -- [✓] installed
  "cel",   -- [✓] installed
  -- "chatito",            -- [✗] not installed
  -- "clojure",            -- [✗] not installed
  "cmake",   -- [✓] installed
  "comment", -- [✓] installed
  -- "commonlisp",         -- [✗] not installed
  -- "cooklang",           -- [✗] not installed
  -- "corn",               -- [✗] not installed
  -- "cpon",               -- [✗] not installed
  "cpp",  -- [✓] installed
  -- "css",                -- [✗] not installed
  "csv",  -- [✓] installed
  "cuda", -- [✓] installed
  "cue",  -- [✓] installed
  -- "d",                  -- [✗] not installed
  -- "dart",               -- [✗] not installed
  "devicetree",   -- [✓] installed
  -- "dhall",              -- [✗] not installed
  "diff",         -- [✓] installed
  "disassembly",  -- [✓] installed
  -- "djot",               -- [✗] not installed
  "dockerfile",   -- [✓] installed
  "dot",          -- [✓] installed
  "doxygen",      -- [✓] installed
  "dtd",          -- [✓] installed
  -- "earthfile",          -- [✗] not installed
  "ebnf",         -- [✓] installed
  "editorconfig", -- [✓] installed
  -- "eds",                -- [✗] not installed
  -- "eex",                -- [✗] not installed
  -- "elixir",             -- [✗] not installed
  -- "elm",                -- [✗] not installed
  -- "elsa",               -- [✗] not installed
  "elvish",            -- [✓] installed
  "embedded_template", -- [✓] installed
  -- "erlang",             -- [✗] not installed
  -- "facility",           -- [✗] not installed
  -- "faust",              -- [✗] not installed
  -- "fennel",             -- [✗] not installed
  -- "fidl",               -- [✗] not installed
  -- "firrtl",             -- [✗] not installed
  -- "fish",               -- [✗] not installed
  -- "foam",               -- [✗] not installed
  -- "forth",              -- [✗] not installed
  -- "fortran",            -- [✗] not installed
  -- "fsh",                -- [✗] not installed
  -- "fsharp",             -- [✗] not installed
  "func", -- [✓] installed
  -- "fusion",             -- [✗] not installed
  -- "gap",                -- [✗] not installed
  -- "gaptst",             -- [✗] not installed
  -- "gdscript",           -- [✗] not installed
  -- "gdshader",           -- [✗] not installed
  "git_config",    -- [✓] installed
  "git_rebase",    -- [✓] installed
  "gitattributes", -- [✓] installed
  "gitcommit",     -- [✓] installed
  "gitignore",     -- [✓] installed
  -- "gleam",              -- [✗] not installed
  "glimmer",       -- [✓] installed
  -- "glimmer_javascript", -- [✗] not installed
  -- "glimmer_typescript", -- [✗] not installed
  "glsl", -- [✓] installed
  "gn",   -- [✓] installed
  -- "gnuplot",            -- [✗] not installed
  "go",   -- [✓] installed
  -- "goctl",              -- [✗] not installed
  -- "godot_resource",     -- [✗] not installed
  "gomod",   -- [✓] installed
  "gosum",   -- [✓] installed
  "gotmpl",  -- [✓] installed
  "gowork",  -- [✓] installed
  "gpg",     -- [✓] installed
  "graphql", -- [✓] installed
  -- "gren",               -- [✗] not installed
  -- "groovy",             -- [✗] not installed
  -- "gstlaunch",          -- [✗] not installed
  -- "hack",               -- [✗] not installed
  -- "hare",               -- [✗] not installed
  -- "haskell",            -- [✗] not installed
  -- "haskell_persistent", -- [✗] not installed
  "hcl",   -- [✓] installed
  -- "heex",               -- [✗] not installed
  "helm",  -- [✓] installed
  "hjson", -- [✓] installed
  -- "hlsl",               -- [✗] not installed
  -- "hlsplaylist",        -- [✗] not installed
  -- "hocon",              -- [✗] not installed
  -- "hoon",               -- [✗] not installed
  "html",       -- [✓] installed
  "htmldjango", -- [✓] installed
  "http",       -- [✓] installed
  -- "hurl",               -- [✗] not installed
  -- "hyprlang",           -- [✗] not installed
  -- "idl",                -- [✗] not installed
  "ini",        -- [✓] installed
  -- "inko",               -- [✗] not installed
  "ispc",       -- [✓] installed
  -- "janet_simple",       -- [✗] not installed
  "java",       -- [✓] installed
  "javascript", -- [✓] installed
  "jq",         -- [✓] installed
  "jsdoc",      -- [✓] installed
  "json",       -- [✓] installed
  "json5",      -- [✓] installed
  "jsonc",      -- [✓] installed
  "jsonnet",    -- [✓] installed
  -- "julia",              -- [✗] not installed
  -- "just",               -- [✗] not installed
  "kconfig", -- [✓] installed
  -- "kdl",                -- [✗] not installed
  "kotlin",  -- [✓] installed
  -- "koto",               -- [✗] not installed
  -- "kusto",              -- [✗] not installed
  -- "lalrpop",            -- [✗] not installed
  "latex", -- [✓] installed
  -- "ledger",             -- [✗] not installed
  -- "leo",                -- [✗] not installed
  -- "linkerscript",       -- [✗] not installed
  -- "liquid",             -- [✗] not installed
  -- "liquidsoap",         -- [✗] not installed
  "llvm",            -- [✓] installed
  "lua",             -- [✓] installed
  "luadoc",          -- [✓] installed
  "luap",            -- [✓] installed
  "luau",            -- [✓] installed
  -- "m68k",               -- [✗] not installed
  "make",            -- [✓] installed
  "markdown",        -- [✓] installed
  "markdown_inline", -- [✓] installed
  "matlab",          -- [✓] installed
  -- "menhir",             -- [✗] not installed
  "mermaid",         -- [✓] installed
  "meson",           -- [✓] installed
  "mlir",            -- [✓] installed
  -- "muttrc",             -- [✗] not installed
  "nasm",            -- [✓] installed
  -- "nginx",              -- [✗] not installed
  -- "nickel",             -- [✗] not installed
  "nim",               -- [✓] installed
  "nim_format_string", -- [✓] installed
  "ninja",             -- [✓] installed
  "nix",               -- [✓] installed
  -- "norg",               -- [✗] not installed
  -- "nqc",                -- [✗] not installed
  "objc",    -- [✓] installed
  "objdump", -- [✓] installed
  -- "ocaml",              -- [✗] not installed
  -- "ocaml_interface",    -- [✗] not installed
  -- "ocamllex",           -- [✗] not installed
  -- "odin",               -- [✗] not installed
  -- "org",                -- [✗] not installed
  -- "pascal",             -- [✗] not installed
  "passwd", -- [✓] installed
  "pem",    -- [✓] installed
  "perl",   -- [✓] installed
  -- "php",                -- [✗] not installed
  -- "php_only",           -- [✗] not installed
  -- "phpdoc",             -- [✗] not installed
  "pioasm", -- [✓] installed
  -- "po",                 -- [✗] not installed
  -- "pod",                -- [✗] not installed
  -- "poe_filter",         -- [✗] not installed
  -- "pony",               -- [✗] not installed
  -- "powershell",         -- [✗] not installed
  "printf", -- [✓] installed
  -- "prisma",             -- [✗] not installed
  -- "problog",            -- [✗] not installed
  -- "prolog",             -- [✗] not installed
  "promql",     -- [✓] installed
  "properties", -- [✓] installed
  "proto",      -- [✓] installed
  -- "protobuf",           -- [✗] not installed
  -- "prql",               -- [✗] not installed
  -- "psv",                -- [✗] not installed
  "pug", -- [✓] installed
  -- "puppet",             -- [✗] not installed
  -- "purescript",         -- [✗] not installed
  "pymanifest", -- [✓] installed
  "python",     -- [✓] installed
  "ql",         -- [✓] installed
  -- "qmldir",             -- [✗] not installed
  -- "qmljs",              -- [✗] not installed
  "query", -- [✓] installed
  -- "r",                  -- [✗] not installed
  -- "racket",             -- [✗] not installed
  -- "ralph",              -- [✗] not installed
  -- "rasi",               -- [✗] not installed
  -- "rbs",                -- [✗] not installed
  "re2c",         -- [✓] installed
  "readline",     -- [✓] installed
  "regex",        -- [✓] installed
  "rego",         -- [✓] installed
  "requirements", -- [✓] installed
  -- "rescript",           -- [✗] not installed
  -- "rnoweb",             -- [✗] not installed
  -- "robot",              -- [✗] not installed
  -- "robots",             -- [✗] not installed
  -- "roc",                -- [✗] not installed
  -- "ron",                -- [✗] not installed
  "rst",  -- [✓] installed
  "ruby", -- [✓] installed
  "rust", -- [✓] installed
  -- "scala",              -- [✗] not installed
  -- "scfg",               -- [✗] not installed
  "scheme", -- [✓] installed
  -- "scss",               -- [✗] not installed
  -- "sflog",              -- [✗] not installed
  -- "slang",              -- [✗] not installed
  -- "slint",              -- [✗] not installed
  -- "smali",              -- [✗] not installed
  "smithy",   -- [✓] installed
  -- "snakemake",          -- [✗] not installed
  "solidity", -- [✓] installed
  -- "soql",               -- [✗] not installed
  -- "sosl",               -- [✗] not installed
  -- "sourcepawn",         -- [✗] not installed
  -- "sparql",             -- [✗] not installed
  "sql",        -- [✓] installed
  -- "squirrel",           -- [✗] not installed
  "ssh_config", -- [✓] installed
  "starlark",   -- [✓] installed
  "strace",     -- [✓] installed
  -- "styled",             -- [✗] not installed
  -- "supercollider",      -- [✗] not installed
  -- "superhtml",          -- [✗] not installed
  -- "surface",            -- [✗] not installed
  -- "svelte",             -- [✗] not installed
  "swift", -- [✓] installed
  -- "sxhkdrc",            -- [✗] not installed
  -- "systemtap",          -- [✗] not installed
  -- "t32",                -- [✗] not installed
  "tablegen", -- [✓] installed
  -- "tact",               -- [✗] not installed
  -- "tcl",                -- [✗] not installed
  "teal",      -- [✓] installed
  "templ",     -- [✓] installed
  "terraform", -- [✓] installed
  "textproto", -- [✓] installed
  "thrift",    -- [✓] installed
  -- "tiger",              -- [✗] not installed
  -- "tlaplus",            -- [✗] not installed
  "tmux",    -- [✓] installed
  "todotxt", -- [✓] installed
  "toml",    -- [✓] installed
  "tsv",     -- [✓] installed
  "tsx",     -- [✓] installed
  -- "turtle",             -- [✗] not installed
  -- "twig",               -- [✗] not installed
  "typescript", -- [✓] installed
  -- "typespec",           -- [✗] not installed
  -- "typoscript",         -- [✗] not installed
  -- "typst",              -- [✗] not installed
  -- "udev",               -- [✗] not installed
  -- "ungrammar",          -- [✗] not installed
  -- "unison",             -- [✗] not installed
  -- "usd",                -- [✗] not installed
  -- "uxntal",             -- [✗] not installed
  -- "v",                  -- [✗] not installed
  "vala", -- [✓] installed
  -- "vento",              -- [✗] not installed
  -- "verilog",            -- [✗] not installed
  -- "vhdl",               -- [✗] not installed
  "vhs",    -- [✓] installed
  "vim",    -- [✓] installed
  "vimdoc", -- [✓] installed
  -- "vrl",                -- [✗] not installed
  -- "vue",                -- [✗] not installed
  -- "wgsl",               -- [✗] not installed
  -- "wgsl_bevy",          -- [✗] not installed
  -- "wing",               -- [✗] not installed
  -- "wit",                -- [✗] not installed
  -- "xcompose",           -- [✗] not installed
  "xml",  -- [✓] installed
  -- "xresources",         -- [✗] not installed
  "yaml", -- [✓] installed
  -- "yang",               -- [✗] not installed
  -- "yuck",               -- [✗] not installed
  -- "zathurarc",          -- [✗] not installed
  "zig", -- [✓] installed
  -- "ziggy",              -- [✗] not installed
  -- "ziggy_schema",       -- [✗] not installed
  -- "zsh", -- [✓] installed
}

---------- old? config ----------

vim.opt.runtimepath:append(vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "tree-sitter"))
vim.opt.runtimepath:append(vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "tree-sitter"), "parser")

--- @diagnostic disable-next-line: missing-fields
ts_config.setup({
  parser_install_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "tree-sitter"),
  ensure_installed = parsers,
  highlight = {
    enable = true,
    disable = {
      "tmux",
      "git_config",
      -- "diff",
      -- "make",
      -- "vim",
    },
    -- additional_vim_regex_highlighting = false,
    additional_vim_regex_highlighting = {
      -- "gitconfig",
      -- "diff",
      -- "gitcommit",
      -- "make",
      -- "toml",
    },
    set_custom_captures = {},
  },
  indent = {
    enable = true,
    disable = {
      -- "go",
      -- "gomod",
      "json",
      -- "python",
      "yaml",
    },
  },
  incremental_selection = {
    enable = true,
    disable = {
      "go",
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
  pairs = {
    enable = true,
    disable = {},
    highlight_pair_events = {},                                   -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
    highlight_self = false,                                       -- whether to highlight also the part of the pair under cursor (or only the partner)
    goto_right_end = false,                                       -- whether to go to the end of the right partner or the beginning
    fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
    keymaps = {
      goto_partner = "<leader>%",
      delete_balanced = "X",
    },
    delete_balanced = {
      only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
      fallback_cmd_normal = nil,  -- fallback command when no pair found, can be nil
      longest_partner = false,    -- whether to delete the longest or the shortest pair when multiple found.
      -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
    }
  },
  -- matchup = {
  --   enable = true,
  --   disable = {},
  --   disable_virtual_text = {},
  --   -- include_match_wor = { "/* */" },
  --   -- additional_vim_regex_highlighting = {
  --   --   "go",
  --   -- },
  -- },
})
