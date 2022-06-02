-- Accelerated JK:
vim.g.accelerated_jk_enable_deceleration = 0
vim.g.accelerated_jk_acceleration_limit = 250 -- 70, 250, 350
vim.g.accelerated_jk_acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 } -- g.accelerated_jk_acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28 }

vim.g["vista#renderer#enable_icon"] = true
vim.g["vista#renderer#enable_kind"] = true
vim.g.vista_blink = { 0, 0 }
vim.g.vista_cursor_delay = 400 -- default
vim.g.vista_default_executive = "nvim_lsp"
vim.g.vista_disable_statusline = 0
vim.g.vista_echo_cursor_strategy = "floating_win" -- echo, scroll, floating_win, both
vim.g.vista_executive_for = {
  markdown = "toc",
}
vim.g.vista_sidebar_width = "80"
vim.g.vista_update_on_text_changed = true
vim.g.vista_executive_nvim_lsp_fetching = true

vim.cmd([[
function! s:open_vista(mode)
  if len(a:mode)
    let l:save_vista_default_executive = g:vista_default_executive
    let g:vista_default_executive = a:mode
  endif

  Vista!!
  call timer_start(50, {-> execute('wincmd W')}, {'repeat': 1})

  if get(l:, 'save_vista_default_executive', 0)
    let g:vista_default_executive = l:save_vista_default_executive
  endif
endfunction
command! -nargs=* VistaOpen call s:open_vista(<q-args>)
]])

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  nested = true,
  callback = function()
    if vim.fn.winnr "$" == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
      vim.api.nvim_command ":silent qa!"
    end
  end,
})

local terraform_id = vim.api.nvim_create_augroup("terraform", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = terraform_id,
  pattern = { "*.tf" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
vim.g.hcl_align = 1
vim.g.terraform_binary_path = "/usr/local/opt/terraform/bin/terraform"

-- https://github.com/vovkasm/input-source-switcher
local issw_id = vim.api.nvim_create_augroup("terraform", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = issw_id,
  pattern = { "*" },
  callback = function()
    vim.fn.jobstart('issw com.apple.inputmethod.Kotoeri.RomajiTyping.Roman', { detach = true })
  end,
})

-- vim.cmd([[
-- let s:single_import = '^import\\>\\_.\\{-}\\_$\\%(\\nimport\\>\\)\\@!'
-- let s:multi_import = '^import\\>\\s\\+(\\_[^)]\\+)'
--
-- function! s:uniqadd(obj, item) abort
--   if index(a:obj, a:item) == -1
--     call add(a:obj, a:item)
--   endif
-- endfunction
--
-- function! HlGoimportUpdate(forced) abort
--   let start = 0
--   let end = 0
--   let view = winsaveview()
--
--   call cursor(1, 1)
--   let start = search(s:multi_import, 'cW')
--   if start
--     let end = search(s:multi_import, 'ceW')
--   else
--     let start = search(s:single_import, 'cW')
--     if start
--       let end = search(s:single_import, 'ceW')
--     endif
--   endif
--
--   let imports = []
--   if start && end
--     for l in range(start, end)
--       let text = getline(l)
--       let import = matchstr(text, '"\\zs[^"]\\+\\ze"')
--       if empty(import)
--         continue
--       endif
--
--       let alias = matchstr(substitute(text, '^\\s*import\\>', '', ''), '^\\s*\\zs\\k\\+')
--       if !empty(alias)
--         call s:uniqadd(imports, alias)
--       else
--         call s:uniqadd(imports, split(import, '/')[-1])
--       endif
--     endfor
--
--     call sort(imports)
--   endif
--
--   if a:forced || !exists('b:goimports') || b:goimports != imports
--     silent! syntax clear goImportedPkg
--     let b:goimports = imports
--     silent! execute 'syntax keyword goImportedPkg '.join(imports, ' ')
--   endif
--
--   call winrestview(view)
-- endfunction
--
-- highlight default link goImportedPkg Statement
-- ]])

-- local id = vim.api.nvim_create_augroup("hlgoimport", {
--   clear = false
-- })
-- vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged" }, {
-- 	group = id,
-- 	pattern = { "*.go" },
-- 	nested = false,
-- 	callback = function()
-- 	  vim.fn.HlGoimportUpdate(0)
-- 	end,
-- })
-- vim.api.nvim_create_autocmd({ "FileType", "Syntax" }, {
-- 	group = id,
-- 	pattern = { "*.go" },
-- 	nested = false,
-- 	callback = function()
-- 	  vim.fn.HlGoimportUpdate(1)
-- 	end,
-- })

-- ale-lint-file-linters
-- g.ale_set_highlights = 0
-- g.ale_set_balloons = 0

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   callback = function()
--     require('lint').try_lint()
--   end
-- })

-- Current FileType: go
-- Avaliable Executives: ['ctags']
-- Global Variables:
-- let g:vista = {'get_tagline_under_cursor': function('13'), 'winnr': function('11'), 'silent': v:false, 'source': {'fname': 'config/config_test.go', 'bufnr': 1, 'get_winid': function('15'), 'winid': 1001, 'winnr': 1, 'extension': function('20'), 'line': function('18'), 'get_winnr': function('14'), 'filetype': function('16'), 'lines': function('17'), 'line_trimmed': function('19'), 'scope_seperator': function('21'), 'fpath': '/Users/zchee/go/src/github.com/kouzoh/merpay-invoice-jp/config/config_test.go'}, 'bufnr': 4, 'provider': 'nvim_lsp', 'floating_visible': v:false, 'winid': 1002, 'tmps': [], 'functions': [{'lnum': 18, 'col': 1, 'kind': 'Function', 'text': 'TestReadFromEnv'}, {'lnum': 42, 'col': 1, 'kind': 'Function', 'text': 'TestReadFromEnvInvalidLogLevel'}, {'lnum': 56, 'col': 1, 'kind': 'Function', 'text': 'TestReadFromEnvValidationFailed'}, {'lnum': 71, 'col': 1, 'kind': 'Function', 'text': 'TestReadFromEnvProcessFailed'}, {'lnum': 83, 'col': 1, 'kind': 'Function', 'text': 'TestIsProduction'}, {'lnum': 119, 'col': 1, 'kind': 'Function', 'text': 'TestValidate'}, {'lnum': 181, 'col': 1, 'kind': 'Function', 'text': 'setenv'}, {'lnum': 198, 'col': 1, 'kind': 'Function', 'text': 'unsetenv'}, {'lnum': 215, 'col': 1, 'kind': 'Function', 'text': 'setenvs'}], 'pos': [{'lnum': 1, 'leftcol': 0, 'col': 0, 'topfill': 0, 'topline': 1, 'coladd': 0, 'skipcol': 0, 'curswant': 0}, 3, '1resize 142|vert 1resize 300|2resize 142|vert 2resize 219|3resize 142|vert 3resize 80|1resize 142|vert 1resize 300|2resize 142|vert 2resize 219|3resize 142|vert 3resize 80|']}
-- let g:vista#executives = ['ale', 'coc', 'ctags', 'lcn', 'nvim_lsp', 'vim_lsc', 'vim_lsp']
-- let g:vista#extensions = ['markdown', 'rst']
-- let g:vista#finders = ['clap', 'fzf', 'skim']
-- let g:vista#renderer#ctags = 'default'
-- let g:vista#renderer#enable_icon = 1
-- let g:vista#renderer#enable_kind = 0
-- let g:vista#renderer#icons = {'subroutine': '羚', 'method': '', 'func': '', 'variables': '', 'constructor': '略', 'field': '', 'interface': '', 'type': '', 'packages': '', 'property': '襁', 'implementation': '', 'default': '', 'augroup': 'פּ', 'macro': '', 'enumerator': '', 'const': '', 'macros': '', 'map': 'פּ', 'fields': '', 'functions': '', 'enum': '', 'function': '', 'target': '', 'typedef': '', 'namespace': '', 'enummember': '', 'variable': '', 'modules': '', 'constant': '', 'struct': '', 'types': '', 'module': '', 'typeParameter': '', 'package': '', 'class': '', 'member': '', 'var': '', 'union': '鬒'}
-- let g:vista_blink = [0, 0]
-- let g:vista_close_on_fzf_select = 0
-- let g:vista_close_on_jump = 0
-- let g:vista_cursor_delay = 400
-- let g:vista_default_executive = 'nvim_lsp'
-- let g:vista_disable_statusline = 0
-- let g:vista_echo_cursor = 1
-- let g:vista_echo_cursor_strategy = 'floating_win'
-- let g:vista_enable_centering_jump = 1
-- let g:vista_executive_for = {'markdown': 'toc'}
-- let g:vista_executive_nvim_lsp_fetching = v:false
-- let g:vista_executive_nvim_lsp_reload_only = v:true
-- let g:vista_executive_nvim_lsp_should_display = v:false
-- let g:vista_find_absolute_nearest_method_or_function = 0
-- let g:vista_find_nearest_method_or_function_delay = 300
-- let g:vista_fold_toggle_icons = ['▼', '▶']
-- let g:vista_fzf_preview = []
-- let g:vista_icon_indent = ['└ ', '│ ']
-- let g:vista_ignore_kinds = []
-- let g:vista_no_mappings = 0
-- let g:vista_sidebar_position = 'vertical botright'
-- let g:vista_sidebar_width = '80'
-- let g:vista_stay_on_open = 1
-- let g:vista_top_level_blink = [2, 100]
-- let g:vista_update_on_text_changed = 0
-- let g:vista_update_on_text_changed_delay = 500

-- ale-options
-- vim.cmd([[
-- let g:ale_linters = {}
-- let g:ale_linters.go = []
-- let g:ale_linters.c = []
-- let g:ale_linters.cpp = []
-- let g:ale_linters.python = []
-- let g:ale_linters.lua = []
-- ]])
-- vim.g.ale_linters = {
--   c = {},
--   cpp = {},
--   dockerfile = {
--     "hadolint",
--   },
--   go = {},
--   lua = {},
--   proto = {
--     "api-linter",
--   },
--   python = {
--     "black",
--     -- "pyright", "flake8", "pylint", "pyls", "mypy"
--   },
--   rust = {},
--   sh = {
--     "shellcheck",
--   },
--   terraform = {
--     "fmt",
--   },
--   yaml = {
--     "yamllint",
--   },
-- }
--
-- -- python:
-- vim.g.ale_python_black_executable = "black"
-- vim.g.ale_python_black_use_global = true
--
-- -- dockerfile:
-- vim.g.ale_dockerfile_hadolint_use_docker = "never"
--
-- -- proto:
-- vim.g.ale_proto_api_linter_options = {}
-- vim.g.ale_proto_api_linter_config_path = ".api-linter.yaml"
-- vim.g.ale_proto_api_linter_include_paths = { ".", "third_party/googleapis" }
--
-- -- rust:
--
-- -- shellcheck:
-- vim.g.ale_sh_shellcheck_executable = "shellcheck"
-- vim.g.ale_sh_shellcheck_options = "-x --color=never --severity=style --wiki-link-count=10"
-- vim.g.ale_sh_shellcheck_exclusions = "SC1072,SC1090,SC1091"
-- vim.g.ale_sh_shellcheck_change_directory = 1
--
-- -- terraform:
-- vim.g.ale_terraform_fmt_executable = 'terraform'
-- vim.g.ale_terraform_fmt_options = ''
--
-- -- yaml:
-- local yamllint_config_file
-- if vim.env.YAMLLINT_CONFIG_FILE then
--   yamllint_config_file = "--config-file="..vim.env.YAMLLINT_CONFIG_FILE
-- else
--   local yamllint_filepath = vim.fn.findfile(vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('%%')), ':p:h')..'/.yamllint.yaml', '.;')
--   if vim.fn.filereadable(yamllint_filepath) then
--     yamllint_config_file = '--config-file='..yamllint_filepath
--   end
-- end
-- vim.g.ale_yaml_yamllint_options = '--strict '..yamllint_config_file
--
-- vim.g["airline#extensions#ale#enabled"] = 0
-- vim.g.ale_cache_executable_check_failures = 1
-- vim.g.ale_change_sign_column_color = 0
-- vim.g.ale_close_preview_on_inlet = 0
-- vim.g.ale_completion_enabled = 0
-- vim.g.ale_cursor_detail = 0
-- vim.g.ale_disable_lsp = 1
-- vim.g.ale_echo_cursor = 1
-- vim.g.ale_echo_delay = 10
-- vim.g.ale_echo_msg_format = '[%linter%] %code: %%s'
-- vim.g.ale_enabled = 1
-- vim.g.ale_fix_on_save = 0
-- vim.g.ale_hover_to_preview = 0
-- vim.g.ale_keep_list_window_open = 0
-- vim.g.ale_list_window_size = 10
-- vim.g.ale_lint_delay = 200
-- vim.g.ale_lint_on_enter = 0
-- vim.g.ale_lint_on_filetype_changed = 0
-- vim.g.ale_lint_on_save = 1
-- vim.g.ale_lint_on_text_changed = 'never'
-- vim.g.ale_lint_on_insert_leave = 0
-- vim.g.ale_linters_explicit = 1
-- vim.g.ale_max_signs = -1
-- vim.g.ale_open_list = 1
-- vim.g.ale_set_loclist = 1
-- vim.g.ale_set_quickfix = 0
-- vim.g.ale_shell = 'bash'
-- vim.g.ale_sign_column_always = 1
-- vim.g.ale_sign_highlight_linenrs = 1
-- vim.g.ale_update_tagstack = 0
-- vim.g.ale_use_global_executables = 1
-- vim.g.ale_virtualtext_cursor = 1
-- vim.g.ale_virtualtext_delay = 10
-- vim.g.ale_warn_about_trailing_blank_lines = 1
-- vim.g.ale_warn_about_trailing_whitespace = 1
-- vim.g.ale_linter_aliases = {
--   zsh = 'sh',
-- }
-- vim.g.ale_fixers = {
--   ["*"] = {
--     "remove_trailing_lines",
--     "trim_whitespace",
--   },
--   markdown = {},
-- }
-- vim.g.ale_pattern_options = {}
