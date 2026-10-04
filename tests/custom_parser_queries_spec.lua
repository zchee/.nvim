---@diagnostic disable: undefined-global
-- Regression spec for the queries of the custom Tree-sitter grammars.
--
-- nvim-treesitter ships no queries for the grammars lua/nvim-treesitter/parsers.lua
-- adds, so each of those entries sets install_info.queries and install copies
-- (url) or symlinks (path) the grammar repo's own queries/ into
-- install_dir/queries/<lang>. Without them the parser still attaches,
-- vim.treesitter.start clears 'syntax', and the buffer renders with no colour
-- at all -- what a Ghostty config looked like before. This spec checks every
-- installed grammar among them: highlights resolves from the install dir and
-- every installed query compiles against the parser it shipped with. Then it
-- pins real captures on a Ghostty config.
local data = tostring(vim.fn.stdpath("data"))
local install_dir = vim.fs.joinpath(data, "tree-sitter-main")
vim.opt.runtimepath:prepend(install_dir)

local langs = { "cel", "ghostty", "goasm", "mustache", "x86asm" }

local checked = 0
for _, lang in ipairs(langs) do
  local parser_path = vim.fs.joinpath(install_dir, "parser", lang .. ".so")
  if not vim.uv.fs_stat(parser_path) then
    print("SKIP " .. lang .. ": parser is not installed at " .. parser_path .. " (run :TSEnsureInstalled)")
  else
    vim.treesitter.language.add(lang, { path = parser_path })
    local query_dir = vim.fs.joinpath(install_dir, "queries", lang)
    local files = vim.treesitter.query.get_files(lang, "highlights")
    assert(
      #files > 0 and vim.startswith(files[1], query_dir),
      string.format(
        "%s highlights should resolve from %s (reinstall with force so install copies the queries): got %s",
        lang,
        query_dir,
        vim.inspect(files)
      )
    )
    for name, kind in vim.fs.dir(query_dir, { follow = true }) do
      if (kind == "file" or kind == "link") and name:match("%.scm$") then
        local path = vim.fs.joinpath(query_dir, name)
        local ok, err = pcall(vim.treesitter.query.parse, lang, table.concat(vim.fn.readfile(path), "\n"))
        assert(ok, string.format("%s should compile against the installed %s parser: %s", path, lang, tostring(err)))
      end
    end
    checked = checked + 1
  end
end

if not vim.uv.fs_stat(vim.fs.joinpath(install_dir, "parser", "ghostty.so")) then
  print(string.format("ALL PASS (%d grammars; ghostty captures skipped)", checked))
  return
end

local query = vim.treesitter.query.get("ghostty", "highlights")
local lines = {
  "# comment",
  "font-family = JetBrains Mono",
  "font-size = 14",
  "bold-is-bright = true",
  "background = #1e1e2e",
  "palette = 0=#45475a",
  "config-file = ?themes/extra",
  "keybind = super+shift+k=goto_split:top",
  "keybind = clear",
}
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
local tree = vim.treesitter.get_parser(buf, "ghostty"):parse()[1]
assert(not tree:root():has_error(), "the fixture should parse without ERROR nodes: " .. tree:root():sexpr())

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
  { 0, "# comment", "comment" },
  { 1, "font-family", "variable" },
  { 1, "=", "operator" },
  { 1, "JetBrains", "string" },
  { 2, "14", "number" },
  { 3, "true", "boolean" },
  { 4, "#1e1e2e", "string" },
  { 5, "0=", "variable.member" },
  { 6, "config-file", "keyword.import" },
  { 6, "?", "keyword.conditional" },
  { 6, "themes/extra", "string.special.path" },
  { 7, "super", "constant.builtin" },
  { 7, "k=", "constant.builtin" },
  { 7, "goto_split", "function.call" },
  { 7, "top", "variable.parameter" },
  { 8, "clear", "keyword" },
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
print(string.format("ALL PASS (%d grammars, %d ghostty captures)", checked, #expect))
