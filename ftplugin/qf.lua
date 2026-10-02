vim.opt_local.list = false
-- Holds only until nvim-bqf enables itself on the window (ft = "qf" loads it,
-- auto_enable is on): bqf.main.enable() sets number and signcolumn=number, so
-- its item signs have a column. Everywhere bqf is not enabled, no numbers.
vim.opt_local.number = false
