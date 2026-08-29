---@diagnostic disable: undefined-global
-- Regression spec for the dev cargo config wiring in
-- lua/plugins/rustaceanvim.lua.
--
-- rust-analyzer hands `cargo.configPath` to every cargo it spawns -- metadata,
-- build scripts, clippy, runnables -- as `--config <path>`, so the value has to
-- be an absolute path that exists. cargo does no tilde expansion, rust-analyzer
-- joins a relative path onto the workspace root, and a path cargo cannot read
-- fails `cargo metadata` outright, which loses the whole client rather than one
-- check. The path comes from util.xdg_config_home(), which is realpath-based:
-- it resolves XDG_CONFIG_HOME through every symlink on the way, falls back to
-- ~/.config when the variable is unset, and always answers with an absolute
-- path -- one that may still not exist, which is what the stat guard in
-- cargo_dev_config_path() is for.
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
  -- fs_realpath resolves the whole path, so the expectation has to as well: on
  -- macOS tempname() sits under /var, itself a link to /private/var. Resolve it
  -- while the tree is still there -- the delete below makes it unresolvable.
  local expected = vim.fs.joinpath(assert(vim.uv.fs_realpath(real)), "rust", "config.dev.toml")

  local ok, cargo = pcall(cargo_settings, link)
  vim.fn.delete(root, "rf")
  assert(ok, cargo)

  assert_equal(
    expected,
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
  -- The environments a readlink-based xdg_config_home() used to answer "" for:
  -- XDG_CONFIG_HOME pointing at a real directory rather than a symlink, and
  -- XDG_CONFIG_HOME unset (a GUI/launchd-started nvim). "" made vim.fs.joinpath
  -- drop its leading segment and hand cargo a relative path; both now resolve.
  -- A real directory holding the file must therefore produce a configPath, and
  -- in every case a set configPath has to be readable.
  local root = vim.fn.tempname()
  assert(vim.fn.mkdir(vim.fs.joinpath(root, "rust"), "p") == 1, "temp config home should be created")
  vim.fn.writefile({ "[build]" }, vim.fs.joinpath(root, "rust", "config.dev.toml"))

  for _, config_home in ipairs({ root, vim.NIL }) do
    local ok, cargo = pcall(cargo_settings, config_home ~= vim.NIL and config_home or nil)
    assert(ok, cargo)

    if config_home ~= vim.NIL then
      assert_equal(
        vim.fs.joinpath(assert(vim.uv.fs_realpath(root)), "rust", "config.dev.toml"),
        cargo.configPath,
        "a real-directory XDG_CONFIG_HOME holding the dev config should still produce a configPath"
      )
    end

    if cargo.configPath ~= nil then
      assert(
        vim.uv.fs_stat(cargo.configPath),
        string.format("configPath %s must exist on disk -- cargo hard-errors on one it cannot read", cargo.configPath)
      )
    end
  end

  vim.fn.delete(root, "rf")
end

do
  -- The analysis target-dir, which reads as redundant beside a configPath that
  -- already names one and has been deleted on that reasoning before. Deleting
  -- it is silent and costly: an environment variable beats a --config value, so
  -- dropping it moves analysis into the shell's own build directory, cargo
  -- locks a build directory exclusively, and checkOnSave keeps clippy running
  -- most of the time -- so the two start waiting on each other.
  local ok, cargo = pcall(cargo_settings, original_config_home)
  assert(ok, cargo)

  local target_dir = cargo.extraEnv.CARGO_TARGET_DIR
  assert(
    type(target_dir) == "string" and target_dir ~= "",
    "CARGO_TARGET_DIR has to stay set, or analysis shares the shell's build lock"
  )

  -- An absolute path is only worth handing cargo when its parent really exists;
  -- otherwise cargo materialises a directory under an absent mount point, once
  -- per analysed crate.
  if vim.startswith(target_dir, "/") then
    local parent = vim.fs.dirname(target_dir)
    local stat = vim.uv.fs_stat(parent)
    assert(
      stat ~= nil and stat.type == "directory",
      string.format("CARGO_TARGET_DIR %s is absolute, so %s has to exist", target_dir, parent)
    )
  end

  -- And whatever it is, it is not the directory the dev config hands the shell.
  if cargo.configPath ~= nil then
    local shell_target = nil
    for _, line in ipairs(vim.fn.readfile(cargo.configPath)) do
      shell_target = shell_target or line:match('^%s*target%-dir%s*=%s*"([^"]+)"')
    end
    if shell_target ~= nil then
      assert(
        vim.fs.normalize(target_dir) ~= vim.fs.normalize(shell_target),
        string.format("analysis must not share the shell's target-dir (%s)", shell_target)
      )
    end
  end
end
