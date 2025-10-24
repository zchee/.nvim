local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  autostart = true,
  cmd = { util.homebrew_binary("bash-language-server-head", "bash-language-server"), "start" },
  filetypes = { "sh", "bash" },
  settings = {
    bashIde = {
      backgroundAnalysisMaxFiles = 10000,
      enableSourceErrorDiagnostics = true,
      globPattern = "*@(.sh|.inc|.bash|.command)", -- globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
      -- explainshellEndpoint = "",
      -- logLevel = "info",
      includeAllWorkspaceSymbols = true,
      shellcheckArguments = { "-f", "gcc" }, --  "--enable=all"
      shellcheckPath = "/opt/local/bin/shellcheck",
      shfmt = {
        path = util.homebrew_binary("shfmt", "shfmt"),
        -- // Ignore shfmt config options in .editorconfig (always use language server config)
        -- ignoreEditorconfig: z.boolean().default(false),
        -- // Language dialect to use when parsing (bash/posix/mksh/bats).
        -- languageDialect: z.enum(['auto', 'bash', 'posix', 'mksh', 'bats']).default('auto'),
        -- // Allow boolean operators (like && and ||) to start a line.
        -- binaryNextLine: z.boolean().default(false),
        -- // Indent patterns in case statements.
        -- caseIndent: z.boolean().default(false),
        -- // Place function opening braces on a separate line.
        -- funcNextLine: z.boolean().default(false),
        -- // (Deprecated) Keep column alignment padding.
        -- keepPadding: z.boolean().default(false),
        -- // Simplify code before formatting.
        -- simplifyCode: z.boolean().default(false),
        -- // Follow redirection operators with a space.
        -- spaceRedirects: z.boolean().default(false),
      },
    }
  },
}
