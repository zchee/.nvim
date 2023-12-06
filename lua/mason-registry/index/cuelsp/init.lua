local Pkg = require "mason-core.package"
local go = require "mason-core.managers.go"
local Optional = require "mason-core.optional"

return Pkg.new {
  name = "cuelsp",
  desc = [[Language Server implementation for CUE, with built-in support for Dagger.]],
  homepage = "https://github.com/dagger/cuelsp",
  languages = { Pkg.Lang.Cue },
  categories = { Pkg.Cat.LSP },
  install = function(ctx)
    ctx.requested_version = ctx.requested_version:or_(function()
      return Optional.of "main"
    end)
    go.install({ "github.com/dagger/cuelsp/cmd/cuelsp", bin = { "cuelsp" } }).with_receipt()
  end,
}
