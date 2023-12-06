local Pkg = require "mason-core.package"

return Pkg.new {
  name = "gopls",
  desc = [[gopls (pronounced "Go please") is the official Go language server developed by the Go team. It provides IDE features to any LSP-compatible editor.]],
  homepage = "https://pkg.go.dev/golang.org/x/tools/gopls",
  languages = { Pkg.Lang.Go },
  categories = { Pkg.Cat.LSP },
  install = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end
}
