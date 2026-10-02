---@diagnostic disable: undefined-global
-- Regression spec for the hujson route in lsp/jsonls.lua.
--
-- When filetype.lua moved *.hujson from jsonc to its own filetype, jsonls
-- stopped attaching. Listing hujson is not enough on its own: the server
-- relaxes validation only for the literal languageId "jsonc", so a buffer sent
-- as "hujson" gets an Error on every comment (521) and every trailing comma
-- (519). The config therefore sends hujson as "jsonc" and drops
-- ErrorCode.TrailingComma on hujson buffers, since trailing commas are legal
-- HuJSON; every other grammar error, a missing comma (514) included, stays.
--
-- The live half runs the real server with the config's own get_language_id and
-- handler, so the languageId semantics and the diagnostic codes are the
-- server's, not a restatement of them. Needs no network: no schema is set.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  -- lsp/jsonls.lua lives in the native runtimepath form at the repo root.
  vim.fn.getcwd() .. "/?.lua",
  package.path,
}, ";")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local config = require("lsp.jsonls")
local handler = config.handlers["textDocument/diagnostic"]

--- Runs the handler on a scratch buffer of `filetype` and returns the items it
--- forwarded to vim.lsp.diagnostic.on_diagnostic.
---@param filetype string
---@param items table[]
---@return table[]
local function forwarded_items(filetype, items)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = filetype
  local captured
  local original = vim.lsp.diagnostic.on_diagnostic
  vim.lsp.diagnostic.on_diagnostic = function(_, result)
    captured = result
  end
  local ok, failure = pcall(handler, nil, { kind = "full", items = items }, { bufnr = bufnr, client_id = 1 })
  vim.lsp.diagnostic.on_diagnostic = original
  vim.api.nvim_buf_delete(bufnr, { force = true })
  assert(ok, failure)
  return assert(captured, "the handler must forward to vim.lsp.diagnostic.on_diagnostic").items
end

---@param items table[]
---@return string
local function codes(items)
  return table.concat(
    vim.tbl_map(function(d)
      return tostring(d.code)
    end, items),
    ","
  )
end

do
  assert(vim.list_contains(config.filetypes, "hujson"), "jsonls must attach to hujson buffers")
  assert_equal("jsonc", config.get_language_id(0, "hujson"), "hujson must reach the server as jsonc")
  for _, filetype in ipairs({ "json", "jsonc", "json5", "jsonschema" }) do
    assert_equal(filetype, config.get_language_id(0, filetype), filetype .. " must keep its own languageId")
  end
end

do
  local items = {
    { code = 519, message = "Trailing comma" },
    { code = 514, message = "Expected comma" },
    { code = 521, message = "Comments are not permitted in JSON." },
    { code = 1, message = "Value is not accepted." },
    { code = nil, message = 'Incorrect type. Expected "boolean".' },
  }
  assert_equal(
    "514,521,1,nil",
    codes(forwarded_items("hujson", vim.deepcopy(items))),
    "a hujson buffer should lose ErrorCode.TrailingComma and nothing else"
  )
  assert_equal(
    "519,514,521,1,nil",
    codes(forwarded_items("jsonc", vim.deepcopy(items))),
    "a jsonc buffer must keep its trailing comma warnings"
  )
end

-- The live half.
-- cmd is a function (the lookups run at server start), so ask util here.
local server_bin = require("util").bun_prefix("vscode-json-language-server")
assert(vim.uv.fs_stat(server_bin) ~= nil, ("vscode-json-language-server is not installed at %s"):format(server_bin))

local root = assert(vim.uv.fs_realpath(vim.fn.tempname():match("^(.*)/[^/]*$")))
local path = vim.fs.joinpath(root, "policy.hujson")
vim.fn.writefile({
  "// comment",
  "{",
  '  /* block */ "a": [1, 2,],',
  '  "b": {"c": true,},',
  '  "d": 3 "e": 4,',
  "}",
}, path)

local client_id = vim.lsp.start({
  name = "jsonls",
  cmd = config.cmd,
  init_options = config.init_options,
  settings = config.settings,
  get_language_id = config.get_language_id,
  root_dir = root,
}, { attach = false })
assert(client_id ~= nil, "jsonls failed to start")
local client = assert(vim.lsp.get_client_by_id(client_id))

local ok, err = pcall(function()
  assert(
    vim.wait(30000, function()
      return client.initialized == true
    end, 50),
    "jsonls never finished initialize"
  )
  vim.cmd.edit(vim.fn.fnameescape(path))
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].filetype = "hujson"
  assert(vim.lsp.buf_attach_client(bufnr, client_id), "jsonls did not attach to the hujson buffer")

  local response =
    client:request_sync("textDocument/diagnostic", { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }, 15000, bufnr)
  assert(response and response.err == nil, "textDocument/diagnostic failed: " .. vim.inspect(response))
  local raw = response.result.items
  -- What the server says under the languageId the config picks: no comment
  -- complaints, and every trailing comma carries the code the filter drops.
  for _, d in ipairs(raw) do
    assert(d.code ~= 521, "sent as jsonc, comments must not be diagnosed: " .. d.message)
    if d.message == "Trailing comma" then
      assert_equal(519, d.code, "the server's trailing comma code must be the one the filter drops")
    end
  end
  assert_equal("519,519,514,519", codes(raw), "the fixture's three trailing commas and one missing comma")

  local kept = forwarded_items("hujson", raw)
  assert_equal("514", codes(kept), "after the handler only the missing comma should remain")
end)

client:stop(true)
vim.fn.delete(path)
if not ok then
  error(err, 0)
end
