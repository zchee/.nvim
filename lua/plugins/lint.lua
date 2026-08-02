-- nvim-lint: successor of the none-ls diagnostic sources. ruff carries over
-- directly; golangci-lint is reactivated from null-ls.lua's long-commented
-- source -- pinning the absolute binary keeps the mise shim (which prints
-- errors to stdout and used to crash the JSON decode) out of the loop.
local util = require("util")

local lint = require("lint")

lint.linters.golangcilint.cmd = util.go_path("bin", "golangci-lint")

lint.linters_by_ft = {
  go = { "golangcilint" },
  python = { "ruff" },
}

-- FileType (not BufReadPost) for the read-time trigger: the lazy spec loads
-- this module during the first buffer's BufReadPost, when 'filetype' is not
-- set yet and try_lint() would resolve zero linters for that buffer.
vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
  callback = function()
    require("lint").try_lint()
  end,
})

if lint.linters_by_ft[vim.bo.filetype] then
  lint.try_lint()
end
