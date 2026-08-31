local util = require("util")

local joinpath = vim.fs.joinpath
local cache_home = util.xdg_cache_home()

-- vim-helm ftdetect port: <root>/templates/**.{yaml,tpl,txt} is a Helm
-- template only when Chart.yaml sits at <root>; return nil otherwise so the
-- path falls through to the yaml/gotmpl rules.
local function helm_chart_template(path)
  local root = path:match("^(.*)/templates/")
  if root and vim.uv.fs_stat(root .. "/Chart.yaml") then
    return "helm"
  end
end

vim.filetype.add({
  extension = {
    s = require("filetypes.goasm").detect,
    ["code-workspace"] = "json",
    actiongrap = "json",
    alfredappearance = "json",
    apinotes = "yaml",
    asm = "nasm",
    bash = "bash",
    bttpreset = "json",
    cnf = "ini",
    conf = "conf",
    defs = "c",
    dockerfile = "dockerfile",
    dockerignore = "gitignore",
    editorconfig = "dosini",
    envrc = "sh",
    es6 = "javascript",
    gcloudignore = "gitignore",
    go = "go",
    go2 = "go",
    gunk = "gunk.go",
    hla = "hla",
    hujson = "jsonc",
    i = "swig",
    icls = "xml",
    inc = "masm",
    jsonc = "jsonc",
    jsonl = "jsonl",
    mm = "objcpp",
    pen = "json",
    pth = "python",
    pyd = "python",
    pyx = "python",
    replay = "json",
    sb = "scheme",
    slide = "goslide",
    sql = "mysql",
    swig = "swig",
    swigcxx = "swig",
    tbd = "yaml",
    tfstate = "teraterm",
    -- helmfile templated values (vim-helm ftdetect port)
    gotmpl = "helm",
    tmpl = "gotmpl",
    tpl = "gotmpl",
    ts = "typescript",
    vfj = "jsonc",
    vmoptions = "conf",
    y = "goyacc",
    zsh = "zsh",
  },
  filename = {
    [".aiderignore"] = "gitignore",
    [".bash_profile"] = "bash",
    [".bazelrc"] = "bzl",
    [".boto"] = "cfg",
    [".clang-format"] = "yaml",
    [".clangd"] = "yaml",
    [".dockerignore"] = "gitignore",
    [".eslintignore"] = "gitignore",
    [".firebaserc"] = "json",
    [".gcloudignore"] = "gitignore",
    [".gunkconfig"] = "cfg",
    [".markdownlintrc"] = "json",
    [".prettierignore"] = "gitignore",
    [".pythonrc"] = "python",
    [".renovaterc"] = "json5",
    [".renovaterc.json"] = "json5",
    [".tern-config"] = "json",
    [".tfvars"] = "teraterm",
    [".yamlfmt"] = "yaml",
    [".yamllint"] = "yaml",
    -- ["docker-bake.hcl"]  = "docker-bake",
    ["glide.lock"] = "yaml",
    ["go.tool.mod"] = "gomod",
    ["Gopkg.lock"] = "toml",
    ["kitty.conf"] = "kitty",
    ["lsif.json"] = "json5",
    ["netrc"] = "netrc",
    ["osquery.conf"] = "json",
    ["poetry.lock"] = "toml",
    ["proto.lock"] = "json",
    ["tsconfig%.json"] = "json5",
    bash_profile = "sh",
    boto = "cfg",
    manifest = "json",
    PROJECT = "yaml",
    Tiltfile = "tiltfile",
  },
  pattern = {
    -- vim-helm ftdetect port: chart templates (Chart.yaml-gated, nil falls
    -- through to yaml/gotmpl), helmfile manifests, and helm values files
    [".*/templates/.*%.ya?ml"] = helm_chart_template,
    [".*/templates/.*%.tpl"] = helm_chart_template,
    [".*/templates/.*%.txt"] = helm_chart_template,
    [".*/helmfile[^/]*%.ya?ml"] = "helm",
    [".*/values[^/]*%.ya?ml"] = "yaml.helm-values",
    [".*%.go%.tpl"] = "gotmpl",
    [".*%.keymap"] = "devicetree",
    [".*%.llms%.txt"] = "markdown",
    [".*%.py%.tmpl"] = "python",
    [".*%.tf%.tmpl"] = "terraform",
    [".*%.xo%.go%.tpl"] = "go",
    [".*.schema%.json"] = "jsonschema",
    [".*/.?git/config"] = "gitconfig",
    [".*/.?kube/config"] = "yaml",
    [".*/.config/%.ssh/config.d/.*"] = "sshconfig",
    [".*/.config/cabal"] = "cabalconfig",
    [".*/.config/direnv/direnvrc"] = "sh",
    [".*/.config/gcloud/configurations/.*"] = "cfg",
    [".*/.config/git/config.d/.*"] = "gitconfig",
    [".*/.config/go/env/.*"] = "sh",
    [".*/.config/jira.d/templates/.*"] = "gotmpl",
    [".*/.config/op/config"] = "json",
    [".*/.config/tig/config*"] = "tigrc",
    [".*/.config/zsh/completions/.*"] = "zsh",
    [".*/.jira.d/templates/.*"] = "gotmpl",
    [".*/.vscode/.*%.json"] = "json5",
    [".*/argocd/config"] = "yaml",
    [".*/c%+%+/.*"] = "cpp",
    [".*/google%-cloud%-sdk/properties"] = "cfg",
    [".*/kitty/.*%.conf"] = "kitty",
    -- ftdetect/kitty.lua port: its vim.b.filetype assignment was a no-op
    -- (buffer variable, not vim.bo), so this rule is what makes the mapping
    -- real for the first time
    [".*/kitty/.*%.session"] = "kitty-session",
    [".*/makedefs/.*"] = "make",
    [".*/share/zsh/(site-)?functions/.*"] = "zsh",
    [".*/testdata/.*/.*%.go%.golden"] = "go",
    [".*/zed/settings.json"] = "jsonc",
    [".*/zsh/functions/.*"] = "zsh",
    [".*/zsh_history"] = "zsh",
    [".*bashrc.*"] = "bash",
    [".*lima%-editor%-.*"] = "yaml", -- for limactl edit
    [".*renovate%.json"] = "json5",
    [".env.*"] = "bash",
    [".envrc.*"] = "bash",
    ["/private/etc/sudoers.d/.*"] = "sudoers",
    ["[Dd]ockerfile.*[^.vim|^.lua]"] = "dockerfile",
    ["~/Library/Application Support/Code - Insiders/User/keybindings.json"] = "json5",
    -- vim.filetype.add matches `pattern` keys as Lua patterns, not globs, and
    -- an unescaped one here matched nothing: `-` is the lazy quantifier, so
    -- "go-build" stood for "gbuild"/"gobuild" and never the real directory,
    -- while `**` is not a wildcard at all. vim.pesc escapes the whole prefix,
    -- the `.` of .cache included; the match is unanchored, so `/.*` is what
    -- carries the "everything under here" the `**` was reaching for.
    [vim.pesc(joinpath(cache_home, "go", "go-build")) .. "/.*"] = "go",
    -- ftdetect/gotmpl.vim replacement: that autocmd ran an unanchored
    -- whole-buffer VimL search() on EVERY BufNewFile/BufRead and clobbered
    -- filetypes other rules had already set. Negative priority makes this a
    -- fallback consulted only when no filename/extension/pattern rule (here
    -- or in the runtime) decided anything, and the scan is bounded to the
    -- first 20 lines. Matches Go template actions such as `{{.Name}}`,
    -- `{{ .Name }}`, and `{{$var}}`.
    --
    -- Keyed ".*.*", not ".*": vim.filetype.add stores user patterns by their
    -- implicitly anchored form ("^<pat>$"), so snacks.nvim's bigfile feature
    -- registering ".*" at setup would silently replace a ".*" entry here --
    -- and an explicit "^" cannot be used because anchoring would double it
    -- into a never-matching "^^...". ".*.*" matches identically under its
    -- own slot.
    [".*.*"] = {
      function(_, bufnr)
        if bufnr == nil then
          return
        end
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)) do
          if line:find("{{%s*[%.%$]") then
            return "gotmpl"
          end
        end
      end,
      { priority = -math.huge },
    },
    [".*README.(%a+)"] = function(_, _, ext)
      return util.switch(ext)({
        ["md"] = function()
          return "markdown"
        end,
        ["rst"] = function()
          return "rst"
        end,
      })
    end,
  },
})
