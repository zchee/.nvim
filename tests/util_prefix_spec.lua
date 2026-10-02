-- lua/util/init.lua -- bun_prefix and nodenv_prefix: the derived absolute
-- path when it is executable, the $PATH fallback with its warning, the
-- derived path handed back when $PATH has no such binary either, and one
-- warning per helper and binary.
--
-- Every case runs against a scratch $BUN_INSTALL / $NODENV_ROOT / $PATH, so
-- no real bun or nodenv install is read. The warn-once table is module state
-- keyed by helper and binary, so each case uses binary names of its own.

vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local util = require("util")

local function assert_equal(got, want, message)
  if got ~= want then
    error(string.format("%s: got %s, want %s", message, vim.inspect(got), vim.inspect(want)))
  end
end

local function assert_contains(haystack, needle, message)
  if not haystack:find(needle, 1, true) then
    error(string.format("%s: %s does not contain %s", message, vim.inspect(haystack), vim.inspect(needle)))
  end
end

-- fs_realpath: on macOS tempname() sits under /var, a link to /private/var,
-- and vim.fn.exepath answers with the path as $PATH spells it.
local root = vim.fn.tempname()
assert(vim.fn.mkdir(root, "p") == 1, "scratch root should be created: " .. root)
root = assert(vim.uv.fs_realpath(root))

--- Writes an executable file at `root`/<...> and returns its path.
---@param ... string path segments below the scratch root
---@return string
local function executable(...)
  local path = vim.fs.joinpath(root, ...)
  assert(vim.fn.mkdir(vim.fs.dirname(path), "p") == 1, "should create the directory of " .. path)
  assert(vim.fn.writefile({ "#!/bin/sh" }, path) == 0, "should write " .. path)
  assert(vim.uv.fs_chmod(path, 493), "should chmod " .. path) -- 0755
  return path
end

local bun_root = vim.fs.joinpath(root, "bun")
local nodenv_root = vim.fs.joinpath(root, "nodenv")
local nodenv_unversioned_root = vim.fs.joinpath(root, "nodenv-unversioned")
local path_dir = vim.fs.joinpath(root, "path")

local bun_direct = executable("bun", "bin", "spec-bun-direct")
local nodenv_direct = executable("nodenv", "versions", "9.9.9", "bin", "spec-nodenv-direct")
assert(vim.fn.writefile({ "9.9.9" }, vim.fs.joinpath(nodenv_root, "version")) == 0, "should write the version file")
assert(vim.fn.mkdir(nodenv_unversioned_root, "p") == 1, "should create the unversioned nodenv root")
local on_path = {}
for _, name in ipairs({ "spec-bun-on-path", "spec-nodenv-on-path", "spec-nodenv-unversioned" }) do
  on_path[name] = executable("path", name)
end

local saved_env = { BUN_INSTALL = vim.env.BUN_INSTALL, NODENV_ROOT = vim.env.NODENV_ROOT, PATH = vim.env.PATH }
local saved_notify = vim.notify

---@type { msg: string, level: integer }[]
local warnings = {}

local ok, err = pcall(function()
  vim.env.BUN_INSTALL = bun_root
  vim.env.NODENV_ROOT = nodenv_root
  vim.env.PATH = path_dir
  vim.notify = function(msg, level)
    warnings[#warnings + 1] = { msg = msg, level = level }
  end

  -- the derived file is executable: returned as is, and nothing is said
  do
    assert_equal(util.bun_prefix("spec-bun-direct"), bun_direct, "bun_prefix must return $BUN_INSTALL/bin/<binary>")
    assert_equal(
      util.nodenv_prefix("spec-nodenv-direct"),
      nodenv_direct,
      "nodenv_prefix must return the binary of the version $NODENV_ROOT/version names"
    )
    assert_equal(#warnings, 0, "an executable derived path must not warn")
  end

  -- the derived file is missing: $PATH answers, with one warning however
  -- often the helper is asked
  do
    for _ = 1, 3 do
      assert_equal(
        util.bun_prefix("spec-bun-on-path"),
        on_path["spec-bun-on-path"],
        "bun_prefix must fall back to $PATH"
      )
    end
    assert_equal(#warnings, 1, "bun_prefix must warn once per binary")
    assert_equal(warnings[1].level, vim.log.levels.WARN, "the fallback notice must be a WARN")
    assert_contains(warnings[1].msg, "util.bun_prefix: ", "the warning must name the helper")
    assert_contains(
      warnings[1].msg,
      vim.fs.joinpath(bun_root, "bin", "spec-bun-on-path") .. " is not executable",
      "the warning must name the derived path"
    )
    assert_contains(
      warnings[1].msg,
      "using " .. on_path["spec-bun-on-path"] .. " from $PATH",
      "the warning must name the $PATH answer"
    )

    for _ = 1, 3 do
      assert_equal(
        util.nodenv_prefix("spec-nodenv-on-path"),
        on_path["spec-nodenv-on-path"],
        "nodenv_prefix must fall back to $PATH"
      )
    end
    assert_equal(#warnings, 2, "nodenv_prefix must warn once per binary")
    assert_contains(warnings[2].msg, "util.nodenv_prefix: ", "the warning must name the helper")
    assert_contains(
      warnings[2].msg,
      vim.fs.joinpath(nodenv_root, "versions", "9.9.9", "bin", "spec-nodenv-on-path") .. " is not executable",
      "the warning must name the derived path"
    )
  end

  -- neither the derived file nor $PATH has the binary: the derived absolute
  -- path comes back, so the spawn error names where it was expected
  do
    warnings = {}
    for _ = 1, 2 do
      assert_equal(
        util.bun_prefix("spec-bun-nowhere"),
        vim.fs.joinpath(bun_root, "bin", "spec-bun-nowhere"),
        "bun_prefix must hand back the derived path when $PATH has no such binary"
      )
    end
    assert_equal(#warnings, 1, "the nothing-found case must warn once as well")
    assert_contains(warnings[1].msg, "spec-bun-nowhere is not on $PATH either", "the warning must say $PATH failed too")
  end

  -- the warn-once key is the helper AND the binary: a binary one helper
  -- already warned about still warns for the other
  do
    warnings = {}
    util.nodenv_prefix("spec-bun-nowhere")
    assert_equal(#warnings, 1, "a binary bun_prefix warned about must still warn for nodenv_prefix")
    assert_contains(warnings[1].msg, "util.nodenv_prefix: ", "that warning must name nodenv_prefix")
  end

  -- an unreadable version file: the reason is the file, the derived path is
  -- the shim, and $PATH answers when it can
  do
    warnings = {}
    vim.env.NODENV_ROOT = nodenv_unversioned_root
    local version_file = vim.fs.joinpath(nodenv_unversioned_root, "version")
    assert_equal(
      util.nodenv_prefix("spec-nodenv-unversioned"),
      on_path["spec-nodenv-unversioned"],
      "nodenv_prefix must fall back to $PATH without a version file"
    )
    assert_equal(#warnings, 1, "an unreadable version file must warn")
    assert_contains(warnings[1].msg, "cannot read " .. version_file, "the warning must name the version file")
    assert_equal(
      util.nodenv_prefix("spec-nodenv-shim-only"),
      vim.fs.joinpath(nodenv_unversioned_root, "shims", "spec-nodenv-shim-only"),
      "without a version file and off $PATH the shim path must come back"
    )

    -- an executable shim does not make the answer trusted: a shim picks its
    -- version from the cwd, so the unreadable version file still decides
    warnings = {}
    local shim = executable("nodenv-unversioned", "shims", "spec-nodenv-shim-present")
    assert_equal(util.nodenv_prefix("spec-nodenv-shim-present"), shim, "the shim path must come back")
    assert_equal(#warnings, 1, "an executable shim must still warn about the version file")
    assert_contains(warnings[1].msg, "cannot read " .. version_file, "that warning must name the version file")
  end
end)

vim.notify = saved_notify
for _, name in ipairs({ "BUN_INSTALL", "NODENV_ROOT", "PATH" }) do
  vim.env[name] = saved_env[name] -- nil unsets
end
vim.fn.delete(root, "rf")

if not ok then
  error(err, 0)
end
print("ALL PASS: util_prefix_spec")
