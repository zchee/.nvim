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
}
