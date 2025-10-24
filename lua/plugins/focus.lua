local focus = require("focus")

focus.setup({
  enable = true,                 -- Enable module
  commands = true,               -- Create Focus commands
  autoresize = {
    enable = true,               -- Enable or disable auto-resizing of splits
    width = 200,                 -- Force width for the focused window
    height = 0,                  -- Force height for the focused window
    minwidth = 0,                -- Force minimum width for the unfocused window
    minheight = 0,               -- Force minimum height for the unfocused window
    focusedwindow_minwidth = 0,  -- Force minimum width for the focused window
    focusedwindow_minheight = 0, -- Force minimum height for the focused window
    height_quickfix = 20,        -- Set the height of quickfix panel
  },
  split = {
    bufnew = false, -- Create blank buffer for new split windows
    tmux = false,   -- Create tmux splits instead of neovim splits
  },
  ui = {
    number = false,                    -- Display line numbers in the focussed window only
    relativenumber = false,            -- Display relative line numbers in the focussed window only
    hybridnumber = false,              -- Display hybrid line numbers in the focussed window only
    absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows
    cursorline = false,                -- Display a cursorline in the focussed window only
    cursorcolumn = false,              -- Display cursorcolumn in the focussed window only
    colorcolumn = {
      enable = false,                  -- Display colorcolumn in the foccused window only
      list = '+1',                     -- Set the comma-saperated list for the colorcolumn
    },
    signcolumn = false,                -- Display signcolumn in the focussed window only
    winhighlight = false,              -- Auto highlighting for focussed/unfocussed windows
  },
})

local augroup = vim.api.nvim_create_augroup("Focus", { clear = false })

-- legacy
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  group = augroup,
  pattern = { "*" },
  desc = "Disable autoresize after read buffers",
  once = true,
  callback = function()
    focus.config.autoresize.enable = false
  end,
})

-- local minwidth = focus.config.autoresize.minwidth
-- local ignore_filetype = { "neo-tree", "nofile", "prompt", "popup" }
-- -- "CursorHold"
-- vim.api.nvim_create_autocmd({ 'CursorHold', 'FileType' }, {
--   group = augroup,
--   pattern = { "*" },
--   desc = "Disable autoresize after read buffers",
--   callback = function()
--     -- same as `slices.Contains` in Go
--     local function contains(table, element)
--       for _, value in pairs(table) do
--         if value == element then
--           return true
--         end
--       end
--       return false
--     end
--
--     print(vim.o.filetype, contains(ignore_filetype, vim.o.filetype))
--     if contains(ignore_filetype, vim.o.filetype) then
--       focus.config.autoresize.enable = false
--       minwidth = focus.config.autoresize.minwidth
--       focus.config.autoresize.minwidth = 0
--     else
--       focus.config.autoresize.enable = true
--       focus.config.autoresize.minwidth = minwidth
--     end
--   end,
-- })
