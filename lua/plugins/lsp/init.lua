local util = require("util")

local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
local lsp_setup = require("lsp-setup")
local lspkind = require("lspkind")
local lsp_format = require("lsp-format")
local gtd = require('gtd')

lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    -- handlers = {
    --   ["window/logMessage"] = function(err, method, params, client_id)
    --     if params and params.type <= vim.lsp.protocol.MessageType.Log then
    --       vim.lsp.handlers["window/logMessage"](err, method, params, client_id)
    --     end
    --   end,
    --   ["window/showMessage"] = function(err, method, params, client_id)
    --     if params and params.type <= vim.lsp.protocol.MessageType.Error then
    --       vim.lsp.handlers["window/showMessage"](err, method, params, client_id)
    --     end
    --   end,
    -- }
  }
)

lsp_format.setup({
  go = {
    -- sync = true,
    exclude = { "gopls" }
  },
  c = {
    exclude = { "clangd" }
  },
  cpp = {
    exclude = { "clangd" }
  },
  lua = {
    sync = true,
  },
  sh = {
    sync = true,
  },
})

-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#clientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocumentClientCapabilities
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
local default_capabilities_config = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.formatting.dynamicRegistration = true
  capabilities.textDocument.semanticTokens.augmentsSyntaxTokens = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.codeAction.dynamicRegistration = true
  capabilities.textDocument.codeAction.isPreferredSupport = false
  capabilities.textDocument.codeAction.dataSupport = true
  capabilities.textDocument.codeAction.codeActionLiteralSupport.codeActionKind.valueSet = {
    "quickfix",
    "refactor",
    "refactor.extract",
    "refactor.inline",
    "refactor.rewrite",
    "source",
    "source.organizeImports",
    "source.fixAll",
  }
  capabilities.textDocument.definition = {
    linkSupport = false,
  }

  capabilities.workspace.applyEdit = true
  capabilities.workspace.configuration = true
  capabilities.workspace.didChangeConfiguration.dynamicRegistration = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  capabilities.workspace.inlayHint.refreshSupport = true
  capabilities.workspace.semanticTokens.refreshSupport = true
  capabilities.workspace.symbol.dynamicRegistration = true
  capabilities.workspace.workspaceEdit.documentChanges = true
  capabilities.workspace.workspaceEdit.normalizesLineEndings = true
  capabilities.workspace.workspaceFolders = true

  return capabilities
end

--- @param client vim.lsp.Client
--- @param bufnr integer
local on_attach = function(client, bufnr)
  vim.lsp.set_log_level("OFF") -- "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
  vim.lsp._watchfunc = vim._watch.watch

  --- @diagnostic disable-next-line
  lsp_format.on_attach(client, bufnr)

  if client.name == "bashls" or client.name == "lua_ls" then
    return
  end

  if client.name == "dockerls" then
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.semanticTokensProvider.range = true
    client.server_capabilities.semanticTokensProvider.full.delta = true
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
      client.stop(true)
    end
  end
end

-- local inlayHint = function()
--   local enabled = true
--   local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
--   if ft ~= "go" or ft ~= "gotmpl" then
--     enabled = false
--   end
--
--   return {
--     enabled = enabled, -- TODO(zchee): use inlayHint?
--     highlight = "Comment",
--   }
-- end

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
  "bufls",
  {
    cmd = { "bufls", "serve" },
    filetypes = { "proto" },
    root_dir = function()
      return lspconfig.util.find_git_ancestor
    end,
    settings = {},
  }
)
lspconfig.bufls.setup(require("plugins.lsp.bufls"))

register_lsp(
  "bzl",
  {
    cmd = { "bzl", "lsp", "serve" },
    filetypes = { "bzl" },
    root_dir = function()
      return lspconfig.util.find_git_ancestor
    end,
    settings = {},
  }
)
lspconfig.bzl.setup(require("plugins.lsp.bzl"))

register_lsp(
  "neocmake",
  {
    cmd = { require("mason-core.path").bin_prefix("neocmakelsp"), "--stdio" },
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
  }
)
lspconfig.neocmake.setup({})

-- register_lsp(
--   "cuepls",
--   {
--     cmd = { "cuepls", "serve" },
--     filetypes = { "cue" },
--     root_dir = function(fname)
--       return lspconfig.util.find_git_ancestor(fname)
--     end,
--     settings = {},
--   }
-- )
-- lspconfig.cuepls.setup(require("plugins.lsp.cuepls"))

register_lsp(
  "tilt_ls",
  {
    cmd = { "tilt", "lsp", "start" },
    filetypes = { "tiltfile" },
    root_dir = function()
      return lspconfig.util.find_git_ancestor
    end,
    settings = {},
  }
)
lspconfig.tilt_ls.setup(require("plugins.lsp.tilt_ls"))

register_lsp(
  "grammarly_lsp",
  {
    cmd = { "node", vim.fs.joinpath(util.src_path("github.com/emacs-grammarly/grammarly-language-server/packages/grammarly-languageserver/bin/server.js")), "--stdio" },
    filetypes = { "markdown" },
    root_dir = function()
      return lspconfig.util.find_git_ancestor
    end,
    settings = {},
  }
)
-- lspconfig.grammarly_lsp.setup(require("plugins.lsp.grammarly_lsp"))

-- register_lsp(
--   "flowtype",
--   {
--     cmd = { "/usr/local/var/nodenv/versions/16.20.2/bin/node", "/usr/local/var/nodenv/versions/16.20.2/bin/flow-language-server", "--stdio" },
--     filetypes = { "javascript" },
--     root_dir = function()
--       return lspconfig.util.find_git_ancestor
--     end,
--   }
-- )
-- lspconfig.flowtype.setup()

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
  }
)
lspconfig.sourcekit.setup(require("plugins.lsp.sourcekit"))

-- ["awk_ls"] = awk_ls_config,
-- ["bufls"] = bufls_config,
-- ["cmake"] = cmake_config,
-- ["docker_compose_language_service"] = {},
-- ["flow"] = {},
-- ["pls"] = require("plugins.lsp.pls"),
-- ["pyright"] = require("plugins.lsp.pyright"),
-- ["vimls"] = vimls_config,
-- ["vtsls"] = vtsls_config,
-- ["zls"] = zls_config,
local servers = {
  ["asm_lsp"] = require("plugins.lsp.asm_lsp"),
  ["basedpyright"] = require("plugins.lsp.basedpyright"),
  ["bashls"] = require("plugins.lsp.bashls"),
  ["bzl"] = require("plugins.lsp.bzl"),
  ["clangd"] = require("plugins.lsp.clangd"),
  ["dagger"] = {},
  ["dockerls"] = require("plugins.lsp.dockerls"),
  ["golangci_lint_ls"] = require("plugins.lsp.golangci_lint_ls"),
  ["gopls"] = require("plugins.lsp.gopls"),
  ["graphql"] = require("plugins.lsp.graphql"),
  ["helm_ls"] = require("plugins.lsp.helm_ls"),
  ["jsonls"] = require("plugins.lsp.jsonls"),
  ["lua_ls"] = require("plugins.lsp.lua_ls"),
  ["neocmake"] = require("plugins.lsp.neocmake"),
  -- ["ruff_lsp"] = require("plugins.lsp.ruff_lsp"),
  ["rust_analyzer"] = require("plugins.lsp.rust_analyzer"),
  -- ["sourcekit"] = require("plugins.lsp.sourcekit"),
  ["taplo"] = require("plugins.lsp.taplo"),
  ["terraformls"] = require("plugins.lsp.terraformls"),
  ["ts_ls"] = require("plugins.lsp.ts_ls"),
  ["yamlls"] = require("plugins.lsp.yamlls"),
}

---@class gtd.kit.App.Config.Schema
--@param sources { name: string, option?: table }[] # Specify the source that will be used to search for the definition
--@param get_buffer_path fun(): string # Specify the function to get the current buffer path. It's useful for searching path from terminal buffer etc.
--@param on_event fun(event: gtd.Event)
--@param on_context fun(context: gtd.Context) # Modify context on user-land.
--@param on_cancel fun(params: gtd.Params)
--@param on_nothing fun(params: gtd.Params)
--@param on_location fun(params: gtd.Params, location: gtd.kit.LSP.LocationLink)
--@param on_locations fun(params: gtd.Params, locations: gtd.kit.LSP.LocationLink[])
gtd.setup({})

vim.keymap.set('n', 'gf', function()
  gtd.exec({ command = 'edit' })
end)
vim.keymap.set('n', 'gs', function()
  gtd.exec({ command = 'split' })
end)
vim.keymap.set('n', 'gv', function()
  gtd.exec({ command = 'vsplit' })
end)

lsp_setup.setup({
  default_mappings = false,
  mappings = {
    -- ["<C-]>"] = "lua vim.lsp.buf.definition()",
    ["<C-]>"] = "<Cmd>Lspsaga goto_definition<CR>",

    -- ["<C-k>"] = "lua vim.lsp.buf.signature_help()",
    ["<C-k>"] = "<Cmd>Lspsaga signature_help<CR>",

    -- ["<BS>ca"] = "lua vim.lsp.buf.code_action()",
    ["<BS>ca"] = "<Cmd>Lspsaga code_action<CR>",

    ["<BS>f"] = "lua vim.lsp.buf.format()",
    ["<BS>gci"] = "<Cmd>Lspsaga incoming_calls<CR>",
    ["<BS>gco"] = "<Cmd>Lspsaga outgoing_calls<CR>",
    ["<BS>ge"] = "<Cmd>Lspsaga show_line_diagnostics<CR>",
    ["<BS>gh"] = "<Cmd>Lspsaga lsp_finder<CR>",
    ["<BS>gi"] = "lua vim.lsp.buf.implementation()",
    ["<BS>gp"] = "<Cmd>Lspsaga peek_definition<CR>",
    ["<BS>gr"] = "lua vim.lsp.buf.references()",
    ["<BS>gt"] = "<Cmd>Lspsaga goto_type_definition<CR>",

    -- ["<Space>e"] = "lua vim.lsp.buf.rename()",
    ["<Space>e"] = "<Cmd>Lspsaga rename<CR>",

    -- K = "lua vim.lsp.buf.hover()",
    K = "<Cmd>Lspsaga hover_doc<CR>",
  },
  capabilities = default_capabilities_config(),
  on_attach = on_attach,
  servers = servers,
  -- inlay_hints = inlayHint(),
})

lspkind.init()
