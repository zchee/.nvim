---@diagnostic disable: undefined-global
-- Regression spec for the root_dir of lsp/asm_lsp.lua.
--
-- asm-lsp answers `initialize`, then reads its config, and when that config
-- has a [[project]] table and the client sent no workspaceFolders, rootUri or
-- rootPath it shows "Unable to detect project root directory.. Please make
-- corrections and restart asm-lsp.", sleeps 5 s and exits 1. A global
-- ~/.config/asm-lsp/.asm-lsp.toml with a [[project]] table is enough, so any
-- buffer whose root_dir resolves to nil kills the server: Go assembly under
-- GOROOT or the module cache, which carry go.mod but no .git, did exactly that
-- while root_markers were { ".asm-lsp.toml", ".git" }.
--
-- The unit half pins the resolution order on a real tree. The live half starts
-- the real binary with HOME pointed at a throwaway global config holding a
-- [[project]] table: a nil root must reproduce the error (otherwise the spec
-- could not tell a fixed server from one that never started), and the root
-- the config resolves for a marker-less file must leave the server answering
-- requests. The live half prints SKIP when asm-lsp is not installed.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  -- lsp/asm_lsp.lua lives in the native runtimepath form at the repo root.
  vim.fn.getcwd() .. "/?.lua",
  package.path,
}, ";")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_truthy(value, message)
  if not value then
    error(message)
  end
end

local config = require("lsp.asm_lsp")

assert_equal("function", type(config.root_dir), "root_dir must be a function so a marker-less buffer still gets a root")
assert_equal(nil, config.root_markers, "root_markers is ignored once root_dir is a function, so it must not linger")
assert_truthy(vim.tbl_contains(config.filetypes, "goasm"), "asm_lsp must serve goasm")

local base = assert(vim.uv.fs_realpath(vim.fn.fnamemodify(vim.fn.tempname(), ":h")))
base = vim.fs.joinpath(base, ("asm_lsp_root_spec_%d"):format(vim.uv.getpid()))
vim.fn.delete(base, "rf")

local function write(path, lines)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile(lines or {}, path)
end

-- The label gives documentSymbol something to return, so an answer from a
-- server that parsed nothing does not pass as a working one.
local asm = { '#include "textflag.h"', "", "TEXT ·add(SB), NOSPLIT, $0-24", "loop:", "\tRET" }

local function buffer_for(path)
  local buf = vim.fn.bufnr(path)
  if buf ~= -1 then
    return buf
  end
  buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, path)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, asm)
  vim.bo[buf].filetype = "goasm"
  return buf
end

--- Calls config.root_dir and returns what it handed to on_dir, or the
--- `missing` sentinel when on_dir was never called.
local missing = {}
local function resolve(buf)
  local got = missing
  config.root_dir(buf, function(dir)
    got = dir
  end)
  return got
end

-- The project config wins over everything above it.
write(vim.fs.joinpath(base, "configured", ".git", "HEAD"))
write(vim.fs.joinpath(base, "configured", "asm", ".asm-lsp.toml"))
write(vim.fs.joinpath(base, "configured", "asm", "go.mod"), { "module example.com/asm" })
local configured = vim.fs.joinpath(base, "configured", "asm", "x86", "add_amd64.s")
write(configured, asm)
assert_equal(
  vim.fs.joinpath(base, "configured", "asm"),
  resolve(buffer_for(configured)),
  ".asm-lsp.toml must root the buffer ahead of .git and go.mod"
)

-- Inside a repository the root stays the repository, as before go.mod was a
-- marker: a nested module must not split one repository into several clients.
write(vim.fs.joinpath(base, "repo", ".git", "HEAD"))
write(vim.fs.joinpath(base, "repo", "sub", "go.mod"), { "module example.com/sub" })
local in_repo = vim.fs.joinpath(base, "repo", "sub", "pkg", "add_arm64.s")
write(in_repo, asm)
assert_equal(vim.fs.joinpath(base, "repo"), resolve(buffer_for(in_repo)), ".git must root the buffer ahead of go.mod")

-- The GOROOT and module-cache shape: go.mod, no .git anywhere above it.
write(vim.fs.joinpath(base, "goroot", "src", "go.mod"), { "module std" })
local in_goroot = vim.fs.joinpath(base, "goroot", "src", "runtime", "asm_arm64.s")
write(in_goroot, asm)
assert_equal(
  vim.fs.joinpath(base, "goroot", "src"),
  resolve(buffer_for(in_goroot)),
  "go.mod must root Go assembly that sits outside any repository"
)

-- No marker at all: the file's own directory, never nil.
local bare = vim.fs.joinpath(base, "bare", "add_amd64.s")
write(bare, asm)
assert_equal(
  vim.fs.joinpath(base, "bare"),
  resolve(buffer_for(bare)),
  "a marker-less file must be rooted at its directory"
)

-- A buffer with no name has nothing to root; asm_lsp must not attach to it.
assert_equal(missing, resolve(vim.api.nvim_create_buf(true, true)), "an unnamed buffer must not call on_dir")

-- Live half.
local bin = config.cmd[1]
if vim.fn.executable(bin) ~= 1 then
  print(("SKIP: asm-lsp is not installed at %s; the root resolution checks passed"):format(bin))
  vim.fn.delete(base, "rf")
  os.exit(0)
end

-- asm-lsp reads its global config from $HOME/.config/asm-lsp (and, on macOS,
-- $HOME/Library/Application Support/asm-lsp), so a throwaway HOME keeps the
-- user's real config out of the run. The [[project]] path is absolute, which
-- is what makes the missing root a pure client-side failure.
local home = vim.fs.joinpath(base, "home")
local project = vim.fs.joinpath(base, "project")
vim.fn.mkdir(project, "p")
write(vim.fs.joinpath(home, ".config", "asm-lsp", ".asm-lsp.toml"), {
  "[default_config]",
  'assembler = "go"',
  'instruction_set = "arm64"',
  "",
  "[[project]]",
  ('path = "%s"'):format(project),
  'assembler = "go"',
  'instruction_set = "x86-64"',
})

local root_error = "Unable to detect project root directory"

--- Starts asm-lsp on `buf` with `root_dir`, then reports the showMessage
--- texts the server sent and the symbols it answered textDocument/documentSymbol
--- with (nil when it never answered).
local function run(name, buf, root_dir)
  local messages = {}
  local client_id = vim.lsp.start({
    name = name,
    cmd = config.cmd,
    cmd_env = { HOME = home },
    root_dir = root_dir,
    handlers = {
      ["window/showMessage"] = function(_, result)
        table.insert(messages, result.message)
      end,
    },
  }, {
    bufnr = buf,
    reuse_client = function()
      return false
    end,
  })
  assert_truthy(client_id, ("%s: vim.lsp.start returned no client"):format(name))
  local client = assert(vim.lsp.get_client_by_id(client_id))

  assert_truthy(
    vim.wait(10000, function()
      return client.initialized or client:is_stopped()
    end, 20),
    ("%s: asm-lsp never finished initialize"):format(name)
  )
  -- The config is read right after `initialized`; give a failing server the
  -- time to say so before asking it anything.
  vim.wait(1500, function()
    return #messages > 0
  end, 20)

  local symbols
  if not client:is_stopped() then
    client:request("textDocument/documentSymbol", {
      textDocument = vim.lsp.util.make_text_document_params(buf),
    }, function(err, result)
      if err == nil then
        symbols = result or {}
      end
    end, buf)
    vim.wait(3000, function()
      return symbols ~= nil
    end, 20)
  end

  client:stop(true)
  vim.wait(2000, function()
    return client:is_stopped()
  end, 20)
  return messages, symbols
end

do
  local buf = buffer_for(bare)
  local messages = run("asm_lsp_spec_nil_root", buf, nil)
  local reproduced = vim.iter(messages):any(function(m)
    return m:find(root_error, 1, true) ~= nil
  end)
  assert_truthy(
    reproduced,
    ("control: a nil root with a [[project]] config must reproduce %q, got %s"):format(
      root_error,
      vim.inspect(messages)
    )
  )
end

do
  local buf = buffer_for(bare)
  local messages, symbols = run("asm_lsp_spec_resolved_root", buf, resolve(buf))
  for _, message in ipairs(messages) do
    assert_truthy(
      not message:find(root_error, 1, true),
      ("the resolved root must satisfy asm-lsp, got %q"):format(message)
    )
  end
  assert_truthy(
    symbols and #symbols > 0,
    ("asm-lsp must answer documentSymbol with the fixture's label on the resolved root, got %s, messages: %s"):format(
      vim.inspect(symbols),
      vim.inspect(messages)
    )
  )
end

vim.fn.delete(base, "rf")
print("OK: asm_lsp roots every buffer it can name, and asm-lsp starts on a marker-less file with a [[project]] config")
