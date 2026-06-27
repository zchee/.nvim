local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
  ls.s(
    {
      trig = "shebang",
      dscr = "bash shebang with strict mode",
    },
    fmt(
      [[
#!/usr/bin/env bash
set -euo pipefail
# shellcheck shell=bash
				]],
      {}
    )
  ),

  ls.s({
    trig = "devnull",
    name = "ignores show stdio output",
    dscr = " > /dev/null 2>&1",
  }, ls.t("> /dev/null 2>&1{}")),
}
