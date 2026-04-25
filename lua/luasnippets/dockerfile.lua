local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

-- # syntax=docker.io/docker/dockerfile-upstream:master-labs
-- # check=error=true

return {
  -- https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md#syntax
  ls.s(
    {
      trig = "syntax",
      name = "Declare the Dockerfile syntax version to use for the build.",
      dscr = "syntax",
    },
    fmt([[# syntax=docker.io/docker/dockerfile-upstream:{}]], {
      ls.i(1, "master-labs"),
    })
  ),

  -- https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md#check
  ls.s(
    {
      trig = "check",
      name = "Configure how build checks are evaluated.",
      dscr = "check",
    },
    fmt([[# check={}]], {
      ls.i(1, "error=true"),
    })
  ),
}
