if vim.g.vscode then
  require("code")
  return
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
-- Must be the real key, not the string "<BS>": <LocalLeader> expands by
-- copying this value verbatim, so a literal "<BS>" binds mappings to those
-- four characters instead of Backspace, and nothing ever matches them.
vim.g.maplocalleader = vim.keycode("<BS>")

-- Ensure Neovim has a usable RPC server address.
-- When $XDG_RUNTIME_DIR points at an unwritable directory (e.g. a root-owned
-- /tmp/run/user/$UID created via `sudo mkdir`), Neovim cannot create its default
-- socket at startup and `v:servername` is left empty. Child jobs then never
-- inherit $NVIM, which silently breaks RPC-based plugins such as
-- github-preview.nvim (its Bun backend aborts when $NVIM is unset). Start a
-- server on a writable temp path as a fallback so RPC keeps working regardless
-- of the runtime-dir environment.
if vim.v.servername == nil or vim.v.servername == "" then
  pcall(vim.fn.serverstart, vim.fn.tempname())
end

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
      { vim.trim(out or ""), "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("config.lazy")

require("config")
