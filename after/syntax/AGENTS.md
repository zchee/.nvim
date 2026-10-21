<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# after/syntax

## Purpose
Neovim's `after-directory` slot for legacy regex `:syntax` overrides that
load after `$VIMRUNTIME` or a plugin's `syntax/<filetype>.vim`. It holds no
syntax file -- only this AGENTS.md, which is what keeps the directory in git.
Git history (commit `b7c5c93`, "after: cleanup after/ftplugin and
after/syntax", 2023-03-22) removed its former contents together with a batch
of VimScript `ftplugin` files, as the config moved to Lua ftplugins
(`after/ftplugin/`) and Tree-sitter query overrides (`after/queries/`).
Do not confuse it with the top-level `syntax/` directory, which is active
and holds real `:syntax` files -- see the repo root `syntax/AGENTS.md`.

## Key Files
None besides this AGENTS.md.

## For AI Agents

### Working In This Directory
- Only add a file here if a filetype needs a `:syntax` override that must
  win over the runtime's or a plugin's `syntax/<filetype>.vim` and a
  Tree-sitter query cannot express it (Tree-sitter is this repo's default
  highlighting path -- prefer `after/queries/<language>/highlights.scm`).
- A buffer with a Tree-sitter highlighter attached has 'syntax' cleared, so
  a file here is not sourced for it at all -- check
  `vim.treesitter.highlighter.active[bufnr]` before debugging why a new
  file has no effect.
- Do not resurrect pre-2023-03-22 content from `git log -- after/syntax`
  without verifying it is still needed; it was removed deliberately.

### Testing Requirements
No content, no tests. If a file is ever added, open a buffer of the target
filetype and confirm the expected highlight group applies (`:Inspect`).

### Common Patterns
None -- follow `after/ftplugin/` (per-filetype Lua) or `after/queries/`
(Tree-sitter `.scm`) conventions unless a genuine `:syntax`-only override is
required.

## Dependencies

### Internal
None.

### External
Neovim's `after-directory` and legacy `:syntax` mechanism
(`:h after-directory`, `:h syntax`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
