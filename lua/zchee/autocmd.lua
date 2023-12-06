local autocmd_user = vim.api.nvim_create_augroup("AutocmdUser", { clear = true })

-- FileType
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = autocmd_user,
  pattern = {
    -- "help",
    "man",
    "qf",
    "quickrun",
    "ref",
  },
  callback = function()
    vim.opt_local.colorcolumn = ""

    vim.api.nvim_buf_set_keymap(0, "n", "u", "<C-u>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "d", "<C-d>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { silent = true })
  end,
})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "go" },
--   callback = function(args)
--     vim.treesitter.start(args.buf, "go")
--     vim.bo[args.buf].syntax = "on" -- only if additional legacy syntax is needed
--   end
-- })

-- "" Man:
-- Gautocmdft man://* nmap  <buffer><nowait>j  <Plug>(accelerated_jk_gj_position)
-- Gautocmdft man://* nmap  <buffer><nowait>k  <Plug>(accelerated_jk_gk_position)
--
-- " Vim:
-- "" nested autoload
-- Gautocmdft vim setlocal tags+=$XDG_DATA_HOME/nvim/tags/runtime.tags
-- Gautocmdft qf hi Search  gui=None  guifg=None  guibg=#373b41
--
-- "" Misc:
-- Gautocmdft jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = autocmd_user,
  pattern = {
    "json",
  },
  callback = function()
    local bufname = vim.fn.bufname()

    if bufname == "package.json" or string.find(bufname, ".*%.schema%.json$") then
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.tabstop = 2
    end
  end,
})

-- BufNewFile, BufReadPost
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = autocmd_user,
  pattern = {
    "/System/Library/*",
    "/Applications/Xcode%.*",
    "/usr/include/*",
    "/usr/lib/*",
  },
  callback = function()
    vim.opt_local.readonly = true
    vim.opt_local.modified = false
  end,
})

-- BufEnter
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = autocmd_user,
  pattern = {
    "COMMIT_EDITMSG",
    "option-window",
  },
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- local autoJump = function()
--   vim.cmd([[
-- if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != "gitcommit" && &filetype != "gitrebase"
--   execute "silent! keepjumps normal! g`\"zt"
-- endif
-- ]])
-- end
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = autocmd_user,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then --  and not vim.bo.filetype == "gitcommit" and not vim.bo.filetype == "gitrebase"
      vim.cmd([[
        execute "silent! keepjumps normal! g`\"zz\""
      ]])
    end
  end,
})

-- WinEnter
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    -- http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
    local only_one_window = vim.fn.winnr("$") == 1
    if only_one_window then
      local is_ft = function(ft)
        return vim.o.filetype == ft
      end

      local is_nvimtree = vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr()
      if is_nvimtree or is_ft("qt") or is_ft("git") or is_ft("vista_kind") then
        vim.fn.quit()
      end
    end
  end,
})

-- BufWritePre
if vim.lsp.protocol.resolve_capabilities({ "documentFormattingProvider" }) then
  local lsp_format_augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = lsp_format_augroup,
    pattern = {
      "*.go",
      "*.lua",
      "*.tf",
      "*.tfvars",
      "*.ts",
    },
    callback = function()
      vim.lsp.buf.format({
        async = false,
        trimTrailingWhitespace = true,
        insertFinalNewline = true,
      })
    end,
  })
end

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = autocmd_user,
--   pattern = {
--     "*.go",
--     -- "*.lua",
--     "*.tf",
--     "*.tfvars",
--     "*.ts",
--   },
--   callback = function()
--     vim.lsp.buf.format({ async = false })
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = autocmd_user,
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { 'source.organizeImports' } },
      apply = true,
    })
  end
})

-- local lsp_inlayhints = function()
--   local inlayhints = require("lsp-inlayhints")
--   inlayhints.setup({
--     inlay_hints = {
--       parameter_hints = {
--         show = true,
--         prefix = "<- ",
--         separator = ", ",
--         remove_colon_start = false,
--         remove_colon_end = true,
--       },
--       -- type and other hints
--       type_hints = {
--         show = true,
--         prefix = "",
--         separator = ", ",
--         remove_colon_start = false,
--         remove_colon_end = false,
--       },
--       only_current_line = false,
--       -- separator between types and parameter hints. Note that type hints are shown before parameter
--       labels_separator = "  ",
--       -- whether to align to the length of the longest line in the file
--       max_len_align = false,
--       -- padding from the left if max_len_align is true
--       max_len_align_padding = 1,
--       -- highlight group
--       highlight = "LspInlayHint",
--       -- virt_text priority
--       priority = 10000,
--     },
--     enabled_at_startup = true,
--     debug_mode = false,
--   })
--
--   return inlayhints
-- end

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = autocmd_user,
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end
--
--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     lsp_inlayhints().on_attach(client, bufnr)
--   end,
-- })

-- FocusGained
-- github.com/vovkasm/input-source-switcher
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    vim.fn.jobstart("issw com.apple.keylayout.ABC", { detach = true })
  end,
})

-- InsertLeave
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    vim.opt.paste = false
  end,
})
