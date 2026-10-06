---@diagnostic disable: undefined-global
-- Regression spec for the no-op formatting-edit filter in lua/lsp/init.lua.
--
-- The filter wraps client:request from an LspAttach autocmd and drops, from a
-- formatting reply, every edit that would leave the buffer byte-identical
-- (vscode-json-language-server sends one per request, and applying it leaves
-- an undo entry on the last line). Its helpers are file-local, so the spec
-- drives them the way a session does: lua/lsp/init.lua is loaded with lspkind
-- stubbed and vim.lsp.enable recorded instead of run, a fake client is
-- attached through the real autocmd, and the handler the filter hands to the
-- client's original request is called with a formatting result.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_deep_equal(expected, actual, message)
  if not vim.deep_equal(expected, actual) then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

package.loaded["lspkind"] = { init = function() end }
local enable = vim.lsp.enable
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.enable = function() end
require("lsp")
vim.lsp.enable = enable

---@type table<integer, table>
local clients = {}
local get_client_by_id = vim.lsp.get_client_by_id
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.get_client_by_id = function(id)
  return clients[id] or get_client_by_id(id)
end

---A client with just the fields the filter reads. Its `request` records the
---handler it is given, which is what the server's reply would be passed to.
---@param id integer
---@param offset_encoding string?
---@return table
local function attach_fake_client(id, offset_encoding)
  local client = { id = id, offset_encoding = offset_encoding, sent = {} }
  function client:request(method, params, handler, bufnr)
    self.sent[#self.sent + 1] = { method = method, params = params, handler = handler, bufnr = bufnr }
    return true, #self.sent
  end
  clients[id] = client
  vim.api.nvim_exec_autocmds("LspAttach", { group = "lsp_noop_format_edits", data = { client_id = id } })
  return client
end

---@param start_line integer
---@param start_character integer
---@param end_line integer
---@param end_character integer
---@param new_text string
---@return lsp.TextEdit
local function edit(start_line, start_character, end_line, end_character, new_text)
  return {
    range = {
      start = { line = start_line, character = start_character },
      ["end"] = { line = end_line, character = end_character },
    },
    newText = new_text,
  }
end

---Sends `edits` through the filter as the reply to a formatting request on a
---buffer holding `lines`, and returns what the caller's handler receives.
---@param client table
---@param lines string[]
---@param edits lsp.TextEdit[]?
---@param method string?
---@return lsp.TextEdit[]?
local function reply(client, lines, edits, method)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  local received
  client:request(method or "textDocument/formatting", {}, function(_, result)
    received = result
  end, bufnr)
  client.sent[#client.sent].handler(nil, edits, { bufnr = bufnr })
  vim.api.nvim_buf_delete(bufnr, { force = true })
  return received
end

local utf16 = attach_fake_client(9001, "utf-16")

-- ASCII: an edit replacing text with itself is dropped, a real one is kept,
-- and the kept edits come through unchanged and in order.
do
  local same = edit(0, 0, 0, 3, "abc")
  local real = edit(0, 0, 0, 3, "abd")
  local insert = edit(1, 0, 1, 0, "x")
  local empty_insert = edit(1, 1, 1, 1, "")
  assert_deep_equal({}, reply(utf16, { "abc", "de" }, { same }), "replacing abc with abc changes nothing")
  assert_deep_equal({ real }, reply(utf16, { "abc", "de" }, { real }), "replacing abc with abd is a real edit")
  assert_deep_equal(
    { real, insert },
    reply(utf16, { "abc", "de" }, { same, real, empty_insert, insert }),
    "only the no-op edits are dropped, the rest keep their order"
  )
end

-- The reply every vscode-json-language-server formatting request ends with:
-- from the end of the last line to (last_line + 1, 0), with an empty newText.
do
  local trailing = edit(1, 1, 2, 0, "")
  assert_deep_equal({}, reply(utf16, { "{", "}" }, { trailing }), "the end-of-buffer edit with no text is dropped")
  local newline = edit(1, 1, 2, 0, "\n")
  assert_deep_equal(
    { newline },
    reply(utf16, { "{", "}" }, { newline }),
    "the same range with a newline to insert is kept"
  )
end

-- A range that starts past the last line can only append.
do
  local nothing = edit(5, 0, 6, 0, "")
  local append = edit(5, 0, 6, 0, "x")
  assert_deep_equal({ append }, reply(utf16, { "a" }, { nothing, append }), "past the last line only text is an edit")
end

-- Multi-line ranges compare against the joined text.
do
  local same = edit(0, 0, 1, 1, "a\nb")
  local real = edit(0, 0, 1, 1, "a\nc")
  assert_deep_equal({ real }, reply(utf16, { "a", "b" }, { same, real }), "a multi-line edit is compared as one string")
end

-- A range whose end precedes its start is read the other way round, as
-- vim.lsp.util.apply_text_edits does.
do
  assert_deep_equal({}, reply(utf16, { "abc" }, { edit(0, 3, 0, 0, "abc") }), "a reversed range is swapped")
end

-- A character offset past the end of the line stops at the end of the line.
do
  local same = edit(0, 1, 0, 99, "bc")
  local real = edit(0, 1, 0, 99, "bcd")
  local past_both = edit(0, 50, 0, 99, "")
  assert_deep_equal(
    { real },
    reply(utf16, { "abc" }, { same, real, past_both }),
    "columns past the end of the line are clamped to it"
  )
end

-- Multibyte text: character offsets count the client's encoding units, not
-- bytes. "あ" is 3 bytes and 1 UTF-16 unit; "😀" is 4 bytes, 2 UTF-16 units and
-- 1 UTF-32 unit.
do
  local same = edit(0, 1, 0, 2, "い")
  local real = edit(0, 1, 0, 2, "う")
  assert_deep_equal({ real }, reply(utf16, { "あいう" }, { same, real }), "utf-16 offsets on 3-byte characters")

  local after_astral = edit(0, 2, 0, 3, "x")
  assert_deep_equal({}, reply(utf16, { "😀x" }, { after_astral }), "utf-16 counts a surrogate pair as two units")

  local utf32 = attach_fake_client(9002, "utf-32")
  local utf32_same = edit(0, 1, 0, 2, "x")
  assert_deep_equal({}, reply(utf32, { "😀x" }, { utf32_same }), "utf-32 counts an astral character as one unit")
  assert_deep_equal(
    { after_astral },
    reply(utf32, { "😀x" }, { after_astral }),
    "the utf-16 offsets are past the end of the line for a utf-32 client, so the edit inserts"
  )

  local utf8 = attach_fake_client(9003, "utf-8")
  local utf8_same = edit(0, 4, 0, 5, "x")
  assert_deep_equal({}, reply(utf8, { "😀x" }, { utf8_same }), "utf-8 offsets are bytes")
  assert_deep_equal(
    { utf32_same },
    reply(utf8, { "😀x" }, { utf32_same }),
    "utf-32 offsets mean other bytes in utf-8"
  )

  -- A client that reports no encoding is read as utf-16.
  local unset = attach_fake_client(9004, nil)
  assert_deep_equal({}, reply(unset, { "😀x" }, { after_astral }), "a missing offset_encoding falls back to utf-16")
end

-- Range formatting replies are filtered too; any other method keeps the
-- caller's handler untouched.
do
  local same = edit(0, 0, 0, 1, "a")
  assert_deep_equal({}, reply(utf16, { "a" }, { same }, "textDocument/rangeFormatting"), "rangeFormatting is filtered")
  assert_deep_equal(
    {},
    reply(utf16, { "a" }, { same }, "textDocument/rangesFormatting"),
    "rangesFormatting is filtered"
  )

  local handler = function() end
  utf16:request("textDocument/hover", {}, handler, 0)
  assert_equal(handler, utf16.sent[#utf16.sent].handler, "a non-formatting request keeps its own handler")
  utf16:request("textDocument/formatting", {}, nil, 0)
  assert_equal(nil, utf16.sent[#utf16.sent].handler, "a formatting request without a handler stays without one")
  local sent = utf16.sent[#utf16.sent]
  assert_equal("textDocument/formatting", sent.method, "the method reaches the original request")
  assert_equal(0, sent.bufnr, "the buffer reaches the original request")
end

-- Replies that carry no edit list pass through as they are.
do
  assert_equal(nil, reply(utf16, { "a" }, nil), "a nil result stays nil")
  local empty = {}
  assert_equal(empty, reply(utf16, { "a" }, empty), "an empty result is handed on as the same table")
end

-- The buffer comes from the reply's context, or from the request when the
-- context names none; with no valid buffer nothing is filtered.
do
  local same = edit(0, 0, 0, 1, "a")
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { "a" })
  local received
  utf16:request("textDocument/formatting", {}, function(_, result)
    received = result
  end, bufnr)
  local wrapped = utf16.sent[#utf16.sent].handler
  wrapped(nil, { same }, {})
  assert_deep_equal({}, received, "the request's buffer is used when the context has none")

  vim.api.nvim_buf_delete(bufnr, { force = true })
  wrapped(nil, { same }, { bufnr = bufnr })
  assert_deep_equal({ same }, received, "a reply for a deleted buffer is not filtered")
end

-- The handler's other arguments and its return value pass through.
do
  local err, ctx, config = { code = 1, message = "failed" }, { bufnr = 0 }, {}
  local seen
  utf16:request("textDocument/formatting", {}, function(...)
    seen = { ... }
    return "returned"
  end, 0)
  local returned = utf16.sent[#utf16.sent].handler(err, nil, ctx, config)
  assert_equal("returned", returned, "the caller's handler return value is kept")
  assert_equal(err, seen[1], "the error is passed on")
  assert_equal(ctx, seen[3], "the context is passed on")
  assert_equal(config, seen[4], "the config is passed on")
end

-- LspAttach fires once per buffer: a second attach must not wrap the wrapper.
do
  local wrapped = utf16.request
  vim.api.nvim_exec_autocmds("LspAttach", { group = "lsp_noop_format_edits", data = { client_id = utf16.id } })
  assert_equal(wrapped, utf16.request, "a client's request is wrapped once")
end

vim.lsp.get_client_by_id = get_client_by_id

print("OK: no-op formatting edits are dropped in every offset encoding, real edits are kept")
