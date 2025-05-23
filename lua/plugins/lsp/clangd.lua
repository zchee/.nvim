--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = {
    -- clangd version 18.0.0 (https://github.com/llvm/llvm-project 4b5366c9512aa273a5272af1d833961e1ed156e7)
    -- Features: mac+grpc+xpc
    -- Platform: x86_64-apple-darwin23.2.0
    "/opt/llvm/clangd/bin/clangd",
    "--query-driver=/usr/bin/**",
    "--all-scopes-completion",
    "--background-index",
    "--background-index-priority=normal",
    "--clang-tidy",
    "--completion-parse=auto",
    "--completion-style=detailed",
    "--experimental-modules-support",
    "--function-arg-placeholders=1",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--import-insertions",
    "--include-ineligible-results",
    "--limit-references=0",
    "--limit-results=0",
    "--ranking-model=heuristics",
    "--rename-file-limit=1000",
    "--enable-config",
    "-j=32",
    "--parse-forwarding-functions",
    "--pch-storage=memory",
    "--use-dirty-headers",
    "--input-style=standard",
    "--offset-encoding=utf-16",
    "--hidden-features",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  offsetEncoding = { 'utf-16' },

  -- on_new_config = function(new_config, _)
  --   local cwd = vim.fn.getcwd()
  --   new_config.init_options = {
  --     compilationDatabasePath = cwd,
  --   }
  --
  --   -- if string.find(cwd, "google/EXEgesis") then
  --   --   new_config.cmd = vim.tbl_flatten({ new_config.cmd, "--header-insertion=never", "--compile-commands-dir="..cwd })
  --   -- end
  --   -- print(vim.inspect(new_config.init_options))
  -- end
}

-- OVERVIEW: clangd is a language server that provides IDE-like features to editors.
--
-- It should be used via an editor plugin rather than invoked directly. For more information, see:
-- 	https://clangd.llvm.org/
-- 	https://microsoft.github.io/language-server-protocol/
--
-- clangd accepts flags on the commandline, and in the CLANGD_FLAGS environment variable.
--
-- USAGE: clangd [options]
--
-- OPTIONS:
--
-- Generic Options:
--
--   -h                                  - Alias for --help
--   --help                              - Display available options (--help-hidden for more)
--   --help-hidden                       - Display all available options
--   --help-list                         - Display list of available options (--help-list-hidden for more)
--   --help-list-hidden                  - Display list of all available options
--   --print-all-options                 - Print all option values after command line parsing
--   --print-options                     - Print non-default options after command line parsing
--   --version                           - Display the version of this program
--
-- clangd compilation flags options:
--
--   --compile-commands-dir=<string>     - Specify a path to look for compile_commands.json. If path is invalid, clangd will look in the current directory and parent paths of each source file
--   --compile_args_from=<value>         - The source of compile commands
--     =lsp                              -   All compile commands come from LSP and 'compile_commands.json' files are ignored
--     =filesystem                       -   All compile commands come from the 'compile_commands.json' files
--   --query-driver=<string>             - Comma separated list of globs for white-listing gcc-compatible drivers that are safe to execute. Drivers matching any of these globs will be used to extract system includes. e.g. /usr/bin/**/clang-*,/path/to/repo/**/g++-*
--   --resource-dir=<string>             - Directory for system clang headers
--
-- clangd feature options:
--
--   --all-scopes-completion             - If set to true, code completion will include index symbols that are not defined in the scopes (e.g. namespaces) visible from the code completion point. Such completions can insert scope qualifiers
--   --background-index                  - Index project code in the background and persist index on disk.
--   --background-index-priority=<value> - Thread priority for building the background index. The effect of this flag is OS-specific.
--     =background                       -   Minimum priority, runs on idle CPUs. May leave 'performance' cores unused.
--     =low                              -   Reduced priority compared to interactive work.
--     =normal                           -   Same priority as other clangd work.
--   --clang-tidy                        - Enable clang-tidy diagnostics
--   --completion-parse=<value>          - Whether the clang-parser is used for code-completion
--     =always                           -   Block until the parser can be used
--     =auto                             -   Use text-based completion if the parser is not ready
--     =never                            -   Always used text-based completion
--   --completion-style=<value>          - Granularity of code completion suggestions
--     =detailed                         -   One completion item for each semantically distinct completion, with full type information
--     =bundled                          -   Similar completion items (e.g. function overloads) are combined. Type information shown where possible
--   --debug-origin                      - Show origins of completion items
--   --experimental-modules-support      - Experimental support for standard c++ modules
--   --fallback-style=<string>           - clang-format style to apply by default when no .clang-format file is found
--   --function-arg-placeholders=<int>   - When disabled (0), completions contain only parentheses for function calls. When enabled (1), completions also contain placeholders for method parameters
--   --header-insertion=<value>          - Add #include directives when accepting code completions
--     =iwyu                             -   Include what you use. Insert the owning header for top-level symbols, unless the header is already directly included or the symbol is forward-declared
--     =never                            -   Never insert #include directives as part of code completion
--   --header-insertion-decorators       - Prepend a circular dot or space before the completion label, depending on whether an include line will be inserted or not
--   --hidden-features                   - Enable hidden features mostly useful to clangd developers
--   --import-insertions                 - If header insertion is enabled, add #import directives when accepting code completions or fixing includes in Objective-C code
--   --include-ineligible-results        - Include ineligible completion results (e.g. private members)
--   --limit-references=<int>            - Limit the number of references returned by clangd. 0 means no limit (default=1000)
--   --limit-results=<int>               - Limit the number of results returned by clangd. 0 means no limit (default=100)
--   --project-root=<string>             - Path to the project root. Requires remote-index-address to be set.
--   --ranking-model=<value>             - Model to use to rank code-completion items
--     =heuristics                       -   Use heuristics to rank code completion items
--     =decision_forest                  -   Use Decision Forest model to rank completion items
--   --remote-index-address=<string>     - Address of the remote index server
--   --rename-file-limit=<int>           - Limit the number of files to be affected by symbol renaming. 0 means no limit (default=50)
--   --tweaks=<string>                   - Specify a list of Tweaks to enable (only for clangd developers).
--
-- clangd flags no longer in use:
--
--   --async-preamble                    - Obsolete flag, ignored
--   --clang-tidy-checks=<string>        - Obsolete flag, ignored
--   --collect-main-file-refs            - Obsolete flag, ignored
--   --cross-file-rename                 - Obsolete flag, ignored
--   --folding-ranges                    - Obsolete flag, ignored
--   --include-cleaner-stdlib            - Obsolete flag, ignored
--   --index                             - Obsolete flag, ignored
--   --inlay-hints                       - Obsolete flag, ignored
--   --recovery-ast                      - Obsolete flag, ignored
--   --recovery-ast-type                 - Obsolete flag, ignored
--   --suggest-missing-includes          - Obsolete flag, ignored
--
-- clangd miscellaneous options:
--
--   --check[=<string>]                    - Parse one file in isolation instead of acting as a language server. Useful to investigate/reproduce crashes or configuration problems. With --check=<filename>, attempts to parse a particular file.
--   --crash-pragmas                     - Respect `#pragma clang __debug crash` and friends.
--   --enable-config                     - Read user and project configuration from YAML files.
--                                         Project config is from a .clangd file in the project directory.
--                                         User config is from clangd/config.yaml in the following directories:
--                                         	Windows: %USERPROFILE%\AppData\Local
--                                         	Mac OS: ~/Library/Preferences/
--                                         	Others: $XDG_CONFIG_HOME, usually ~/.config
--                                         Configuration is documented at https://clangd.llvm.org/config.html
--   --index-file=<string>               - Index file to build the static index. The file must have been created by a compatible clangd-indexer
--                                         WARNING: This option is experimental only, and will be removed eventually. Don't rely on it
--   -j <uint>                           - Number of async workers used by clangd. Background index also uses this many workers.
--   --lit-test                          - Abbreviation for -input-style=delimited -pretty -sync -enable-test-scheme -enable-config=0 -log=verbose -crash-pragmas. Also sets config options: Index.StandardLibrary=false. Intended to simplify lit tests
--   --parse-forwarding-functions        - Parse all emplace-like functions in included headers
--   --pch-storage=<value>               - Storing PCHs in memory increases memory usages, but may improve performance
--     =disk                             -   store PCHs on disk
--     =memory                           -   store PCHs in memory
--   --sync                              - Handle client requests on main thread. Background index still uses its own thread.
--   --use-dirty-headers                 - Use files open in the editor when parsing headers instead of reading from the disk
--
-- clangd protocol and logging options:
--
--   --enable-test-uri-scheme            - Enable 'test:' URI scheme. Only use in lit tests
--   --input-mirror-file=<string>        - Mirror all LSP input to the specified file. Useful for debugging
--   --input-style=<value>               - Input JSON stream encoding
--     =standard                         -   usual LSP protocol
--     =delimited                        -   messages delimited by --- lines, with # comment support
--   --log=<value>                       - Verbosity of log messages written to stderr
--     =error                            -   Error messages only
--     =info                             -   High level execution tracing
--     =verbose                          -   Low level details
--   --offset-encoding=<value>           - Force the offsetEncoding used for character positions. This bypasses negotiation via client capabilities
--     =utf-8                            -   Offsets are in UTF-8 bytes
--     =utf-16                           -   Offsets are in UTF-16 code units
--     =utf-32                           -   Offsets are in unicode codepoints
--   --path-mappings=<string>            - Translates between client paths (as seen by a remote editor) and server paths (where clangd sees files on disk). Comma separated list of '<client_path>=<server_path>' pairs, the first entry matching a given path is used. e.g. /home/project/incl=/opt/include,/home/project=/workarea/project
--   --pretty                            - Pretty-print JSON output
