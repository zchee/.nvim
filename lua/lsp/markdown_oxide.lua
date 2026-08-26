local util = require("util")

-- markdown-oxide keeps every knob in TOML rather than in LSP settings: it never
-- sends workspace/configuration, so a `settings` table here would be dropped on
-- the floor. Vault-wide options (dailynote format, unresolved_diagnostics,
-- inlay_hints, excluded_folders, ...) live in `~/.config/moxide/settings.toml`
-- or a per-vault `.moxide.toml`; `markdown-oxide config` opens the former.
--
-- The root markers come from nvim-lspconfig's own `lsp/markdown_oxide.lua`
-- ({ ".git", ".obsidian", ".moxide.toml" }, nearest ancestor wins) and are left
-- alone on purpose: measured on the agent notes tree -- 1604 markdown files
-- under a single .git -- the server finishes indexing in 1.8s and answers
-- textDocument/definition 90ms later, so narrowing the root buys nothing.
-- Dropping a `.moxide.toml` beside a vault still wins, a nearer marker taking
-- precedence over the repository .git.
--
-- Unlike marksman, this server indexes files that git ignores, which is what
-- makes it work on the agent memory trees (`claude/.gitignore` excludes
-- `projects/`, where those notes live).
--
-- `on_attach` is deliberately absent: the config merge resolves the last
-- on_attach wins, and leaving this one unset keeps nvim-lspconfig's, which
-- registers the :LspToday / :LspTomorrow / :LspYesterday daily-note commands.
-- The global on_attach in lua/lsp/init.lua only branches on other server names,
-- so nothing is lost by not running it here.

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("markdown-oxide", "markdown-oxide") },
  filetypes = { "markdown" },
}
