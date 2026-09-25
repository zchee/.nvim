---@diagnostic disable: undefined-global
-- Regression spec for the Chrome extension manifest route in lsp/jsonls.lua.
--
-- A manifest.json under a chrome-extension* directory must resolve to
-- chrome-manifest.json and nothing else. Two properties of
-- vscode-json-languageservice make that easy to lose:
--
--   * Every matching fileMatch association is merged under one allOf, so a
--     Chrome entry alone still leaves Foxx Manifest, WebExtensions and Web App
--     Manifest applied. Measured on an MV3 manifest, WebExtensions then flags
--     the object content_security_policy with `Incorrect type. Expected
--     "string"`. The competitors have to carry a negation.
--   * FilePatternAssociation lets the last matching pattern decide, so that
--     negation only works after the entry's own "manifest.json".
--
-- The live half asks the real server through json/languageStatus, which
-- reports the schema URIs chosen for a document without downloading any of
-- them, so the glob semantics are the server's own and the spec needs no
-- network.
--
-- Run: nvim --headless -u NONE -l tests/jsonls_chrome_manifest_spec.lua
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

local function assert_true(value, message)
  if not value then
    error(message)
  end
end

-- schemastore.nvim lives in lazy's plugin dir, which -u NONE does not put on
-- the rtp; before_init requires it.
local schemastore_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("data")), "lazy", "schemastore.nvim")
if not vim.uv.fs_stat(schemastore_dir) then
  print("SKIP: schemastore.nvim is not installed at " .. schemastore_dir)
  return
end
vim.opt.runtimepath:append(schemastore_dir)

local CHROME = "https://json.schemastore.org/chrome-manifest.json"
local PATTERN = "chrome-extension*/**/manifest.json"
local NEGATION = "!" .. PATTERN

local config = require("lsp.jsonls")
local resolved = vim.deepcopy(config)
resolved.before_init(nil, resolved)
local schemas = resolved.settings.json.schemas

do
  local chrome = vim.iter(schemas):find(function(schema)
    return schema.url == CHROME
  end)
  assert_true(chrome ~= nil, "before_init must route manifests to " .. CHROME)
  assert_equal("Chrome Extension", chrome.name, "the route reuses the catalog's Chrome Extension entry")
  assert_equal(1, #chrome.fileMatch, "the Chrome entry carries exactly one pattern")
  assert_equal(PATTERN, chrome.fileMatch[1], "the Chrome entry claims chrome-extension* manifests")
end

do
  local competitors = {}
  for _, schema in ipairs(schemas) do
    if schema.url ~= CHROME and type(schema.fileMatch) == "table" then
      for _, pattern in ipairs(schema.fileMatch) do
        if pattern == "manifest.json" or vim.endswith(pattern, "/manifest.json") then
          competitors[#competitors + 1] = schema.name
          assert_equal(
            NEGATION,
            schema.fileMatch[#schema.fileMatch],
            schema.name .. " must end with the negation, since the last matching pattern decides"
          )
          break
        end
      end
    end
  end
  for _, name in ipairs({ "Foxx Manifest", "WebExtensions", "Web App Manifest" }) do
    assert_true(
      vim.list_contains(competitors, name),
      name .. " claims every bare manifest.json and must exclude the Chrome paths"
    )
  end
end

do
  local catalog = require("schemastore").json.get("WebExtensions")
  assert_equal(1, #catalog.fileMatch, "before_init must not mutate the catalog module's own table")
end

-- The live half.
assert_true(
  vim.uv.fs_stat(config.cmd[2]) ~= nil,
  ("vscode-json-language-server is not installed at %s"):format(config.cmd[2])
)

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
-- tempname() sits under /var on macOS, itself a link to /private/var.
root = assert(vim.uv.fs_realpath(root))

---@param relative string
---@param lines string[]
---@return string
local function fixture(relative, lines)
  local path = vim.fs.joinpath(root, relative)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile(lines, path)
  return path
end

local chrome_manifest = { "{", '  "manifest_version": 3,', '  "name": "demo",', '  "version": "1.0.0"', "}" }
local cases = {
  ["chrome-extension-demo/manifest.json"] = { CHROME },
  -- The UI5 Manifest entry claims **/src/manifest.json.
  ["chrome-extension-demo/src/manifest.json"] = { CHROME },
  ["chrome-extension-ietf/src/extension/manifest.json"] = { CHROME },
  ["chrome-extensions-project-mariner/manifest.json"] = { CHROME },
}

local client_id = vim.lsp.start({
  name = "jsonls",
  cmd = config.cmd,
  init_options = config.init_options,
  settings = resolved.settings,
  root_dir = root,
}, { attach = false })
assert_true(client_id ~= nil, "jsonls failed to start")
local client = assert(vim.lsp.get_client_by_id(client_id))
assert_true(
  vim.wait(30000, function()
    return client.initialized == true
  end, 50),
  "jsonls never finished initialize"
)

---@param path string
---@return string[]
local function schemas_for(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].filetype = "json"
  assert_true(vim.lsp.buf_attach_client(bufnr, client_id), "jsonls did not attach to " .. path)
  -- Checked after the wait: an error raised inside the handler would be logged
  -- by the RPC loop, not propagated to this spec.
  local done, response_err, result = false, nil, nil
  client:request("json/languageStatus", vim.uri_from_bufnr(bufnr), function(e, res)
    response_err, result, done = e, res, true
  end, bufnr)
  assert_true(
    vim.wait(15000, function()
      return done
    end, 50),
    "json/languageStatus never came back for " .. path
  )
  assert_true(response_err == nil, ("json/languageStatus failed for %s: %s"):format(path, vim.inspect(response_err)))
  return assert(result, "json/languageStatus returned nothing for " .. path).schemas
end

local ok, err = pcall(function()
  for relative, expected in pairs(cases) do
    assert_equal(
      vim.inspect(expected),
      vim.inspect(schemas_for(fixture(relative, chrome_manifest))),
      relative .. " must resolve to chrome-manifest.json alone"
    )
  end

  local package_json = schemas_for(fixture("chrome-extension-demo/package.json", { "{}" }))
  assert_true(
    not vim.list_contains(package_json, CHROME),
    "only manifest.json is routed, package.json got " .. vim.inspect(package_json)
  )

  -- Outside the Chrome paths the catalog's own associations stay as they were.
  local pwa = schemas_for(fixture("pwa/manifest.json", { "{}" }))
  assert_true(not vim.list_contains(pwa, CHROME), "a web app manifest must not get the Chrome schema")
  assert_true(
    vim.list_contains(pwa, "https://www.schemastore.org/web-manifest-combined.json"),
    "a web app manifest must keep the Web App Manifest schema, got " .. vim.inspect(pwa)
  )
end)

client:stop(true)
vim.fn.delete(root, "rf")
if not ok then
  error(err, 0)
end

print("OK: chrome-extension* manifests resolve to chrome-manifest.json alone")
