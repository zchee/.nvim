local ls = require("luasnip")
local ls_ext_fmt = require("luasnip.extras.fmt")
local fmt = ls_ext_fmt.fmt
local fmta = ls_ext_fmt.fmta
local rep = require("luasnip.extras").rep
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local partial = require("luasnip.extras").partial
local luasnip_util = require("luasnip.util")
-- local events = require("luasnip.util.events")

local in_test_fn = {
  show_condition = luasnip_util.in_test_function,
  condition = luasnip_util.in_test_function,
}

local in_test_file = {
  show_condition = luasnip_util.in_test_file_fn,
  condition = luasnip_util.in_test_file_fn,
}

local in_fn = {
  show_condition = luasnip_util.in_function,
  condition = luasnip_util.in_function,
}

local not_in_fn = {
  show_condition = luasnip_util.in_func,
  condition = luasnip_util.in_func,
}

local func_snippets = {
  ls.s(
    {
      trig = "tabwriter",
      dscr = "tw := tabwriter.NewWriter(...)",
    },
    fmt([[tw := tabwriter.NewWriter(os.Stdout, 0, 8, 0, '\t', tabwriter.TabIndent){}]],
      {
        ls.i(1, ""),
      }
    ),
    in_fn
  )
}

-- Comment
local doc_snippets = {
  ls.s(
    {
      trig = "doc_string",
      name = "String method documentations",
      dscr = "String returns a string representation of the $1",
    },
    fmt([[String returns a string representation of the {}.]],
      {
        ls.i(1, "type name"),
      }
    ),
    not_in_fn
  ),

  ls.s(
    {
      trig = "doc_error",
      name = "Error method documentations",
      dscr = "Error returns a string representation of the $1",
    },
    fmt([[Error returns a string representation of the {}.]],
      {
        ls.i(1, "type name"),
      }
    ),
    not_in_fn
  ),

  ls.s(
    {
      trig = "doc_implements",
      name = "... implements [...]",
      dscr = "... implements [...]",
    },
    fmt([[{} implements {}]],
      {
        ls.i(1, "type name"),
        ls.i(2),
      }
    ),
    not_in_fn
  ),

  ls.s(
    {
      trig = "doc_represents",
      name = "... represents a [...]",
      dscr = "... represents a [...]",
    },
    fmt([[{} represents a {}]],
      {
        ls.i(1, "type name"),
        ls.i(2),
      }
    ),
    not_in_fn
  ),

  ls.s(
    {
      trig = "doc_deprecated",
      name = "Deprecated: ...",
      dscr = "Deprecated: ...",
    },
    fmt([[Deprecated: Use {} instead of.{}]],
      {
        ls.i(1, "name"),
        ls.i(2),
      }
    ),
    not_in_fn
  ),

  ls.s(
    {
      trig = "doc_drop-in",
      name = "drop-in replacement",
    },
    fmt([[{} is a drop-in replacement for [{}] with {}.]],
      {
        ls.i(1, "type name"),
        ls.i(2, "target type name"),
        ls.i(3, "what"),
      }
    ),
    not_in_fn
  ),
  ls.s(
    {
      trig = "doc_equivalent",
      name = "equivalent to",
    },
    fmt([[{} is equivalent to [{}] with {}.]],
      {
        ls.i(1, "type name"),
        ls.i(2, "target type name"),
        ls.i(3, "what"),
      }
    ),
    not_in_fn
  ),
}

-- testing
local test_snippets = {
  -- testcases
  ls.s(
    {
      trig = "test",
      dscr = "create test cases for testing",
    },
    fmta([[
				func Test<>(t *testing.T) {
					t.Parallel()

					tests := map[string]struct {
						<>
					}{
						// Test cases here
					}
					for name, tt := range tests {
						tt := tt
						t.Run(name, func(t *testing.T) {
							t.Parallel()

							<>
						})
					}
				}
				]],
      {
        ls.i(1),
        ls.i(2),
        ls.i(3),
      }
    ),
    in_test_fn
  ),

  -- bench test
  ls.s(
    {
      trig = "bench",
      name = "bench test cases ",
      dscr = "Create benchmark test",
    },
    fmt([[
				func Benchmark{}(b *testing.B) {{
					b.ReportAllocs()
					b.ResetTimer()

					for i := 0; i < b.N; i++ {{
						{}({})
					}}
				}}
				]],
      {
        ls.i(1, "method name"),
        rep(1),
        ls.i(2, "args")
      }
    ),
    in_test_file
  ),
}

local add_snippets_opt = { refresh_notify = true, type = "snippets" }
ls.add_snippets("go", func_snippets, add_snippets_opt)
ls.add_snippets("go", doc_snippets, add_snippets_opt)
ls.add_snippets("go", test_snippets, add_snippets_opt)
