local util = require("util")

-- https://github.com/LuaLS/lua-language-server/blob/master/doc/en-us/config.md
-- https://github.com/LuaLS/lua-language-server/blob/master/locale/en-us/setting.lua
-- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua
--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("lua-language-server-head", "lua-language-server") },
  root_markers = {
    ".git",
    ".stylua.toml",
    "init.vim",
  },
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
          "vim", -- neovim builtin
          "vim.uv", -- neovim builtin
          -- "vim%.uv", -- neovim builtin
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
        workspaceDelay = 300,
        workspaceEvent = "OnChange", -- "OnSave",
        workspaceRate = 500,
      },
      format = {
        enable = true,
        -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
          max_line_length = "160",
          allow_non_indented_comments = false,
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
        version = "LuaJIT",
        pathStrict = false,
        path = {
          "?.lua",
          "?/init.lua",
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
        -- LLS-Addons keeps each addon's definitions one level down, under
        -- `addons/<name>/module/library`.
        library = {
          vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/busted/module/library"),
          vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/luassert/module/library"),
          vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/luvit/module/library"),
        },
        maxPreload = 500000, -- default: 5000, 500000
        preloadFileSize = 50000, -- default: 500, 50000
        useGitIgnore = true,
        userThirdParty = {},
      },
    },
  },
  offsetEncodings = { "utf-16" },
}
