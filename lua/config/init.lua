local lazy_clipboard
lazy_clipboard = "unnamedplus" -- vim.opt.clipboard
vim.opt.clipboard = ""

require("config.nvim")

require("config.keymap")
require("config.autocmd")
require("config.command")
require("config.highlight")

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
