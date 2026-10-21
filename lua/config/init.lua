local lazy_clipboard
lazy_clipboard = "unnamedplus" -- vim.opt.clipboard
vim.opt.clipboard = ""

require("config.nvim")

-- Statusline/tabline: the hand-rolled config.chrome or the
-- lualine+bufferline pair, per config.ui_mode. chrome must run before the
-- first UI draw so the default statusline never flashes, and after
-- config.nvim so the colorscheme's Pmenu/Normal/Diagnostic* values are
-- readable.
-- require+setup is ~0.5 ms; the switch itself adds one state-file read.
require("config.ui_mode").setup()

require("config.keymap")
require("config.autocmd")

-- User commands load synchronously: 'keywordprg' is ":Help" (config.nvim),
-- so K, +'Help ...' on the command line and any headless run (where
-- VeryLazy never fires) need :Help before the UI is up. The require
-- costs ~0.3 ms with vim.loader on.
require("config.command")

-- Cooperative insert-stack warmup: arms only on UIEnter, so headless
-- sessions are untouched; costs one autocmd registration here.
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
