local util = require("util")

-- https://github.com/LuaLS/lua-language-server/blob/master/doc/en-us/config.md
-- https://github.com/LuaLS/lua-language-server/blob/master/locale/en-us/setting.lua
-- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua
local lua_ls_bin = util.homebrew_binary("lua-language-server-head", "lua-language-server")

-- lua-language-server holds its index in memory only: ~/.cache/lua-language-server
-- carries just logs and the stdlib meta, no workspace index, so every nvim
-- restart re-pays it. Measured here: 5.0s to load 1099 files, 1.27GB resident.
-- github.com/zchee/lspmux keeps one server alive per workspace between editor
-- sessions, keyed by {binary, args, cwd} -- hence the explicit cwd below.
--
-- Deliberately restricted to this config repo. lua_ls starts a client per root
-- and lspmux keeps every instance resident between sessions, so wrapping all
-- Lua projects would park 1.27GB per root indefinitely; this is the one
-- workspace reopened often enough for the trade to pay.
--
-- Every failure path falls back to spawning the server directly, because a
-- slow LSP beats no LSP. LUA_LS_NO_LSPMUX=1 bypasses the daemon for bisecting.
---@param dispatchers vim.lsp.rpc.Dispatchers
---@param config vim.lsp.ClientConfig
---@return vim.lsp.rpc.PublicClient
local function lua_ls_cmd(dispatchers, config)
  local function direct()
    return vim.lsp.rpc.start({ lua_ls_bin }, dispatchers, { cwd = config.root_dir })
  end

  local root = config.root_dir and vim.uv.fs_realpath(config.root_dir)
  if vim.env.LUA_LS_NO_LSPMUX or not root or root ~= vim.uv.fs_realpath(vim.fn.stdpath("config")) then
    return direct()
  end

  local lspmux = vim.fn.exepath("lspmux")
  if lspmux == "" then
    return direct()
  end

  -- `status` exits non-zero when no daemon is listening; detach one so no
  -- launchd unit is needed. The daemon resolves its own socket path.
  if vim.system({ lspmux, "status" }):wait().code ~= 0 then
    local log_file = vim.fs.joinpath(tostring(vim.fn.stdpath("log")), "lspmux.log")
    vim.system({ lspmux, "server", "--log-file", log_file }, { detach = true })
    vim.wait(2000, function()
      return vim.system({ lspmux, "status" }):wait().code == 0
    end, 100)
    if vim.system({ lspmux, "status" }):wait().code ~= 0 then
      return direct()
    end
  end

  return vim.lsp.rpc.start({ lspmux, "client", "--server-path", lua_ls_bin }, dispatchers, { cwd = root })
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = lua_ls_cmd,
  filetypes = { "lua" },
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
        workspaceDelay = 30, -- 3000
        workspaceEvent = "OnChange", -- "OnSave",
        workspaceRate = 100,
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
        -- Both were 100x the upstream defaults, which left no cap at all.
        -- Measured on this workspace: 1099 files preloaded, and the largest
        -- Lua file anywhere in scope is nvim's generated vim/_meta/vimfn.gen.lua
        -- at 431KB -- too close to the 500KB default to keep it, since losing
        -- it would silently drop every vim.fn signature.
        maxPreload = 5000, -- default: 5000
        preloadFileSize = 1000, -- KB; default: 500
        useGitIgnore = true,
        userThirdParty = {},
      },
    },
  },
  offsetEncodings = { "utf-16" },
}
