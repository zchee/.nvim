-- Returned as `opts` for stevearc/conform.nvim in lua/plugins/init.lua.
-- Successor of the none-ls formatting sources; manual formatting stays on
-- the <BS>f keymap in lua/lsp/init.lua, and filetypes without an entry
-- fall back to LSP formatting at the call site.
local util = require("util")

return {
  -- restored from the pre-migration conform draft; set
  -- vim.b.disable_autoformat (buffer) or vim.g.disable_autoformat (global)
  -- to opt out
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
      return
    end
    -- Per-filetype toggle: set an entry to true to skip write-time
    -- formatting for that filetype and keep only the manual <BS>f path
    -- (e.g. when goimports-rereviser's import rewriting or stylua feel too
    -- intrusive per write). Everything currently formats on save.
    local manual_only = {
      go = false,
      lua = false,
    }
    if manual_only[vim.bo[bufnr].filetype] then
      return
    end
    return {
      lsp_format = "fallback",
      timeout_ms = 500,
    }
  end,
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
    tombi = {
      command = util.homebrew_binary("tombi", "tombi"),
      -- In stdin mode tombi resolves its config from the CWD (verified: not
      -- from --stdin-filename), and it has no --config flag, so pyproject
      -- buffers run with cwd pointed at a directory whose tombi.toml sets
      -- indent-width = 4 (ported from taplo's pyproject on_attach override).
      -- The real --stdin-filename is kept, so schema detection is unchanged.
      -- Caveat: a project's own [tool.tombi]/tombi.toml is bypassed for
      -- pyproject.toml files.
      cwd = function(_, ctx)
        if vim.fs.basename(ctx.filename) == "pyproject.toml" then
          local config_home = vim.env.XDG_CONFIG_HOME
            or vim.fs.joinpath(tostring(vim.uv.os_homedir()), ".config")
          return vim.fs.joinpath(config_home, "tombi", "pyproject")
        end
      end,
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
    -- taplo's LSP formatting retired with the server; tombi LSP keeps
    -- formatting.enabled = false, so the CLI here is the single toml
    -- formatter (per-project pyproject indent via [tool.tombi])
    toml = { "tombi" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    yaml = { "yamlfmt" },
  },
}
