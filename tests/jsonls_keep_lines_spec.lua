---@diagnostic disable: undefined-global
-- Regression spec for the keepLines setting in lsp/jsonls.lua.
--
-- lsp/jsonls.lua advertises no formatter (provideFormatter = false), but the
-- server still answers a direct textDocument/formatting request, which is
-- what this spec sends. The server applies keepLines only from
-- `settings.json.keepLines.enable`; the config used to send
-- `settings.json.format.keepLines`, which the server never reads, and every
-- single-line array was broken one element per line on save.
--
-- Both halves run the real server. The control formats the same buffer with
-- the old shape and must still expand it, so this spec fails if the server
-- ever starts reading that key and the comment in jsonls.lua goes stale, and
-- it proves the fixture is one the formatter would otherwise rewrite.
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

do
  assert_equal(true, vim.tbl_get(config.settings, "json", "keepLines", "enable"), "json.keepLines.enable must be on")
  assert_equal(
    nil,
    vim.tbl_get(config.settings, "json", "format", "keepLines"),
    "json.format.keepLines is never read by the server and must not stand in for json.keepLines.enable"
  )
end

-- cmd is a function (the lookups run at server start), so ask util here.
local server_bin = require("util").bun_prefix("vscode-json-language-server")
assert(vim.uv.fs_stat(server_bin) ~= nil, ("vscode-json-language-server is not installed at %s"):format(server_bin))

local fixture = {
  "{",
  '  "zig": ["zig", "fmt"],',
  '  "go": [["gofmt", "-s", "-w"], ["gofumpt", "-w", "-extra"]],',
  '  "c,h,cc,cpp,cxx,hpp,hxx,m,mm": ["clang-format", "-i", "-style=file:${HOME}/.config/llvm/.clang-format"],',
  '  "lua": ["stylua"],',
  '  "empty": [],',
  '  "obj": {"a": 1, "b": [1, 2]},',
  '  "multi": [',
  '    "a",',
  '    "b"',
  "  ]",
  "}",
}

---Drops the one space keepLines pads inside a single-line bracket pair, which
---is the only change it makes to a line it keeps.
---@param line string
---@return string
local function unpad(line)
  return (line:gsub("([%[{]) ", "%1"):gsub(" ([%]}])", "%1"))
end

local root = assert(vim.uv.fs_realpath(vim.fn.tempname():match("^(.*)/[^/]*$")))

---Formats `fixture` as a json buffer through a server started with `settings`.
---@param label string
---@param settings table
---@return string[]
local function format_with(label, settings)
  local path = vim.fs.joinpath(root, ("keep_lines_%s.json"):format(label))
  vim.fn.writefile(fixture, path)
  local client_id = vim.lsp.start({
    name = "jsonls_" .. label,
    cmd = config.cmd,
    init_options = config.init_options,
    settings = settings,
    get_language_id = config.get_language_id,
    root_dir = root,
  }, { attach = false })
  assert(client_id ~= nil, "jsonls failed to start")
  local client = assert(vim.lsp.get_client_by_id(client_id))

  local ok, result = pcall(function()
    assert(
      vim.wait(30000, function()
        return client.initialized == true
      end, 50),
      "jsonls never finished initialize"
    )
    vim.cmd.edit(vim.fn.fnameescape(path))
    local bufnr = vim.api.nvim_get_current_buf()
    vim.bo[bufnr].filetype = "json"
    assert(vim.lsp.buf_attach_client(bufnr, client_id), "jsonls did not attach to the json buffer")

    local response = client:request_sync("textDocument/formatting", {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
      options = { tabSize = 2, insertSpaces = true },
    }, 15000, bufnr)
    assert(response and response.err == nil, "textDocument/formatting failed: " .. vim.inspect(response))
    vim.lsp.util.apply_text_edits(response.result or {}, bufnr, client.offset_encoding)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    vim.api.nvim_buf_delete(bufnr, { force = true })
    return lines
  end)

  client:stop(true)
  vim.fn.delete(path)
  if not ok then
    error(result, 0)
  end
  return result
end

do
  local formatted = format_with("configured", config.settings)
  assert_equal(#fixture, #formatted, "keepLines must neither split nor join lines:\n" .. table.concat(formatted, "\n"))
  for i, line in ipairs(formatted) do
    assert_equal(unpad(fixture[i]), unpad(line), ("line %d may change only by padding inside its brackets"):format(i))
  end
  assert_equal('  "zig": [ "zig", "fmt" ],', formatted[2], "a kept single-line array is padded inside its brackets")
end

do
  local old_shape = vim.deepcopy(config.settings)
  old_shape.json.keepLines = nil
  old_shape.json.format.keepLines = true
  local formatted = format_with("old_shape", old_shape)
  assert(
    #formatted > #fixture,
    "with only json.format.keepLines the server should still expand single-line arrays; if it no longer does, "
      .. "the server reads that key now and the jsonls.lua comment is stale:\n"
      .. table.concat(formatted, "\n")
  )
end
