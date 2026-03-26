local lualine = require("lualine")

-- Autocommand to update untracked status only on save or load
-- https://github.com/pietervdheijden/dotfiles/commit/cc0a7aad212a
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
  pattern = "*",
  callback = function()
    local filepath = vim.fn.expand("%:p")
    if filepath == "" then
      vim.b.untracked_status = ""
      return
    end

    -- Check if the file is untracked
    local git_status = vim.fn.systemlist("git ls-files --others --exclude-standard " .. filepath)
    if #git_status > 0 then
      vim.b.untracked_status = "Untracked"
    else
      vim.b.untracked_status = ""
    end
  end,
})

local get_branch = function()
  local result
  local on_exit = function(obj)
    result = obj.stdout:gsub("\n", "")
  end
  vim.system({ "git", "branch", "--show-current", "--no-color", "--omit-empty" }, { text = false }, on_exit):wait()
  return " " .. result
end

-- { 'fileformat', icons_enabled = true }
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
      statusline = 500,
      tabline = 500,
      winbar = 500,
      refresh_time = 16, -- ~60fps
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
        get_branch,
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
      {
        "fileformat",
        icons_enabled = false,
      },
    },
    lualine_c = {
    },
    lualine_x = {
      "filetype",
      "encoding",
    },
    lualine_y = {
      -- "location",
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
