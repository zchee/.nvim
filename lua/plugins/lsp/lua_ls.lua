local util = require("util")

---@class lazydev.Config
require("lazydev").setup({
  runtime = vim.env.VIMRUNTIME,
  library = {
    { path = "luvit-meta/library", words = { "vim%.uv" } },
  },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  ---@type boolean|(fun(root:string):boolean?)
  enabled = function(root_dir)
    return true
  end,
})

-- https://github.com/LuaLS/lua-language-server/blob/master/doc/en-us/config.md
-- https://github.com/LuaLS/lua-language-server/blob/master/locale/en-us/setting.lua
-- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("lua-language-server", "lua-language-server") },
  -- cmd = {
  --   util.homebrew_binary("lua-language-server", "lua-language-server"),
  --   "--config-path", vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "lua", "plugins", "lsp", "luarc.json"),
  -- },
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
        -- builtin = "defalut",
        -- path = lua_ls_runtime_path,
        path = { "?.lua", "?/init.lua" },
        -- unicodeName = true,
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
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        }),
        useGitIgnore = true,
        maxPreload = 500000,     -- default: 5000, 500000
        preloadFileSize = 50000, -- default: 500, 50000
        checkThirdParty = "Disable",
      },
      -- workspace = {
      --   ignoreDir = {
      --     ".*",
      --     "lua",
      --     ".*/zchee/.*",
      --   },
      --   useGitIgnore = true,
      --   maxPreload = 5000,     -- default: 5000, 500000
      --   preloadFileSize = 500, -- default: 500, 50000
      --   checkThirdParty = false,
      --   -- userThirdParty = userThirdParty(),
      -- },
    },
  },
  on_init = function(client)
    if client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = false -- turn off semantic tokens
    end
  end,
}
