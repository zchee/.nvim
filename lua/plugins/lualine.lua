local lualine = require("lualine")

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "equinusocio_material",
    component_separators = {
      left = " ",
      right = "",
    },
    section_separators = {
      left = "",
      right = "",
    },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
      },
    },
    lualine_b = {
      {
        "filename",
        path = 3,
        shorting_target = 40,
        symbols = {
          modified = "[+]",      -- Text to show when the file is modified.
          readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]",     -- Text to show for newly created file before first write
        },
      },
      {
        "branch",
        padding = {
          left = 0,
          right = 1,
        },
      },
      {
        "filetype",
        color = {
          gui = "bold",
        },
        padding = {
          left = 1,
          right = 1,
        },
      },
      "diff",
      "diagnostics",
      "location",
    },
    lualine_c = {
    },
    lualine_x = {
      "filetype",
      "encoding",
    },
    lualine_y = {
      "location",
    },
    lualine_z = {
      "progress",
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
