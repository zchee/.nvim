local lsp_endhints_pattern = {
  -- "*.go",
  "*.lua",
  "*.py",
}

-- setup() is idempotent configuration, not a per-buffer toggle: calling it on
-- every LspAttach re-ran the whole plugin setup each time. Run it once on the
-- first matching attach; autoEnableHints keeps enabling hints for later
-- attaches on its own. The augroup is load-bearing: this module runs inside
-- the LspAttach that loads the plugin, and lazy.nvim replays that event only
-- for autocmds in augroups created by the load, so an ungrouped autocmd
-- missed the first attach and left its buffer without hints.
local configured = false
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("plugins.lsp_endhints", { clear = true }),
  pattern = lsp_endhints_pattern,
  callback = function()
    if configured then
      return
    end
    configured = true
    require("lsp-endhints").setup({
      icons = {
        type = "󰜁  ",
        parameter = "󰏪  ",
        offspec = "  ",
        unknown = "  ",
      },
      label = {
        truncateAtChars = 100,
        padding = 1,
        marginLeft = 3,
        sameKindSeparator = ", ",
      },
      extmark = {
        priority = 3000,
      },
      autoEnableHints = true,
    })
  end,
})
