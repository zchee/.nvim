-- nvim-lint: ruff lints Python. golangci-lint is held off Go buffers (the
-- `go` entry below is commented out) until its runs on the real projects
-- pass; the cmd override stays so re-enabling it keeps the absolute
-- binary, which keeps the mise shim (it prints errors to stdout, which
-- breaks the JSON decode) out of the loop.
local util = require("util")

local lint = require("lint")

lint.linters.golangcilint.cmd = util.go_path("bin", "golangci-lint")

lint.linters_by_ft = {
  -- go = { "golangcilint" },
  python = { "ruff" },
}

local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

local function has_linter(buf)
  return lint.linters_by_ft[vim.api.nvim_get_option_value("filetype", { buf = buf })] ~= nil
end

-- FileType (not BufReadPost) for the read-time trigger: the lazy spec loads
-- this module during the first buffer's BufReadPost, when 'filetype' is not
-- set yet and try_lint() would resolve zero linters for that buffer.
-- Both events stay immediate; only filetypes with a configured linter fire.
vim.api.nvim_create_autocmd({ "FileType", "BufWritePost" }, {
  group = lint_augroup,
  callback = function(args)
    if not has_linter(args.buf) then
      return
    end
    lint.try_lint()
  end,
})

-- InsertLeave can fire in rapid bursts; debounce trailing-edge per buffer so
-- at most one lint run starts per 500 ms quiet window.
local lint_timers = {} ---@type table<integer, any> uv timer handle per buffer

vim.api.nvim_create_autocmd("InsertLeave", {
  group = lint_augroup,
  callback = function(args)
    local buf = args.buf
    if not has_linter(buf) then
      return
    end

    local timer = lint_timers[buf]
    if not timer then
      timer = assert(vim.uv.new_timer())
      lint_timers[buf] = timer
    end
    timer:stop()
    timer:start(
      500,
      0,
      vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_call(buf, function()
            lint.try_lint()
          end)
        end
      end)
    )
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = lint_augroup,
  callback = function(args)
    local timer = lint_timers[args.buf]
    if timer then
      timer:stop()
      timer:close()
      lint_timers[args.buf] = nil
    end
  end,
})

if lint.linters_by_ft[vim.bo.filetype] then
  lint.try_lint()
end
