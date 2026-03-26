local ts_context_commentstring = require("ts_context_commentstring")

---@type ts_context_commentstring.Config
ts_context_commentstring.setup({
  enable_autocmd = true,
  custom_calculation = nil,
  languages = {
    go = { __default = "// %s", __multiline = "/* %s */" },
    lua = { __default = "-- %s", __multiline = "--[[ %s ]]" },
  },
  config = {},
  commentary_integration = nil,
})

vim.g.skip_ts_context_commentstring_module = true
