local chowcho = require("chowcho")

-- local win_keymap_set = function(key, callback)
--   vim.keymap.set({ "n", "t" }, "<C-w><C-" .. key .. ">", callback)
-- end
--
-- win_keymap_set("w", function()
--   local wins = 0
--
--   for i = 1, vim.fn.winnr("$") do
--     local win_id = vim.fn.win_getid(i)
--     local conf = vim.api.nvim_win_get_config(win_id)
--
--     if conf.focusable then
--       wins = wins + 1
--
--       if wins > 2 then
--         chowcho.run()
--         return
--       end
--     end
--   end
--
--   vim.api.nvim_command("wincmd w")
-- end)

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
