local util = require("util")

local lazydev = require("lazydev")
vim.g.lazydev_enabled = true

---@type lazydev.Config
lazydev.setup({
  runtime = vim.env.VIMRUNTIME,
  ---@type lazydev.Library.spec[]
  library = {
    {
      "lazy.nvim",
      {
        path = "${3rd}/luv/library",
        words = { "vim%.uv" },
      },
      "plenary.nvim",
      "nvim-treesitter",
    },
  },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  enabled = function()
    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
  end,
  debug = false,
})

-- https://github.com/LuaLS/lua-language-server/blob/master/doc/en-us/config.md
-- https://github.com/LuaLS/lua-language-server/blob/master/locale/en-us/setting.lua
-- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua
--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("lua-language-server", "lua-language-server") },
  settings = {
    Lua = {
      completion = {
        autoRequire = true,
        callSnippet = "Diasble",
        displayContext = 1,
        enable = true,
        keywordSnippet = "Replace",
        showWord = "Enable",
      },
      diagnostics = {
        enable = true,
        globals = {
          "vim",            -- neovim builtin
          "package",        -- neovim builtin
          "packer_plugins", -- packer.nvim
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
          -- "undefined-field",
        },
        -- workspaceDelay = 3000,
        workspaceRate = 100,
        libraryFiles = "Enable",
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      hint = {
        arrayIndex = "Disable",
        enable = true,
        paramName = "Disable",
        paramType = true,
        setType = false,
      },
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        builtin = "defalut",
        -- path = lua_ls_runtime_path,
        path = { "?.lua", "?/init.lua" },
        unicodeName = true,
      },
      semantic = {
        enabled = true,
        variable = true,
        annotation = true,
        keyword = true,
      },
      telemetry = {
        enable = false,
      },
      window = {
        statusBar = true,
        progressBar = true,
      },
      workspace = {
        ignoreDir = {
          ".*_tmp/.*",
        },
        -- library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
        --   "${3rd}/luv/library",
        --   "${3rd}/busted/library",
        --   "${3rd}/luassert/library",
        -- }),
        useGitIgnore = true,
        maxPreload = 500000,     -- default: 5000, 500000
        preloadFileSize = 50000, -- default: 500, 50000
        checkThirdParty = "Disable",
      },
    },
  },
  offsetEncodings = { "utf-16" },
  on_init = function(client)
    if client.server_capabilities then
      -- client.server_capabilities.semanticTokensProvider = false -- turn off semantic tokens
    end
  end,
}

-- library = {
--   vim.env.VIMRUNTIME
--   -- Depending on the usage, you might want to add additional paths here.
--   -- "${3rd}/luv/library"
--   -- "${3rd}/busted/library",
-- }
-- -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
-- -- library = vim.api.nvim_get_runtime_file("", true)
