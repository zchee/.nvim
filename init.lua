-- Byte-compile and cache Lua modules. Must run before any require so every
-- module load hits the cache. The one loadfile-sensitive site,
-- lua/nvim-treesitter/parsers.lua, reads source text directly instead of
-- loadfile (vim.loader patches loadfile to serve bytecode, which trips
-- "wrong mode" there) -- pinned by tests/parsers_overlay_loader_spec.lua.
vim.loader.enable()

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
  local ok, err = pcall(vim.fn.serverstart, vim.fn.tempname())
  if not ok then
    -- The failure mode this fallback exists for is silent, so say it failed.
    vim.notify(
      "init.lua: no RPC server address and the serverstart fallback failed ("
        .. tostring(err)
        .. "); child jobs get no $NVIM, so RPC plugins such as github-preview.nvim will not work",
      vim.log.levels.WARN
    )
  end
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
    -- Nothing can answer getchar() without a UI: a headless bootstrap
    -- (`nvim --headless "+Lazy! sync" +qa`) blocks on it forever, and an
    -- `nvim -l` run exits 0 there as if the clone had worked.
    if #vim.api.nvim_list_uis() > 0 then
      vim.fn.getchar()
    end
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("config.lazy")

require("config")
