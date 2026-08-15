---
name: nvim-search-plugin
description: Search for a Neovim plugin with mcp-gemini-search and vet it against this config. Use when finding a plugin for a capability this config lacks, replacing an unmaintained one, or judging whether a named candidate is worth adopting.
---

## Searching for a Neovim plugin

Gemini produces **leads**, never evidence. A lead names a plugin and says what it
does; every fact reported from it — last commit, star count, benchmark number,
option name — is confirmed at its own source first.

### 1. Check what this config already has

`lua/plugins/AGENTS.md` describes every spec in `lua/plugins/init.lua`, including
the specs that are commented out and the config modules that are dead on disk.
Read it before searching.

Done when: the closest existing plugin is named, or none covers the capability.

### 2. Search

Load the tool (deferred, one call):

```
ToolSearch query: select:mcp__plugin_mcp-gemini-search_mcp-gemini-search__google_search
```

`google_search` answers a plugin question in one round trip. `deep_research` is
billed per run and takes minutes — reserve it for an open landscape survey, not
for "is X still maintained".

Neovim plugin queries pull in listicles years out of date. Sharpen them by naming
the incumbent plugin, naming the Neovim version (0.13-dev nightly), and asking
for maintenance status instead of recommendations:

> alternatives to `<owner>/<repo>` for Neovim, actively maintained, which repos
> have commits in the last year

Done when: a candidate list of `owner/repo` names exists.

### 3. Confirm every lead at its source

| Claim | Source |
|---|---|
| maintained, archived, stars, last push | `gh api repos/<owner>/<repo> --jq '{full_name,pushed_at,archived,stargazers_count}'` |
| option names, API shape | the installed source under `~/.local/share/nvim/lazy/<repo>/lua/`, after `nvim --headless "+Lazy! install" +qa` |
| speed, startup cost | a measurement inside this config |

`gh api` follows GitHub's redirect, so a `full_name` that differs from the path
requested means the repo was transferred: `NvChad/nvim-colorizer.lua` resolves to
`catgoose/nvim-colorizer.lua`, which is how "abandoned" plugins turn out to have
a live maintainer.

READMEs document APIs the plugin no longer has — dotprompt's still shows the
pre-`main` nvim-treesitter registry schema. Read the installed source.

Measure with `nvim --headless "+luafile <abs path>"`; `nvim -l` skips the user
config, so it has no filetypes, no LSP, and no plugins. Gemini's performance
figures have been wrong here by two orders of magnitude and in the wrong
direction — it ranked mini.pairs above nvim-autopairs where measurement showed
the reverse.

Done when: every number and every date to be reported came from one of these
three sources.

### 4. Judge against this config's bar

- **Tracks nightly.** This config runs 0.13-dev; a plugin still calling APIs
  removed after 0.10 is out.
- **Lazy-loads under a narrow trigger** — `ft`, `cmd`, `keys`, or `event`. A
  plugin that demands `lazy = false` needs a reason.
- **Ships a prebuilt binary** when it has a native component. Source builds
  inherit this machine's `RUSTFLAGS` and fall back silently to a slower pure-Lua
  path; that is how blink.cmp lost gopls completions here.
- **Earns its overlap.** Where an existing plugin already covers part of the
  capability, name that plugin and what the candidate adds on top.

### 5. Report, then hand off

Report per candidate: last commit date, stars, what it overlaps with in this
config, and the single fact that decides it. When the verdict is adopt, the
wiring steps are the `add-plugin` skill.
