local ls = require("luasnip")
local ls_ext_fmt = require("luasnip.extras.fmt")
local fmt = ls_ext_fmt.fmt
local fmta = ls_ext_fmt.fmta

return {
  ls.s(
    {
      trig = "uv_shebang",
      dscr = "uv inline-script header (PEP 723)",
    },
    fmta(
      [[
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">>=<1>"
# dependencies = [
#   "<2>",
# ]
# ///
<>
				]],
      {
        ls.i(1, "version"),
        ls.i(2, "dependencies"),
        ls.i(0),
      }
    )
  ),
}
