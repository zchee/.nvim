vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = {
    ".tigrc",
    "tigrc",
  },
  callback = function()
    vim.bo.filetype = "tigrc"
  end,
})
