-- nvim-treesitter main branch: the master-era module system is gone --
-- highlighting/indent are started per buffer from the FileType autocmd below,
-- parser management goes through require("nvim-treesitter").install() /
-- :TSUpdate, and incremental selection is hand-rolled in
-- plugins/treesitter_selection.lua.
require("plugins.ts_context_commentstring")

-- filetype -> parser routing (core API, unchanged from master)
vim.treesitter.language.register("starlark", "tiltfile")
vim.treesitter.language.register("json", "jsonschema")
vim.treesitter.language.register("json", "jsonl")
vim.treesitter.language.register("gotmpl", "helm")
vim.treesitter.language.register("docker-bake", "hcl")
vim.treesitter.language.register("bash", "zsh")

local nts = require("nvim-treesitter")

-- Fresh install dir for the main-branch parser layout; the master-era
-- parsers stay untouched in stdpath("data")/tree-sitter for instant rollback.
local install_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "tree-sitter-main")
nts.setup({ install_dir = install_dir })

-- tree-sitter-rust reparses every macro token_tree as Rust. When a macro body
-- is not Rust -- a DSL such as ganja-code's `invocations!` -- that reparse
-- desyncs and starts pairing string quotes across lines, so the doc comments
-- between fields render as @string. Upstream already excludes a few macros by
-- name, so widen that list in place instead of restating the query: the rest
-- keeps tracking the installed grammar, and a miss leaves upstream untouched.
local rust_macro_injection_skip = { "invocations" }
do
  local file = vim.api.nvim_get_runtime_file("queries/rust/injections.scm", false)[1]
  if file then
    local extra = table.concat(vim.tbl_map(function(name)
      return string.format(" %q", name)
    end, rust_macro_injection_skip))
    local src = table.concat(vim.fn.readfile(file), "\n")
    local patched, hits =
      src:gsub("%(#not%-any%-of%? @_macro_name ([^)]*)%)", "(#not-any-of? @_macro_name %1" .. extra .. ")", 1)
    if hits == 1 then
      vim.treesitter.query.set("rust", "injections", patched)
    end
  end
end

-- Custom/forked grammars live in lua/nvim-treesitter/parsers.lua -- a user
-- module that shadows the plugin registry by runtimepath order, because
-- install.lua's reload_parsers() re-requires that module and would wipe any
-- runtime mutation done here.

-- main has no ensure_installed: parsers are installed on demand.
-- Bootstrap/repair with :TSEnsureInstalled; the spec's build = ":TSUpdate"
-- keeps them in sync with registry revisions on plugin updates.
vim.api.nvim_create_user_command("TSEnsureInstalled", function()
  nts.install(require("plugins.treesitter_parsers"))
end, { desc = "Install all configured tree-sitter parsers" })

local highlight_skip = {
  metal = true,
  tmux = true,
}
local indent_skip = {
  yaml = true,
}

local function start_treesitter(buf, ft)
  local lang = vim.treesitter.language.get_lang(ft) or ft
  if highlight_skip[lang] then
    return
  end
  -- *.dockerfile files kept tree-sitter highlighting off under master
  -- (TSBufDisable autocmd); preserve that behavior.
  if lang == "dockerfile" and vim.api.nvim_buf_get_name(buf):match("%.dockerfile$") then
    return
  end
  -- no parser (or no queries) for this language: silently keep legacy
  -- syntax highlighting
  if not pcall(vim.treesitter.start, buf, lang) then
    return
  end
  if not indent_skip[lang] then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(ev)
    start_treesitter(ev.buf, ev.match)
  end,
})

-- The spec defers this module to the first FileType event (round-4 V1), and
-- autocmds created while an event is running do not fire for that occurrence
-- -- without a replay the triggering buffer would silently keep legacy
-- syntax. vim.treesitter.start is idempotent, so replaying a buffer the
-- autocmd will also see (cmd/require-triggered loads) is harmless.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) then
    local ft = vim.bo[buf].filetype
    if ft ~= "" then
      start_treesitter(buf, ft)
    end
  end
end

require("plugins.treesitter_selection").setup({
  init_selection = "gnn",
  node_incremental = "grn",
  node_decremental = "grm",
  scope_incremental = "grc",
})
