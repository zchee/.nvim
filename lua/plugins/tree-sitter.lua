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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
    if highlight_skip[lang] then
      return
    end
    -- *.dockerfile files kept tree-sitter highlighting off under master
    -- (TSBufDisable autocmd); preserve that behavior.
    if lang == "dockerfile" and vim.api.nvim_buf_get_name(ev.buf):match("%.dockerfile$") then
      return
    end
    -- no parser (or no queries) for this language: silently keep legacy
    -- syntax highlighting
    if not pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end
    if not indent_skip[lang] then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("plugins.treesitter_selection").setup({
  init_selection = "gnn",
  node_incremental = "grn",
  node_decremental = "grm",
  scope_incremental = "grc",
})
