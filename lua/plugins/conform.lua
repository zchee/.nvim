-- Returned as `opts` for stevearc/conform.nvim in lua/plugins/init.lua.
-- Successor of the none-ls formatting sources; manual formatting stays on
-- the <LocalLeader>f keymap in lua/lsp/init.lua, and filetypes without an
-- entry fall back to LSP formatting at the call site.
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

---Where to run taplo, and whether to point it at the personal config.
---
---taplo owns TOML formatting because its `[[rule]]` blocks scope options per
---file; tombi's format rules are global only, so the same per-file behaviour
---previously needed a full tombi config copy per file type under
---~/.config/tombi plus a cwd-routing function here. tombi keeps the LSP side
---(diagnostics + schema store) with its own formatting disabled, so the two
---do not collide.
---
---Everything hinges on one measured fact: taplo resolves BOTH its config
---discovery and its `[[rule]]` include globs against the process CWD, not
---against --stdin-filepath and not against the config file's own location.
---So a project's config is honoured by running taplo from the directory that
---holds it -- which is also what makes a relative include like
---`include = ["sub/*.toml"]` match, exactly as it would for someone running
---taplo by hand at their project root. Running from the buffer's directory
---instead finds the config but silently drops those rules, and passing
-----config while sitting elsewhere drops them too.
---@param dirname string
---@return string? cwd
---@return string[] args
local function taplo_invocation(dirname)
  local project = vim.fs.find({ ".taplo.toml", "taplo.toml" }, { upward = true, path = dirname, type = "file" })[1]
  if project then
    return vim.fs.dirname(project), {}
  end
  -- No project config: point at the personal one explicitly, since taplo would
  -- otherwise find nothing and fall back to its defaults (column_width = 80,
  -- array_auto_expand = true). Its globs are absolute for the same CWD reason.
  local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(tostring(vim.uv.os_homedir()), ".config")
  return nil, { "--config", vim.fs.joinpath(config_home, "taplo", "taplo.toml") }
end

-- oxfmt owns filetype json5 because vscode-json-language-server cannot: it has
-- no JSON5 mode, and the LSP fallback below used to hand it these buffers and
-- get a mangled file back -- measured on ganja-code's .github/renovate.json5,
-- 41 diagnostics and a space injected inside 'https://...', because a single
-- quoted string is not a string to it. oxfmt parses JSON5 for real.

---Config files oxfmt reads for a project, in the order conform's own builtin
---looks for them. The vite entries that builtin also lists are left out: a
---vite config's presence says nothing about oxfmt formatting rules here.
local oxfmt_config_names = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }

---Extensions oxfmt infers a JSON dialect from. Anything else -- `.renovaterc`
---has no extension at all -- makes it exit 1 with "Unsupported file type for
---stdin-filepath".
local oxfmt_json_extensions = { json = true, json5 = true, jsonc = true }

---A config path is always passed explicitly rather than left to oxfmt's own
---upward search, because the search starts from the process CWD and a miss is
---silent: oxfmt falls back to defaults, and the default rewrites every
---single-quoted string to double quotes -- 30 lines of that same
---renovate.json5 on its first write. Note oxfmt does not validate the file, so
---a typo'd key is accepted with exit 0 and lands you back on the defaults.
---@param dirname string
---@return string config path
local function oxfmt_config(dirname)
  local project = vim.fs.find(oxfmt_config_names, { upward = true, path = dirname, type = "file" })[1]
  if project then
    return project
  end
  local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(tostring(vim.uv.os_homedir()), ".config")
  return vim.fs.joinpath(config_home, "oxfmt", ".oxfmtrc.jsonc")
end

---oxfmt picks its parser from the name handed to --stdin-filepath and nothing
---else -- there is no --parser flag to override it with. filetype.lua maps one
---extensionless file to json5 (`.renovaterc`), so name it something oxfmt can
---read. The suffix only ever travels on the command line; the buffer keeps its
---own name, and json5 is the right dialect for every file that reaches here.
---@param filename string
---@return string
local function oxfmt_stdin_path(filename)
  if oxfmt_json_extensions[vim.fn.fnamemodify(filename, ":e"):lower()] then
    return filename
  end
  return filename .. ".json5"
end

---@class conform.setupOpts
return {
  formatters_by_ft = {
    c = { "clang_format" },
    go = { "lsp_organize_imports", "goimports_rereviser", lsp_format = "first" },
    goasm = { "asmfmt", lsp_format = "first" },
    -- lsp_format = "never" is load-bearing, not decoration: format_on_save
    -- below returns lsp_format = "fallback", and conform reads that as "use the
    -- LSP when no formatter here is available". Drop this and an oxfmt that
    -- fails to resolve silently restores the mangling it was added to stop.
    json5 = { "oxfmt", lsp_format = "never" },
    lua = { "stylua", lsp_format = "never" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format", "ruff_fix", "ruff_organize_imports" }
      end
      return {}
    end,
    -- python = { "ruff_format", "ruff_fix" },
    rust = { "rustfmt" },
    zig = { "zigfmt" },
    terraform = { "terraform_fmt" },
    -- tombi LSP keeps formatting.enabled = false and only serves diagnostics
    -- and schemas, so the taplo CLI here is the single toml formatter
    toml = { "taplo" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    yaml = { "yamlfmt" },
  },
  -- restored from the pre-migration conform draft; set
  -- vim.b.disable_autoformat (buffer) or vim.g.disable_autoformat (global)
  -- to opt out
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
      return
    end
    -- Per-filetype toggle: set an entry to true to skip write-time
    -- formatting for that filetype and keep only the manual <LocalLeader>f path
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
    -- conform fills in a formatters_by_ft entry's own lsp_format only for the
    -- keys the caller leaves nil, and this function supplies one -- so a
    -- pinned "never" is silently discarded unless it is read back here.
    -- Only "never" is honoured, because it can only ever stop the server from
    -- formatting: json5 needs exactly that (jsonls has no JSON5 mode and
    -- rewrites the file as strict JSON, injecting a space inside
    -- 'https://...'), and every other filetype keeps the fallback it has now.
    local ft_opts = require("conform").formatters_by_ft[vim.bo[bufnr].filetype]
    local pinned = type(ft_opts) == "table" and ft_opts.lsp_format or nil
    return {
      lsp_format = pinned == "never" and "never" or "fallback",
      timeout_ms = format_timeout_ms[vim.bo[bufnr].filetype] or 500,
    }
  end,
  formatters = {
    clang_format = {
      -- -style=file:<path> does not fall back the way a bare -style=file does:
      -- given a path it cannot read, clang-format exits 1 with empty stdout
      -- (measured), so conform reports a failed format instead of formatting.
      -- Passing no -style at all leaves it searching upward for .clang-format
      -- on its own, which is the better answer whenever this file is absent --
      -- another machine, or a checkout without the dotfiles tree.
      prepend_args = function()
        local path = vim.fs.joinpath(util.xdg_config_home(), "llvm/.clang-format")
        return vim.uv.fs_stat(path) and { "-style=file:" .. path } or {}
      end,
    },
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
    oxfmt = {
      command = util.bun_prefix("oxfmt"),
      -- conform's builtin passes only `--stdin-filepath $FILENAME`; both args
      -- are rebuilt so the config is explicit and the name is one oxfmt can
      -- infer a parser from. Its builtin `cwd` (root_file over the same config
      -- names) is left in place -- harmless, since --config already decided.
      args = function(_, ctx)
        return {
          "--config",
          oxfmt_config(ctx.dirname),
          "--stdin-filepath",
          oxfmt_stdin_path(ctx.filename),
        }
      end,
    },
    stylua = {
      command = util.homebrew_binary("stylua", "stylua"),
    },
    taplo = {
      command = util.homebrew_binary("taplo", "taplo"),
      -- --config has to sit after the subcommand, so the whole arg list is
      -- rebuilt rather than prepended to conform's builtin.
      --
      -- ~/.config/taplo/taplo.toml carries the per-file rules that used to be
      -- separate tombi config copies: pyproject.toml and Cargo.toml keep
      -- 4-space indent, everything else 2. The codex copy is gone because
      -- taplo never inserts a blank line between a table and its nested
      -- table, which is the only reason that copy existed.
      --
      -- Caveat: taplo is TOML v1.0 only. A file using v1.1 syntax (multi-line
      -- inline tables -- ~/.config/tombi/config.toml itself does) fails with a
      -- non-zero exit and empty stdout, so conform reports the error and
      -- leaves the buffer alone rather than truncating it (verified).
      args = function(_, ctx)
        local _, config_args = taplo_invocation(ctx.dirname)
        local args = { "format" }
        vim.list_extend(args, config_args)
        vim.list_extend(args, { "--stdin-filepath", "$FILENAME", "-" })
        return args
      end,
      cwd = function(_, ctx)
        return (taplo_invocation(ctx.dirname))
      end,
    },
  },
}
