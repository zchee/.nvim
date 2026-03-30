local compat = require("plugins.ts_context_commentstring_compat")
local ts_context_commentstring = require("ts_context_commentstring")
local utils = require("ts_context_commentstring.utils")

compat.patch_utils(utils)

---@type ts_context_commentstring.Config
ts_context_commentstring.setup({
  enable_autocmd = false,
  custom_calculation = nil,
  languages = {
    go = { __default = "// %s", __multiline = "/* %s */" },
    lua = { __default = "-- %s", __multiline = "--[[ %s ]]" },
  },
  config = {},
  commentary_integration = nil,
})

vim.g.skip_ts_context_commentstring_module = true
