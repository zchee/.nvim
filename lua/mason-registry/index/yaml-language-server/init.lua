local Pkg = require "mason-core.package"
local git = require "mason-core.managers.git"
local path = require "mason-core.path"

return Pkg.new {
  name = "yaml-language-server",
  desc = [[Language Server for YAML Files]],
  homepage = "https://github.com/redhat-developer/yaml-language-server",
  languages = { Pkg.Lang.YAML },
  categories = { Pkg.Cat.LSP },
  install = function(ctx)
    git.clone({ "https://github.com/redhat-developer/yaml-language-server" }).with_receipt()
    ctx:promote_cwd()
    ctx.spawn.yarn {
      "add", "prettier@2.0.5",
      with_paths = { ctx.cwd:get() },
    }
    ctx.spawn.yarn {
      "run", "compile",
      with_paths = { ctx.cwd:get() },
    }
    ctx:link_bin(
      "yaml-language-server",
      ctx:write_node_exec_wrapper("yaml-language-server", path.concat { "bin", "yaml-language-server" })
    )
  end,
}
