vim.opt_local.comments:append("b:#")
vim.opt_local.comments:append("b:#\\:")

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "kitty.conf", "*/kitty/*.conf" },
  callback = function()
    vim.b.filetype = "kitty"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*/kitty/*.session" },
  callback = function()
    vim.b.filetype = "kitty-session"
  end,
})
