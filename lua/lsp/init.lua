vim.lsp.set_log_level("OFF") -- "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"

local util = require("util")

local actions_preview = require("actions-preview")

local lspsaga = require("lspsaga")

-- local lsp_setup = require("lsp-setup")

local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
-- local lspconfig_ui_windows = require('lspconfig.ui.windows')

local lspkind = require("lspkind")

-- local tiny_inline_diagnostic = require('tiny-inline-diagnostic')
-- local lsp_endhints = require("lsp-endhints")

local snacks = require("snacks")

vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = true,
  severity_sort = true,
})

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
    "telescope",
  },
  nui = {
    -- component direction. "col" or "row"
    dir = "col",
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
  telescope = vim.tbl_extend(
    "force",
    -- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
    require("telescope.themes").get_dropdown(),
    -- a table for customizing content
    {
      -- a function to make a table containing the values to be displayed.
      -- fun(action: Action): { title: string, client_name: string|nil }
      make_value = nil,

      -- a function to make a function to be used in `display` of a entry.
      -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
      -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
      make_make_display = nil,
    }
  ),
  ---@type snacks.picker.Config
  snacks = {
    layout = {
      preset = "default",
    },
  },
})
local code_actions = function()
  ---@type vim.lsp.buf.code_action.Opts
  local opts = {
    context = nil,
    filter = nil,
    apply = nil,
    range = nil,
  }
  actions_preview.code_actions(opts)
end

lspsaga.setup({
  ui = {
    winbar_prefix = "",
    border = "rounded",
    devicon = true,
    foldericon = true,
    title = true,
    expand = "⊞",
    collapse = "⊟",
    code_action = " ", -- "💡",
    lines = { "┗", "┣", "┃", "━", "┏" },
    kind = {},
    button = { "", "" },
    imp_sign = "󰳛 ", -- " ", "󰳛 "
    use_nerd = true,
  },
  hover = {
    max_width = 0.9,
    max_height = 1,
    open_link = "gx",
    open_cmd = "!chrome",
  },
  diagnostic = {
    show_layout = "float",
    show_normal_height = 10,
    jump_num_shortcut = true,
    auto_preview = false,
    max_width = 0.8,
    max_height = 0.6,
    max_show_width = 0.9,
    max_show_height = 0.6,
    wrap_long_lines = true,
    extend_relatedInformation = false,
    diagnostic_only_current = false,
    keys = {
      exec_action = "o",
      quit = "q",
      toggle_or_jump = "<CR>",
      quit_in_show = { "q", "<ESC>" },
    },
  },
  code_action = {
    num_shortcut = true,
    show_server_name = false,
    extend_gitsigns = false,
    only_in_cursor = true,
    max_height = 0.3,
    cursorline = true,
    keys = {
      quit = "<C-c>",
      exec = "<CR>",
    },
  },
  lightbulb = {
    enable = true,
    sign = false,
    debounce = 10,
    sign_priority = 40,
    virtual_text = true,
    enable_in_insert = true,
    ignore = {
      clients = {},
      ft = {},
    },
  },
  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  request_timeout = 2000,
  finder = {
    max_height = 0.5,
    left_width = 0.4,
    methods = {},
    default = "ref+imp",
    layout = "float",
    silent = false,
    filter = {},
    fname_sub = nil,
    sp_inexist = false,
    sp_global = false,
    ly_botright = false,
    number = vim.o.number,
    relativenumber = vim.o.relativenumber,
    keys = {
      shuttle = "[w",
      toggle_or_open = "o",
      vsplit = "s",
      split = "i",
      tabe = "t",
      tabnew = "r",
      quit = "q",
      close = "<Esc>",
    },
  },
  definition = {
    width = 0.6,
    height = 0.5,
    save_pos = false,
    number = vim.o.number,
    relativenumber = vim.o.relativenumber,
    keys = {
      edit = "o",
      vsplit = "v",
      split = "s",
      tabe = "t",
      tabnew = "<C-t>",
      quit = "q",
      close = "<Esc>",
    },
  },
  rename = {
    in_select = false,
    auto_save = false,
    project_max_width = 0.5,
    project_max_height = 0.5,
    keys = {
      quit = "<C-k>",
      exec = "<CR>",
      select = "x",
    },
  },
  symbol_in_winbar = {
    enable = true,
    separator = " ",
    hide_keyword = false,
    ignore_patterns = nil,
    show_file = true,
    folder_level = 1,
    color_mode = true,
    delay = 300,
  },
  outline = {
    win_position = "right",
    win_width = 30,
    auto_preview = true,
    detail = true,
    auto_close = true,
    close_after_jump = false,
    layout = "normal",
    max_height = 0.5,
    left_width = 0.3,
    keys = {
      toggle_or_jump = "o",
      quit = "q",
      jump = "e",
    },
  },
  callhierarchy = {
    layout = "float",
    left_width = 0.2,
    keys = {
      edit = "o",
      vsplit = "s",
      split = "i",
      tabe = "t",
      close = "<Esc>",
      quit = "q",
      shuttle = "[w",
      toggle_or_req = "u",
    },
  },
  typehierarchy = {
    layout = 'float',
    left_width = 0.2,
    keys = {
      edit = 'e',
      vsplit = 's',
      split = 'i',
      tabe = 't',
      close = "<Esc>",
      quit = 'q',
      shuttle = '[w',
      toggle_or_req = 'u',
    },
  },
  implement = {
    enable = true,
    sign = true,
    lang = {},
    virtual_text = false,
    priority = 100,
  },
  beacon = {
    enable = false,
    frequency = 7,
  },
  floaterm = {
    height = 0.7,
    width = 0.7,
  },
})

lspkind.init({
  mode = "symbol_text",
  preset = "codicons",
})

-- lsp_endhints.setup({
--   icons = {
--     type = "󰜁 ",
--     parameter = "󰏪 ",
--     offspec = " ",
--     unknown = " ",
--   },
--   label = {
--     truncateAtChars = 20,
--     padding = 1,
--     marginLeft = 3,
--     sameKindSeparator = ", ",
--   },
--   extmark = {
--     priority = 3000,
--   },
--   autoEnableHints = false,
-- })

-- tiny_inline_diagnostic.setup({
--   preset = "modern", -- "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
--   transparent_bg = true,
--   hi = {
--     error = "DiagnosticError",
--     warn = "DiagnosticWarn",
--     info = "DiagnosticInfo",
--     hint = "DiagnosticHint",
--     arrow = "NonText",
--     background = "CursorLine", -- Background color for diagnostics. Can be a highlight group or a hexadecimal color (#RRGGBB)
--     mixing_color = "Normal",   -- Color blending option for the diagnostic background. Use "None" or a hexadecimal color (#RRGGBB) to blend with another color
--   },
--   options = {
--     show_source = true,
--     use_icons_from_diagnostic = true,
--     add_messages = true, -- Add messages to diagnostics when multiline diagnostics are enabled. If set to false, only signs will be displayed
--     throttle = 10,       -- milliseconds
--     softwrap = 200,      -- Minimum message length before wrapping to a new line
--     multilines = {
--       enabled = false,
--       always_show = false,
--     },
--     show_all_diags_on_cursorline = false,
--     enable_on_insert = false,
--     enable_on_select = false,
--     overflow = {
--       mode = "wrap", -- "wrap" - Split long messages into multiple lines, "none" - Do not truncate messages, "oneline" - Keep the message on a single line, even if it's long
--       padding = 5,   -- Trigger wrapping to occur this many characters earlier when mode == "wrap".
--     },
--     break_line = {
--       enabled = true,
--       after = 200, -- Number of characters after which to break the line
--     },
--     -- format = function(diagnostic)
--     --   return diagnostic.message .. " [" .. diagnostic.source .. "]"
--     -- end
--     format = nil,
--     virt_texts = {
--       priority = 2000,
--     },
--     severity = {
--       vim.diagnostic.severity.ERROR,
--       vim.diagnostic.severity.WARN,
--       vim.diagnostic.severity.INFO,
--       vim.diagnostic.severity.HINT,
--     },
--     overwrite_events = nil, -- Events to attach diagnostics to buffers. You should not change this unless the plugin does not work with your configuration
--   },
--   disabled_ft = {}          -- List of filetypes to disable the plugin
-- })

-- lspconfig.util.default_config = vim.tbl_extend(
--   "force",
--   lspconfig.util.default_config,
--   {
--     handlers = {
--       ["textDocument_inlayHint"] = function(err, result, ctx, config)
--         local client = vim.lsp.get_client_by_id(ctx.client_id)
--         if client then
--           local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
--           result = vim.iter(result):filter(function(hint)
--             return hint.position.line + 1 == row
--           end):totable()
--         end
--         vim.lsp.handlers["textDocument_inlayHint"](err, result, ctx, config)
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

-- :Help lspconfig-setup-hook
-- lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
--   if some_condition and config.name == "clangd" then
--     local custom_server_prefix = "/my/custom/server/prefix"
--     config.cmd = { custom_server_prefix .. "/bin/clangd" }
--   end
-- end)

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#clientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentClientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
local default_capabilities_config = function()
  ---@type lsp.ClientCapabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  ---@type lsp.ClientCapabilities
  local capabilities_override = {
    general = {
      positionEncodings = { "utf-16" },
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
        contextSupport = true,
      },
      foldingRange = {
        dynamicRegistration = true,
        lineFoldingOnly = true
      }
    },
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }
  return vim.tbl_deep_extend('force', capabilities, capabilities_override)
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
    if bufname:match(".*/templates/.*%.ya?ml") or bufname:match(".*/templates/.*%.tpl") or bufname:match("helmfile.*%.ya?ml") then
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

register_lsp(
  "neocmake",
  {
    cmd = { vim.fn.exepath("neocmakelsp"), "--stdio" },
    filetypes = { "cmake" },
    root_dir = function(fname)
      return lspconfig.util.root_pattern(
        unpack({ 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' })
      )(fname)
    end,
    single_file_support = true,
    init_options = {
      format = {
        enable = false,
      },
      lint = {
        enable = false,
      },
      scan_cmake_in_package = true,
      enable_semantic_token = true,
    },
    capabilities = default_capabilities_config(),
  }
)
lspconfig.neocmake.setup({})

register_lsp(
  "tilt_ls",
  {
    cmd = { "tilt", "lsp", "start" },
    filetypes = { "tiltfile" },
    root_dir = function(filename, _)
      return vim.fs.dirname(vim.fs.find('.git', { path = filename, upward = true })[1])
    end,
    settings = {},
    capabilities = default_capabilities_config(),
  }
)
lspconfig.tilt_ls.setup(require("lsp.tilt_ls"))

register_lsp(
  "sourcekit",
  {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
    root_dir = function(filename, _)
      return util.root_pattern 'buildServer.json' (filename)
          or util.root_pattern('*.xcodeproj', '*.xcworkspace')(filename)
          -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
          or util.root_pattern('compile_commands.json', 'Package.swift')(filename)
          or util.find_git_ancestor(filename)
    end,
    capabilities = default_capabilities_config(),
  }
)
lspconfig.sourcekit.setup(require("lsp.sourcekit"))

register_lsp(
  "ruby_lsp",
  {
    cmd = { "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
    init_options = {
      formatter = "auto",
    },
    single_file_support = true,
    capabilities = default_capabilities_config(),
  }
)
lspconfig.ruby_lsp.setup(require("lsp.ruby_lsp"))

register_lsp(
  "docker_language_server",
  {
    cmd = { "docker-language-server" },
    filetypes = { "dockerfile", "eruby" },
    root_dir = require("lspconfig").util.root_pattern("Dockerfile", "*.dockerfile", "Dockerfile*"),
    single_file_support = true,
    capabilities = default_capabilities_config(),
  }
)
lspconfig.docker_language_server.setup(require("lsp.docker_language_server"))

register_lsp(
  "stainless",
  {
    cmd = { "stainless-language-server", "--stdio" },
    filetypes = { "stainless.yml", "stainless.yaml", "*.stainless.yml", "openapi.yaml", "openapi.yml" },
    root_dir = lspconfig.util.root_pattern(".git"),
    single_file_support = true,
    capabilities = default_capabilities_config(),
  }
)
lspconfig.docker_language_server.setup({})

-- register_lsp(
--   "cmake_language_server",
--   {
--     cmd = { util.homebrew_binary("cmake-language-server", "cmake-language-server") },
--     -- filetypes = { "ruby", "eruby" },
--     -- root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
--     -- init_options = {
--     --   formatter = "auto",
--     -- },
--     -- single_file_support = true,
--   }
-- )
-- lspconfig.cmake_language_server.setup(require("plugins.lsp.cmake-language-server"))

-- register_lsp(
--   "tsgo",
--   {
--     cmd = { "tsgo" },
--     filetypes = { "typescript" },
--     -- root_dir = require("lspconfig").util.root_pattern("Dockerfile", "*.dockerfile", "Dockerfile*"),
--     single_file_support = true,
--     capabilities = default_capabilities_config(),
--   }
-- )
-- lspconfig.tsgo.setup(require("plugins.lsp.tsgo"))


--- @class vim.lsp.Config : vim.lsp.ClientConfig
vim.lsp.config("*", {
  capabilities = default_capabilities_config(),
  on_attach = on_attach,
  root_markers = { ".git" },
})

-- ["asm_lsp"] = require("plugins.lsp.asm_lsp"),
-- ["basedpyright"] = require("plugins.lsp.basedpyright"),
-- ["bashls"] = require("plugins.lsp.bashls"),
-- ["clangd"] = require("plugins.lsp.clangd"),
-- ["dockerls"] = require("plugins.lsp.dockerls"),
-- ["gopls"] = require("plugins.lsp.gopls"),
-- ["helm_ls"] = require("plugins.lsp.helm_ls"),
-- ["jsonls"] = require("plugins.lsp.jsonls"),
-- ["lua_ls"] = require("plugins.lsp.lua_ls"),
-- ["rust_analyzer"] = require("plugins.lsp.rust_analyzer"),
-- ["stainless"] = {},
-- ["taplo"] = require("plugins.lsp.taplo"),
-- ["terraformls"] = require("plugins.lsp.terraformls"),
-- ["ts_ls"] = require("plugins.lsp.ts_ls"),
-- ["yamlls"] = require("plugins.lsp.yamlls"),
local servers = {
  ["asm_lsp"] = require("lsp.asm_lsp"),
  ["basedpyright"] = require("lsp.basedpyright"),
  ["bashls"] = require("lsp.bashls"),
  ["clangd"] = require("lsp.clangd"),
  ["dockerls"] = require("lsp.dockerls"),
  ["gopls"] = require("lsp.gopls"),
  ["helm_ls"] = require("lsp.helm_ls"),
  ["jsonls"] = require("lsp.jsonls"),
  ["lua_ls"] = require("lsp.lua_ls"),
  ["rust_analyzer"] = require("lsp.rust_analyzer"),
  ["stainless"] = {},
  ["taplo"] = require("lsp.taplo"),
  ["terraformls"] = require("lsp.terraformls"),
  ["ts_ls"] = require("lsp.ts_ls"),
  ["yamlls"] = require("lsp.yamlls"),
  ["zls"] = require("lsp.zls"),
}
for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

vim.keymap.set({ "n" }, "K", "lua require('hover').hover()", { silent = true })
vim.keymap.set({ "n" }, "<C-]>", function() snacks.picker.lsp_definitions() end, { silent = true })
vim.keymap.set({ "n" }, "<C-k>", "<Cmd>Lspsaga signature_help<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "<BS>ac", code_actions)
vim.keymap.set({ "n" }, "<BS>ca", "<Cmd>Lspsaga code_action<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>f", "lua vim.lsp.buf.format({ async = false })", { silent = true })
vim.keymap.set({ "n" }, "<BS>gci", "<Cmd>Lspsaga incoming_calls<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>gco", "<Cmd>Lspsaga outgoing_calls<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>ge", "<Cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>gh", "<Cmd>Lspsaga lsp_finder<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>gi", function() snacks.picker.lsp_implementations() end, { silent = true })
vim.keymap.set({ "n" }, "<BS>gk", function()
  local new_virtual_lines = not vim.diagnostic.config().virtual_lines
  local new_virtual_text = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_lines = new_virtual_lines, virtual_text = new_virtual_text })
end, { silent = true })
vim.keymap.set({ "n" }, "<BS>gp", "<Cmd>Lspsaga peek_definition<CR>", { silent = true })
vim.keymap.set({ "n" }, "<BS>gr", function() snacks.picker.lsp_references() end, { silent = true })
vim.keymap.set({ "n" }, "<BS>gt", function() snacks.picker.lsp_type_definitions() end, { silent = true })
vim.keymap.set({ "n" }, "<Space>e", "<Cmd>Lspsaga rename<CR>", { silent = true })
