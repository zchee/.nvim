local hover = require("hover")

hover.config({
  --- @class Hover.UserConfig : Hover.Config
  init = function()
    require("hover.providers.dap")
    require("hover.providers.diagnostic")
    require("hover.providers.dictionary")
    require("hover.providers.fold_preview")
    require("hover.providers.gh")
    require("hover.providers.gh_user")
    require("hover.providers.highlight")
    require("hover.providers.lsp")
    require("hover.providers.man")
  end,
  providers = {
    'hover.providers.diagnostic',
    'hover.providers.lsp',
    'hover.providers.dap',
    'hover.providers.man',
    'hover.providers.dictionary',
  },
  ---@type vim.api.keyset.win_config
  preview_opts = {
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- "double",
  },
  preview_window = false,
  title = false,
  mouse_providers = { 'hover.providers.lsp' },
  mouse_delay = 1000
})
