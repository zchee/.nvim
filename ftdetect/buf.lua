vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  pattern = { "buf.gen", "buf.lock", "buf.mod", "buf.work" },
  callback = function()
    vim.bo.filetype = "yaml"
  end,
})
