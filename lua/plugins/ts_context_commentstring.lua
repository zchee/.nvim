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

-- Wire context-aware commentstrings into the BUILT-IN gc commenting
-- (upstream-documented native integration): native commenting resolves
-- 'commentstring' through vim.filetype.get_option(), so return the
-- treesitter-context value there and fall back for everything else.
local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
  if option == "commentstring" then
    local ctx = require("ts_context_commentstring.internal").calculate_commentstring()
    if ctx then
      return ctx
    end
  end
  return get_option(filetype, option)
end
