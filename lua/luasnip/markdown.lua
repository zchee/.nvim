local ls = require("luasnip")
local ls_ext_fmt = require("luasnip.extras.fmt")
local fmt = ls_ext_fmt.fmt

-- https://github.com/orgs/community/discussions/16925
return {
  ls.s({
      trig = "note",
      name = "Highlights information that users should take into account, even when skimming.",
      dscr = "[!NOTE]",
    },
    fmt([[
> [!NOTE]
> {}]],
      {
        ls.i(1),
      }
    )
  ),
  ls.s({
      trig = "tip",
      name = "Optional information to help a user be more successful.",
      dscr = "[!TIP]",
    },
    fmt([[
> [!TIP]
> {}]],
      {
        ls.i(1),
      }
    )
  ),
  ls.s({
      trig = "important",
      name = "Crucial information necessary for users to succeed.",
      dscr = "[!IMPORTANT]",
    },
    fmt([[
> [!IMPORTANT]
> {}]],
      {
        ls.i(1),
      }
    )
  ),
  ls.s({
      trig = "warning",
      name = "Critical content demanding immediate user attention due to potential risks.",
      dscr = "[!WARNING]",
    },
    fmt([[
> [!WARNING]
> {}]],
      {
        ls.i(1),
      }
    )
  ),
  ls.s({
      trig = "caution",
      name = "Negative potential consequences of an action.",
      dscr = "[!CAUTION]",
    },
    fmt([[
> [!CAUTION]
> {}]],
      {
        ls.i(1),
      }
    )
  ),
}
