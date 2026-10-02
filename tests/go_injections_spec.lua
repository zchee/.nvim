---@diagnostic disable: undefined-global
-- Regression spec for after/queries/go/injections.scm's SQL and JSON
-- patterns.
--
-- The SQL pattern is one #match? anchored at the start of a string's
-- content: an upper-case statement keyword followed by more text, a
-- lower-case select/insert/update/delete that later reaches
-- from/into/set/values, or a "-- sql" marker. Import paths and sentences
-- that merely contain an SQL word must stay plain, and a literal must never
-- be injected twice. The JSON patterns once captured raw_string_literal,
-- whose raw_string_literal_content child an injection leaves out of the
-- region, and injected nothing.
-- This parses an inline Go source against the installed go/sql/json parsers
-- with only $VIMRUNTIME, the parser dir and this checkout's after/ on the rtp,
-- and compares the number of regions per injected text with the expected
-- counts, so a dropped match, a false positive or a duplicate fails here.
-- Prints SKIP when any of the three parsers is missing.

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
  'import _ "database/sql/driver"',
  "",
  'const fooJSON = `{"a": 1}`',
  "const plain = `plain text`",
  "var multi = `",
  '\t{"e": [1, 2]}',
  "`",
  "var query = `",
  "\tSELECT id, name",
  "\tFROM users",
  "\tWHERE id = $1`",
  "",
  "func f(db interface{ Query(string) }) {",
  '\tshort := `{"foo": "bar"}`',
  "\tdb.Query(\"SELECT * FROM users WHERE name = 'John'\")",
  '\tdb.Query("insert into users values (1)")',
  '\tdb.Query("select p.name from people as p where p.id = :id")',
  '\ta := "ALTER TABLE users ADD COLUMN age int"',
  "\tb := `-- sql",
  "DROP TABLE users`",
  '\tc := "CREATE INDEX idx ON users (name)"',
  '\tn1 := "unknown database name %q"',
  '\tn2 := "no rows having that id"',
  '\tn3 := "please update the cache"',
  '\tn4 := "please select an option from the menu"',
  '\tn5 := "create %q: %s"',
  '\tn6 := "can\'t delete from empty map"',
  '\tprintln(`{"f": 5}`)',
  '\tq := "{\\"g\\": 6}"',
  "\t_ = []any{short, a, b, c, n1, n2, n3, n4, n5, n6, q}",
  "}",
}

local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, source)
local parser = vim.treesitter.get_parser(buf, "go")
parser:parse(true)

--- Number of regions injected as `lang`, keyed by the region's text.
--- @param lang string
--- @return table<string, integer>
local function injected(lang)
  local child = parser:children()[lang]
  local counts = {}
  for _, ranges in pairs(child and child:included_regions() or {}) do
    for _, r in ipairs(ranges) do
      local text = table.concat(vim.api.nvim_buf_get_text(buf, r[1], r[2], r[4], r[5], {}), "\n")
      counts[text] = (counts[text] or 0) + 1
    end
  end
  return counts
end

--- Every text in `expected` must be injected exactly once, and nothing else.
--- @param lang string
--- @param expected string[]
local function assert_once_each(lang, expected)
  local want = {}
  for _, text in ipairs(expected) do
    want[text] = 1
  end
  local actual = injected(lang)
  if not vim.deep_equal(want, actual) then
    error(
      string.format("%s regions per text:\n  expected %s\n  got      %s", lang, vim.inspect(want), vim.inspect(actual))
    )
  end
  print(string.format("ok: %d %s region(s), one per literal", #expected, lang))
end

--- A negative that is missing from the source would pass vacuously.
--- @param texts string[]
local function assert_in_source(texts)
  local joined = table.concat(source, "\n")
  for _, text in ipairs(texts) do
    assert(joined:find(text, 1, true), "the source should contain the negative case " .. text)
  end
end

-- No SQL for an import path, for sentences that hold an SQL word, or for Go
-- error strings that start with a lower-case verb.
assert_in_source({
  "database/sql/driver",
  "unknown database name %q",
  "no rows having that id",
  "please update the cache",
  "please select an option from the menu",
  "create %q: %s",
  "can't delete from empty map",
})

assert_once_each("sql", {
  "\n\tSELECT id, name\n\tFROM users\n\tWHERE id = $1",
  "SELECT * FROM users WHERE name = 'John'",
  "insert into users values (1)",
  "select p.name from people as p where p.id = :id",
  "ALTER TABLE users ADD COLUMN age int",
  "-- sql\nDROP TABLE users",
  "CREATE INDEX idx ON users (name)",
})

-- Only raw strings bound by const, var or := whose content is one object;
-- not plain text, not a call argument, not an interpreted string.
assert_once_each("json", {
  '{"a": 1}',
  '\n\t{"e": [1, 2]}\n',
  '{"foo": "bar"}',
})

print("ALL PASS: go_injections_spec")
