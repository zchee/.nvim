-- Returned as `opts` for stevearc/conform.nvim in lua/plugins/init.lua.
-- Successor of the none-ls formatting sources; manual formatting stays on
-- the <BS>f keymap in lua/lsp/init.lua, and filetypes without an entry
-- fall back to LSP formatting at the call site.
local util = require("util")

-- Cache of go.mod module paths keyed by go.mod path, invalidated on mtime
-- change, so write-time -project-name resolution stays off the disk for
-- unchanged modules.
local gomod_modules = {}

---@param dirname string
---@return string?
local function go_module_path(dirname)
  local gomod = vim.fs.find("go.mod", { upward = true, path = dirname, type = "file" })[1]
  if not gomod then
    return nil
  end
  local stat = vim.uv.fs_stat(gomod)
  local mtime = stat and stat.mtime.sec or -1
  local cached = gomod_modules[gomod]
  if not cached or cached.mtime ~= mtime then
    cached = { mtime = mtime }
    local f = io.open(gomod, "r")
    if f then
      for line in f:lines() do
        cached.module = line:match('^%s*module%s+"?([^%s"]+)')
        if cached.module then
          break
        end
      end
      f:close()
    end
    gomod_modules[gomod] = cached
  end
  return cached.module
end

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
      -- -project-name pins project-import grouping to the buffer's nearest
      -- go.mod; omitted when none is found (module-less scratch files), in
      -- which case the binary falls back to its own detection.
      args = function(_, ctx)
        local args = { "-use-cache=true", "-cache-fast-skip=true", "-rm-unused", "-set-alias", "-format" }
        local module = go_module_path(ctx.dirname)
        if module then
          table.insert(args, "-project-name=" .. module)
        end
        table.insert(args, "$FILENAME")
        return args
      end,
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
          local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(tostring(vim.uv.os_homedir()), ".config")
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
