local bufferline = require("bufferline")

---@type bufferline.Options
bufferline.setup({
  options = {
    mode = "buffers",                    -- "tabs"
    numbers = "buffer_id",               -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string
    close_command = "bdelete! %d",       -- string | function
    right_mouse_command = "bdelete! %d", -- string | function
    left_mouse_command = "buffer %d",    -- string | function
    middle_mouse_command = nil,          -- string | function
    indicator = {
      icon = "▎",
    },
    buffer_close_icon = " ",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
    --   -- remove extension from markdown files for example
    --   if buf.name:match('%.md') then
    --     return vim.fn.fnamemodify(buf.name, ':t:r')
    --   end
    -- end,

    max_name_length = 18,
    max_prefix_length = 15,   -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or ""
      return " " .. icon .. count
    end,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    --
    -- custom_filter = function(buf_number, buf_numbers)
    --   -- filter out filetypes you don't want to see
    --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
    --     return true
    --   end
    --   -- filter out by buffer name
    --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
    --     return true
    --   end
    --   -- filter out based on arbitrary rules
    --   -- e.g. filter out vim wiki buffer from tabline in your work repo
    --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
    --     return true
    --   end
    --   -- filter out by it's index number in list (don't show first buffer)
    --   if buf_numbers[1] ~= buf_number then
    --     return true
    --   end
    -- end,
    offsets = { { filetype = "NvimTree", text = "File Explorer" } }, --  | function , text_align = "left" | "center" | "right"
    color_icons = true,                                              -- | false, -- whether or not to add the filetype icon highlights
    -- get_element_icon = function(opts)
    --   return require('nvim-web-devicons').get_icon(vim.fn.fnamemodify(opts.path, ":t"), opts.extension,
    --     { default = true })
    --   -- return require('bufferline.utils').get_icon(vim.fn.fnamemodify(opts.path, ":t"), opts.extension, {
    --   --   default = true,
    --   -- })
    -- end,
    show_buffer_icons = false,       -- | false, -- disable filetype icons for buffers
    show_buffer_close_icons = false, -- | false,
    show_close_icon = false,         -- | false,
    show_tab_indicators = true,      -- | false,
    persist_buffer_sort = true,      -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "slant",        -- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = true,      -- | true,
    always_show_bufferline = true,    -- | false,
    sort_by = "insert_after_current", -- |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' |
    --   function(buffer_a, buffer_b)
    --   -- add custom logic
    --   return buffer_a.modified > buffer_b.modified
    -- end
  },
  -- - guifg -> fg
  -- - guibg -> bg
  -- - guisp -> sp
  -- - gui -> underline = true, undercurl = true, italic = true
  highlights = {
    fill = {
      bg = {
        attribute = "bg",
        highlight = "Pmenu",
      },
    },
    -- group_separator = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- group_label = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- tab = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- tab_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- tab_close = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- close_button = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- close_button_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- close_button_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- background = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- buffer = {
    --   fg = {
    --     attribute = "bg",
    --     highlight = "Pmenu",
    --   },
    --   bg = {
    --     attribute = "fg",
    --     highlight = "Pmenu",
    --   },
    -- },
    -- buffer_visible = {
    --   fg = {
    --     attribute = "bg",
    --     highlight = "Pmenu",
    --   },
    --   bg = {
    --     attribute = "fg",
    --     highlight = "Pmenu",
    --   },
    -- },
    -- buffer_selected = {
    --   fg = {
    --     attribute = "bg",
    --     highlight = "Pmenu",
    --   },
    --   bg = {
    --     attribute = "fg",
    --     highlight = "Pmenu",
    --   },
    --   gui = "bold,italic"
    -- },
    -- numbers = {
    --   fg = {
    --     attribute = "fg",
    --     highlight = "Pmenu",
    --   },
    --   bg = {
    --     attribute = "bg",
    --     highlight = "Pmenu",
    --   },
    -- },
    -- numbers_selected = {
    --   fg = {
    --     attribute = "fg",
    --     highlight = "Pmenu",
    --   },
    --   bg = {
    --     attribute = "bg",
    --     highlight = "Pmenu",
    --   },
    -- },
    -- numbers_visible = {
    --   fg = {
    --     attribute = "fg",
    --     highlight = "Pmenu",
    --   },
    --   bg = {
    --     attribute = "bg",
    --     highlight = "Pmenu",
    --   },
    -- },
    -- diagnostic = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- diagnostic_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- diagnostic_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic"
    -- },
    -- hint = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- hint_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- hint_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- hint_diagnostic = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- hint_diagnostic_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- hint_diagnostic_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    -- },
    -- info = {
    --   fg = "#fff714",
    --   guisp = "#c7106b",
    --   bg = "#c7106b"
    -- },
    -- info_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- info_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic",
    --   guisp = "#c7106b"
    -- },
    -- info_diagnostic = {
    --   fg = "#fff714",
    --   guisp = "#c7106b",
    --   bg = "#c7106b"
    -- },
    -- info_diagnostic_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- info_diagnostic_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic",
    --   guisp = "#c7106b"
    -- },
    -- warning = {
    --   fg = "#fff714",
    --   guisp = "#c7106b",
    --   bg = "#c7106b"
    -- },
    -- warning_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- warning_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic",
    --   guisp = "#c7106b"
    -- },
    -- warning_diagnostic = {
    --   fg = "#fff714",
    --   guisp = "#c7106b",
    --   bg = "#c7106b"
    -- },
    -- warning_diagnostic_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- warning_diagnostic_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic",
    --   -- guisp = warning_diagnostic_fg
    -- },
    -- error = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   guisp = "#c7106b"
    -- },
    -- error_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- error_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic",
    --   sp = "#c7106b"
    -- },
    -- error_diagnostic = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   sp = "#c7106b"
    -- },
    -- error_diagnostic_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- error_diagnostic_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic",
    --   sp = "#c7106b"
    -- },
    -- modified = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- modified_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- modified_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- duplicate_selected = {
    --   fg = "#fff714",
    --   gui = "italic",
    --   bg = "#c7106b"
    -- },
    -- duplicate_visible = {
    --   fg = "#fff714",
    --   gui = "italic",
    --   bg = "#c7106b"
    -- },
    -- duplicate = {
    --   fg = "#fff714",
    --   gui = "italic",
    --   bg = "#c7106b"
    -- },
    separator_selected = {
      fg = {
        attribute = "bg",
        highlight = "Pmenu",
      },
      -- bg = "#c7106b"
    },
    separator_visible = {
      fg = {
        attribute = "bg",
        highlight = "Pmenu",
      },
      -- bg = "#c7106b"
    },
    separator = {
      fg = {
        attribute = "bg",
        highlight = "Pmenu",
      },
      -- bg = "#c7106b"
    },
    -- indicator_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b"
    -- },
    -- pick_selected = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic"
    -- },
    -- pick_visible = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic"
    -- },
    -- pick = {
    --   fg = "#fff714",
    --   bg = "#c7106b",
    --   gui = "bold,italic"
    -- },
  },
})
