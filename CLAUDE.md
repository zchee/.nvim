# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration. Lua is the primary language, with legacy VimScript in `init.vim`. Plugin management via [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

- `init.vim` — Entry point. Loads `lua/init.lua` (or `lua/code/` for VSCode-Neovim).
- `lua/init.lua` — Bootstraps lazy.nvim, then loads `config.lazy` and `config`.
- `lua/config/` — Core settings: `nvim.lua` (vim.opt), `keymap.lua`, `autocmd.lua`, `highlight.lua`, `command.lua`.
- `lua/lsp/init.lua` — Central LSP orchestration. Registers servers, sets global capabilities/on_attach, enables each server via `vim.lsp.config()` + `vim.lsp.enable()`.
- `lua/lsp/<server>.lua` — Each file returns a `vim.lsp.Config` table (cmd, filetypes, settings, on_attach). Consumed by `lua/lsp/init.lua`.
- `lua/plugins/init.lua` — Returns a `LazySpec` table. Each plugin's config function loads from `lua/plugins/<name>.lua`.
- `lua/util/init.lua` — Helper functions used across configs (path resolution, XDG dirs, homebrew paths).
- `filetype.lua` — Custom `vim.filetype.add()` overrides.
- `after/ftplugin/` — Per-filetype buffer-local settings.
- `after/queries/` — Tree-sitter query overrides (highlights, injections, locals).

## Key Conventions

- LSP server binaries are resolved via `util.homebrew_binary()`, `util.prefix()`, `util.bun_prefix()`, or `util.go_path()` — not bare command names.
- `util.prefix()` returns `/opt/local` on arm64 macOS (not `/opt/homebrew`). `util.homebrew_prefix()` returns the actual Homebrew prefix.
- `util.src_path(...)` resolves to `~/src/...`. Local plugin dirs use this pattern.
- Plugins default to `lazy = true`. Use appropriate lazy-loading triggers (`cmd`, `ft`, `keys`, `event`).
- `vim.g.mapleader = " "` (Space), `vim.g.maplocalleader = "<BS>"` (Backspace).
- LSP keymaps are set globally in `lua/lsp/init.lua`, not per-server.
- The config uses `vim.lsp.config()` / `vim.lsp.enable()` (Neovim native LSP config, not lspconfig.setup()).
- Custom LSP servers not in lspconfig are registered via `register_lsp()` in `lua/lsp/init.lua` using `lspconfig.configs`.
