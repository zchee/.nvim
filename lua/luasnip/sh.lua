local ls = require("luasnip")

return {
  ls.s({
      trig = "devnull",
      name = "ignores show stdio output",
      dscr = " > /dev/null 2>&1",
    },
    ls.t("> /dev/null 2>&1{}")
  ),
}
