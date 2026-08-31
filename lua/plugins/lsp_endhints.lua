local lsp_endhints_pattern = {
  -- "*.go",
  "*.lua",
  "*.py",
}

-- setup() is idempotent configuration, not a per-buffer toggle: calling it on
-- every LspAttach/LspDetach re-ran the whole plugin setup each time. Run it
-- once on the first matching attach; autoEnableHints keeps enabling hints for
-- later attaches on its own.
local configured = false
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
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
