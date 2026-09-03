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

-- User commands are not consulted before the UI is up, so they can wait
-- until VeryLazy. nvim/keymap/autocmd above stay synchronous: they are
-- ordering-sensitive against the first buffer. The former highlight
-- override module is folded into colors/equinusocio_material.lua.
require("util").on_very_lazy(function()
  require("config.command")
end)

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
