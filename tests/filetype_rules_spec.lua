---@diagnostic disable: undefined-global
-- Regression spec for the filename/pattern/extension rules in filetype.lua
-- and ftdetect/.
--
-- Every case opens a real file in a scratch tree, so detection runs exactly
-- as in a session: vim.filetype.match (runtime rules plus filetype.lua),
-- content detection (shebang), and the ftdetect/ autocmds that override a
-- detected filetype. Most cases pin a rule that once matched far more than
-- it meant to: `pattern` keys are Lua patterns, implicitly anchored, and
-- matched against the tail when they contain no "/", so `.env.*` caught
-- venv.py, `.*bashrc.*` caught bashrc_test.go, and `[^.vim|^.lua]` was a
-- one-character class, not an exclusion list.
--
-- Run: nvim --headless -u NONE -i NONE -l tests/filetype_rules_spec.lua
-- Exits 0 only after printing "ALL PASS".
local cwd = vim.fn.getcwd()
vim.opt.runtimepath:append(cwd)
package.path = table.concat({ cwd .. "/lua/?.lua", cwd .. "/lua/?/init.lua", package.path }, ";")

-- -u NONE leaves detection on but never sources this repo's ftdetect/ (it
-- was not on the rtp at startup), so load both the way :filetype on would.
vim.cmd("filetype on")
vim.cmd("augroup filetypedetect")
for _, file in ipairs(vim.fn.globpath(cwd, "ftdetect/*.{vim,lua}", false, true)) do
  vim.cmd.source(file)
end
vim.cmd("augroup END")
dofile(vim.fs.joinpath(cwd, "filetype.lua"))

local root = vim.fn.tempname()
assert(vim.fn.mkdir(root, "p") == 1, "scratch root should be created: " .. root)

local home = assert(vim.env.HOME, "$HOME must be set")
local vscode_keybindings =
  vim.fs.joinpath(home, "Library", "Application Support", "Code - Insiders", "User", "keybindings.json")

---@class FiletypeCase
---@field path string relative to the scratch root, or absolute
---@field lines? string[] file contents (default: one blank line)
---@field ft string expected 'filetype'
---@field why string what the case pins
---@field match_only? boolean resolve with vim.filetype.match instead of opening a file

---@type FiletypeCase[]
local cases = {
  -- Dockerfile: the extension decides when there is one; bare suffixes are dockerfile.
  { path = "dockerfile_test.go", ft = "go", why = "a Go test named after Dockerfiles is Go" },
  { path = "Dockerfile", ft = "dockerfile", why = "plain Dockerfile" },
  { path = "Dockerfile.dev", ft = "dockerfile", why = "Dockerfile.<stage>" },
  { path = "dockerfile.prod", ft = "dockerfile", why = "lowercase dockerfile.<stage>" },
  { path = "dockerfile.vim", ft = "vim", why = "a Vim script named dockerfile stays vim" },
  { path = "app.dockerfile", ft = "dockerfile", why = "*.dockerfile" },
  -- dotenv / envrc
  { path = "venv.py", ft = "python", why = "a Python file ending in env.py is Python" },
  { path = ".env", ft = "env", why = "dotenv: the runtime's env filetype" },
  { path = ".env.local", ft = "env", why = "dotenv .env.<stage>, same as .env" },
  { path = ".envrc", ft = "bash", why = "direnv .envrc" },
  { path = ".envrc.local", ft = "bash", why = ".envrc.<suffix>" },
  { path = "environment.yaml", ft = "yaml", why = "a name merely starting with env keeps its extension" },
  -- bashrc
  { path = "bashrc_test.go", ft = "go", why = "a Go test named after bashrc is Go" },
  { path = ".bashrc.local", ft = "bash", why = ".bashrc.<suffix>" },
  -- Terraform
  { path = "a.tfvars", ft = "terraform-vars", why = "*.tfvars" },
  { path = ".tfvars", ft = "terraform-vars", why = "a file named .tfvars is still tfvars, not teraterm" },
  { path = "terraform.tfstate", ft = "json", why = "Terraform state is JSON, not teraterm" },
  -- tsconfig: runtime jsonc (the dialect tsc accepts)
  { path = "tsconfig.json", ft = "jsonc", why = "tsconfig.json" },
  -- libstdc++/libc++ trees
  { path = "include/c++/13/iostream", ft = "cpp", why = "extensionless header under c++/" },
  { path = "include/c++/13/bits/stl_vector.h", ft = "cpp", why = ".h header under c++/" },
  { path = "c++/README.md", ft = "markdown", why = "documentation under c++/ keeps its extension" },
  -- README.<ext>
  { path = "README.rst", ft = "rst", why = "README.rst" },
  { path = "README.md", ft = "markdown", why = "README.md" },
  { path = "README.txt", ft = "text", why = "a README extension the rule does not name falls through" },
  -- Go templates: the content fallback, and a shebang beating it
  { path = "notes", lines = { "Hello {{ .Name }}" }, ft = "gotmpl", why = "Go template action in an unknown file" },
  {
    path = "run",
    lines = { "#!/bin/sh", 'echo "{{ .X }}"' },
    ft = "sh",
    why = "a #!/bin/sh script containing {{ .X }} is still sh",
  },
  -- ragel, Doxygen and Clang module maps
  { path = "lexer.rl", ft = "ragel", why = "Ragel state machines" },
  { path = "Doxyfile", ft = "doxyfile", why = "Doxygen config" },
  { path = "module.modulemap", ft = "modulemap", why = "Clang module map" },
  { path = "Foo.modulemap", ft = "modulemap", why = "*.modulemap" },
  -- names moved from ftdetect/ into filetype.lua (or left to the runtime)
  { path = ".npmrc", ft = "dosini", why = ".npmrc is dosini (the runtime rule)" },
  { path = "npmrc", ft = "dosini", why = "npmrc is dosini" },
  { path = ".tigrc", ft = "tigrc", why = ".tigrc" },
  { path = "tigrc", ft = "tigrc", why = "tigrc" },
  { path = "home/.config/tig/config", ft = "tigrc", why = "XDG tig config" },
  { path = "home/.config/tig/confi", ft = "", why = "config* read as confi+g* matched this" },
  { path = "kernel.ispc", ft = "ispc", why = "*.ispc" },
  { path = "buf.lock", ft = "yaml", why = "buf.lock" },
  { path = "buf.gen.yaml", ft = "yaml", why = "buf.gen.yaml" },
  -- content sniffing that stays in ftdetect/
  { path = "go.log", lines = { "=== RUN   TestX" }, ft = "gotestlog", why = "go test -v log" },
  -- `~` and `-` in a pattern key
  -- match_only: never create files under the real ~/Library.
  {
    path = vscode_keybindings,
    ft = "json5",
    why = "VS Code Insiders keybindings (a `-` in the path)",
    match_only = true,
  },
  { path = "shader.metal", ft = "metal", why = "Metal Shading Language" },
}

local failures = 0
for _, case in ipairs(cases) do
  local path = case.path:sub(1, 1) == "/" and case.path or vim.fs.joinpath(root, case.path)
  local got
  if case.match_only then
    got = vim.filetype.match({ filename = path }) or ""
  else
    assert(vim.fn.mkdir(vim.fs.dirname(path), "p") == 1, "should create the directory of " .. path)
    assert(vim.fn.writefile(case.lines or { "" }, path) == 0, "should write " .. path)
    vim.cmd("silent! edit! " .. vim.fn.fnameescape(path))
    got = vim.bo.filetype
    vim.cmd("silent! bwipeout!")
  end
  local ok = got == case.ft
  local shown = case.path:gsub(vim.pesc(home), "~")
  io.stdout:write(("%s %-45s -> %-15s %s\n"):format(ok and "ok  " or "FAIL", shown, got, case.why))
  if not ok then
    io.stdout:write(("     expected %q\n"):format(case.ft))
    failures = failures + 1
  end
end

vim.fn.delete(root, "rf")

if failures > 0 then
  io.stdout:write(("FAILED: %d of %d cases\n"):format(failures, #cases))
  os.exit(1)
end
io.stdout:write(("ALL PASS (%d cases)\n"):format(#cases))
os.exit(0)
