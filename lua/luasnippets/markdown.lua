local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

-- https://github.com/orgs/community/discussions/16925
return {
  ls.s({
      trig = "high-note",
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
      trig = "high-tip",
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
      trig = "high-important",
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
      trig = "high-warning",
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
      trig = "high-caution",
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
