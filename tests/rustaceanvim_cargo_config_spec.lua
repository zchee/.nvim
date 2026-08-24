---@diagnostic disable: undefined-global
-- Regression spec for the dev cargo config wiring in
-- lua/plugins/rustaceanvim.lua.
--
-- rust-analyzer hands `cargo.configPath` to every cargo it spawns -- metadata,
-- build scripts, clippy, runnables -- as `--config <path>`, so the value has to
-- be an absolute path that exists. cargo does no tilde expansion, rust-analyzer
-- joins a relative path onto the workspace root, and a path cargo cannot read
-- fails `cargo metadata` outright, which loses the whole client rather than one
-- check. The path comes from util.xdg_config_home(), which is readlink-based:
-- it resolves a symlinked XDG_CONFIG_HOME to its target and answers "" for
-- anything else.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local original_config_home = vim.env.XDG_CONFIG_HOME

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

--- Reloads the module with XDG_CONFIG_HOME set to `config_home` (nil unsets it)
--- and returns the rust-analyzer `cargo` settings it published.
---@param config_home string?
---@return table
local function cargo_settings(config_home)
  vim.env.XDG_CONFIG_HOME = config_home
  package.loaded["plugins.rustaceanvim"] = nil
  package.loaded["util"] = nil

  local ok, err = pcall(require, "plugins.rustaceanvim")

  vim.env.XDG_CONFIG_HOME = original_config_home
  package.loaded["plugins.rustaceanvim"] = nil

  if not ok then
    error(err)
  end
  return vim.g.rustaceanvim.server.default_settings["rust-analyzer"].cargo
end

--- Builds `<tmp>/link -> <tmp>/real`, the shape this machine's XDG_CONFIG_HOME
--- has (~/.config points into the dotfiles checkout).
---@return string root, string real, string link
local function symlinked_config_home()
  local root = vim.fn.tempname()
  local real = vim.fs.joinpath(root, "real")
  local link = vim.fs.joinpath(root, "link")
  assert(vim.fn.mkdir(vim.fs.joinpath(real, "rust"), "p") == 1, "temp config home should be created")
  assert(vim.uv.fs_symlink(real, link), "temp config home symlink should be created")
  return root, real, link
end

do
  local root, real, link = symlinked_config_home()
  vim.fn.writefile({ "[build]" }, vim.fs.joinpath(real, "rust", "config.dev.toml"))

  local ok, cargo = pcall(cargo_settings, link)
  vim.fn.delete(root, "rf")
  assert(ok, cargo)

  assert_equal(
    vim.fs.joinpath(real, "rust", "config.dev.toml"),
    cargo.configPath,
    "configPath should be the dev cargo config under the resolved XDG_CONFIG_HOME"
  )
end

do
  local root, _, link = symlinked_config_home()

  local ok, cargo = pcall(cargo_settings, link)
  vim.fn.delete(root, "rf")
  assert(ok, cargo)

  assert_equal(nil, cargo.configPath, "configPath should stay unset when the dev cargo config does not exist")
end

do
  -- Environments util.xdg_config_home() cannot answer for: XDG_CONFIG_HOME
  -- unset (a GUI/launchd-started nvim) or pointing at a real directory rather
  -- than a symlink. Losing the dev config there is acceptable; handing cargo a
  -- path that does not resolve is not, so the only invariant is that a set
  -- configPath is always readable.
  local root = vim.fn.tempname()
  assert(vim.fn.mkdir(vim.fs.joinpath(root, "rust"), "p") == 1, "temp config home should be created")
  vim.fn.writefile({ "[build]" }, vim.fs.joinpath(root, "rust", "config.dev.toml"))

  for _, config_home in ipairs({ root, vim.NIL }) do
    local ok, cargo = pcall(cargo_settings, config_home ~= vim.NIL and config_home or nil)
    assert(ok, cargo)

    if cargo.configPath ~= nil then
      assert(
        vim.uv.fs_stat(cargo.configPath),
        string.format("configPath %s must exist on disk -- cargo hard-errors on one it cannot read", cargo.configPath)
      )
    end
  end

  vim.fn.delete(root, "rf")
end
