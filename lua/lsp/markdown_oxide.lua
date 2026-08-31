local util = require("util")

-- markdown-oxide keeps every knob in TOML rather than in LSP settings: it never
-- sends workspace/configuration, so a `settings` table here would be dropped on
-- the floor. Vault-wide options (dailynote format, unresolved_diagnostics,
-- inlay_hints, excluded_folders, ...) live in `~/.config/moxide/settings.toml`
-- or a per-vault `.moxide.toml`; `markdown-oxide config` opens the former.
--
-- The root markers ({ ".git", ".obsidian", ".moxide.toml" }, nearest ancestor
-- wins) and the daily-note on_attach used to come from nvim-lspconfig's own
-- `lsp/markdown_oxide.lua`; they are inlined here since nvim-lspconfig was
-- removed. The wide .git root is deliberate: measured on the agent notes tree
-- -- 1604 markdown files under a single .git -- the server finishes indexing
-- in 1.8s and answers textDocument/definition 90ms later, so narrowing the
-- root buys nothing. Dropping a `.moxide.toml` beside a vault still wins, a
-- nearer marker taking precedence over the repository .git.
--
-- Unlike marksman, this server indexes files that git ignores, which is what
-- makes it work on the agent memory trees (`claude/.gitignore` excludes
-- `projects/`, where those notes live).
--
-- The global on_attach in lua/lsp/init.lua only branches on other server
-- names, so replacing it with the daily-note one loses nothing.

---@param client vim.lsp.Client
---@param bufnr integer
---@param cmd string
local function daily_note(client, bufnr, cmd)
  return client:exec_cmd({
    title = ("Markdown-Oxide-%s"):format(cmd),
    command = "jump",
    arguments = { cmd },
  }, { bufnr = bufnr })
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("markdown-oxide", "markdown-oxide") },
  filetypes = { "markdown" },
  root_markers = { ".git", ".obsidian", ".moxide.toml" },
  on_attach = function(client, bufnr)
    for _, cmd in ipairs({ "today", "tomorrow", "yesterday" }) do
      vim.api.nvim_buf_create_user_command(bufnr, "Lsp" .. cmd:gsub("^%l", string.upper), function()
        daily_note(client, bufnr, cmd)
      end, {
        desc = ("Open %s daily note"):format(cmd),
      })
    end
  end,
}
