<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# indent

## Purpose
Holds a single indent script, `jinja.vim`, providing indent behavior for the
`jinja` filetype (set by `ftdetect/jinja.vim`). It layers HTML indent rules
with a Django/Jinja-aware `indentexpr` that adjusts for `{% block %}` /
`{% for %}` / `{% if %}` / `{% with %}` / `{% autoescape %}` / `{% comment
%}` / `{% filter %}` / `{% spaceless %}` / `{% macro %}` tag pairs and their
`empty`/`else`/`elif` midpoints.

## Key Files
| File | Description |
|------|-------------|
| `jinja.vim` | Jinja/Django HTML template indent: sources `indent/html.vim`, then overrides `indentexpr`/`indentkeys` with `GetDjangoIndent()` |

## For AI Agents

### Working In This Directory
- Standard indent-file skeleton: guarded by `b:did_indent`, `runtime!
  indent/html.vim` first for the HTML baseline, then `GetDjangoIndent()`
  layers block-tag-aware adjustments on top via a saved `b:html_indentexpr`.
- `GetDjangoIndent()` is defined once, guarded by `if exists("*GetDjangoIndent")
  | finish | endif`, so re-sourcing the file is safe.
- The block/mid-tag regex lists (`blocktags`, `midtags`) are the single
  source of truth for which Jinja/Django tags affect indentation — extend
  those lists rather than adding ad hoc regex checks elsewhere in the
  function.

### Testing Requirements
No automated specs. Verify manually with a sample `.jinja`/`.j2` file:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'edit <file.jinja>' -c 'set ft=jinja' -c 'normal! gg=G' -c 'qa'`
and inspect the resulting indentation, or open interactively and check
`:verbose set indentexpr?`.

### Common Patterns
Delegate to the built-in filetype's indent file first, then override
`indentexpr`/`indentkeys` with a custom function — the same layering pattern
used by `ftdetect/jinja.vim` and `syntax/jinja.vim` for this filetype.

## Dependencies

### Internal
Paired with `ftdetect/jinja.vim` (sets the `jinja`/`jinja.html` filetype) and
`syntax/jinja.vim` (highlighting).

### External
Neovim's bundled `indent/html.vim`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
