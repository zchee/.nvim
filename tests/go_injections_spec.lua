---@diagnostic disable: undefined-global
-- Regression spec for after/queries/go/injections.scm's SQL and JSON
-- patterns.
--
-- Two of its pattern groups once injected nothing while compiling cleanly:
-- the keyword list used #contains?, which needs every listed string in the
-- same literal, and the JSON patterns captured raw_string_literal, whose
-- raw_string_literal_content child an injection leaves out of the region.
-- This parses an inline Go source against the installed go/sql/json parsers
-- with only $VIMRUNTIME, the parser dir and this checkout's after/ on the rtp,
-- and compares the distinct injected texts per language with the expected
-- sets, so a predicate whose semantics change or a capture that is masked
-- again fails here. Prints SKIP when any of the three parsers is missing.

local function parser_base()
  local candidates = {
    tostring(vim.fn.stdpath("data")),
    vim.fs.joinpath(vim.env.HOME, ".local", "share", "nvim"),
  }
  for _, data in ipairs(candidates) do
    local base = vim.fs.joinpath(data, "tree-sitter-main")
    local complete = true
    for _, lang in ipairs({ "go", "sql", "json" }) do
      complete = complete and vim.uv.fs_stat(vim.fs.joinpath(base, "parser", lang .. ".so")) ~= nil
    end
    if complete then
      return base
    end
  end
end

local base = parser_base()
if not base then
  print("SKIP: go, sql and json parsers are not all installed under stdpath('data') or ~/.local/share/nvim")
  return
end
print("parsers from " .. base)

local repo = vim.fn.getcwd()
local after_query = vim.fs.joinpath(repo, "after", "queries", "go", "injections.scm")
assert(vim.uv.fs_stat(after_query), "run this from the repo root: " .. after_query .. " is missing")
vim.o.runtimepath = table.concat({ base, vim.env.VIMRUNTIME, vim.fs.joinpath(repo, "after") }, ",")

local files = vim.treesitter.query.get_files("go", "injections")
assert(
  files[#files] == after_query,
  "the checkout's go injections query should be on the rtp, got " .. vim.inspect(files)
)

local source = {
  "package fixture",
  "",
  'const fooJSON = `{"a": 1}`',
  "const plain = `plain text`",
  "var multi = `",
  '\t{"e": [1, 2]}',
  "`",
  "",
  "func f(db interface{ Query(string) }) {",
  '\tshort := `{"foo": "bar"}`',
  "\tdb.Query(\"SELECT * FROM users WHERE name = 'John'\")",
  '\ta := "ALTER TABLE users ADD COLUMN age int"',
  "\tb := `-- sql",
  "DROP TABLE users`",
  '\tc := "create index idx on users (name)"',
  '\tn := "update the cache"',
  '\tprintln(`{"f": 5}`)',
  '\tq := "{\\"g\\": 6}"',
  "\t_, _, _, _, _ = short, a, b, c, n, q",
  "}",
}

local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, source)
local parser = vim.treesitter.get_parser(buf, "go")
parser:parse(true)

--- Distinct texts of the regions injected as `lang`, sorted.
--- @param lang string
--- @return string[]
local function injected(lang)
  local child = parser:children()[lang]
  local seen, texts = {}, {}
  for _, ranges in pairs(child and child:included_regions() or {}) do
    for _, r in ipairs(ranges) do
      local text = table.concat(vim.api.nvim_buf_get_text(buf, r[1], r[2], r[4], r[5], {}), "\n")
      if not seen[text] then
        seen[text] = true
        texts[#texts + 1] = text
      end
    end
  end
  table.sort(texts)
  return texts
end

local function assert_set(lang, expected)
  table.sort(expected)
  local actual = injected(lang)
  if not vim.deep_equal(expected, actual) then
    error(
      string.format("%s injections:\n  expected %s\n  got      %s", lang, vim.inspect(expected), vim.inspect(actual))
    )
  end
  print(string.format("ok: %d distinct %s region(s)", #actual, lang))
end

-- The SELECT ... FROM regex pattern, then one string per keyword-list match
-- ("ALTER TABLE", "-- sql", "create index"). "update the cache" holds no
-- listed string and must stay plain.
assert_set("sql", {
  "SELECT * FROM users WHERE name = 'John'",
  "ALTER TABLE users ADD COLUMN age int",
  "-- sql\nDROP TABLE users",
  "create index idx on users (name)",
})

-- Only raw strings bound by const, var or := whose content is one object;
-- not plain text, not a call argument, not an interpreted string.
assert_set("json", {
  '{"a": 1}',
  '\n\t{"e": [1, 2]}\n',
  '{"foo": "bar"}',
})

print("ALL PASS: go_injections_spec")
