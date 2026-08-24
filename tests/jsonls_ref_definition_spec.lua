---@diagnostic disable: undefined-global
-- Regression spec for the `$ref` jump in lua/lsp/jsonls.lua.
--
-- vscode-json-language-server exposes no definitionProvider, so <C-]> on a
-- `"$ref": "#/$defs/Foo"` can only be served by textDocument/documentLink. Two
-- details of that reply are easy to lose in a refactor and are what this spec
-- pins:
--
--   * `target` is `${uri}#${line},${character}`, 1-indexed, not an lsp.Location
--     -- reading it as a plain URI jumps to the top of the file instead.
--   * the reported range covers the string's contents, not its quotes, so a
--     cursor outside it must fall through to the global definition picker
--     rather than jumping to whichever link happens to be first.
--
-- The fixture reproduces the shape measured against the real server on
-- ganja-code's schema/ganja-config.schema.json, where `#/$defs/AgentConfig` on
-- line 64 resolves to `#260,20` -- column 20 being the `{` that opens the
-- definition, since findNode() returns the property's value node, not its key.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

-- lua/lsp/jsonls.lua pulls its schema catalog from b0o/SchemaStore.nvim at
-- module scope, so the spec needs the plugin on the runtimepath that the real
-- config gets from lazy.nvim (lua/config/lazy.lua roots it at stdpath("data")).
local schemastore = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "schemastore.nvim")
assert(
  vim.uv.fs_stat(schemastore),
  ("schemastore.nvim is not installed at %s -- run: nvim --headless '+Lazy! sync' +qa"):format(schemastore)
)
vim.opt.runtimepath:append(schemastore)

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

-- Requiring the module is what registers the LspAttach handler.
require("lsp.jsonls")

local FIXTURE = {
  "{",
  '  "properties": {',
  '    "agent": {',
  '      "additionalProperties": {',
  '        "$ref": "#/$defs/AgentConfig"',
  "      }",
  "    }",
  "  },",
  '  "$defs": {',
  '    "AgentConfig": {',
  '      "type": "object"',
  "    }",
  "  }",
  "}",
}

---Line/column of `needle` in FIXTURE, in the 1-indexed form findLinks reports.
---@param needle string
---@return integer line, integer character
local function locate(needle)
  for index, text in ipairs(FIXTURE) do
    local column = text:find(needle, 1, true)
    if column then
      return index, column
    end
  end
  error(("fixture has no %q"):format(needle))
end

local ref_line, ref_column = locate("#/$defs/AgentConfig")
local def_line, def_column = locate('"AgentConfig": {')
-- findNode() resolves to the value node, so the target is the `{`, not the key.
def_column = def_column + #'"AgentConfig": '

local path = vim.fs.joinpath(vim.fn.tempname(), "ganja-config.schema.json")
vim.fn.mkdir(vim.fs.dirname(path), "p")
vim.fn.writefile(FIXTURE, path)

vim.cmd.edit(path)
local bufnr = vim.api.nvim_get_current_buf()
local uri = vim.uri_from_bufnr(bufnr)

-- Exactly the shape services/jsonLinks.js emits: the range spans the pointer
-- between the quotes, and the target carries a 1-indexed `#line,column`.
local LINKS = {
  {
    range = {
      start = { line = ref_line - 1, character = ref_column - 1 },
      ["end"] = { line = ref_line - 1, character = ref_column - 1 + #"#/$defs/AgentConfig" },
    },
    target = ("%s#%d,%d"):format(uri, def_line, def_column),
  },
}

local requested_method = nil
local fake_client = {
  name = "jsonls",
  offset_encoding = "utf-16",
  request = function(_, method, _, handler, _)
    requested_method = method
    handler(nil, LINKS)
    return true
  end,
}

local real_get_client_by_id = vim.lsp.get_client_by_id
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.get_client_by_id = function(id)
  return id == 1 and fake_client or real_get_client_by_id(id)
end

vim.api.nvim_exec_autocmds("LspAttach", { buffer = bufnr, data = { client_id = 1 } })

local mapping = vim.fn.maparg("<C-]>", "n", false, true)
assert(mapping.buffer == 1, "jsonls must bind <C-]> buffer-locally, not globally")
assert(type(mapping.callback) == "function", "the <C-]> mapping must carry a Lua callback")

-- A non-jsonls client on the same buffer must not claim the key.
local other_bufnr = vim.api.nvim_create_buf(false, true)
vim.lsp.get_client_by_id = function(id)
  return id == 2 and { name = "yamlls" } or real_get_client_by_id(id)
end
vim.api.nvim_exec_autocmds("LspAttach", { buffer = other_bufnr, data = { client_id = 2 } })
assert_equal(
  0,
  vim.api.nvim_buf_call(other_bufnr, function()
    return vim.fn.maparg("<C-]>", "n", false, true).buffer or 0
  end),
  "only jsonls buffers may take the buffer-local <C-]>"
)
vim.lsp.get_client_by_id = function(id)
  return id == 1 and fake_client or real_get_client_by_id(id)
end

local fallbacks = 0
package.loaded["snacks"] = {
  picker = {
    lsp_definitions = function()
      fallbacks = fallbacks + 1
    end,
  },
}

-- On the pointer: jumps to the definition's value node.
vim.api.nvim_win_set_cursor(0, { ref_line, ref_column + 4 })
mapping.callback()

assert_equal("textDocument/documentLink", requested_method, "jsonls has no definitionProvider to ask")
assert_equal(0, fallbacks, "a resolved $ref must not fall back to the definition picker")
local row, column = unpack(vim.api.nvim_win_get_cursor(0))
assert_equal(def_line, row, "cursor line after jumping to #/$defs/AgentConfig")
assert_equal(def_column - 1, column, "cursor column must land on the value node, not the key")

-- Outside the pointer (on the `"$ref"` key): falls through, cursor unmoved.
vim.api.nvim_win_set_cursor(0, { ref_line, 9 })
mapping.callback()
assert_equal(1, fallbacks, "a cursor outside every link must fall back")
assert_equal(ref_line, vim.api.nvim_win_get_cursor(0)[1], "the fallback must not move the cursor itself")

vim.lsp.get_client_by_id = real_get_client_by_id
print("OK: jsonls resolves $ref through documentLink and falls back elsewhere")
