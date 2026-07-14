local util = require("util")

local h = require("null-ls.helpers")
local log = require("null-ls.logger")
local null_ls = require("null-ls")
local u = require("null-ls.utils")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  log_level = "error",
  sources = {
    --- Go
    -- formatting.gofumpt,
    -- require("none-ls.formatting.goimports_rereviser"),
    --- Lua
    formatting.stylua,
    --- Python
    -- require("none-ls.formatting.ruff"),
    -- require("none-ls.formatting.ruff_format"),
    --- Rust
    require("none-ls.formatting.rustfmt"),
    --- YAML
    formatting.yamlfmt,
    --- Terraform
    formatting.terraform_fmt,

    --- Go
    -- NOTE(zchee): pin the absolute binary so the mise shim
    -- (~/.local/share/mise/shims/golangci-lint), which may sit earlier in the
    -- GUI/kitty PATH, is never invoked; the shim prints "mise ERROR ... not
    -- currently active" to stdout, which none-ls then feeds to vim.json.decode
    -- and crashes with "failed to decode json: ... invalid token at character 1".
    -- format = "json_raw" additionally degrades any future non-JSON stdout to
    -- "no diagnostics" instead of throwing a hard generator error.
    -- diagnostics.golangci_lint.with({
    --   generator_opts = {
    --     command = util.go_path("bin", "golangci-lint"),
    --     to_stdin = true,
    --     from_stderr = false,
    --     ignore_stderr = true,
    --     multiple_files = true,
    --     args = h.cache.by_bufnr(function(params)
    --       -- params.command respects prefer_local and only_local options
    --       local version = vim.system({ params.command, "version" }, { text = true }):wait().stdout
    --       if not version then
    --         -- early return if not found version
    --         return {}
    --       end
    --       -- from observation the version can be either v2.x.x or 2.x.x
    --       -- depending on packaging
    --       if version:match("version v2.0.") or version:match("version 2.0.") then
    --         -- for v2.0.{0,1,2} Go submodules (with golangci-lint config at
    --         -- the project root) require "relative-path-mode: gomod" or cwd
    --         -- set to where the golangci-lint config file is and $DIRNAME
    --         -- in extra_args
    --         return {
    --           "run",
    --           "--output.text.path=/dev/null",
    --           "--fix=false",
    --           "--show-stats=false",
    --           "--output.json.path=stdout",
    --         }
    --       elseif version:match("version v2") or version:match("version 2") then
    --         return {
    --           "run",
    --           "--output.text.path=/dev/null",
    --           "--fix=false",
    --           "--show-stats=false",
    --           "--output.json.path=stdout",
    --           "--path-mode=abs",
    --         }
    --       else
    --         return { "run", "--output.text.path=/dev/null", "--fix=false", "--out-format=json" }
    --       end
    --     end),
    --     check_exit_code = function(code)
    --       return code <= 2
    --     end,
    --     on_output = function(params)
    --       local diags = {}
    --       if params.output["Report"] and params.output["Report"]["Error"] then
    --         log:warn(params.output["Report"]["Error"])
    --         return diags
    --       end
    --       local issues = params.output["Issues"]
    --       if type(issues) == "table" then
    --         for _, d in ipairs(issues) do
    --           -- prepend cwd to filename to get absolute path unless
    --           -- already absolute
    --           local filename = d.Pos.Filename
    --           if filename:sub(1, #params.cwd) ~= params.cwd then
    --             filename = u.path.join(params.cwd, d.Pos.Filename)
    --           end
    --           table.insert(diags, {
    --             source = string.format("golangci-lint: %s", d.FromLinter),
    --             row = d.Pos.Line,
    --             col = d.Pos.Column,
    --             message = d.Text,
    --             severity = h.diagnostics.severities["warning"],
    --             filename = filename,
    --           })
    --         end
    --       end
    --       return diags
    --     end,
    --   },
    -- }),
    --- Python
    require("none-ls.diagnostics.ruff"),

    --- Go
    -- code actions
    -- code_actions.gomodifytags,
    -- code_actions.impl,
  },
})

-- local is_null_ls_formatting_enabled = function()
--   local file_type = vim.api.nvim_get_option_value("filetype", {scope = "local"})
--   local generators = require("null-ls.generators").get_available(
--     file_type,
--     require("null-ls.methods").internal.FORMATTING
--   )
--   return #generators > 0
-- end
--
-- local lsp_formatting = function(client, bufnr)
--   print(client.name)
--   local opts = {
--     async = false,
--     bufnr = bufnr,
--   }
--   if (client.name == "null-ls" and is_null_ls_formatting_enabled(bufnr)) or client.name == "null-ls" then
--     opts.filter = function(c)
--       return c.name == "null-ls"
--     end
--   end
--
--   vim.lsp.buf.ormat(opts)
-- end

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- null_ls.setup({
--   sources = {
--     -- code_actions
--     -- null_ls.builtins.code_actions.
--
--     -- completion
--     -- null_ls.builtins.completion.
--
--     -- diagnostics
--     -- null_ls.builtins.diagnostics.
--
--     -- formatting
--     null_ls.builtins.formatting.gofumpt,
--     null_ls.builtins.formatting.goimports_reviser,
--     null_ls.builtins.formatting.prettier,
--     null_ls.builtins.formatting.stylua,
--     null_ls.builtins.formatting.terraform_fmt,
--     null_ls.builtins.formatting.yamlfmt,
--   },
--   -- on_attach = on_attach,
--   -- on_attach = function(client, bufnr)
--   --   if client.supports_method("textDocument/formatting") then
--   --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--   --     vim.api.nvim_create_autocmd("BufWritePre", {
--   --       group = augroup,
--   --       buffer = bufnr,
--   --       callback = function()
--   --         lsp_formatting(bufnr)
--   --       end,
--   --     })
--   --   end
--   -- end,
-- })

-- local mason_null_ls = require("mason-null-ls")
-- mason_null_ls.setup({
--   ensure_installed = {
--     { 'stylua', version = 'v0.14.2' },
--   },
--   automatic_installation = true,
-- })
-- mason_null_ls.check_install(true)
-- local on_attach = function(client, bufnr)
--   print("null_ls.on_attach")
--   if client.supports_method("textDocument/formatting") then
--     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       group = augroup,
--       buffer = bufnr,
--       callback = function()
--         lsp_formatting(bufnr)
--       end,
--     })
--   end
-- end
-- on_attach = function(client, bufnr)
--   if client.supports_method("textDocument/formatting") then
--     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       group = augroup,
--       buffer = bufnr,
--       callback = function()
--         if client.name == "null-ls" then
--           vim.lsp.buf.format({   async = false})
--           return
--         end
--         vim.lsp.buf.format({  async = false })
--       end,
--     })
--   end
-- end,
