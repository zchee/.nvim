local util = require("util")

local copilot = require("copilot")

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
    ["*"] = false,
    go = true,
    lua = true,
    sh = true,
    toml = true,
  },
  copilot_node_command = util.homebrew_binary("node", "node"),
  server = {
    type = "nodejs",
    custom_server_filepath = vim.fs.joinpath(
      util.getenv("BUN_INSTALL"),
      "install/global/node_modules/@github/copilot-language-server/dist/language-server.js"
    ),
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
    -- ACL is bound to the code signature + path of the node binary that was granted access,
    -- but Homebrew's node is ad-hoc signed and lives under a version-specific Cellar path
    -- (e.g. Cellar/node/26.4.0/bin/node) that changes on every upgrade. So each node update
    -- invalidates the ACL and the Keychain auth popup reappears on every file open.
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

-- configuration: [{
--   title: "GitHub Copilot",
--   properties: {
--     "github.copilot.selectedCompletionModel": {
--       type: "string",
--       default: "",
--       markdownDescription: "The currently selected completion model ID. To select from a list of available models, use the __\"Change Completions Model\"__ command or open the model picker (from the Copilot menu in the VS Code title bar, select __\"Configure Code Completions\"__ then __\"Change Completions Model\"__. The value must be a valid model ID. An empty value indicates that the default model will be used."
--     },
--     "github.copilot.advanced": {
--       type: "object",
--       title: "Advanced Settings",
--       properties: {
--         authProvider: {
--           type: "string",
--           enum: ["github", "github-enterprise"],
--           enumDescriptions: ["GitHub.com", "GitHub Enterprise"],
--           default: "github",
--           description: "The GitHub identity to use for Copilot"
--         },
--         authPermissions: {
--           type: "string",
--           enum: ["default", "minimal"],
--           markdownEnumDescriptions: ["Default (recommended) - The default permissions enable the best that Copilot has to offer including, but not limited to, faster repo indexing and the power of the `@github` agent.", "Minimal - The minimal permissions required for Copilot functionality."],
--           default: "default",
--           markdownDescription: "Controls what kind of permissions are asked for when signing in to Copilot. The options are\n* `default` - (strongly recommended) The default permissions enable the best that Copilot has to offer including, but not limited to, faster repo indexing and the power of the `@github` agent.\n* `minimal` - The minimal permissions are the least that Copilot needs to function. Some features may behave slower or not at all."
--         },
--         useLanguageServer: {
--           type: "boolean",
--           default: false,
--           description: "Experimental: Use language server"
--         },
--         "debug.overrideEngine": {
--           type: "string",
--           default: "",
--           description: "Override engine name"
--         },
--         "debug.overrideProxyUrl": {
--           type: "string",
--           default: "",
--           description: "Override GitHub authentication proxy full URL"
--         },
--         "debug.testOverrideProxyUrl": {
--           type: "string",
--           default: "",
--           description: "Override GitHub authentication proxy URL when running tests"
--         },
--         "debug.overrideCapiUrl": {
--           type: "string",
--           default: "",
--           description: "Override GitHub Copilot API full URL"
--         },
--         "debug.testOverrideCapiUrl": {
--           type: "string",
--           default: "",
--           description: "Override GitHub Copilot API URL when running tests"
--         },
--         "debug.filterLogCategories": {
--           type: "array",
--           default: [],
--           deprecationMessage: "Set overrideLogLevels.* to ERROR to filter out unwanted categories.",
--           description: "Show only log categories listed in this setting. If an array is empty, show all loggers"
--         }
--       }
--     },
--     "github.copilot.enable": {
--       type: "object",
--       scope: "window",
--       default: {
--         "*": true,
--         plaintext: false,
--         markdown: false,
--         scminput: false
--       },
--       additionalProperties: {
--         type: "boolean"
--       },
--       markdownDescription: "Enable or disable auto triggering of Copilot completions for specified [languages](https://code.visualstudio.com/docs/languages/identifiers). You can still trigger suggestions manually using `Alt + \\`"
--     }
--   }
-- }],
