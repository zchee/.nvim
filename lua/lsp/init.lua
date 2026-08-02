-- local util = require("util")

-- local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")

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
  update_in_insert = true,
  severity_sort = true,
  jump = nil,
})

local hover = require("hover")
hover.config({
  --- @class Hover.UserConfig : Hover.Config
  init = function()
    require("hover.providers.dap")
    require("hover.providers.diagnostic")
    require("hover.providers.dictionary")
    require("hover.providers.fold_preview")
    require("hover.providers.gh")
    require("hover.providers.gh_user")
    require("hover.providers.highlight")
    require("hover.providers.lsp")
    require("hover.providers.man")
  end,
  providers = {
    "hover.providers.diagnostic",
    "hover.providers.lsp",
    "hover.providers.dap",
    "hover.providers.man",
    "hover.providers.dictionary",
  },
  ---@type vim.api.keyset.win_config
  preview_opts = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  preview_window = false,
  title = false,
  mouse_providers = { "hover.providers.lsp" },
  mouse_delay = 1000,
})

local lspkind = require("lspkind")
lspkind.init({
  mode = "symbol_text",
  preset = "codicons",
})

local lsp_endhints_pattern = {
  -- "*.go",
  "*.lua",
  "*.py",
}
local lsp_endhints = require("lsp-endhints")
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  pattern = lsp_endhints_pattern,
  callback = function()
    lsp_endhints.setup({
      icons = {
        type = "󰜁  ",
        parameter = "󰏪  ",
        offspec = "  ",
        unknown = "  ",
      },
      label = {
        truncateAtChars = 100,
        padding = 1,
        marginLeft = 3,
        sameKindSeparator = ", ",
      },
      extmark = {
        priority = 3000,
      },
      autoEnableHints = true,
    })
  end,
})

local tiny_inline_diagnostic = require("tiny-inline-diagnostic")
tiny_inline_diagnostic.setup({
  preset = "modern", -- "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
  transparent_bg = true,
  transparent_cursorline = true,
  hi = {
    error = "DiagnosticError",
    warn = "DiagnosticWarn",
    info = "DiagnosticInfo",
    hint = "DiagnosticHint",
    arrow = "NonText",
    background = "CursorLine", -- Background color for diagnostics. Can be a highlight group or a hexadecimal color (#RRGGBB)
    mixing_color = "Normal", -- Color blending option for the diagnostic background. Use "None" or a hexadecimal color (#RRGGBB) to blend with another color
  },
  options = {
    show_source = {
      enabled = true,
      if_many = true,
    },
    use_icons_from_diagnostic = true,
    set_arrow_to_diag_color = false,
    add_messages = true, -- Add messages to diagnostics when multiline diagnostics are enabled. If set to false, only signs will be displayed
    throttle = 20, -- milliseconds
    softwrap = 200, -- Minimum message length before wrapping to a new line
    multilines = {
      enabled = true,
      always_show = true,
      trim_whitespaces = true,
      tabstop = 4,
    },
    show_all_diags_on_cursorline = false,
    enable_on_insert = false,
    enable_on_select = false,
    overflow = {
      mode = "wrap", -- "wrap" - Split long messages into multiple lines, "none" - Do not truncate messages, "oneline" - Keep the message on a single line, even if it's long
      padding = 5, -- Trigger wrapping to occur this many characters earlier when mode == "wrap".
    },
    break_line = {
      enabled = false,
      after = 200, -- Number of characters after which to break the line
    },
    -- format = function(diagnostic)
    --   return diagnostic.message .. " [" .. diagnostic.source .. "]"
    -- end
    format = nil,
    virt_texts = {
      priority = 2048,
    },
    severity = {
      vim.diagnostic.severity.ERROR,
      vim.diagnostic.severity.WARN,
      vim.diagnostic.severity.INFO,
      vim.diagnostic.severity.HINT,
    },
    overwrite_events = nil, -- Events to attach diagnostics to buffers. You should not change this unless the plugin does not work with your configuration
  },
  disabled_ft = {}, -- List of filetypes to disable the plugin
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

local actions_preview = require("actions-preview")
actions_preview.setup({
  -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
  diff = {
    ctxlen = 3,
  },
  highlight_command = {
    require("actions-preview.highlight").delta(),
    require("actions-preview.highlight").diff_so_fancy(),
    require("actions-preview.highlight").diff_highlight(),
  },
  backend = {
    "snacks",
    "nui",
  },
  ---@type snacks.picker.Config
  snacks = {
    layout = {
      preset = "default",
    },
  },
  nui = {
    dir = "col", -- "col" or "row"
    -- keymap for selection component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu#keymap
    keymap = nil,
    -- options for nui Layout component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/layout
    layout = {
      position = "50%",
      size = {
        width = "60%",
        height = "90%",
      },
      min_width = 40,
      min_height = 10,
      relative = "editor",
    },
    -- options for preview area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
    preview = {
      size = "60%",
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
    -- options for selection area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu
    select = {
      size = "40%",
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
  },
})

local protocol = require("lsp.protocol")

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#clientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentClientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
local default_capabilities_config = function()
  ---@type lsp.ClientCapabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- merge blink.cmp client capabilities (second arg false: the base above
  -- already starts from make_client_capabilities())
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

  -- if capabilities.workspace then
  --   capabilities.workspace.didChangeWatchedFiles = {
  --     dynamicRegistration = true,
  --     relativePatternSupport = true,
  --   }
  -- end

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

---@param name string
---@param default_config any
local register_lsp = function(name, default_config)
  if not lspconfig_configs[tostring(name)] then
    lspconfig_configs[tostring(name)] = {
      default_config = default_config,
    }
  end
end

register_lsp("tsgo", {
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

--- @class vim.lsp.Config : vim.lsp.ClientConfig
vim.lsp.config("*", {
  capabilities = default_capabilities_config(),
  on_attach = on_attach,
  root_markers = { ".git" },
})

-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- ["buf_ls"] = require("lsp.buf_ls"),
-- ["emmylua_ls"] = require("lsp.emmylua_ls"),
-- ["markdown_oxide"] = {},
-- ["marksman"] = { cmd = { util.homebrew_binary("marksman", "marksman") } },
-- ["pyright"] = require("lsp.pyright"),
-- ["rust_analyzer"] = require("lsp.rust_analyzer"), -- rustaceanvim owns the rust-analyzer client (see lua/plugins/init.lua). Enabling this as well attaches a second rust-analyzer to every Rust buffer.
-- ["tilt_ls"] = require("lsp.tilt_ls"),
-- ["ts_ls"] = require("lsp.ts_ls"),
-- ["tsgo"] = require("lsp.tsgo"),
-- ["zizmor"] = require("lsp.zizmor"),
local servers = {
  ["asm_lsp"] = require("lsp.asm_lsp"),
  ["bashls"] = require("lsp.bashls"),
  ["clangd"] = require("lsp.clangd"),
  ["dockerls"] = require("lsp.dockerls"),
  ["gopls"] = require("lsp.gopls"),
  ["helm_ls"] = require("lsp.helm_ls"),
  ["jsonls"] = require("lsp.jsonls"),
  ["lua_ls"] = require("lsp.lua_ls"),
  ["neocmake"] = require("lsp.neocmake"),
  ["basedpyright"] = require("lsp.basedpyright"),
  ["protols"] = require("lsp.protols"),
  ["ruby_lsp"] = require("lsp.ruby_lsp"),
  ["sourcekit"] = require("lsp.sourcekit"),
  ["terraformls"] = require("lsp.terraformls"),
  ["taplo"] = require("lsp.taplo"),
  ["tombi"] = require("lsp.tombi"),
  ["vtsls"] = require("lsp.vtsls"),
  ["yamlls"] = require("lsp.yamlls"),
  ["zls"] = require("lsp.zls"),
}
for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server, true)
end

vim.keymap.set({ "n" }, "K", function()
  require("hover").open()
end, { desc = "hover.nvim (open)" })
vim.keymap.set({ "n" }, "<C-]>", function()
  require("snacks").picker.lsp_definitions()
end, { silent = true })
vim.keymap.set({ "n" }, "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { silent = true, desc = "LSP signature help" })
-- vim.keymap.set({ "n", "v" }, "<BS>ac", function() actions_preview.code_actions({}) end, { silent = true })
vim.keymap.set({ "n", "v" }, "<BS>ac", function()
  require("snacks").picker.actions()
end, { silent = true })
vim.keymap.set({ "n" }, "<BS>ca", function()
  vim.lsp.buf.code_action()
end, { silent = true, desc = "LSP code action" })
vim.keymap.set({ "n" }, "<BS>f", function()
  require("conform").format({ async = false, lsp_format = "fallback" })
end, { silent = true, desc = "Format buffer (conform)" })
vim.keymap.set({ "n" }, "<BS>gci", "<Cmd>Trouble lsp_incoming_calls toggle<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>gco", "<Cmd>Trouble lsp_outgoing_calls toggle<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>ge", function()
  vim.diagnostic.open_float({ scope = "line" })
end, { silent = true, desc = "Line diagnostics" })
vim.keymap.set({ "n" }, "<BS>gh", "<Cmd>Trouble lsp toggle<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>gi", function()
  require("snacks").picker.lsp_implementations()
end, { silent = true })
vim.keymap.set({ "n" }, "<BS>gk", function()
  local new_virtual_lines = not vim.diagnostic.config().virtual_lines
  local new_virtual_text = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_lines = new_virtual_lines, virtual_text = new_virtual_text })
end, { silent = true })
vim.keymap.set({ "n" }, "<BS>gp", function()
  require("overlook").open_definition()
end, { silent = true, desc = "Peek definition" })
vim.keymap.set({ "n" }, "<BS>gr", function()
  require("snacks").picker.lsp_references()
end, { silent = true })
vim.keymap.set({ "n" }, "<BS>gt", function()
  require("snacks").picker.lsp_type_definitions()
end, { silent = true })
vim.keymap.set({ "n" }, "<Space>e", function()
  vim.lsp.buf.rename()
end, { silent = true, desc = "LSP rename" })
