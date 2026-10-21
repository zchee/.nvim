---@diagnostic disable: undefined-global
-- Regression spec for the hujson Tree-sitter queries.
--
-- tree-sitter-hujson is a custom registry entry (lua/nvim-treesitter/parsers.lua),
-- so nvim-treesitter ships no queries/hujson/ for it, and the grammar repo's
-- own queries/ is written for Zed (booleans as @constant.builtin, @indent/@end
-- indents that nvim-treesitter's indentexpr ignores). Without a query the
-- parser still attaches, vim.treesitter.start clears 'syntax', and the buffer
-- renders with no colour at all. The grammar keeps tree-sitter-json's node
-- types, so queries/hujson/*.scm inherit the json queries; this spec pins that
-- every one of them compiles against the real grammar and that highlighting
-- lands on the HuJSON-only syntax (comments, trailing commas) without ERRORs.
vim.opt.runtimepath:append(vim.fn.getcwd())

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local data = tostring(vim.fn.stdpath("data"))
local parser_path = vim.fs.joinpath(data, "tree-sitter-main", "parser", "hujson.so")
if not vim.uv.fs_stat(parser_path) then
  print("SKIP: hujson parser is not installed at " .. parser_path .. " (run :TSEnsureInstalled)")
  return
end
-- the json queries these inherit from live in the plugin's runtime/ dir
local ts_runtime = vim.fs.joinpath(data, "lazy", "nvim-treesitter", "runtime")
assert(vim.uv.fs_stat(ts_runtime), "nvim-treesitter runtime queries should be installed at " .. ts_runtime)
vim.opt.runtimepath:append(ts_runtime)
vim.treesitter.language.add("hujson", { path = parser_path })

do
  for _, name in ipairs({ "highlights", "injections", "indents", "folds", "locals" }) do
    local ok, query = pcall(vim.treesitter.query.get, "hujson", name)
    assert(ok, string.format("hujson %s query should compile against the grammar: %s", name, tostring(query)))
    assert(query ~= nil, "hujson " .. name .. " query should be found on the runtimepath")
  end
end

do
  local lines = {
    "// leading comment",
    "{",
    '  "key": 1, // trailing comment',
    '  "list": [true, false, null, "s",],',
    '  "obj": {"k": /* inline */ 2,},',
    "}",
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local tree = vim.treesitter.get_parser(buf, "hujson"):parse()[1]
  assert_equal(false, tree:root():has_error(), "comments and trailing commas should parse without ERROR nodes")

  local query = vim.treesitter.query.get("hujson", "highlights")
  local function captures_at(row, needle)
    local col = assert(lines[row + 1]:find(needle, 1, true), "fixture should contain " .. needle) - 1
    local names = {}
    for id, node in query:iter_captures(tree:root(), buf, row, row + 1) do
      local srow, scol, erow, ecol = node:range()
      if srow <= row and row <= erow and (srow < row or scol <= col) and (row < erow or col < ecol) then
        names[query.captures[id]] = true
      end
    end
    return names
  end

  local expect = {
    { 0, "// leading", "comment" },
    { 2, '"key"', "property" },
    { 2, "1", "number" },
    { 2, "// trailing", "comment" },
    { 3, "true", "boolean" },
    { 3, "false", "boolean" },
    { 3, "null", "constant.builtin" },
    { 3, '"s"', "string" },
    { 3, ",]", "punctuation.delimiter" },
    { 4, "/* inline", "comment" },
    { 4, ",}", "punctuation.delimiter" },
    { 5, "}", "punctuation.bracket" },
  }
  for _, e in ipairs(expect) do
    local row, needle, capture = e[1], e[2], e[3]
    local got = captures_at(row, needle)
    assert(
      got[capture],
      string.format("line %d %s should be captured as @%s, got %s", row + 1, needle, capture, vim.inspect(got))
    )
  end
  vim.api.nvim_buf_delete(buf, { force = true })
end
