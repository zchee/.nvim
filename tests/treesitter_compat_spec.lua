---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local compat = require("plugins.treesitter_compat")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_truthy(value, message)
  if not value then
    error(message)
  end
end

local function assert_falsy(value, message)
  if value then
    error(message)
  end
end

local function new_parent(child)
  local parent = {}

  function parent:named_child_count()
    return 1
  end

  function parent:named_child(index)
    assert_equal(0, index, "nth? should query the requested child index")
    return child
  end

  return parent
end

local function new_node(kind)
  local node = {
    _type = kind,
  }

  function node:type()
    return self._type
  end

  return node
end

do
  local node = new_node("lua")

  assert_equal(node, compat.capture_node({ [3] = node }, 3), "capture_node should return a direct capture")
  assert_equal(node, compat.capture_node({ [3] = { node } }, 3), "capture_node should unwrap list captures")
  assert_equal(nil, compat.capture_node({}, 3), "capture_node should ignore missing captures")
end

do
  assert_equal(
    "markdown",
    compat.get_parser_from_markdown_info_string("md", function(args)
      assert_equal("a.md", args.filename, "filetype lookup should receive the synthetic filename")
      return "markdown"
    end),
    "markdown aliases should prefer filetype matches"
  )

  assert_equal(
    "bash",
    compat.get_parser_from_markdown_info_string("sh", function(_args)
      return nil
    end),
    "known non-filetype aliases should map to their parser names"
  )
end

do
  local predicate_calls = 0
  local directive_calls = 0
  local errors = {}
  local registered_predicates = {}
  local registered_directives = {}
  local fake_query = {
    add_predicate = function(name, handler, opts)
      predicate_calls = predicate_calls + 1
      registered_predicates[name] = { handler = handler, opts = opts }
    end,
    add_directive = function(name, handler, opts)
      directive_calls = directive_calls + 1
      registered_directives[name] = { handler = handler, opts = opts }
    end,
  }

  compat.patch_query_predicates(fake_query, {
    add_opts = { force = true, all = false },
    notify_error = function(message)
      errors[#errors + 1] = message
    end,
    get_node_text = function(node, _bufnr, opts)
      if opts and opts.metadata and opts.metadata.text then
        return opts.metadata.text
      end
      return node._text
    end,
    match_filetype = function(args)
      if args.filename == "a.lua" then
        return "lua"
      end
      return nil
    end,
    tbl_contains = function(list, value)
      return vim.tbl_contains(list, value)
    end,
    find_definition = function(_node, _bufnr)
      return nil, nil, "parameter"
    end,
  })

  compat.patch_query_predicates(fake_query, {})

  assert_equal(3, predicate_calls, "patch should register the expected custom predicates")
  assert_equal(3, directive_calls, "patch should register the expected custom directives")
  assert_truthy(fake_query._zchee_query_predicates_patched, "patch should mark the query module as patched")

  local nth_node = new_node("identifier")
  local nth_parent = new_parent(nth_node)
  function nth_node:parent()
    return nth_parent
  end

  assert_truthy(
    registered_predicates["nth?"].handler({ [1] = { nth_node } }, nil, 0, { "nth?", 1, "0" }),
    "nth? should unwrap list captures before checking the parent"
  )

  assert_truthy(
    registered_predicates["kind-eq?"].handler(
      { [1] = { new_node("string") } },
      nil,
      0,
      { "kind-eq?", 1, "comment", "string" }
    ),
    "kind-eq? should compare the unwrapped capture type"
  )

  assert_truthy(
    registered_predicates["is?"].handler(
      { [1] = { new_node("identifier") } },
      nil,
      0,
      { "is?", 1, "parameter", "field" }
    ),
    "is? should use the unwrapped capture when resolving the local definition kind"
  )

  local mimetype_metadata = {}
  registered_directives["set-lang-from-mimetype!"].handler(
    { [1] = { { _text = "application/ecmascript" } } },
    nil,
    0,
    { "set-lang-from-mimetype!", 1 },
    mimetype_metadata
  )
  assert_equal(
    "javascript",
    mimetype_metadata["injection.language"],
    "mimetype directive should map known script types"
  )

  local markdown_metadata = {}
  registered_directives["set-lang-from-info-string!"].handler(
    { [1] = { { _text = "LUA" } } },
    nil,
    0,
    { "set-lang-from-info-string!", 1 },
    markdown_metadata
  )
  assert_equal(
    "lua",
    markdown_metadata["injection.language"],
    "markdown info directive should lowercase and resolve parser aliases"
  )

  local downcase_metadata = {
    [1] = { text = "HeLLo" },
  }
  registered_directives["downcase!"].handler(
    { [1] = { { _text = "unused" } } },
    nil,
    0,
    { "downcase!", 1 },
    downcase_metadata
  )
  assert_equal("hello", downcase_metadata[1].text, "downcase! should lowercase capture metadata text")

  assert_equal(nil, errors[1], "valid registrations should not emit argument errors")
  assert_equal(true, registered_predicates["nth?"].opts.force, "patch should register predicates with force enabled")
  assert_falsy(registered_predicates["nth?"].opts.all, "patch should preserve the nvim-treesitter override scope")
end
