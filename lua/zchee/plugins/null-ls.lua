local null_ls = require("null-ls")
local utils = require("null-ls.utils")

local code_actions = require("null-ls.builtins").code_actions
local completion = require("null-ls.builtins").completion
local diagnostics = require("null-ls.builtins").diagnostics
local formatting = require("null-ls.builtins").formatting
local hover = require("null-ls.builtins.hover")

-- local shellcheck_source = {
--   name = "shellcheck",
--   filetypes = { ["sh"] = true },
--   method = methods.internal.DIAGNOSTICS,
--   condition = function(utils)
--     return utils.root_has_file("*.bash")
--   end,
--   generator = null_ls.generator({
--     command = "shellcheck",
--     args = { "--shell", "sh", "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--     to_stdin = true,
--     from_stderr = true,
--     format = "json",
--     check_exit_code = function(code)
--       return code <= 1
--     end,
--     on_output = function(params)
--       local parser = helpers.diagnostics.from_json({
--         attributes = { code = "code" },
--         severities = {
--           info = helpers.diagnostics.severities["information"],
--           style = helpers.diagnostics.severities["hint"],
--         },
--       })
--
--       return parser({ output = params.output.comments })
--     end,
--   }),
-- }
-- null_ls.register({
--   name = "shellcheck",
--   filetypes = { "sh" },
--   -- command = "shellcheck",
--   -- args = { "--shell", "sh", "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--   sources = { shellcheck_source },
-- })

-- bash
-- null_ls.register({
--   name = "shellcheck",
--   filetypes = { "sh" },
--   command = "shellcheck",
--   args = { "--shell", "sh", "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--   sources = {
--     null_ls.builtins.diagnostics.shellcheck.with({
--       condition = function(utils)
--         return utils.root_has_file("*.bash")
--       end,
--     }),
--   },
-- })

-- shell
-- local shellcheck_source = {
--   method = null_ls.methods.DIAGNOSTICS,
--   filetypes = { "sh" },
--   generator = null_ls.generator({
--     command = "shellcheck",
--     args = { "--shell", "sh", "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--     to_stdin = true,
--     from_stderr = true,
--     format = "json",
--     check_exit_code = function(code)
--       return code <= 1
--     end,
--     on_output = function(params)
--       local parser = helpers.diagnostics.from_json({
--         attributes = { code = "code" },
--         severities = {
--           info = helpers.diagnostics.severities["information"],
--           style = helpers.diagnostics.severities["hint"],
--         },
--       })
--
--       return parser({ output = params.output.comments })
--     end,
--     -- on_output = helpers.diagnostics.from_patterns({
--     --   {
--     --     pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
--     --     groups = { "row", "col", "message" },
--     --   },
--     --   {
--     --     pattern = [[:(%d+) [%w-/]+ (.*)]],
--     --     groups = { "row", "message" },
--     --   },
--     -- }),
--   }),
-- }
-- null_ls.register({
--   name = "shell",
--   filetypes = { "sh" },
--   sources = { shellcheck_source },
-- })

-- local source_shellcheck = null_ls.builtins.diagnostics.shellcheck.with({
--   diagnostics_format = "[#{c}] #{m} (#{s})",
--   command = "shellcheck",
--   args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--   condition = function(utils)
--     return not utils.root_has_file("/private/tmp/*.zsh")
--   end,
-- })
-- local _shellcheck = {
--   -- name = "shell",
--   name = "shellcheck",
--   meta = {
--     url = "https://www.shellcheck.net/",
--     description = "A shell script static analysis tool.",
--   },
--   method = builtins.diagnostics.shellcheck.DIAGNOSTICS,
--   filetypes = { "sh" },
--   sources = { source_shellcheck },
--   generator_opts = {
--     command = "shellcheck",
--     args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--     to_stdin = true,
--     format = "json",
--     check_exit_code = function(code)
--       return code <= 1
--     end,
--     on_output = function(params)
--       local parser = helpers.diagnostics.from_json({
--         attributes = { code = "code" },
--         severities = {
--           info = helpers.diagnostics.severities["information"],
--           style = helpers.diagnostics.severities["hint"],
--         },
--       })
--
--       return parser({ output = params.output.comments })
--     end,
--   },
--   factory = helpers.generator_factory,
-- }
-- null_ls.register({ _shellcheck })

-- local shellcheck_source = null_ls.builtins.diagnostics.shellcheck.with({
--   args = { "--shell", "bash", "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--   condition = function(utils)
--     if utils.root_has_file("*.bash") then
--       return true
--     end
--   end,
-- })
--
-- local shellcheck = {
--   name = "shellcheck",
--   meta = {
--     url = "https://www.shellcheck.net/",
--     description = "A shell script static analysis tool.",
--   },
--   method = builtins.diagnostics.shellcheck.DIAGNOSTICS,
--   filetypes = { "sh" },
--   sources = { shellcheck_source },
--   generator_opts = {
--     command = "shellcheck",
--     args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--     to_stdin = true,
--     format = "json",
--     check_exit_code = function(code)
--       return code <= 1
--     end,
--     on_output = function(params)
--       local parser = helpers.diagnostics.from_json({
--         attributes = { code = "code" },
--         severities = {
--           info = helpers.diagnostics.severities["information"],
--           style = helpers.diagnostics.severities["hint"],
--         },
--       })
--
--       return parser({ output = params.output.comments })
--     end,
--   },
--   factory = helpers.generator_factory,
-- }
-- null_ls.register({ shellcheck })
--
-- local __shellcheck = {
--   -- name = "shellcheck",
--   -- method = builtins.diagnostics.shellcheck.DIAGNOSTICS,
--   -- filetypes = { "sh" },
--   -- methods = { [require("null-ls").methods.FORMATTING] = true },
--   -- generator = {
--   --   fn = function()
--   --     return "I am a source!"
--   --   end,
--   -- },
--
--   -- generator_opts = {
--   --   command = "shellcheck",
--   --   args = { "--format", "json1", "--source-path=$DIRNAME", "--external-sources", "-" },
--   --   to_stdin = true,
--   --   format = "json",
--   --   check_exit_code = function(code)
--   --     return code <= 1
--   --   end,
--   --   on_output = function(params)
--   --     local parser = helpers.diagnostics.from_json({
--   --       attributes = { code = "code" },
--   --       severities = {
--   --         info = helpers.diagnostics.severities["information"],
--   --         style = helpers.diagnostics.severities["hint"],
--   --       },
--   --     })
--   --
--   --     return parser({ output = params.output.comments })
--   --   end,
--   -- },
--   -- factory = helpers.generator_factory,
--
--   -- name = "shellcheck",
--   -- filetypes = { ["sh"] = true, ["zsh"] = true },
--   -- methods = null_ls.methods.internal.DIAGNOSTICS,
--   -- generator = {
--   --   fn = function()
--   --     return "I am a source!"
--   --   end,
--   -- },
--   -- id = 1,
-- }
-- null_ls.register({ shellcheck })

-- markdown
-- local markdownlint = {
--   method = null_ls.methods.DIAGNOSTICS,
--   filetypes = { "markdown" },
--   -- null_ls.generator creates an async source
--   -- that spawns the command with the given arguments and options
--   generator = null_ls.generator({
--     command = "markdownlint",
--     args = { "--stdin" },
--     to_stdin = true,
--     from_stderr = true,
--     -- choose an output format (raw, json, or line)
--     format = "line",
--     check_exit_code = function(code, _) -- code, stderr
--       local success = code <= 1
--
--       -- if not success then
--       --   -- can be noisy for things that run often (e.g. diagnostics), but can
--       --   -- be useful for things that run on demand (e.g. formatting)
--       --   -- print(stderr)
--       -- end
--
--       return success
--     end,
--     -- use helpers to parse the output from string matchers,
--     -- or parse it manually with a function
--     on_output = helpers.diagnostics.from_patterns({
--       {
--         pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
--         groups = { "row", "col", "message" },
--       },
--       {
--         pattern = [[:(%d+) [%w-/]+ (.*)]],
--         groups = { "row", "message" },
--       },
--     }),
--   }),
-- }
--
-- null_ls.register({
--   name = "markdown",
--   filetypes = { "markdown" },
--   sources = { markdownlint },
-- })

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- null_ls.setup({
--   on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--       vim.api.nvim_clear_autocmds({
--         group = augroup,
--         buffer = bufnr,
--       })
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         buffer = bufnr,
--         callback = function()
--           vim.lsp.buf.formatting_sync()
--         end,
--       })
--     end
--   end,
-- })

-- return h.make_builtin({
--   name = "shellcheck",
--   meta = {
--     url = "https://www.shellcheck.net/",
--     description =
--     "provides actions to disable shellcheck errors/warnings, either for the current line or for the entire file.",
--     notes = {
--       "running the action to disable a rule for the current line adds a disable directive above the line or appends the rule to an existing disable directive for that line.",
--       "running the action to disable a rule for the current file adds a disable directive at the top of the file or appends the rule to an existing file disable directive.",
--       "the first non-comment line in a script is not eligible for a line-level disable directive. see [shellcheck#1877](https://github.com/koalaman/shellcheck/issues/1877).",
--     },
--   },
--   method = code_action,
--   filetypes = { "sh" },
--   generator_opts = {
--     command = "shellcheck",
--     args = { "--format", "json1", "--source-path=$dirname", "--external-sources", "-" },
--     to_stdin = true,
--     format = "json",
--     use_cache = true,
--     check_exit_code = function(code)
--       return code <= 1
--     end,
--     on_output = code_action_handler,
--   },
--   factory = h.generator_factory,
-- })

-- local code_actions_shellcheck = code_actions.shellcheck.args = {
-- code_actions.shellcheck.args = {
--   "--shell", "sh",
--   "--format", "json1",
--   "--source-path=$dirname",
--   "--external-sources", "-",
-- }
-- code_actions_shellcheck.args = {
--   "--shell", "sh",
--   "--format", "json1",
--   "--source-path=$dirname",
--   "--external-sources", "-",
-- }

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      return client.name == "null-ls"
    end,
  })
end
local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({
      group = augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

null_ls.setup({
  sources = {
    -- completion.spell,
    diagnostics.shellcheck,
    -- diagnostics.eslint,
    -- formatting.stylua,
    formatting.buf, -- TODO(zchee): check buf format options
    formatting.yamlfmt,
    formatting.zigfmt,
    hover.printenv,
  },
  -- cmd = { "nvim" },
  debounce = 250,
  debug = false,
  default_timeout = 5000,
  -- diagnostic_config = {
  --   virtual_text = true,
  -- },
  diagnostics_format = "#{m} #{s} #{c}",
  fallback_severity = vim.diagnostic.severity.ERROR,
  notify_format = "[null-ls] %s",
  -- root_dir = utils.root_pattern(".null-ls-root", "Makefile", ".git"),
  update_in_insert = true,
  on_attach = on_attach,
})
