local Pkg = require "mason-core.package"

return Pkg.new {
  name = "delve",
  desc = [[Delve is a debugger for the Go programming language.]],
  homepage = "https://github.com/go-delve/delve",
  languages = { Pkg.Lang.Go },
  categories = { Pkg.Cat.DAP },
  install = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end
}
