local lint = require("lint")

local severities = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  refactor = vim.diagnostic.severity.INFO,
  convention = vim.diagnostic.severity.HINT,
}

-- TODO(zchee): split under the lua/zchee/plugins/lint directory
lint.linters.golangcilint = {
  cmd = 'golangci-lint',
  append_fname = false,
  args = {
    'run',
    '--out-format',
    'json',
  },
  stream = 'stdout',
  ignore_exitcode = true,
  parser = function(output, bufnr)
    if output == '' then
      return {}
    end
    local decoded = vim.json.decode(output)
    if decoded["Issues"] == nil or type(decoded["Issues"]) == 'userdata' then
      return {}
    end

    local diagnostics = {}
    for _, item in ipairs(decoded["Issues"]) do
      local curfile = vim.api.nvim_buf_get_name(bufnr)
      local lintedfile = vim.fn.getcwd() .. "/" .. item.Pos.Filename
      if curfile == lintedfile then
        -- only publish if those are the current file diagnostics
        local sv = severities[item.Severity] or severities.warning
        table.insert(diagnostics, {
          lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
          col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
          end_lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
          end_col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
          severity = sv,
          source = item.FromLinter,
          message = item.Text,
        })
      end
    end
    return diagnostics
  end
}

-- ansible_lint.lua
-- checkstyle.lua
-- chktex.lua
-- clangtidy.lua
-- clazy.lua
-- clj-kondo.lua
-- cmakelint.lua
-- codespell.lua
-- compiler.lua
-- cppcheck.lua
-- cpplint.lua
-- credo.lua
-- cspell.lua
-- eslint.lua
-- fennel.lua
-- fish.lua
-- flake8.lua
-- flawfinder.lua
-- glslc.lua
-- golangcilint.lua
-- hadolint.lua
-- hlint.lua
-- inko.lua
-- jshint.lua
-- ktlint.lua
-- lacheck.lua
-- languagetool.lua
-- luacheck.lua
-- markdownlint.lua
-- mlint.lua
-- mypy.lua
-- nix.lua
-- phpcs.lua
-- proselint.lua
-- pycodestyle.lua
-- pydocstyle.lua
-- pylint.lua
-- revive.lua
-- rflint.lua
-- robocop.lua
-- rstcheck.lua
-- rstlint.lua
-- ruby.lua
-- selene.lua
-- shellcheck.lua
-- standardrb.lua
-- staticcheck.lua
-- statix.lua
-- stylelint.lua
-- tidy.lua
-- vale.lua
-- vint.lua
-- vulture.lua
-- yamllint.lua
-- zig.lua

lint.linters_by_ft = {
  cmake = { "cmakelint" },
  dockerfile = { "hadolint" },
  -- lua = { "luacheck" },
  sh = { "shellcheck" },
  yaml = { "yamllint" },
}
