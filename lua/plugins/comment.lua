local comment = require("Comment")
local ft = require("Comment.ft")

local ts_comment = require("ts_context_commentstring.integrations.comment_nvim")

---@class CommentConfig
local comment_config = {
  padding = true,
  sticky = true,
  -- ignore = "",
  toggler = {
    line = "gc",
    block = "gbc",
  },
  opleader = {
    line = "disable",  -- hack
    block = "disable", -- hack
  },
  extra = {
    above = "gcO",
    below = "gco",
    eol = "gcA",
  },
  mappings = {
    basic = false,
    extra = false,
    extended = false,
  },
  pre_hook = ts_comment.create_pre_hook(),
}
comment.setup(comment_config)

-- ft.c = { "//%s", "/*%s*/" }
-- ft.gitconfig = { "#%s" }
-- ft.go = { "//%s", "//%s" }
-- ft.gomod = { "//%s" }
-- ft.gotexttmpl = { "//%s" }
-- ft.gotmpl = { "//%s" }
-- ft.gowork = { "//%s" }
-- ft.graphql = { "#%s" }
-- ft.kitty = { "#%s" }
-- ft.lua = { '//%s', '/*%s*/' }
-- ft.proto = { "//%%s" }
-- ft.rust = { "//%s" }
-- ft.terraform = { "//%s" }
-- ft.tiltfile = { "#%s" }
-- ft.toml = { "#%s" }
-- ft.yaml = { "#%s" }

-- local ft = require('Comment.ft')
--
-- -- 1. Using set function
--
-- ft
--  -- Set only line comment
--  .set('yaml', '#%s')
--  -- Or set both line and block commentstring
--  .set('javascript', {'//%s', '/*%s*/'})
--
-- -- 2. Metatable magic
--
-- ft.javascript = {'//%s', '/*%s*/'}
-- ft.yaml = '#%s'
--
-- -- Multiple filetypes
-- ft({'go', 'rust'}, ft.get('c'))
-- ft({'toml', 'graphql'}, '#%s')

-- vim.keymap.del('n', 'gcc')
-- vim.keymap.set({ "n" }, "gc", "<Plug>(comment_toggle_linewise_current)",
--   { noremap = true, nowait = true, expr = true, desc = "Comment toggle current line" })
-- vim.keymap.set({ "x" }, "gc", "<Plug>(comment_toggle_linewise_visual)",
--   { noremap = true, nowait = true, desc = "Comment toggle linewise (visual)" })

-- local comment = require("Comment")
-- local ft = require("Comment.ft")
-- local ts_comment = require("ts_context_commentstring.integrations.comment_nvim")

-- ---@class CommentConfig
-- local comment_config = {
--   padding = true,
--   sticky = true,
--   ignore = "",
--   toggler = {
--     line = "gc",
--     block = "gb",
--   },
--   opleader = {
--     line = "disable",  -- hack
--     block = "disable", -- hack
--   },
--   extra = {
--     above = "gcO",
--     below = "gco",
--     eol = "gcA",
--   },
--   mappings = {
--     basic = false,
--     extra = false,
--   },
--   pre_hook = ts_comment.create_pre_hook(),
-- }
--
-- comment.setup(comment_config)
--
-- vim.keymap.del('n', 'gcc')
-- --- map-overview
-- --- normal
-- vim.keymap.set(
--   { "n" },
--   "gc",
--   "<Plug>(comment_toggle_linewise_current)",
--   { noremap = false, silent = true, nowait = true }
-- )
