local ls = require("luasnip")

return {
  ls.s({
    trig = "yaml-language-server",
    name = "yaml-language-server=",
    dscr = "yaml-language-server: $schema=...",
  }, ls.t("# yaml-language-server: $schema=")),
}
