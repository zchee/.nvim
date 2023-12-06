local Pkg = require "mason-core.package"
local go = require "mason-core.managers.go"
local Optional = require "mason-core.optional"

return Pkg.new {
  name = "buf-language-server",
  desc = [[`bufls` is a prototype for the beginnings of a Protobuf language server compatible with Buf modules and workspaces.]],
  homepage = "https://github.com/bufbuild/buf-language-server",
  languages = { Pkg.Lang.Protobuf },
  categories = { Pkg.Cat.LSP },
  install = function(ctx)
    ctx.requested_version = ctx.requested_version:or_(function()
      return Optional.of "main"
    end)
    go.install({ "github.com/bufbuild/buf-language-server/cmd/bufls", bin = { "bufls" } }).with_receipt()
  end,
}
