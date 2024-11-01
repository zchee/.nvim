local chowcho = require("chowcho")

chowcho.setup({
  icon_enabled = true,
  -- text_color = '#FFFFFF',
  -- bg_color = '#555555',
  -- active_border_color = '#0A8BFF',
  border_style = "rounded",
  use_exclude_default = false,
  -- exclude = function(buf, win)
  --   _ = win
  --   -- Exclude a window from the choice based on its buffer information.
  --   -- This option is applied iff `use_exclude_default = false`.
  --   -- Note that below is identical to the `use_exclude_default = true`.
  --   local fname = vim.fn.expand('#' .. buf .. ':t', nil, {})
  --   return fname == ''
  -- end
})
