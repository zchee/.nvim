-- local autocmd_user = vim.api.nvim_create_augroup("AutocmdUser", { clear = true })

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


vim.keymap.set({ "n" }, "<Space>", "<Nop>", { noremap = true })
vim.keymap.set({ "n" }, "<BS>", "<Nop>", { noremap = true })

-- vim.keymap.set({ "n" }, "*", "<Plug>(asterisk-gz*)", { nowait = true, silent = true })
-- vim.keymap.set({ "n" }, "-", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, nowait = true })
vim.keymap.set({ "n" }, "-", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, nowait = true })
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
vim.keymap.set({ "n" }, "<BS>ci", "<cmd>Inspect<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<C-g>", live_grep_from_project_git_root, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<C-q>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<Down>", "<Down>", { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "<S-Down>", "<Nop>", { noremap = true })
vim.keymap.set({ "n" }, "<S-Tab>", "%", { noremap = true })
vim.keymap.set({ "n" }, "<S-Up>", "<Nop>", { noremap = true })
vim.keymap.set({ "n" }, "<Up>", "<Up>", { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "@", "^", { nowait = true, silent = true })
vim.keymap.set({ "n" }, "^", "@", { nowait = true, silent = true })
vim.keymap.set({ "n" }, "b", "b", { nowait = true, silent = true })
vim.keymap.del("n", "gcc")
vim.keymap.set({ "n" }, "gc",
  "<Plug>(comment_toggle_linewise_current)", { noremap = false, silent = true, nowait = true })
vim.keymap.set({ "n" }, "gs", "<cmd>Switch<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "gx", "<Plug>(openbrowser-smart-search)", { silent = true })
vim.keymap.set({ "n" }, "j", "<Plug>(accelerated_jk_gj)", { nowait = true, silent = true })
vim.keymap.set({ "n" }, "k", "<Plug>(accelerated_jk_gk)", { nowait = true, silent = true })
vim.keymap.set({ "n" }, "Q", "gq", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "s", "A", { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "w", "w", { nowait = true, silent = true })
vim.keymap.set({ "n" }, "x", '"_x', { nowait = true, noremap = true, silent = true })
vim.keymap.set({ "n" }, "zj", "zjzt", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "zk", "2zkzjzt", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "ZQ", "<Nop>", { noremap = true, silent = true })

-- Language:
--- Vim:
--- http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = {
    "*.vim",
  },
  callback = function()
    vim.keymap.set({ "n" }, "K", ":<C-u>Help<Space><C-r><C-w><CR>",
      { noremap = true, silent = true, buffer = true })
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "help",
  },
  callback = function()
    vim.keymap.set({ "n" }, "<C-]>", ":<C-u>Help<Space><C-r><C-w><CR>",
      { noremap = true, silent = true, buffer = true })
  end,
})

-- "" Ouickfix:
-- Gautocmdft qf  nnoremap <buffer><CR>      <CR>zz
--
-- "" Help:
-- Gautocmdft help nnoremap <silent><buffer><C-n> :<C-u>cnext<CR>
-- Gautocmdft help nnoremap <silent><buffer><C-p> :<C-u>cprevious<CR>
--
-- " -------------------------------------------------------------------------------------------------
-- " Insert: (i)

-- " Move cursor to first or end of line
vim.keymap.set({ "i" }, "<C-a>", "<C-o><S-i>", { noremap = true, silent = true })
vim.keymap.set({ "i" }, "<C-e>", "<C-o><S-a>", { noremap = true, silent = true })

-- " Put +register word
vim.keymap.set({ "i" }, "<C-y>", "<C-r>*", { noremap = true, silent = true })
vim.keymap.set({ "i" }, "<C-j>", "<C-r>*", { noremap = true, silent = true })

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

vim.keymap.set({ "v" }, "<S-Tab>", "%", { noremap = true })
vim.keymap.set({ "v" }, "c", "\"_c", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "P", "\"_dP", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "p", "\"_dp", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "x", "\"_x", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "@", "^", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "^", "$", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "ga", "<Plug>(LiveEasyAlign)", { silent = true })
-- TODO(zchee): fix
-- vim.keymap.set({ "v" }, "gs", "<Cmd>lua vim.cmd(\"'<,'>sort i\")<CR>", { noremap = true, silent = true })
vim.keymap.set({ "v" }, "gx", "<Plug>(openbrowser-smart-search)", { silent = true })
vim.keymap.set({ "v" }, "tu", "<Plug>(operator-convert-case-upper-camel)", { silent = true })
vim.keymap.set({ "v" }, "v", "g_", { noremap = true, nowait = true })
vim.keymap.set({ "v" }, "V", "^", { noremap = true, nowait = true })

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
-- hack
-- vim.keymap.del('n', 'gcc')
--- map-overview
--- normal
-- vim.keymap.set(
-- 	{ "n" },
-- 	"gc",
-- 	"<Plug>(comment_toggle_linewise)",
-- 	{ noremap = true, silent = true, nowait = true, desc = "Comment toggle current line" }
-- )
-- vim.keymap.set(
--   { "n" },
--   "gbc",
--   "<Plug>(comment_toggle_linewise_visual)",
--   { noremap = true, silent = true, nowait = true, expr = true, desc = "Comment toggle current line" }
-- )

--- visual
-- vim.keymap.set(
--   { "x" },
--   "gc",
--   "<Plug>(comment_toggle_linewise_visual)",
--   { noremap = true, silent = true, nowait = true, desc = "Comment toggle linewise" }
-- )
vim.keymap.set(
  { "x" },
  "gb",
  "<Plug>(comment_toggle_blockwise_visual)",
  { noremap = true, silent = true, desc = "Comment toggle blockwise (visual)" }
)
-- vim.keymap.set({ "x" }, "<C-t>", "<cmd>Trans<CR>", { noremap = true, silent = true })
-- vim.keymap.set(
--   { "x" },
--   "gb",
--   "<Plug>(comment_toggle_linewise_visual)",
--   { noremap = true, nowait = true, desc = "Comment toggle blockwise" })

-- vim.keymap.set("x", "gc", "<Plug>(comment_toggle_linewise_visual)", { noremap = true, silent = true, nowait = true })
-- vim.keymap.set(
--   { "x" },
--   "gb",
--   "<Plug>(comment_toggle_blockwise_visual)",
--   { noremap = true, silent = true, desc = "Comment toggle blockwise (visual)" }
-- )

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

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  -- group = autocmd_user,
  pattern = {
    "*.go",
    "*.yaml",
    "*.json",
  },
  callback = function()
    vim.keymap.set({ "s" }, "\"", "'", { noremap = true, buffer = true })
    vim.keymap.set({ "s" }, "'", "\"", { noremap = true, buffer = true })
  end,
})

-- " -------------------------------------------------------------------------------------------------
-- " Command Line: (c)
--
-- " Move beginning of the command line
-- " http://superuser.com/a/988874/483994
vim.keymap.set({ "c" }, "<C-a>", "<Home>", { noremap = true })
vim.keymap.set({ "c" }, "<C-d>", "<Del>", { noremap = true })
vim.keymap.set({ "c" }, "<S-Tab>", "<C-p>", { noremap = true })

-- " -------------------------------------------------------------------------------------------------
-- " Terminal: (t)
--
-- " Emacs like mapping
vim.keymap.set({ "t" }, "qq", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set({ "t" }, "<S-Left>", "<C-[>b", { noremap = true, silent = true, buffer = true })
vim.keymap.set({ "t" }, "<C-Left>", "<C-[>b", { noremap = true, silent = true, buffer = true })
vim.keymap.set({ "t" }, "<S-Right>", "<C-[>f", { noremap = true, silent = true, buffer = true })
vim.keymap.set({ "t" }, "<C-Right>", "<C-[>f", { noremap = true, silent = true, buffer = true })
vim.keymap.set({ "t" }, "<BS>", "<BS>", { noremap = true, silent = true, buffer = true, nowait = true })
