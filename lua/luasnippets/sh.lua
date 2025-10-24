local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
  ls.s(
    {
      trig = "shebang",
    },
    fmt([[
#!/usr/bin/env bash
set -eo pipefail
				]],
      {
        -- ls.i(1, "return err"),
      }
    )),

  ls.s({
      trig = "devnull",
      name = "ignores show stdio output",
      dscr = " > /dev/null 2>&1",
    },
    ls.t("> /dev/null 2>&1{}")
  ),
}
