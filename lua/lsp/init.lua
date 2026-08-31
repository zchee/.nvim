-- local util = require("util")

-- Work around a Neovim 0.13-dev regression in the semantic-tokens capability.
--
-- STHighlighter registers a buffer-wide `LspNotify` autocmd (keyed by buffer,
-- not by client), so `didOpen`/`didChange` from *any* attached client invokes
-- `STHighlighter:send_request(client_id)`. That method calls
-- `self:reset_timer(client_id)` *before* it guards `client and state`, and
-- `reset_timer` dereferences `state.timer` unconditionally. For a client whose
-- per-client `state` was never created -- i.e. one that does not advertise
-- `textDocument/semanticTokens`, or whose `on_attach` has not run yet -- `state`
-- is nil and the autocmd throws:
--   semantic_tokens.lua: attempt to index local 'state' (a nil value)
-- This fires on Go buffers as soon as a second (non-semantic-token) client
-- touches the buffer. Patch the shared STHighlighter metatable (intentionally
-- exposed as `__STHighlighter`) to early-return when no state exists, mirroring
-- the guard `send_request` already applies a few lines later. Once upstream
-- ships the fix the guard is a harmless no-op (state is non-nil). Wrapped in a
-- pcall and existence checks so config loading never breaks if a future Neovim
-- removes the escape hatch or renames the method.
pcall(function()
  local st = require("vim.lsp.semantic_tokens")
  local STHighlighter = st.__STHighlighter
  if not STHighlighter or type(STHighlighter.reset_timer) ~= "function" then
    return
  end
  if STHighlighter.__reset_timer_state_guard then
    return
  end
  STHighlighter.__reset_timer_state_guard = true

  local orig_reset_timer = STHighlighter.reset_timer
  function STHighlighter:reset_timer(client_id)
    if not self.client_state[client_id] then
      return
    end
    return orig_reset_timer(self, client_id)
  end
end)

vim.lsp.log.set_level(vim.log.levels.OFF) -- "OFF", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  signs = true,
  float = nil,
  -- false: redrawing diagnostics on every insert keystroke costs a redraw per
  -- key and the messages churn while typing anyway.
  update_in_insert = false,
  severity_sort = true,
  jump = nil,
})

-- hover.nvim, nvim-lsp-endhints, tiny-inline-diagnostic and actions-preview
-- are configured in their own `config` blocks (lua/plugins/init.lua, loading
-- lua/plugins/{hover,lsp_endhints,tiny_inline_diagnostic,actions_preview}.lua)
-- so their `event = "LspAttach"` triggers stay real: a require here would load
-- them the moment the LSP stack initializes.

local lspkind = require("lspkind")
lspkind.init({
  mode = "symbol_text",
  preset = "codicons",
})

-- lspconfig.util.default_config = vim.tbl_extend(
--   "force",
--   lspconfig.util.default_config,
--   {
--     handlers = {
--       ["textDocument/inlayHint"] = function(err, result, ctx)
--         local client = vim.lsp.get_client_by_id(ctx.client_id)
--         if client then
--           local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
--           result = vim.iter(result):filter(function(hint)
--             return hint.position.line + 1 == row
--           end):totable()
--         end
--         vim.lsp.handlers["textDocument/inlayHint"](err, result, ctx)
--       end
--       -- ["textDocument/references"] = function(err, method, params, client_id)
--       -- end,
--       -- ["window/logMessage"] = function(err, method, params, client_id)
--       --   if params and params.type <= vim.lsp.protocol.MessageType.Log then
--       --     vim.lsp.handlers["window/logMessage"](err, method, params, client_id)
--       --   end
--       -- end,
--       -- ["window/showMessage"] = function(err, method, params, client_id)
--       --   if params and params.type <= vim.lsp.protocol.MessageType.Error then
--       --     vim.lsp.handlers["window/showMessage"](err, method, params, client_id)
--       --   end
--       -- end,
--     }
--   }
-- )

-- handlers
-- vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx)
--   local client = vim.lsp.get_client_by_id(ctx.client_id)
--   if client then
--     local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
--     result = vim.iter(result):filter(function(hint)
--       return hint.position.line + 1 == row
--     end):totable()
--   end
--   vim.lsp.handlers["textDocument/inlayHint"](err, result, ctx)
-- end

local protocol = require("lsp.protocol")

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#clientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentClientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
local default_capabilities_config = function()
  ---@type lsp.ClientCapabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- merge blink.cmp client capabilities via the static snapshot module: a
  -- require("blink.cmp") here would load blink at LSP-init time and defeat its
  -- InsertEnter trigger. tests/lsp_capabilities_snapshot_spec.lua pins the
  -- snapshot against blink's live output.
  capabilities = vim.tbl_deep_extend("force", capabilities, require("lsp.capabilities"))

  -- Neovim already advertises workspace.didChangeWatchedFiles with both
  -- dynamicRegistration and relativePatternSupport, and the blink.cmp merge
  -- above leaves them alone -- read back from the resolved markdown_oxide
  -- client, the one server here whose upstream docs demand dynamic
  -- registration (it watches the vault, and its create-unresolved-file code
  -- action depends on the watcher). Nothing left to force.

  ---@type lsp.ClientCapabilities
  local capabilities_override = {
    general = {
      positionEncodings = { "utf-16" },
    },
    textDocument = {
      completion = {
        completionItem = {
          commitCharactersSupport = true,
          preselectSupport = true,
          documentationFormat = { protocol.constants.MarkupKind.Markdown },
        },
      },
    },
  }

  capabilities = vim.tbl_deep_extend("force", capabilities, capabilities_override)

  return capabilities
end

--- @param client vim.lsp.Client
--- @param bufnr integer
local on_attach = function(client, bufnr)
  if client.name == "bashls" or client.name == "lua_ls" then
    return
  end

  if client.name == "dockerls" then
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.semanticTokensProvider = nil
    -- client.server_capabilities.semanticTokensProvider.range = true
    -- client.server_capabilities.semanticTokensProvider.full.delta = true
  end

  if client.name == "tsserver" then
    local function filter_tsserver_diagnostics(_, result, ctx, config)
      if result.diagnostics == nil then
        return
      end
      -- ignore some tsserver diagnostics
      local idx = 1
      while idx <= #result.diagnostics do
        local entry = result.diagnostics[idx]
        -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        if entry.code == 80001 then
          -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
          table.remove(result.diagnostics, idx)
        else
          idx = idx + 1
        end
      end
      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end
    vim.lsp.handlers["textDocument/publishDiagnostics"] = filter_tsserver_diagnostics
  end

  if client.name == "yamlls" then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if
      bufname:match(".*/templates/.*%.ya?ml")
      or bufname:match(".*/templates/.*%.tpl")
      or bufname:match("helmfile.*%.ya?ml")
    then
      client:stop(true)
    end
  end
end

-- Registered but not enabled (vtsls owns TypeScript buffers); start it
-- explicitly with vim.lsp.enable("tsgo"). Previously registered through
-- lspconfig.configs, now a plain native config.
vim.lsp.config("tsgo", {
  cmd = { "tsgo", "--lsp", "-stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
  single_file_support = true,
  capabilities = default_capabilities_config(),
})

-- Drop formatting edits that cannot change a single byte.
--
-- vscode-json-language-server answers every textDocument/formatting with an
-- extra edit spanning the end of the last line to (last_line + 1, 0) with an
-- empty newText -- its way of saying "the formatted document carries no
-- trailing newline". A Vim buffer always owns that newline, so
-- vim.lsp.util.apply_text_edits clamps the range back onto the last line and
-- calls nvim_buf_set_text with an empty replacement: nothing changes, not even
-- an on_bytes event fires, yet the line still lands on the undo stack. Every
-- write of such a buffer then leaves an undo entry anchored to the last line,
-- so a `u` that reaches it parks the cursor at the bottom of the file and
-- marks the buffer 'modified' while the text is identical.
--
-- The filter wraps the client's request rather than vim.lsp.handlers because
-- conform.nvim asks through client:request_sync, which supplies its own
-- handler and so never consults the handlers table.
local formatting_methods = {
  ["textDocument/formatting"] = true,
  ["textDocument/rangeFormatting"] = true,
  ["textDocument/rangesFormatting"] = true,
}

---@param line string
---@param character integer LSP character offset in `encoding` units
---@param encoding string
---@return integer byte offset, clamped to the line
local function byte_col(line, character, encoding)
  local ok, col = pcall(vim.str_byteindex, line, encoding, character, false)
  return ok and col or #line
end

---Whether applying `edit` would leave the buffer byte-identical. The range is
---clamped the same way vim.lsp.util.apply_text_edits clamps it, so an edit
---reaching past the last line is compared against what it can really replace.
---@param bufnr integer
---@param edit lsp.TextEdit
---@param encoding string
---@return boolean
local function is_noop_edit(bufnr, edit, encoding)
  local s, e = edit.range.start, edit.range["end"]
  if s.line > e.line or (s.line == e.line and s.character > e.character) then
    s, e = e, s
  end
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if s.line >= line_count then
    return edit.newText == ""
  end
  local end_row = math.min(e.line, line_count - 1)
  local start_line = vim.api.nvim_buf_get_lines(bufnr, s.line, s.line + 1, true)[1]
  local end_line = end_row == s.line and start_line or vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, true)[1]
  local start_col = math.min(byte_col(start_line, s.character, encoding), #start_line)
  local end_col = e.line > end_row and #end_line or math.min(byte_col(end_line, e.character, encoding), #end_line)
  if end_row < s.line or (end_row == s.line and end_col < start_col) then
    return edit.newText == ""
  end
  local current = table.concat(vim.api.nvim_buf_get_text(bufnr, s.line, start_col, end_row, end_col, {}), "\n")
  return current == edit.newText
end

---@type table<integer, true> client ids whose request is already wrapped
local noop_filtered_clients = {}

---@param client vim.lsp.Client
local function drop_noop_format_edits(client)
  if noop_filtered_clients[client.id] then
    return
  end
  noop_filtered_clients[client.id] = true

  local request = client.request
  ---@diagnostic disable-next-line: duplicate-set-field
  function client:request(method, params, handler, bufnr)
    if handler and formatting_methods[method] then
      local inner = handler
      handler = function(err, result, ctx, config)
        local buf = (ctx and ctx.bufnr) or bufnr
        if type(result) == "table" and result[1] ~= nil and buf and vim.api.nvim_buf_is_valid(buf) then
          result = vim.tbl_filter(function(edit)
            return not is_noop_edit(buf, edit, self.offset_encoding or "utf-16")
          end, result)
        end
        return inner(err, result, ctx, config)
      end
    end
    return request(self, method, params, handler, bufnr)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_noop_format_edits", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      drop_noop_format_edits(client)
    end
  end,
})

--- @class vim.lsp.Config : vim.lsp.ClientConfig
vim.lsp.config("*", {
  capabilities = default_capabilities_config(),
  on_attach = on_attach,
  root_markers = { ".git" },
})

-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- ["buf_ls"] = require("lsp.buf_ls"),
-- ["emmylua_ls"] = require("lsp.emmylua_ls"),
-- ["marksman"] = { cmd = { util.homebrew_binary("marksman", "marksman") } },
--   marksman stays out: it skips git-ignored files, so the agent memory
--   trees under the git-ignored claude/projects/ are invisible to it, and
--   rooted at that repository .git it spends 50s indexing before answering
--   nothing. markdown_oxide below covers the same links. Its edge -- broken
--   link diagnostics plus a "Create `file.md`" code action -- only pays off
--   on tracked documentation trees.
-- ["pyright"] = require("lsp.pyright"),
-- ["rust_analyzer"] = require("lsp.rust_analyzer"), -- rustaceanvim owns the rust-analyzer client (see lua/plugins/init.lua). Enabling this as well attaches a second rust-analyzer to every Rust buffer.
-- ["tilt_ls"] = require("lsp.tilt_ls"),
-- ["ts_ls"] = require("lsp.ts_ls"),
-- ["tsgo"] = require("lsp.tsgo"),
-- ["zizmor"] = require("lsp.zizmor"),
-- Pending migration to the native runtimepath form. A server whose file
-- lives in lsp/<name>.lua at the repo root needs no entry here: vim.lsp
-- resolves those lazily on the first FileType event, so its module cost
-- moves off this eager path. Entries below still load at LSP init
-- (one server moves per commit, for bisectability).
local servers = {
  ["gopls"] = require("lsp.gopls"),
  ["helm_ls"] = require("lsp.helm_ls"),
  ["jsonls"] = require("lsp.jsonls"),
  ["lua_ls"] = require("lsp.lua_ls"),
  ["markdown_oxide"] = require("lsp.markdown_oxide"),
  ["yamlls"] = require("lsp.yamlls"),
}
for server, config in pairs(servers) do
  vim.lsp.config(server, config)
end

vim.lsp.enable({
  "asm_lsp",
  "basedpyright",
  "bashls",
  "clangd",
  "dockerls",
  "gopls",
  "helm_ls",
  "jsonls",
  "lua_ls",
  "markdown_oxide",
  "neocmake",
  "protols",
  "ruby_lsp",
  "sourcekit",
  "terraformls",
  "tombi",
  "vtsls",
  "yamlls",
  "zls",
})

vim.keymap.set({ "n" }, "K", function()
  require("hover").open()
end, { desc = "hover.nvim (open)" })
-- rust-analyzer answers textDocument/definition for an attribute macro only
-- from inside the identifier: measured on `#[async_trait]`, the `#` and `[`
-- columns return nothing while every column from `a` onwards resolves. Column
-- 0 is exactly where the cursor sits after moving onto an attribute line, so
-- step onto the first identifier character before asking. Servers that answer
-- on punctuation are unaffected, since the nudge only runs when the cursor is
-- not already on a word character.
local function lsp_definitions()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if not line:sub(col + 1, col + 1):match("[%w_]") then
    local ident = line:find("[%a_]", col + 1)
    if ident then
      vim.api.nvim_win_set_cursor(0, { row, ident - 1 })
    end
  end
  require("snacks").picker.lsp_definitions()
end
vim.keymap.set({ "n" }, "<C-]>", lsp_definitions, { silent = true, desc = "LSP definitions" })
vim.keymap.set({ "n" }, "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { silent = true, desc = "LSP signature help" })
-- vim.keymap.set({ "n", "v" }, "<LocalLeader>ac", function() actions_preview.code_actions({}) end, { silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>ac", function()
  require("snacks").picker.actions()
end, { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>ca", function()
  vim.lsp.buf.code_action()
end, { silent = true, desc = "LSP code action" })
vim.keymap.set({ "n" }, "<LocalLeader>f", function()
  local conform = require("conform")
  -- Mirrors format_on_save in lua/plugins/conform.lua: conform only consults a
  -- formatters_by_ft entry's own lsp_format for keys the caller leaves nil, so
  -- passing a literal "fallback" here would discard a pinned "never". json5
  -- pins it because vscode-json-language-server has no JSON5 mode and rewrites
  -- such a buffer as strict JSON, so an unavailable oxfmt must format nothing.
  local ft_opts = conform.formatters_by_ft[vim.bo.filetype]
  local pinned = type(ft_opts) == "table" and ft_opts.lsp_format or nil
  conform.format({ async = false, lsp_format = pinned == "never" and "never" or "fallback" })
end, { silent = true, desc = "Format buffer (conform)" })
vim.keymap.set({ "n" }, "<LocalLeader>gci", "<Cmd>Trouble lsp_incoming_calls toggle<CR>", { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>gco", "<Cmd>Trouble lsp_outgoing_calls toggle<CR>", { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>ge", function()
  vim.diagnostic.open_float({ scope = "line" })
end, { silent = true, desc = "Line diagnostics" })
vim.keymap.set({ "n" }, "<LocalLeader>gh", "<Cmd>Trouble lsp toggle<CR>", { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>gi", function()
  require("snacks").picker.lsp_implementations()
end, { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>gk", function()
  local new_virtual_lines = not vim.diagnostic.config().virtual_lines
  local new_virtual_text = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_lines = new_virtual_lines, virtual_text = new_virtual_text })
end, { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>gp", function()
  require("overlook").open_definition()
end, { silent = true, desc = "Peek definition" })
vim.keymap.set({ "n" }, "<LocalLeader>gr", function()
  require("snacks").picker.lsp_references()
end, { silent = true })
vim.keymap.set({ "n" }, "<LocalLeader>gt", function()
  require("snacks").picker.lsp_type_definitions()
end, { silent = true })
vim.keymap.set({ "n" }, "<Leader>e", function()
  vim.lsp.buf.rename()
end, { silent = true, desc = "LSP rename" })
