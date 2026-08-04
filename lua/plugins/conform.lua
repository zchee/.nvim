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

-- LSP round-trip budget for the organize-imports formatter below. It shares
-- conform's per-format timeout with the CLI formatters that follow it, so it
-- stays well under the Go entry in format_timeout_ms.
local organize_imports_timeout_ms = 1000

-- Per-filetype override of conform's format timeout. Go needs more than the
-- default because its chain is an LSP organize-imports round-trip plus
-- goimports-rereviser, and conform charges the elapsed time of each formatter
-- against the budget left for the next one.
local format_timeout_ms = {
  go = 3000,
}

---Collect the TextEdits a source.organizeImports code action produces for one
---buffer, resolving the action first when the server answered with `data`
---instead of an inline `edit` (both shapes are legal).
---@param bufnr integer
---@return lsp.TextEdit[] edits
---@return string offset_encoding
local function organize_imports_edits(bufnr)
  local uri = vim.uri_from_bufnr(bufnr)
  ---@type lsp.CodeActionParams
  local params = {
    textDocument = { uri = uri },
    -- source.* actions apply to the whole file, so an empty range is the
    -- conventional request shape -- and it avoids the current-window coupling
    -- that the retired LspCodeActionFormat autocmd had.
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = 0, character = 0 },
    },
    context = {
      diagnostics = {},
      only = { "source.organizeImports" },
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
    },
  }

  local edits = {}
  local offset_encoding = "utf-16"
  local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, organize_imports_timeout_ms)
  for client_id, response in pairs(responses or {}) do
    local client = vim.lsp.get_client_by_id(client_id)
    if client then
      offset_encoding = client.offset_encoding or offset_encoding
    end
    for _, action in pairs(response.result or {}) do
      local edit = action.edit
      if not edit and action.data and client then
        local resolved = client:request_sync("codeAction/resolve", action, organize_imports_timeout_ms, bufnr)
        edit = resolved and resolved.result and resolved.result.edit
      end
      if edit then
        for _, change in ipairs(edit.documentChanges or {}) do
          if change.textDocument and change.textDocument.uri == uri then
            vim.list_extend(edits, change.edits or {})
          end
        end
        vim.list_extend(edits, (edit.changes or {})[uri] or {})
      end
    end
  end
  return edits, offset_encoding
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
      objc = true,
      go = false,
      lua = false,
    }
    if manual_only[vim.bo[bufnr].filetype] then
      return
    end
    return {
      lsp_format = "fallback",
      timeout_ms = format_timeout_ms[vim.bo[bufnr].filetype] or 500,
    }
  end,
  formatters = {
    -- Runs the server's source.organizeImports as a formatter, restoring the
    -- one thing the retired LspCodeActionFormat autocmd did that no CLI here
    -- replaces: adding imports for unresolved identifiers (verified that
    -- goimports-rereviser only revises imports that already exist).
    lsp_organize_imports = {
      format = function(_, ctx, lines, callback)
        -- conform chains formatters purely in memory (runner.format_lines_sync
        -- reads the buffer once, up front) while the server's edit positions
        -- are relative to the buffer. The two agree only while this is the
        -- first formatter in the chain, so bail out rather than corrupt the
        -- text if a later edit reorders formatters_by_ft.
        if not vim.deep_equal(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false), lines) then
          return callback(nil, lines)
        end

        local ok, edits, offset_encoding = pcall(organize_imports_edits, ctx.buf)
        if not ok then
          return callback(tostring(edits))
        end
        if vim.tbl_isempty(edits) then
          return callback(nil, lines)
        end

        -- Apply to a scratch buffer: editing ctx.buf here would both race
        -- conform's own diff (computed against the pre-format lines) and leave
        -- an extra undo entry behind.
        local scratch = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(scratch, 0, -1, false, lines)
        local applied = pcall(vim.lsp.util.apply_text_edits, edits, scratch, offset_encoding)
        local out = applied and vim.api.nvim_buf_get_lines(scratch, 0, -1, false) or lines
        vim.api.nvim_buf_delete(scratch, { force = true })
        callback(nil, out)
      end,
    },
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
      -- from --stdin-filename), and it has no --config flag, so pyproject and
      -- Cargo.toml buffers run with cwd pointed at directories whose
      -- tombi.toml is a full copy of the main config with indent-width = 4
      -- (pyproject: ported from taplo's on_attach override; Cargo: keeps the
      -- hand-written 4-space array style, e.g. ganja-code).
      -- The real --stdin-filename is kept, so schema detection is unchanged.
      -- Caveat: a project's own [tool.tombi]/tombi.toml is bypassed for
      -- these two basenames.
      cwd = function(_, ctx)
        local routed = {
          ["pyproject.toml"] = "pyproject",
          ["Cargo.toml"] = "cargo",
        }
        local dir = routed[vim.fs.basename(ctx.filename)]
        if dir then
          local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(tostring(vim.uv.os_homedir()), ".config")
          return vim.fs.joinpath(config_home, "tombi", dir)
        end
      end,
    },
  },
  formatters_by_ft = {
    go = { "lsp_organize_imports", "goimports_rereviser", lsp_format = "first" },
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
