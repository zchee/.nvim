---@diagnostic disable: undefined-global
-- Regression spec for the json5 diagnostic filter in lsp/jsonls.lua.
--
-- vscode-json-language-server relaxes its validation only for the literal
-- languageId "jsonc", so a json5 buffer is validated as strict JSON. Measured
-- against the real server on ganja-code's .github/renovate.json5 -- 57 lines of
-- genuine JSON5 -- that is 41 diagnostics, every one an Error, and only three
-- codes: 528 PropertyKeysMustBeDoublequoted, 516 ValueExpected, 519
-- TrailingComma. The handler drops that class and keeps schema diagnostics,
-- which carry no code or one below 0x100, and the schema-infrastructure codes
-- at 0x300 and above.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  -- The server config migrated to the native runtimepath form at the repo
  -- root (lsp/jsonls.lua), so require("lsp.jsonls") resolves through this
  -- entry rather than lua/.
  vim.fn.getcwd() .. "/?.lua",
  package.path,
}, ";")

local config = require("lsp.jsonls")

-- The SchemaStore catalog moved from module scope into before_init so a
-- non-JSON session never materializes it: config files under lsp/ are read on
-- the first FileType event of any filetype. Loading the module must therefore
-- leave schemastore untouched.
assert(package.loaded["schemastore"] == nil, "requiring lsp.jsonls must not load the SchemaStore catalog")
assert(type(config.before_init) == "function", "the schema catalog must be filled in by before_init")
local handler = config.handlers["textDocument/diagnostic"]
assert(type(handler) == "function", "jsonls must install a textDocument/diagnostic handler")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

--- Runs `handler` against a scratch buffer of `filetype` and returns what it
--- forwarded to the real vim.lsp.diagnostic.on_diagnostic.
---@param filetype string
---@param result table?
---@param err table?
---@return table forwarded {err=, result=, ctx=}
local function forwarded(filetype, result, err)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = filetype

  local captured
  local diagnostic = vim.lsp.diagnostic
  local original = diagnostic.on_diagnostic
  diagnostic.on_diagnostic = function(forwarded_err, forwarded_result, forwarded_ctx)
    captured = { err = forwarded_err, result = forwarded_result, ctx = forwarded_ctx }
  end

  local ok, failure = pcall(handler, err, result, { bufnr = bufnr, client_id = 1, method = "textDocument/diagnostic" })

  diagnostic.on_diagnostic = original
  vim.api.nvim_buf_delete(bufnr, { force = true })

  assert(ok, failure)
  assert(captured, "the handler must always forward to vim.lsp.diagnostic.on_diagnostic")
  return captured
end

---@param items table[]
---@return table
local function full_report(items)
  return { kind = "full", resultId = "r1", items = items }
end

---@param diagnostics table[]
---@return string[]
local function messages(diagnostics)
  return vim.tbl_map(function(d)
    return d.message
  end, diagnostics)
end

-- The exact shapes the real server emitted: three grammar codes seen on
-- renovate.json5, and the two schema forms seen on a JSONC document validated
-- against a schema (EnumValueMismatch carries code 1, a type mismatch none).
local GRAMMAR = {
  { code = 528, severity = 1, message = "Property keys must be doublequoted" },
  { code = 516, severity = 1, message = "Value expected" },
  { code = 519, severity = 1, message = "Trailing comma" },
  { code = 521, severity = 1, message = "Comments are not permitted in JSON." },
}
local SCHEMA = {
  { code = 1, severity = 2, message = 'Value is not accepted. Valid values: "es2022", "esnext".' },
  { code = nil, severity = 2, message = 'Incorrect type. Expected "boolean".' },
  { code = 2, severity = 2, message = "use strict" },
}

do
  -- A json5 buffer keeps every schema diagnostic and loses every grammar one.
  local mixed = {}
  vim.list_extend(mixed, SCHEMA)
  vim.list_extend(mixed, GRAMMAR)

  local out = forwarded("json5", full_report(mixed))
  assert_equal(
    table.concat(messages(SCHEMA), "|"),
    table.concat(messages(out.result.items), "|"),
    "only the schema diagnostics should survive on a json5 buffer, in order"
  )
  assert_equal("r1", out.result.resultId, "resultId must survive so pull bookkeeping still works")
  assert_equal("full", out.result.kind, "report kind must not change")
end

do
  -- Everything else jsonls serves is real JSON: nothing may be dropped there.
  for _, filetype in ipairs({ "json", "jsonc", "jsonschema" }) do
    local mixed = {}
    vim.list_extend(mixed, SCHEMA)
    vim.list_extend(mixed, GRAMMAR)

    local out = forwarded(filetype, full_report(mixed))
    assert_equal(
      #SCHEMA + #GRAMMAR,
      #out.result.items,
      ("no diagnostic may be filtered on a %s buffer"):format(filetype)
    )
  end
end

do
  -- Code boundaries. ErrorCode puts the scanner at 0x101-0x106 and the parser at
  -- 0x201-0x210; schema problems sit below 0x100 or at 0x300 and above
  -- (SchemaUnsupportedFeature 0x301, SchemaResolveError 0x10000), and an
  -- unresolvable schema is worth reporting rather than hiding.
  local cases = {
    { code = 0, keep = true, what = "ErrorCode.Undefined" },
    { code = 2, keep = true, what = "ErrorCode.Deprecated" },
    { code = 0xFF, keep = true, what = "just below the scanner block" },
    { code = 0x101, keep = false, what = "ErrorCode.UnexpectedEndOfComment" },
    { code = 0x210, keep = false, what = "ErrorCode.PropertyKeysMustBeDoublequoted" },
    { code = 0x2FF, keep = false, what = "top of the parser block" },
    { code = 0x301, keep = true, what = "ErrorCode.SchemaUnsupportedFeature" },
    { code = 0x10000, keep = true, what = "ErrorCode.SchemaResolveError" },
    { code = "some-string-code", keep = true, what = "a non-numeric code" },
  }
  for _, case in ipairs(cases) do
    local out = forwarded("json5", full_report({ { code = case.code, message = case.what } }))
    assert_equal(
      case.keep and 1 or 0,
      #out.result.items,
      ("code %s (%s) should be %s"):format(vim.inspect(case.code), case.what, case.keep and "kept" or "dropped")
    )
  end
end

do
  -- An `unchanged` report carries no items; forwarding it untouched is what
  -- lets vim.lsp.diagnostic keep the previously published (already filtered)
  -- set instead of clearing it.
  local report = { kind = "unchanged", resultId = "r2" }
  local out = forwarded("json5", report)
  assert_equal("unchanged", out.result.kind, "an unchanged report must pass through")
  assert_equal("r2", out.result.resultId, "an unchanged report must keep its resultId")
  assert_equal(nil, out.result.items, "an unchanged report must not gain an items list")
end

do
  -- Errors are the upstream handler's business: it retries a ServerCancelled
  -- and logs the rest, so neither the error nor the result may be touched.
  local err = { code = -32802, message = "ServerCancelled" }
  local out = forwarded("json5", nil, err)
  assert_equal(err, out.err, "the response error must pass through unchanged")
  assert_equal(nil, out.result, "a nil result must stay nil")
end

do
  -- A buffer wiped between the request and its response must not throw; the
  -- handler still has to forward so upstream can drop the stale state.
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = "json5"
  vim.api.nvim_buf_delete(bufnr, { force = true })

  local captured
  local diagnostic = vim.lsp.diagnostic
  local original = diagnostic.on_diagnostic
  diagnostic.on_diagnostic = function(_, result)
    captured = result
  end
  local ok, failure = pcall(handler, nil, full_report(vim.deepcopy(GRAMMAR)), { bufnr = bufnr, client_id = 1 })
  diagnostic.on_diagnostic = original

  assert(ok, failure)
  assert_equal(#GRAMMAR, #captured.items, "an invalid buffer must be forwarded untouched, not crash")
end
