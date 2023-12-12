--                                                                                                 --
--                 __                                                                              --
--  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    --
-- /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  --
-- \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  --
--   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ --
--                                                                                                 --
--                                                                                                 --
-- =============================================================================================== --

local homebrew_prefix = os.getenv("HOMEBREW_PREFIX")

-- Environment Variables:

vim.g.clipboard = {
  name = "mac",
  copy = {
    ["+"] = { "pbcopy" },
    ["*"] = { "pbcopy" },
  },
  paste = {
    ["+"] = { "pbpaste" },
    ["*"] = { "pbpaste" },
  },
  cache_enabled = 0,
}

-- disable built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1       -- $VIMRUNTIME/autoload/tar.vim
vim.g.loaded_tarPlugin = 1 -- $VIMRUNTIME/plugin/tarPlugin.vim
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1       -- $VIMRUNTIME/pack/dist/opt/vimball/autoload/vimball.vim
vim.g.loaded_vimballPlugin = 1 -- $VIMRUNTIME/pack/dist/opt/vimball/plugin/vimballPlugin.vim
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
-- $VIMRUNTIME
vim.g.did_install_default_menus = 1  -- $VIMRUNTIME/menu.vim
vim.g.skip_loading_mswin = true      -- $VIMRUNTIME/mswin.vim
-- $VIMRUNTIME/pack/dist/opt
vim.g.loaded_cfilter = 1             -- $VIMRUNTIME/pack/dist/opt/cfilter/plugin/cfilter.vim
-- $VIMRUNTIME/autoload
vim.g.loaded_netrw = 1               -- $VIMRUNTIME/autoload/netrw.vim
vim.g.loaded_netrwFileHandlers = 1   -- $VIMRUNTIME/autoload/netrwFileHandlers.vim
vim.g.loaded_netrwSettings = 1       -- $VIMRUNTIME/autoload/netrwSettings.vim
vim.g.loaded_pythonx_provider = 1    -- $VIMRUNTIME/autoload/provider/pythonx.vim
vim.g.loaded_syntax_completion = 130 -- $VIMRUNTIME/autoload/syntaxcomplete.vim
vim.g.loaded_xmlformat = 1           -- $VIMRUNTIME/autoload/xmlformat.vim
vim.g.loaded_less = 1                -- $VIMRUNTIME/macros/less.vim
vim.g.loaded_netrwPlugin = 1         -- $VIMRUNTIME/plugin/netrwPlugin.vim
vim.g.netrw_nogx = true              -- $VIMRUNTIME/plugin/netrwPlugin.vim
vim.g.loaded_spellfile_plugin = 1    -- $VIMRUNTIME/plugin/spellfile.vim
vim.g.loaded_tutor_mode_plugin = 1   -- $VIMRUNTIME/plugin/tutor.vim

-- Global Settings:

local state_dir = vim.fn.stdpath("state")

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backup = true
vim.opt.backupdir = vim.fs.joinpath(vim.fn.stdpath("state"), "backup")
vim.opt.backupcopy = "yes"
vim.opt.belloff = "all"
vim.opt.cindent = true
vim.opt.cinkeys:remove("0#") -- comments don't fiddle with indenting
vim.opt.cinoptions = ""      -- See :h cinoptions-values
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2
vim.opt.cmdwinheight = 50
vim.opt.complete = "." -- .,w,b,u,t  -- default: .,w,b,u,t, .
-- vim.opt.completeopt = { "noinsert", "noselect", "menuone" } -- noinsert,noselect,longest,menu,menuone,preview
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.concealcursor = "niv"
vim.opt.conceallevel = 0
vim.opt.copyindent = true
vim.opt.cpoptions:remove("_")
vim.opt.diffopt:append("hiddenoff")
vim.opt.directory = vim.fs.joinpath(string.format("%s", vim.fn.stdpath("state")), "swap")
vim.opt.display:remove("msgsep")
vim.opt.emoji = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.fillchars:append("diff:/")
vim.opt.fileformats = { "unix", "mac", "dos" }
vim.opt.foldcolumn = "0"
-- vim.opt.foldexpr = vim.treesitter.foldexpr
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 99       --open all folds by default
vim.opt.foldmethod = "expr"
vim.opt.foldnestmax = 1           -- maximum fold depth
vim.opt.formatoptions:append("c") -- Autowrap comments using textwidth - :help fo-table
vim.opt.formatoptions:append("j") -- Delete comment character when joining commented lines
vim.opt.formatoptions:append("l") -- do not wrap lines that have been longer when starting insert mode already
vim.opt.formatoptions:append("n") -- Recognize numbered lists
vim.opt.formatoptions:append("q") -- Allow formatting of comments with "gq"
vim.opt.formatoptions:append("r") -- Insert comment leader after hitting <Enter>
vim.opt.formatoptions:append("t") -- Auto-wrap text using textwidth
vim.opt.formatoptions:remove("o") -- Automatically insert the current comment leader after hitting 'o' or'O' in Normal mode
vim.opt.foldnestmax = 1           -- maximum fold depth
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.helplang = { "en" }
vim.opt.hidden = true
vim.opt.history = 10000 -- default: 10000 (maximum)
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.inccommand = "nosplit"
vim.opt.isfname:remove("=")
vim.opt.jumpoptions = "view"
vim.opt.keywordprg = ":Help"
vim.opt.langmenu = "none"
vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  nbsp = "%",
  extends = "›",
  precedes = "‹",
}
vim.opt.makeprg = "make"
vim.opt.matchtime = 0        -- disable nvim matchparen
vim.opt.maxmempattern = 1000 -- default: 1000, max: 2000000
vim.opt.modelines = 1
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.path:append("$PWD/**")
vim.opt.path:append("**")
vim.opt.previewheight = 5
vim.opt.pumblend = 25
vim.opt.pumheight = 30
vim.opt.pyxversion = 3
vim.opt.redrawtime = 20000
vim.opt.regexpengine = 2
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.scrolljump = 5
vim.opt.scrolloff = 8 -- default: 0
vim.opt.secure = true
vim.opt.shada = { "'20", "<50", "s10" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("c") -- atOIc " default: filnxtToOF
vim.opt.shortmess:append("I") -- atOIc " default: filnxtToOF
vim.opt.showfulltag = true
vim.opt.showtabline = 2
vim.opt.sidescroll = 1     -- 0
vim.opt.sidescrolloff = 15 -- 0
vim.opt.signcolumn = "yes:3"
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "globals",
  "help",
  "resize",
  "tabpages",
  "terminal",
  "winpos",
  "winsize",
}
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.suffixes:append(".pyc")
vim.opt.switchbuf = "uselast" -- useopen
vim.opt.synmaxcol = 0         -- default: 3000, 0: unlimited, 400, 1500, 5000
vim.opt.tabstop = 2
vim.opt.tagcase = "smart"
vim.opt.tags = "./tags;" -- http://d.hatena.ne.jp/thinca/20090723/1248286959
vim.opt.textwidth = 0
vim.opt.timeout = true   -- mappnig timeout
vim.opt.timeoutlen = 200 -- default: 1000
vim.opt.ttimeout = true  -- keycode timeout
vim.opt.ttimeoutlen = 20 -- default: 50
vim.opt.undodir = vim.fs.joinpath(vim.fn.stdpath("state"), "undo")
vim.opt.undofile = true
vim.opt.undolevels = 10000 -- default: 1000
vim.opt.updatetime = 100   -- default: 4000
vim.opt.pumblend = 15
vim.opt.pumheight = 30
vim.opt.virtualedit = "block"
-- vim.opt.winbar = vim.fn.expand('%:~:.:h')..'/%t'
vim.opt.wildignore:append("*.jpg")
vim.opt.wildignore:append("*.jpeg")
vim.opt.wildignore:append("*.bmp")
vim.opt.wildignore:append("*.gif")
vim.opt.wildignore:append("*.png")
vim.opt.wildignore:append("*.o")
vim.opt.wildignore:append("*.obj")
vim.opt.wildignore:append("*.exe")
vim.opt.wildignore:append("*.dll")
vim.opt.wildignore:append("*.so")
vim.opt.wildignore:append("*.out")
vim.opt.wildignore:append("*.class")
vim.opt.wildignore:append("*.swp")
vim.opt.wildignore:append("*.swo")
vim.opt.wildignore:append("*.swn")
vim.opt.wildignore:append("*/.git")
vim.opt.wildignore:append("*/.hg")
vim.opt.wildignore:append("*/.svn")
vim.opt.wildignore:append("tags")
vim.opt.wildignore:append("*.tags")
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.wildoptions = "pum"
vim.opt.winblend = 0
vim.opt.wrap = true
vim.opt.writebackup = true

vim.opt.autochdir = false
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.errorbells = false
vim.opt.foldenable = false
vim.opt.ignorecase = false
vim.opt.joinspaces = false
vim.opt.list = false
vim.opt.shiftround = false
vim.opt.showcmd = false
vim.opt.showmatch = false
vim.opt.showmode = false
vim.opt.spell = false
vim.opt.swapfile = false
vim.opt.visualbell = false
vim.opt.wrapscan = false

vim.cmd("colorscheme equinusocio_material")

if vim.fn.has("mac") then
  vim.opt.wildignore:append("DS_Store") -- macOS only

  local path_add_macos_headers = function()
    local developer_dir = vim.fn.system("xcode-select -p")
    local sdk_dir = developer_dir .. "/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    local toolchain_dir = developer_dir .. "/Toolchains/XcodeDefault.xctoolchain"

    vim.opt.path:append("/usr/local/include")
    vim.opt.path:append(sdk_dir .. "/usr/include")
    vim.opt.path:append(toolchain_dir .. "/usr/include/c++/v1")
    vim.opt.path:append(toolchain_dir .. "/usr/include/swift")
    vim.opt.path:append("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include")
    vim.opt.path:append(toolchain_dir .. "/usr/lib/clang/**/include")
    vim.opt.path:append("/Users/zchee/src/github.com/apple-oss-distributions/xnu")

    -- macOS frameworks
    if vim.fn.isdirectory(vim.fn.stdpath("config") .. "/path/Frameworks") then
      vim.opt.path:append(vim.fn.stdpath("config") .. "/path/Frameworks")
    end
  end

  vim.api.nvim_create_autocmd("Filetype", { pattern = "c, cpp, objc, objcpp, go", callback = path_add_macos_headers })
end

local go_include = function()
  vim.opt.path:append("/usr/local/go/pkg/include")
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "go", callback = go_include })

local path_add_python_headers = function()
  if vim.fn.isdirectory("/usr/local/Frameworks/Python.framework/Headers") then
    vim.opt.path:append("/usr/local/Frameworks/Python.framework/Headers")
  end
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "c, cpp, objc, objcpp", callback = path_add_python_headers })

-- Color:

-- Go:
vim.g["go#generate#test#template_dir"] = os.getenv("XDG_CONFIG_HOME") .. "/go/template/gotests"
vim.g.go_highlight_error = 1
vim.g.go_highlight_return = 0
vim.g.go_highlight_fold_enable_comment = 1         -- default : 0
vim.g.go_highlight_generate_tags = 1               -- default : 0
vim.g.go_highlight_string_spellcheck = 0           -- default : 1
vim.g.go_highlight_format_strings = 1              -- default : 1
vim.g.go_highlight_fold_enable_package_comment = 1 -- default : 0
vim.g.go_highlight_fold_enable_block = 1           -- default : 0
vim.g.go_highlight_import = 1                      -- default : 0
vim.g.go_highlight_fold_enable_varconst = 1        -- default : 0
vim.g.go_highlight_array_whitespace_error = 0      -- default : 1
vim.g.go_highlight_trailing_whitespace_error = 0   -- default : 1
vim.g.go_highlight_chan_whitespace_error = 0       -- default : 1
vim.g.go_highlight_extra_types = 0                 -- default : 1
vim.g.go_highlight_space_tab_error = 0             -- default : 1
vim.g.go_highlight_operators = 1                   -- default : 0
vim.g.go_highlight_functions = 1                   -- default : 0
vim.g.go_highlight_function_parameters = 0         -- default : 0
vim.g.go_highlight_function_calls = 1              -- default : 0
vim.g.go_highlight_fields = 1                      -- default : 0
vim.g.go_highlight_types = 0                       -- default : 0
vim.g.go_highlight_variable_assignments = 0        -- default : 0
vim.g.go_highlight_variable_declarations = 0       -- default : 0
vim.g.go_highlight_build_constraints = 1           -- default : 0

-- C:
vim.g.c_ansi_constants = 1
vim.g.c_ansi_typedefs = 1
vim.g.c_comment_strings = 1
vim.g.c_gnu = 0
vim.g.c_no_curly_error = 1
vim.g.c_no_tab_space_error = 1
vim.g.c_no_trail_space_error = 1
vim.g.c_syntax_for_h = 0
vim.g.c_no_curly_error = 1

-- CPP:
vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_experimental_template_highlight = 1
vim.g.cpp_concepts_highlight = 1

-- Json:
vim.g.vim_json_syntax_conceal = 0

-- Asm:
vim.g.nasm_loose_syntax = 1
vim.g.nasm_ctx_outside_macro = 1

-- Perl:
vim.g.perl_include_pod = 1
vim.g.perl_no_scope_in_variables = 0
vim.g.perl_no_extended_vars = 0
vim.g.perl_string_as_statement = 1
vim.g.perl_no_sync_on_sub = 0
vim.g.perl_no_sync_on_global_var = 0
vim.g.perl_sync_dist = 100

vim.g.markdown_fenced_languages = {
  "c",
  "console=sh",
  "cpp",
  "dockerfile",
  "go",
  "graphql",
  "help",
  "mermaid",
  "mysql",
  "objective-c",
  "proto",
  "python",
  "sh",
  "sql",
  "typescript",
}

-- Accelerated JK:
-- vim.g.accelerated_jk_enable_deceleration = 1
-- vim.g.accelerated_jk_acceleration_limit = 500                                     -- 70, 250, 350
-- vim.g.accelerated_jk_acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 } -- g.accelerated_jk_acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28 }

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
vim.g.vista_sidebar_width = "150"
vim.g.vista_update_on_text_changed = true
vim.g.vista_executive_nvim_lsp_fetching = true

-- vim-wakatime
vim.g.wakatime_CLIPath = vim.fs.joinpath(
  homebrew_prefix,
  "opt/wakatime-cli-head/bin/wakatime-cli"
)
vim.g.wakatime_PythonBinary = vim.fs.joinpath(
  homebrew_prefix,
  "opt/python/bin/python3"
)

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
