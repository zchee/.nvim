jit.off()
jit.opt.start(3)
jit.opt.start("-fma")
jit.opt.start("-dce")
-- jit.opt.start("hotloop=10", "hotexit=2")
jit.opt.start("hotloop=1")
jit.opt.start("loopunroll=1000000")
jit.opt.start("sizemcode=524288")
jit.opt.start("maxtrace=8000", "maxrecord=16000", "minstitch=3", "maxmcode=40960")
-- jit.opt.start("-fma", "maxtrace=10000", "maxrecord=40000", "maxirconst=10000", "loopunroll=100")
jit.on(true, true)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.api.nvim_echo({
    {
      "Cloning lazy.nvim\n\n",
      "DiagnosticInfo",
    },
  }, true, {})
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local ok, out = pcall(vim.fn.system, {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=main",
    lazyrepo,
    lazypath,
  })
  if not ok or vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim\n", "ErrorMsg" },
      { vim.trim(out or ""),           "WarningMsg" },
      { "\nPress any key to exit...",  "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " " -- use "<Space>"?
vim.g.maplocalleader = "<BS>"

require("config.lazy")

require("config")
