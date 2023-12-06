local comment = require("Comment")
local comment_ft = require("Comment.ft")

local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
local ts_pre_hook
if loaded and ts_comment then
  ts_pre_hook = ts_comment.create_pre_hook()
end

comment.setup({
  padding = true,
  on_config_done = nil,
  sticky = true,
  mappings = {
    basic = true,
    extra = false,
    extended = false,
  },
  toggler = {
    line = "gc",
    block = "gbc",
  },
  opleader = {
    line = "disable", -- hack
    block = "gb",
  },
  extra = {
    above = "gcO",
    below = "gco",
    eol = "gcA",
  },
  pre_hook = ts_pre_hook,
  -- pre_hook = function(ctx)
  --   -- Only calculate commentstring for tsx filetypes
  --   if not vim.bo.filetype == 'typescriptreact' then
  --     return ""
  --   end
  --
  --   local U = require('Comment.utils')
  --
  --   -- Determine whether to use linewise or blockwise commentstring
  --   local type = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'
  --
  --   -- Determine the location where to calculate commentstring from
  --   local location = nil
  --   if ctx.ctype == U.ctype.blockwise then
  --     location = require('ts_context_commentstring.utils').get_cursor_location()
  --   elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
  --     location = require('ts_context_commentstring.utils').get_visual_start_location()
  --   end
  --
  --   local commentstring = require('ts_context_commentstring.internal').calculate_commentstring({
  --     key = type,
  --     location = location,
  --   })
  --   if commentstring then
  --     return commentstring
  --   end
  --
  --   return ""
  -- end,

  -- Post-hook, called after commenting is done
  -- fun(ctx: Ctx)
  post_hook = function(ctx)
    if ctx.range.srow == ctx.range.erow then
      return
    else
      return
    end
  end,
})

comment_ft.terraform = "//%s"
