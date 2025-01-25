vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  pattern = { "npmrc", ".npmrc" },
  callback = function()
    vim.bo.filetype = "npmrc"
  end,
})
