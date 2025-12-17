local util = require("util")
-- local mason_path = require("mason-core.path")

local lazydev = require("lazydev")

-- ---@type LuaDevOptions
-- require("neodev").setup({
--   library = {
--     enabled = true,
--     runtime = true,
--     types = false,
--     plugins = false, -- you can also specify the list of plugins to make available as a workspace library: plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
--   },
--   setup_jsonls = true,
--   override = function(root_dir, options)
--     _, _ = root_dir, options
--   end,
--   -- With lspconfig, Neodev will automatically setup your lua-language-server
--   -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
--   -- in your lsp start options
--   lspconfig = false,
--   pathStrict = true,
--   debug = false,
-- })

---@type lazydev.Config
lazydev.setup({
  runtime = vim.env.VIMRUNTIME,
  ---@type lazydev.Library.spec[]
  library = {
    "lazy.nvim",
    {
      path = "${3rd}/luv/library",
      words = { "vim%.uv" }
    },
    {
      -- {
      --   path = vim.env.VIMRUNTIME .. "lua/vim/_meta",
      -- },
      {
        -- path = util.homebrew_prefix() .. "/opt/lua-language-server/libexec/meta/3rd/luv/library",
        -- path = mason_path.package_prefix("lua-language-server") .. "libexec/meta/3rd/luv/library"
      },
      -- "plenary.nvim",
      -- "nvim-treesitter",
    },
  },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  enabled = true,
  debug = false,
})

-- https://github.com/LuaLS/lua-language-server/blob/master/doc/en-us/config.md
-- https://github.com/LuaLS/lua-language-server/blob/master/locale/en-us/setting.lua
-- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua
--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("lua-language-server-head", "lua-language-server") },
  settings = {
    Lua = {
      completion = {
        enable = true,
        autoRequire = true,
        callSnippet = "Both",
        displayContext = 1,
        keywordSnippet = "Both",
        showWord = "Fallback",
      },
      diagnostics = {
        enable = true,
        globals = {
          "vim",     -- neovim builtin
          "vim.uv",  -- neovim builtin
          "vim%.uv", -- neovim builtin
          "package", -- neovim builtin
          "describe",
          "it",
          "before_each",
          "after_each",
          "teardown",
          "pending",
          "clear", -- Busted
        },
        disable = {
          "redundant-parameter",
          "duplicate-set-field",
        },
        libraryFiles = "Opened",
        workspaceDelay = 3000,
        workspaceEvent = "OnSave",
        workspaceRate = 100,
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      hint = {
        enable = true,
        semicolon = "Disable",
        arrayIndex = "Disable",
        paramName = "Disable",
        paramType = true,
        setType = false,
      },
      codeLens = {
        enable = true,
      },
      hover = {
        enable = true,
        previewFields = 100,
      },
      runtime = {
        builtin = "enable",
        version = "LuaJIT",
        pathStrict = false,
        path = {
          '?.lua',
          '?/init.lua',
        },
      },
      semantic = {
        enabled = true,
        variable = true,
        annotation = true,
        keyword = true,
      },
      signatureHelp = {
        enable = false,
      },
      telemetry = {
        enable = false,
      },
      window = {
        statusBar = true,
        progressBar = true,
      },
      typeFormat = {
        auto_complete_end = true,
        auto_complete_table_sep = true,
        format_line = true,
      },
      workspace = {
        checkThirdParty = "Disable",
        ignoreDir = {
          ".*_tmp/.*",
        },
        -- library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
        --   "${3rd}/luv/library",
        --   "${3rd}/busted/library",
        --   "${3rd}/luassert/library",
        -- }),
        maxPreload = 500000,     -- default: 5000, 500000
        preloadFileSize = 50000, -- default: 500, 50000
        useGitIgnore = true,
      },
    },
  },
  offsetEncodings = { "utf-16" },
  on_init = function(client)
    if client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
    end
  end,
}
