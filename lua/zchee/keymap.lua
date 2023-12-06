-- " Map Leader:
--
-- " nmap <Nop> for g:mapleader and g:maplocalleader keys
-- nnoremap <nowait><Space> <Nop>
-- nnoremap <nowait><BS>    <Nop>
-- if !exists('g:mapleader')
--   let g:mapleader = "\<Space>"
-- endif
-- if !exists('g:maplocalleader')
--   let g:maplocalleader = "\<BS>"
-- endif
--
-- "" <Leader>
-- " nnoremap              <Leader>ga        :<C-u>Gina add %<CR>
-- " nnoremap              <Leader>gc        :<C-u>Gina commit<CR>
-- " nnoremap              <Leader>gp        :<C-u>Gina push<CR>
-- " nnoremap              <Leader>gs        :<C-u>Gina status<CR>
--      map           <Leader><Leader>     <Plug>(easymotion-prefix)
--
-- "" <LocalLeader>
-- " nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep -buffer-name='grep/rg'<CR>
-- nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
-- nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
-- " nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer'<CR>
-- " nnoremap <silent><LocalLeader>g         :<C-u>Denite line -buffer-name='line'<CR>
-- nnoremap <silent><LocalLeader>gs        :<C-u>call switch#Switch()<CR>
-- nnoremap <silent><LocalLeader>q         :<C-u>q<CR>
-- nnoremap <silent><LocalLeader>w         :<C-u>w<CR>
--
-- "" ,
-- nnoremap              <silent>,m        <C-w>W
-- nnoremap              <silent>,n        <C-w>w
-- nnoremap              <silent>,p        <C-w>W
-- nnoremap              <silent>,r        <C-w>x
-- nnoremap              <silent>,s        :<C-u>bNext<CR>
-- nnoremap              <silent>,t        :<C-u>tabnew<CR>
-- nnoremap              <silent>,w        <C-w>w

-- vim.keymap.set("n", "<Space>", "<Nop>", { noremap = true, nowait = true })
-- vim.keymap.set("n", "<BS>", "<Nop>", { noremap = true, nowait = true })

-- Leaders
-- if not vim.g.mapleader then
--   vim.g.mapleader = "<Space>"
-- end
-- if not vim.g.maplocalleader then
--   vim.g.maplocalleader = "<BS>"
-- end
-- vim.g.mapleader = "<Space>"
-- vim.g.maplocalleader = "<BS>"

-- Map: (m)

-- Operator:
vim.keymap.set({ "v", "x" }, "td", "<Plug>(operator-surround-delete)", { silent = true })
vim.keymap.set({ "v", "x" }, "ti", "<Plug>(operator-surround-append)", { silent = true })
vim.keymap.set({ "v", "x" }, "tr", "<Plug>(operator-surround-replace)", { silent = true })

-- " -------------------------------------------------------------------------------------------------
-- " Normal: (n)
--
-- "        *) asterisk-gz*
-- "        -) 'Vaffle %:p:h' or 'VimFilerExplorer -find<CR>'
-- "      @,^) ^,@: switch '@' and '^' for Dvorak pinky
-- "       ga) EasyAlign
-- "       gx) openbrowser-smart-search
-- "        j) accelerated_jk_gj_position
-- "        k) accelerated_jk_gk_position
-- "        p) Paste
-- "        Q) gq: do not use Ex mode. Use 'gq' is the format the lines that {motion} moves over
-- "        s) A: Append text at the end of the line [count] times
-- "        x) "_x: do not add yank register
-- "       zj)       zjzt
-- "       zk)       2zkzjzt
-- "       ZQ) <Nop>: disable suspend
-- "    <C-g>) 'DeniteProjectDir grep'
-- "    <C-p>) 'DeniteProjectDir file_rec'
-- "    <C-q>) nohlsearch: Stop the highlighting for the 'hlsearch' option
-- " <S-Tab>>) %: Jump to match pair brackets. *<Tab>* and *<C-i>* are similar treatment.
-- "              Note that needs <C-i>(<Tab>) for jump to next taglist
-- " <S-Down>) <Nop>
-- "   <S-Up>) <Nop>

vim.keymap.set({ "n" }, "*", "<Plug>(asterisk-gz*)", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "*", "<Plug>(asterisk-gz*)", { nowait = true, silent = true })
vim.keymap.set({ "n" }, "-", ":<C-u>NvimTreeToggle<CR>", { noremap = true, silent = true, nowait = true })
local live_grep_from_project_git_root = function()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local opts = {}
  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  require("telescope.builtin").live_grep(opts)
end
vim.keymap.set({ "n" }, "<C-g>", live_grep_from_project_git_root,         { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<C-p>", "<cmd>Telescope find_files<CR>",         { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<C-q>", "<cmd>nohlsearch<CR>",                   { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<Down>", "<Down>",                               { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "<S-Down>", "<Nop>",                              { noremap = true })
vim.keymap.set({ "n" }, "<S-Tab>", "%",                                   { noremap = true })
vim.keymap.set({ "n" }, "<S-Up>", "<Nop>",                                { noremap = true })
vim.keymap.set({ "n" }, "<Up>", "<Up>",                                   { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "@", "^",                                         { nowait = true, silent = true })
vim.keymap.set({ "n" }, "^", "@",                                         { nowait = true, silent = true })
vim.keymap.set({ "n" }, "b", "b",                                         { nowait = true, silent = true })
vim.keymap.set({ "n" }, "gc", "<Plug>(comment_toggle_linewise_current)",  { silent = true, noremap = true, nowait = true })
vim.keymap.set({ "n" }, "gs", "<cmd>Switch<CR>",                          { noremap = true, silent = true })
vim.keymap.set({ "n" }, "gx", "<Plug>(openbrowser-smart-search)",         { silent = true })
vim.keymap.set({ "n" }, "j", "<Plug>(accelerated_jk_gj)",                 { nowait = true, silent = true })
vim.keymap.set({ "n" }, "k", "<Plug>(accelerated_jk_gk)",                 { nowait = true, silent = true })
vim.keymap.set({ "n" }, "Q", "gq",                                        { noremap = true, silent = true })
vim.keymap.set({ "n" }, "s", "A",                                         { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "w", "w",                                         { nowait = true, silent = true })
vim.keymap.set({ "n" }, "x", '"_x',                                       { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "zj", "zjzt",                                     { noremap = true, silent = true })
vim.keymap.set({ "n" }, "zk", "2zkzjzt",                                  { noremap = true, silent = true })
vim.keymap.set({ "n" }, "ZQ", "<Nop>",                                    { noremap = true, silent = true })

-- Language:
--
-- "" Go:
-- Gautocmdft go nnoremap <LocalLeader>go  :<C-u>DeniteProjectDir grep -buffer-name='grep' -path=/usr/local/go/src<CR>
-- Gautocmd BufNewFile,BufRead,BufEnter godoc://** nmap <C-]> <CR>
--
-- "" C CXX ObjC:
-- Gautocmdft c,cpp  nnoremap <silent><buffer><C-k>       :<C-u>call <SID>open_online_cfamily_doc()<CR>
-- " if dein#tap('vim-clang-format')
-- "   Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>x        <Plug>(operator-clang-format)
-- "   Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>C        :<C-u>ClangFormatAutoToggle<CR>
-- "   Gautocmdft c,cpp,objc,objcpp,proto nnoremap <buffer><LocalLeader>f   :<C-u>ClangFormat<CR>
-- " endif
--
-- "" Protobuf:
--
-- "" Yaml:
--
-- "" Markdown:
-- Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>
--
-- "" Vim:
-- " http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
-- Gautocmdft vim nnoremap <silent><buffer>K      :<C-u>Help<Space><C-r><C-w><CR>
--
-- "" Ouickfix:
-- Gautocmdft qf  nnoremap <buffer><CR>      <CR>zz
--
-- "" Help:
-- Gautocmdft help nnoremap <silent><buffer><C-n> :<C-u>cnext<CR>
-- Gautocmdft help nnoremap <silent><buffer><C-p> :<C-u>cprevious<CR>
--
-- " -------------------------------------------------------------------------------------------------
-- " Insert: (i)
--
-- " <C-c> doesn't trigger the InsertLeave autocmd
-- inoremap <C-c> <ESC>
--
-- " Move cursor to first or end of line
-- inoremap <silent><C-a>  <C-o><S-i>
-- inoremap <silent><C-e>  <C-o><S-a>
--
-- " Put +register word
-- inoremap <silent><C-y>  <C-r>*
-- inoremap <silent><C-j>  <C-r>*
--
-- " Language:
--
-- "" Go Yaml Json:
-- " Gautocmdft go,yaml,json,jsonschema inoremap <buffer><expr>'    <cmd>lua require('nvim-autopairs').autopairs_map(1,'"')<CR>
-- " Gautocmdft go,yaml,json,jsonschema inoremap <buffer><expr>"    <cmd>lua require('nvim-autopairs').autopairs_map(1,"'")<CR>
-- " inoremap <buffer><expr>'    <cmd>lua require('nvim-autopairs').autopairs_map(1,'"')<CR>
-- " inoremap <buffer><expr>"    <cmd>lua require('nvim-autopairs').autopairs_map(1,"'")<CR>
--
-- "" Swift:
-- " Gautocmdft swift imap <buffer><C-k>  <Plug>(autocomplete_swift_jump_to_placeholder)
--
-- " Plugins:
-- "" Neosnippet:
-- " imap     <silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"
--
--
-- "" GitHub Copilot
-- " imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
-- " let g:copilot_no_tab_map = v:true
-- " Gautocmd BufNewFile,BufRead,BufEnter Copilot disable
--
-- highlight CopilotSuggestion guifg=#555555 ctermfg=8
--
-- " -------------------------------------------------------------------------------------------------
-- " Visual Select: (v)
--
-- " Do not add register to current cursor word
-- " move to start of line
-- "        c : do not add register to current cursor word
-- "        x : do not add register to current cursor word
-- "        P : do not add register to current cursor word
-- "        p : do not add register to current cursor word
-- "        @ : swap @ and ^ for dvorak
-- "        ^ : swap @ and ^ for dvorak
-- "       ga :
-- "       gc :
-- "       gs : sort by ignorecase alphabetically
-- "       tu :
-- "        v : move to the  last non-blank character of the line
-- "        V : move to the first non-blank character of the line
--
-- vnoremap                  <S-Tab>    %
-- vnoremap                <nowait>c    "_c
-- vnoremap                <nowait>P    "_dP
-- vnoremap                <nowait>p    "_dp
-- vnoremap                <nowait>x    "_x
-- vnoremap                <nowait>@    ^
-- vnoremap                <nowait>^    @
-- vmap                    <silent>ga   <Plug>(LiveEasyAlign)
-- " vmap                    <silent>gc   <Plug>(caw:hatpos:toggle)
-- vnoremap                <silent>gs   :<C-u>'<,'>sort i<CR>
-- vmap                    <silent>gx   <Plug>(openbrowser-smart-search)
-- vmap                    <silent>tu   <Plug>(operator-convert-case-upper-camel)
-- vnoremap                <nowait>v    g_
-- vnoremap                <nowait>V    ^
--
--
-- " Language:
--
-- "" Protobuf:
-- Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>
--
-- "" C CXX ObjC:
-- Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

-- vim.keymap.set({ "v" }, "<C-t>", "<Plug>(TranslateW)", { silent = true })
--
-- " -------------------------------------------------------------------------------------------------
-- " Visual: (x)
-- comment
vim.keymap.set("x", "<C-t>", "<cmd>Trans<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "gc", "<Plug>(comment_toggle_linewise_visual)", { silent = true, noremap = true, nowait = true })

-- " xmap                <LocalLeader>    <Plug>(operator-replace)
-- vim.keymap.set({ "x" }, "<C-t>", "<Plug>(TranslateW)", { silent = true })
--
-- xnoremap               <silent>nu :lua require"treesitter-unit".select()<CR>
-- xnoremap               <silent>tu :lua require"treesitter-unit".select(true)<CR>
-- Trans
--
-- " Language:
--
-- " -------------------------------------------------------------------------------------------------
-- " Operator Pending: (o)
--
-- onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
-- onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>
--
-- " -------------------------------------------------------------------------------------------------
-- " Select: (s)
--
-- " neosnippet
-- " smap  <nowait><silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"
--
-- " Language:
--
-- "" Go Yaml Json:
-- Gautocmdft go,yaml,json,jsonschema snoremap <buffer> "    '
-- Gautocmdft go,yaml,json,jsonschema snoremap <buffer> '    "
--
-- " -------------------------------------------------------------------------------------------------
-- " Command Line: (c)
--
-- " Move beginning of the command line
-- " http://superuser.com/a/988874/483994
-- cnoremap       <C-a>    <Home>
-- cnoremap       <C-d>    <Del>
-- cnoremap       <C-k>    <C-\>e(strpart(getcmdline(), 0, getcmdpos()-1))<CR>
-- cnoremap <expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
-- cnoremap <expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"
-- cnoremap       <S-Tab>  <C-p>
--
-- " -------------------------------------------------------------------------------------------------
-- " Terminal: (t)
--
-- " Emacs like mapping
-- tnoremap <silent>qq                <C-\><C-n>
-- tnoremap <silent><buffer><expr>jj  <SID>find_proc_in_tree(b:terminal_job_pid, 'nvim', 0) ? '<ESC>' : '<C-\><C-N>'
-- tnoremap <buffer><S-Left>          <C-[>b
-- tnoremap <buffer><C-Left>          <C-[>b
-- tnoremap <buffer><S-Right>         <C-[>f
-- tnoremap <buffer><C-Right>         <C-[>f
-- tnoremap <nowait><buffer><BS>      <BS>
