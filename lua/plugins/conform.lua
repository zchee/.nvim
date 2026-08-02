-- Returned as `opts` for stevearc/conform.nvim in lua/plugins/init.lua.
-- Successor of the none-ls formatting sources. Formatting stays manual via
-- the <BS>f keymap in lua/lsp/init.lua (none-ls had no format-on-save);
-- filetypes without an entry fall back to LSP formatting at the call site.
local util = require("util")

return {
  formatters = {
    goimports_rereviser = {
      meta = {
        url = "https://github.com/zchee/goimports-rereviser",
        description = "Right imports sorting & code formatting tool (reviser of goimports-reviser)",
      },
      command = util.go_path("bin", "goimports-rereviser"),
      args = { "-use-cache=true", "-cache-fast-skip=true", "-rm-unused", "-set-alias", "-format", "$FILENAME" },
      stdin = false,
    },
    stylua = {
      command = util.homebrew_binary("stylua", "stylua"),
    },
  },
  formatters_by_ft = {
    go = { "goimports_rereviser", lsp_format = "first" },
    goasm = { "asmfmt", lsp_format = "first" },
    lua = { "stylua", lsp_format = "never" },
    python = { "ruff_format", "ruff_fix" },
    rust = { "rustfmt" },
    zig = { "zigfmt" },
    terraform = { "terraform_fmt" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    yaml = { "yamlfmt" },
  },
}
