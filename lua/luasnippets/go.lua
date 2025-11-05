local ls = require("luasnip")
local ls_ext_fmt = require("luasnip.extras.fmt")
local fmt = ls_ext_fmt.fmt
local fmta = ls_ext_fmt.fmta
local rep = require("luasnip.extras").rep
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local partial = require("luasnip.extras").partial

local function in_func()
  local ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
  if not ok then
    return false
  end
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return false
  end
  local expr = current_node

  while expr do
    if expr:type() == 'function_declaration' or expr:type() == 'method_declaration' then
      return true
    end
    local parent = expr:parent()
    if not parent then
      return false
    end
    expr = parent
  end
  return false
end

local function is_in_test_file()
  local filename = vim.fn.expand('%:p')
  return vim.endswith(filename, '_test.go')
end

local function is_in_test_function()
  return is_in_test_file() and in_func()
end

-- local luasnip_util = require("luasnippets.util")
-- local events = require("luasnippets.util.events")

local in_fn = {
  show_condition = in_func,
  condition = in_func,
}

local not_in_fn = {
  show_condition = not in_func,
  condition = not in_func,
}

local in_test_fn = {
  show_condition = is_in_test_function,
  condition = is_in_test_function,
}

local in_test_file = {
  show_condition = is_in_test_file,
  condition = is_in_test_file,
}

--- Function
local func_snippets = {
  ls.s(
    {
      trig = "len",
      dscr = "len(...)",
    },
    fmt([[len({})]],
      {
        ls.i(1, "object"),
      },
      in_fn
    )
  ),

  -- iter
  -- Seq is an iterator over sequences of individual values.
  -- When called as seq(yield), seq calls yield(v) for each value v in the sequence,
  -- stopping early if yield returns false.
  -- See the [iter] package documentation for more details.
  ls.s(
    {
      trig = "iterseq",
      dscr = "iter.Seq[V any]",
    },
    fmta([[
				return func(yield func(<1>) bool) {
					<>
				}
    ]],
      {
        ls.i(1, "type"),
        ls.i(0),
      },
      in_fn
    )
  ),
  -- Seq2 is an iterator over sequences of pairs of values, most commonly key-value pairs.
  -- When called as seq(yield), seq calls yield(k, v) for each pair (k, v) in the sequence,
  -- stopping early if yield returns false.
  -- See the [iter] package documentation for more details.
  ls.s(
    {
      trig = "iterseq2",
      dscr = "iter.Seq2[K, V any]",
    },
    fmta([[
				return func(yield func(<1>, <2>) bool) {
					<>
				}
    ]],
      {
        ls.i(1, "type"),
        ls.i(2, "error"),
        ls.i(0),
      },
      in_fn
    )
  ),

  -- fmt
  ls.s(
    {
      trig = "ff",
      dscr = "fmt.Printf(...)",
    },
    fmt([[fmt.Printf("{}: %#v\n", {})]],
      {
        ls.i(1, ""),
        rep(1),
      },
      in_fn
    )
  ),
  ls.s(
    {
      trig = "ft",
      dscr = "fmt.Printf(%T = %#v)",
    },
    fmt([[fmt.Printf("{}: %[1]T = %#[1]v\n", {})]],
      {
        ls.i(1, ""),
        rep(1),
      },
      in_fn
    )
  ),
  ls.s(
    {
      trig = "fl",
      dscr = "fmt.Println(...)",
    },
    fmt([[fmt.Println("{}")]],
      {
        ls.i(1, ""),
      },
      in_fn
    )
  ),

  -- error handling
  ls.s(
    {
      trig = "iferr",
      dscr = "if err != nil",
    },
    fmta([[
				if err != nil {
					<>
				}
				]],
      {
        ls.i(1, "return err"),
      },
      in_fn
    )
  ),
  ls.s(
    {
      trig = "errnil",
      dscr = "err != nil {return err}",
    },
    fmta([[
				; err != nil {
					<>
				}
				]],
      {
        ls.i(1, "return err"),
      },
      in_fn
    )
  ),

  ls.s(
    {
      trig = "tabwriter",
      dscr = "tw := tabwriter.NewWriter(...)",
    },
    fmt([[tw := tabwriter.NewWriter(os.Stdout, 0, 8, 0, '\t', tabwriter.TabIndent){}]],
      {
        ls.i(1, ""),
      }
    )
  ),
}

-- Testing
local test_snippets = {
  ls.s(
    {
      trig = "tf",
      dscr = "t.Logf(...)",
    },
    fmt([[t.Logf("{}: %#v", {})]],
      {
        ls.i(1, ""),
        rep(1),
      },
      in_test_fn
    )
  ),
  ls.s(
    {
      trig = "ft",
      dscr = "t.Logf(%T = %#v)",
    },
    fmt([[t.Logf("{}: %[1]T = %#[1]v\n", {})]],
      {
        ls.i(1, ""),
        rep(1),
      },
      in_test_fn
    )
  ),

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
      },
      in_test_file
    )
  ),
  -- cmp.Diff
  ls.s(
    {
      trig = "diff",
      dscr = 'if diff := cmp.Diff(sc, got); diff != "" {; t.Fatalf("(+want, -got)", diff)}',
    },
    fmta([[
        if diff := cmp.Diff(<1>, <2>); diff != "" {
        	t.Fatalf("(+want, -got)\n%s", diff)
        }
				]],
      {
        ls.i(1, "want"),
        ls.i(2, "got"),
      },
      in_test_fn
    )
  ),

  -- benchmark
  ls.s(
    {
      trig = "bench",
      name = "benchmark",
      dscr = "Create benchmark",
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
      },
      in_test_file
    )
  ),

  -- benchmark with parallel
  ls.s(
    {
      trig = "benchp",
      name = "parallel benchmark",
      dscr = "Create parallel benchmark",
    },
    fmta([[
				var bench<> <>

				func Benchmark<>(b *testing.B) {{
					b.RunParallel(func(pb *testing.PB) {
          	for pb.Next() {
          		bench<> = <>(<>)
          	}
					}}
				]],
      {
        ls.i(1, "dummy variable"),
        ls.i(2, "dummy type"),
        ls.i(3, "name"),
        rep(1),
        ls.i(3, "function"),
        ls.i(4, "args")
      },
      in_test_file
    )
  ),
}

-- Comment
local doc_snippets = {
  ls.s(
    {
      trig = "doc_string",
      dscr = "String returns a string representation of the $1",
    },
    fmt([[// String returns a string representation of the {}.]],
      {
        ls.i(1, "type name"),
      }
    )
  ),

  ls.s(
    {
      trig = "doc_error",
      dscr = "Error returns a string representation of the ...",
    },
    fmt([[// Error returns a string representation of the [{}].]],
      {
        ls.i(1, "type name"),
      }
    )
  ),
  ls.s(
    {
      trig = "doc_implements",
      name = "... implements [...]",
      dscr = "... implements [...]",
    },
    fmt([[ implements [{}].]],
      {
        ls.i(1),
      }
    )
  ),
  ls.s(
    {
      trig = "doc_represents",
      name = "... represents a [...]",
      dscr = "... represents a [...]",
    },
    fmt([[ represents a {}]],
      {
        ls.i(1),
      }
    )
  ),
  ls.s(
    {
      trig = "doc_deprecated",
      name = "Deprecated: ...",
      dscr = "Deprecated: ...",
    },
    fmt([[// Deprecated: Use {} instead of.{}]],
      {
        ls.i(1, "name"),
        ls.i(2),
      }
    )
  ),
  ls.s(
    {
      trig = "doc_drop-in",
      name = "drop-in replacement",
    },
    fmt([[ is a drop-in replacement for [{}] with {}.]],
      {
        ls.i(1, "target type name"),
        ls.i(2, "what"),
      }
    )
  ),
  ls.s(
    {
      trig = "doc_equivalent",
      name = "equivalent to",
    },
    fmt([[ is equivalent to [{}] with {}.]],
      {
        ls.i(1, "target type name"),
        ls.i(2, "what"),
      }
    )
  ),
  ls.s(
    {
      trig = "doc_concurrently",
      name = "concurrently call",
    },
    fmt([[// This method is safe to call concurrently.]], {}
    )
  ),
}

local add_snippets_opt = { refresh_notify = true, type = "snippets" }
ls.add_snippets("go", func_snippets, add_snippets_opt)
ls.add_snippets("go", doc_snippets, add_snippets_opt)
ls.add_snippets("go", test_snippets, add_snippets_opt)
