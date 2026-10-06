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

-- README.<ext>: the extensions that decide the filetype; any other falls
-- through to the remaining rules.
local readme_filetypes = { md = "markdown", rst = "rst" }

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
    hujson = "hujson",
    i = "swig",
    icls = "xml",
    inc = "masm",
    ispc = "ispc",
    jsonc = "jsonc",
    jsonl = "jsonl",
    -- Metal Shading Language. Unmapped, these fell through to scripts.vim,
    -- which sees the leading #include and guesses "conf" -- no Tree-sitter
    -- and a "# %s" commentstring for a C++-derived language. The name has to
    -- be its own filetype rather than an alias for cpp: lsp/clangd.lua leaves
    -- metal out of its filetypes on purpose, since upstream clangd parses a
    -- shader as C.
    metal = "metal",
    mm = "objcpp",
    modulemap = "modulemap",
    pen = "json",
    pth = "python",
    pyd = "python",
    pyx = "python",
    replay = "json",
    rl = "ragel",
    sb = "scheme",
    slide = "goslide",
    sql = "mysql",
    swig = "swig",
    swigcxx = "swig",
    tbd = "yaml",
    tfstate = "json", -- Terraform state
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
    [".tigrc"] = "tigrc",
    [".yamlfmt"] = "yaml",
    [".yamllint"] = "yaml",
    -- ["docker-bake.hcl"]  = "docker-bake",
    ["glide.lock"] = "yaml",
    ["go.tool.mod"] = "gomod",
    ["Gopkg.lock"] = "toml",
    Doxyfile = "doxyfile",
    ["kitty.conf"] = "kitty",
    ["lsif.json"] = "json5",
    ["netrc"] = "netrc",
    ["osquery.conf"] = "json",
    ["poetry.lock"] = "toml",
    ["proto.lock"] = "json",
    bash_profile = "sh",
    boto = "cfg",
    manifest = "json",
    PROJECT = "yaml",
    Tiltfile = "tiltfile",
    tigrc = "tigrc",
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
    [".*/.config/direnv/direnvrc"] = "bash",
    [".*/.config/gcloud/configurations/.*"] = "cfg",
    [".*/.config/git/config.d/.*"] = "gitconfig",
    [".*/.config/go/env/.*"] = "sh",
    [".*/.config/jira.d/templates/.*"] = "gotmpl",
    [".*/.config/op/config"] = "json",
    [".*/%.config/tig/config"] = "tigrc",
    [".*/.config/zsh/completions/.*"] = "zsh",
    [".*/.jira.d/templates/.*"] = "gotmpl",
    [".*/.vscode/.*%.json"] = "json5",
    [".*/argocd/config"] = "yaml",
    -- Standard-library trees (include/c++/<ver>/...): their headers carry no
    -- extension or .h, and only those are C++ here -- a README.md under c++/
    -- keeps its own filetype (nil falls through to the extension rules).
    [".*/c%+%+/.*"] = function(path)
      local ext = vim.fs.basename(path):match(".%.([^.]+)$")
      if ext == nil or ext == "h" then
        return "cpp"
      end
    end,
    [".*/google%-cloud%-sdk/properties"] = "cfg",
    [".*/kitty/.*%.conf"] = "kitty",
    [".*/kitty/.*%.session"] = "kitty-session",
    [".*/makedefs/.*"] = "make",
    [".*/share/zsh/(site-)?functions/.*"] = "zsh",
    [".*/testdata/.*/.*%.go%.golden"] = "go",
    [".*/zed/settings.json"] = "jsonc",
    [".*/zsh/functions/.*"] = "zsh",
    [".*/zsh_history"] = "zsh",
    -- Priority -1: after the extension rules, so bashrc_test.go stays Go and
    -- only a suffix no extension rule claims (.bashrc.local) is bash.
    [".*bashrc%..+"] = { "bash", { priority = -1 } },
    [".*lima%-editor%-.*"] = "yaml", -- for limactl edit
    [".*renovate%.json"] = "json5",
    -- direnv. Priority 1 beats the runtime's "^%.envrc%." (sh) instead of
    -- tying with it, and "%." keeps the dot literal: ".env.*" matched any
    -- tail with "env" after its first character (venv.py). Plain dotenv
    -- files (.env, .env.<stage>) are left to the runtime's env filetype.
    ["%.envrc.*"] = { "bash", { priority = 1 } },
    ["/private/etc/sudoers.d/.*"] = "sudoers",
    -- Dockerfile.<stage> and the lowercase spelling the runtime lacks.
    -- Priority -1 lets any real extension (go, vim, lua) decide first, so
    -- dockerfile_test.go stays Go.
    ["[Dd]ockerfile[%._-].*"] = { "dockerfile", { priority = -1 } },
    -- "~" is expanded (and escaped) by vim.filetype.add; the rest is a Lua
    -- pattern, so "-" and "." need escaping.
    ["~/Library/Application Support/Code %- Insiders/User/keybindings%.json"] = "json5",
    -- vim.filetype.add matches `pattern` keys as Lua patterns, not globs:
    -- unescaped, the `-` of "go-build" is the lazy quantifier and matches
    -- "gbuild"/"gobuild", never the real directory. vim.pesc escapes the
    -- whole prefix, the `.` of .cache included, and `/.*` matches everything
    -- under it.
    [vim.pesc(joinpath(cache_home, "go", "go-build")) .. "/.*"] = "go",
    -- Go template content detection. Negative priority makes this a
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
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
        -- A #! line names the language; the content detection that runs
        -- after every pattern reads it, so let a script fall through to it.
        if lines[1] and lines[1]:find("^#!") then
          return
        end
        for _, line in ipairs(lines) do
          if line:find("{{%s*[%.%$]") then
            return "gotmpl"
          end
        end
      end,
      { priority = -math.huge },
    },
    [".*README.(%a+)"] = function(_, _, ext)
      return readme_filetypes[ext]
    end,
  },
})
