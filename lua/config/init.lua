local lazy_clipboard
lazy_clipboard = "unnamedplus" -- vim.opt.clipboard
vim.opt.clipboard = ""

require("config.nvim")

-- Statusline/tabline: the hand-rolled config.chrome (round-3 W3.2) or the
-- lualine+bufferline pair it replaced, per config.ui_mode. chrome must run
-- before the first UI draw so the default statusline never flashes (the
-- replaced plugins were VeryLazy and did flash), and after config.nvim so
-- the colorscheme's Pmenu/Normal/Diagnostic* values are readable.
-- require+setup is ~0.5 ms; the switch itself adds one state-file read.
require("config.ui_mode").setup()

require("config.keymap")
require("config.autocmd")

-- User commands load synchronously: 'keywordprg' is ":Help" (config.nvim),
-- so K, +'Help ...' on the command line and any headless run (where
-- VeryLazy never fires) need :Help before the UI is up. Measured
-- 2026-09-29 with vim.loader on: 0.29 ms median over 11 cold requires. The
-- former highlight override module is folded into
-- colors/equinusocio_material.lua.
require("config.command")

-- Cooperative insert-stack warmup (round-2 R2): arms only on UIEnter, so
-- headless sessions are untouched; costs one autocmd registration here.
require("config.warmup").setup()

if lazy_clipboard ~= nil then
  vim.opt.clipboard = lazy_clipboard
end

---@class SemanticTokenModifiers
---@field declaration boolean?
---@field documentation boolean?
---@field global boolean?

---@class SemanticToken
---@field line number
---@field start_col number
---@field end_col number
---@field marked boolean
---@field type string
---@field modifiers SemanticTokenModifiers
