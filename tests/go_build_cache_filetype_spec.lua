---@diagnostic disable: undefined-global
-- Regression spec for the Go build-cache pattern in filetype.lua.
--
-- vim.filetype.add matches `pattern` keys as Lua patterns, so the glob spelling
-- this entry started life with matched nothing: `-` is the lazy quantifier, so
-- "go-build" stood for "gbuild", and `**` is not a wildcard. The failure is
-- silent -- a cached object just opens with no filetype -- and the same shape
-- returns whenever a path with a `-` or a `.` in it is written unescaped, which
-- is why the near-miss assertions below matter as much as the matching one.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local original_cache_home = vim.env.XDG_CACHE_HOME

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

--- Loads filetype.lua with XDG_CACHE_HOME pointed at `cache_home`.
---@param cache_home string
local function load_filetype(cache_home)
  vim.env.XDG_CACHE_HOME = cache_home
  package.loaded["util"] = nil

  local ok, err = pcall(dofile, vim.fs.joinpath(vim.fn.getcwd(), "filetype.lua"))

  vim.env.XDG_CACHE_HOME = original_cache_home
  package.loaded["util"] = nil

  if not ok then
    error(err)
  end
end

do
  local root = vim.fn.tempname()
  assert(vim.fn.mkdir(vim.fs.joinpath(root, "go", "go-build"), "p") == 1, "temp cache home should be created")
  -- util.xdg_cache_home() resolves symlinks, and on macOS tempname() sits under
  -- /var, itself a link to /private/var, so the pattern is built from the
  -- resolved path and the filenames tested against it have to be too.
  local cache = assert(vim.uv.fs_realpath(root))

  load_filetype(root)

  assert_equal(
    "go",
    vim.filetype.match({ filename = vim.fs.joinpath(cache, "go", "go-build", "ab", "abcdef-d") }),
    "an object in the Go build cache should be detected as Go source"
  )

  -- The lazy-quantifier reading of `go-build`: this is what the broken pattern
  -- actually matched, and what a correct one must not.
  assert_equal(
    nil,
    vim.filetype.match({ filename = vim.fs.joinpath(cache, "go", "gobuild", "ab", "abcdef-d") }),
    "gobuild is a different directory and must not be detected as Go source"
  )

  assert_equal(
    nil,
    vim.filetype.match({ filename = vim.fs.joinpath(cache, "go", "other", "abcdef-d") }),
    "paths outside the build cache must not be detected as Go source"
  )

  vim.fn.delete(root, "rf")
end
