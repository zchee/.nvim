local copilot = require("copilot")

-- npm platform names (process.platform / process.arch) for os_uname() fields.
local npm_os = { Darwin = "darwin", Linux = "linux", Windows_NT = "win32" }
local npm_arch = { arm64 = "arm64", aarch64 = "arm64", x86_64 = "x64", AMD64 = "x64" }

--- Returns the native copilot-language-server that bun's global install of
--- @github/copilot-language-server pulls in as the optional dependency
--- @github/copilot-language-server-<os>-<arch>. Running it directly keeps
--- node out of the startup path: the nodejs server type makes copilot.setup()
--- block on a synchronous `node --version`.
---@return string? path executable path, nil when it cannot be resolved
---@return string? err why it cannot, for the error notification
local function native_server_path()
  local uname = vim.uv.os_uname()
  local os_name, arch = npm_os[uname.sysname], npm_arch[uname.machine]
  if not os_name or not arch then
    return nil, string.format("no copilot-language-server build for %s/%s", uname.sysname, uname.machine)
  end
  local bun_install = os.getenv("BUN_INSTALL")
  if not bun_install or bun_install == "" then
    return nil, "BUN_INSTALL is not set"
  end
  local path = vim.fs.joinpath(
    bun_install,
    "install/global/node_modules/@github",
    string.format("copilot-language-server-%s-%s", os_name, arch),
    os_name == "win32" and "copilot-language-server.exe" or "copilot-language-server"
  )
  if vim.fn.executable(path) ~= 1 then
    return nil, path .. " is not executable"
  end
  return path
end

local server_path, server_err = native_server_path()
if not server_path then
  -- Fail fast instead of handing copilot.lua a nil path, which would make it
  -- download its own server build in the background.
  vim.notify(
    string.format("plugins.copilot: %s; install it with `bun add -g @github/copilot-language-server`", server_err),
    vim.log.levels.ERROR
  )
  return
end

copilot.setup({
  panel = { enabled = false },
  suggestion = {
    enabled = false,
    auto_trigger = false,
    keymap = {
      accept = "<C-j>",
      accept_word = "<M-k>",
      accept_line = "<M-j>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    ["*"] = true,
  },
  -- ["*"] also matches buffers with no file behind them; copilot's default
  -- check only rejects unlisted buffers and special buftypes, so a fresh
  -- [No Name] buffer still got a client.
  should_attach = function(bufnr, bufname)
    return bufname ~= "" and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ""
  end,
  server = {
    type = "binary",
    custom_server_filepath = server_path,
  },
  -- Completion (not chat) model. Valid IDs are served dynamically — list and
  -- switch with `:Copilot model`; an invalid ID logs a startup warning and the
  -- server falls back to its default. As of 2026-07 the completion IDs are
  -- gpt-4o-copilot (server default) and gpt-41-copilot; the legacy
  -- copilot-codex/gpt-35-turbo engines are retired.
  copilot_model = "gpt-41-copilot",
  server_opts_overrides = {
    -- Stop copilot-language-server from encrypting its OAuth token with the macOS Keychain.
    -- When encryption is on, the server fetches a "KeytarMasterKey" from the Keychain
    -- (service=copilot-language-server, account=oauth-token-key). The Keychain "Always Allow"
    -- ACL is bound to the code signature + path of the executable that was granted access,
    -- and that executable is replaced on every upgrade (the native server binary on each bun
    -- update; before it, Homebrew's ad-hoc signed node under a version-specific Cellar path).
    -- So each update invalidates the ACL and the Keychain auth popup reappears on every file open.
    -- Injecting the env var equivalent of `internal.auth.tokenEncryption = "false"` makes the
    -- server store the token in plaintext (under ~/.config/github-copilot), eliminating the prompt.
    -- The env var name derives from the server's internal rus() (camelCase -> SNAKE_CASE)
    -- transform joined with the GITHUB_COPILOT_ prefix.
    cmd_env = {
      GITHUB_COPILOT_AUTH_TOKEN_ENCRYPTION = "false",
    },
    settings = {
      telemetry = {
        telemetryLevel = "off",
      },
      advanced = {
        -- displayStyle = "node",
        useLanguageServer = true,
        -- secretKey = ["advanced", "secret_key"],
        length = 0,
        -- stops = ["advanced", "stops"],
        -- temperature = ["advanced", "temperature"],
        -- topP = ["advanced", "top_p"],
        indentationMode = false,
        inlineSuggestCount = 3, -- #completions for getCompletions
        listCount = 3, -- #completions for panel
        -- debugOverrideProxyUrl = ["advanced", "debug.overrideProxyUrl"],
        -- debugTestOverrideProxyUrl = ["advanced", "debug.testOverrideProxyUrl"],
        -- debugEnableGitHubTelemetry = ["advanced", "debug.githubCTSIntegrationEnabled"],
        -- debugOverrideEngine = ["advanced", "debug.overrideEngine"],
        -- debugShowScores = ["advanced", "debug.showScores"],
        -- debugOverrideLogLevels = ["advanced", "debug.overrideLogLevels"],
        -- debugFilterLogCategories = ["advanced", "debug.filterLogCategories"],
        -- debugUseSuffix = ["advanced", "debug.useSuffix"],
        -- debugAcceptSelfSignedCertificate = ["advanced", "debug.acceptSelfSignedCertificate"]
      },
      -- enableAutoCompletions = false,
      -- inlineSuggest = {
      --   enable = false,
      -- },
      -- editor = {
      --   showEditorCompletions = false,
      --   enableAutoCompletions = false,
      --   delayCompletions = false,
      --   -- filterCompletions = ["editor", "filterCompletions"],
      -- },
    },
  },
})
