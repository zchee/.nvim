vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  nested = true,
  callback = function()
    if vim.fn.winnr "$" == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
      vim.api.nvim_cmd(":silent qa!")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.lua" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- github.com/vovkasm/input-source-switcher
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  pattern = { "*" },
  callback = function()
    vim.fn.jobstart('issw com.apple.inputmethod.Kotoeri.RomajiTyping.Roman', { detach = true, pty = true })
  end,
})

-- require ("colorizer").setup()
