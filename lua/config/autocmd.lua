local util = require("util")

local autocmd_user = vim.api.nvim_create_augroup("AutocmdUser", { clear = false })

vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = "go",
  callback = function()
    vim.opt.path:append("/usr/local/go/pkg/include")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = "c, cpp, objc, objcpp",
  callback = function()
    if vim.fn.isdirectory("/usr/local/Frameworks/Python.framework/Headers") then
      vim.opt.path:append("/usr/local/Frameworks/Python.framework/Headers")
    end
  end,
})

-- FileType
vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = {
    "man",
    "qf",
    "quickrun",
    "ref",
    "startuptime",
  },
  callback = function()
    vim.opt_local.colorcolumn = ""

    vim.api.nvim_buf_set_keymap(0, "n", "u", "<C-u>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "d", "<C-d>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { silent = true })
  end,
})

--- macOS
if vim.fn.has("mac") then
  vim.opt.wildignore:append("DS_Store") -- macOS only

  local path_add_macos_headers = function()
    local developer_dir = "/Applications/Xcode.app/Contents/Developer" -- vim.fn.system("xcode-select -p")
    local sdk_dir = vim.fs.joinpath(developer_dir, "/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
    local toolchain_dir = vim.fs.joinpath(developer_dir, "/Toolchains/XcodeDefault.xctoolchain")

    vim.opt.path:append("/usr/local/include")
    vim.opt.path:append(vim.fs.joinpath(sdk_dir, "/usr/include"))
    vim.opt.path:append(vim.fs.joinpath(toolchain_dir .. "/usr/include/c++/v1"))
    vim.opt.path:append(vim.fs.joinpath(toolchain_dir .. "/usr/include/swift"))
    vim.opt.path:append("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include")
    vim.opt.path:append(vim.fs.joinpath(toolchain_dir .. "/usr/lib/clang/**/include"))

    -- macOS frameworks
    local frameworks_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "/path/Frameworks")
    if vim.fn.isdirectory(frameworks_dir) then
      vim.opt.path:append(frameworks_dir)
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "go" },
    callback = path_add_macos_headers
  })
end
-- C familly
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "go" },
  callback = function()
    if vim.fn.isdirectory("/usr/local/Frameworks/Python.framework/Headers") then
      vim.opt.path:append("/usr/local/Frameworks/Python.framework/Headers")
    end
  end,
})
--- Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.opt.path:append(vim.fs.joinpath(util.prefix(), "go/pkg/include"))
  end,
})
--- Zsh
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "zsh" },
  callback = function()
    vim.cmd([[
    filetype plugin indent on
    syntax enable
    ]])
  end,
})

-- BufNewFile, BufReadPost
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
--   group = autocmd_user,
--   pattern = {
--     "json",
--   },
--   callback = function()
--     local bufname = tostring(vim.fn.bufname())
--
--     if bufname == "package.json" or string.find(bufname, ".*%.schema%.json$") then
--       vim.opt_local.expandtab = true
--       vim.opt_local.shiftwidth = 2
--       vim.opt_local.softtabstop = 2
--       vim.opt_local.tabstop = 2
--     end
--   end,
-- })
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

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = autocmd_user,
  pattern = {
    "**/colors/*",
    "**/highlight.lua",
    "**/kitty/color.conf",
  },
  callback = function()
    vim.cmd.ColorizerToggle()
  end,
})

-- BufWinEnter
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = autocmd_user,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then --  and not vim.bo.filetype == "gitcommit" and not vim.bo.filetype == "gitrebase"
      vim.cmd([[
        execute "silent! keepjumps normal! g`\"zt\""
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

local autocmd_lsp_format = vim.api.nvim_create_augroup("LspFormat", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = autocmd_lsp_format,
  pattern = {
    "*.lua",
    -- "*.ts",
  },
  callback = function(args)
    local file = vim.fs.abspath(args.file)
    if string.find(file, "neovim/neovim") then
      return
    end

    vim.lsp.buf.format({
      async = false,
      trimTrailingWhitespace = true,
      insertFinalNewline = true,
      trimFinalNewlines = true,
    })
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = autocmd_lsp_format,
  pattern = {
    "*.tf",
    "*.tfvars",
  },
  callback = function()
    vim.lsp.buf.format({
      async = true,
      trimTrailingWhitespace = true,
      insertFinalNewline = true,
      trimFinalNewlines = true,
    })
  end,
})

---@class PrioritySemanticTokens
---@field type string semantic tokens type
---@field hl_group string semantic tokens hl group name
---@field priority number highlight priority

---@type PrioritySemanticTokens[]
local priority_semantic_tokens = {
  -- { type = "namespace" },
  -- { type = "variable" },
  -- { modifier = "global" },
  -- { modifier = "format" },
  { type = "class", hl_group = "@lsp.type.class.python", priority = 200 },
}

vim.api.nvim_create_autocmd("LspTokenUpdate", {
  callback = function(args)
    --- @type SemanticToken
    local token = args.data.token
    -- local captures = vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)

    for _, t in pairs(priority_semantic_tokens) do
      local priority = t.priority or 105
      if t.type and token.type == t.type then
        vim.lsp.semantic_tokens.highlight_token(
          token,
          args.buf,
          args.data.client_id,
          t.hl_group,
          { priority = priority }
        )
      end

      -- if t.modifier and token.modifiers[t.modifier] then
      --   vim.lsp.semantic_tokens.highlight_token(
      --     token,
      --     args.buf,
      --     args.data.client_id,
      --     t.modifier,
      --     { priority = priority }
      --   )
      -- end

      -- if t.treesitter then
      --   for _, capture in pairs(captures) do
      --     if capture.capture == t.treesitter then
      --       vim.lsp.semantic_tokens.highlight_token(
      --         token,
      --         args.buf,
      --         args.data.client_id,
      --         t.treesitter,
      --         { priority = priority }
      --       )
      --     end
      --   end
      -- end
    end
  end,
})

-- vim.api.nvim_create_autocmd('InsertEnter', {
--   desc = 'Disable LSP semantic highlights',
--   pattern = {
--     "*.go",
--   },
--   callback = function(event)
--     local id = vim.tbl_get(event, 'data', 'client_id')
--     local client = id and vim.lsp.get_client_by_id(id)
--     if client == nil then
--       return
--     end
--
--     client.server_capabilities.documentHighlightProvider = nil
--     client.server_capabilities.documentSymbolProvider = nil
--     client.server_capabilities.semanticTokensProvider = nil
--     client.server_capabilities.semanticTokensProvider = nil
--   end,
-- })

-- vim.api.nvim_create_autocmd('ModeChanged', {
--   pattern = { 'n:i', 'v:s' },
--   desc = 'Disable diagnostics in insert and select mode',
--   callback = function(e) vim.diagnostic.enable(false, { bufnr = e.buf }) end
-- })
-- vim.api.nvim_create_autocmd('ModeChanged', {
--   pattern = 'i:n',
--   desc = 'Enable diagnostics when leaving insert mode',
--   callback = function(e) vim.diagnostic.enable(true, { bufnr = e.buf }) end
-- })
--
-- vim.opt.updatetime = 400
-- local function highlight_symbol(event)
--   local id = vim.tbl_get(event, "data", "client_id")
--   local client = id and vim.lsp.get_client_by_id(id)
--   ---@diagnostics disable
--   if client == nil or not client.supports_method("textDocument/documentHighlight", event.buf) then
--     return
--   end
--   local group = vim.api.nvim_create_augroup("highlight_symbol", { clear = false })
--   vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })
--   vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--     group = group,
--     buffer = event.buf,
--     callback = vim.lsp.buf.document_highlight,
--   })
--   vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--     group = group,
--     buffer = event.buf,
--     callback = vim.lsp.buf.clear_references,
--   })
-- end
-- vim.api.nvim_create_autocmd("LspAttach", {
--   desc = "Setup highlight symbol",
--   callback = highlight_symbol,
-- })

-- -- https://github.com/golang/tools/blob/gopls/v0.11.0/gopls/doc/vim.md#imports
-- ---@param client vim.lsp.Client
-- ---@param bufnr integer
-- ---@param cmd string
-- local function code_action_sync(client, bufnr, cmd)
--   local params = {}
--   params = vim.lsp.util.make_range_params(0, "utf-16")
--   params.context = { only = { cmd }, diagnostics = {} } --- @diagnostic disable-line
--
--   local resp = client.request_sync("textDocument/codeAction", params, 3000, bufnr) --- @diagnostic disable-line
--   for cid, r in pairs(resp and resp.result or {}) do
--     if r.edit then
--       local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
--       vim.lsp.util.apply_workspace_edit(r.edit, enc)
--     end
--   end
-- end
--
-- ---@param client vim.lsp.Client
-- ---@param bufnr integer
-- local function organize_imports_sync(client, bufnr)
--   code_action_sync(client, bufnr, "source.organizeImports")
-- end
--
-- ---@param client vim.lsp.Client
-- ---@param bufnr integer
-- local function fix_all_sync(client, bufnr)
--   code_action_sync(client, bufnr, "source.fixAll")
-- end
--
-- ---@type table<string, fun(client: vim.lsp.Client, bufnr: integer)[]>
-- local save_handlers_by_client_name = {
--   gopls = { organize_imports_sync, format_sync },
--   biome = { fix_all_sync, organize_imports_sync, format_sync },
-- }
--
-- -- none-ls を含むすべての Language Server の保存時の処理をまとめてしまう
-- --
-- -- Language Server の処理を連続で呼び出すと意図通りの動作をしないことがある
-- -- Server 側の内部状態の更新が間に合わないのか？
-- -- その回避のために sleep が必要
-- --
-- -- かつ、複数 Language Server にリクエストを送るときにも sleep を入れるために
-- -- 1つの BufWritePre にまとめている
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   ---@param args { buf: integer }
--   callback = function(args)
--     local bufnr = args.buf
--     local shouldSleep = false
--     for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
--       local save_handlers = save_handlers_by_client_name[client.name]
--       for _, f in pairs(save_handlers or {}) do
--         if shouldSleep then
--           vim.api.nvim_command("sleep 10ms")
--         else
--           shouldSleep = true
--         end
--         f(client, bufnr)
--       end
--     end
--   end,
-- })

-- Codelenses:
-- AddDependency           Command = "add_dependency"
-- AddImport               Command = "add_import"
-- AddTelemetryCounters    Command = "add_telemetry_counters"
-- ApplyFix                Command = "apply_fix"
-- ChangeSignature         Command = "change_signature"
-- CheckUpgrades           Command = "check_upgrades"
-- DiagnoseFiles           Command = "diagnose_files"
-- EditGoDirective         Command = "edit_go_directive"
-- FetchVulncheckResult    Command = "fetch_vulncheck_result"
-- GCDetails               Command = "gc_details"
-- Generate                Command = "generate"
-- GoGetPackage            Command = "go_get_package"
-- ListImports             Command = "list_imports"
-- ListKnownPackages       Command = "list_known_packages"
-- MaybePromptForTelemetry Command = "maybe_prompt_for_telemetry"
-- MemStats                Command = "mem_stats"
-- RegenerateCgo           Command = "regenerate_cgo"
-- RemoveDependency        Command = "remove_dependency"
-- ResetGoModDiagnostics   Command = "reset_go_mod_diagnostics"
-- RunGoWorkCommand        Command = "run_go_work_command"
-- RunGovulncheck          Command = "run_govulncheck"
-- RunTests                Command = "run_tests"
-- StartDebugging          Command = "start_debugging"
-- StartProfile            Command = "start_profile"
-- StopProfile             Command = "stop_profile"
-- Test                    Command = "test"
-- Tidy                    Command = "tidy"
-- ToggleGCDetails         Command = "toggle_gc_details"
-- UpdateGoSum             Command = "update_go_sum"
-- UpgradeDependency       Command = "upgrade_dependency"
-- Vendor                  Command = "vendor"
-- Views                   Command = "views"
-- WorkspaceStats          Command = "workspace_stats"

--- @diagnostic disable-next-line
-- local function is_ft_go()
--   local function table_contains(tbl, contains)
--     for i = 1, #tbl do
--       if (tbl[i] == contains) then
--         return true
--       end
--     end
--     return false
--   end
--   local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
--   local ft_list = {
--     "go",
--     "yaml",
--   }
--   if not table_contains(ft_list, ft) then
--     return
--   end
-- end
-- local augroup_organize_imports = vim.api.nvim_create_augroup("LspOrganizeImports", { clear = false })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = augroup_organize_imports,
--   pattern = "*.go",
--   callback = function()
--     organize_imports_sync()
--   end,
-- })

-- BufWritePre
local augroup_code_action_format = vim.api.nvim_create_augroup("LspCodeActionFormat", { clear = false })
local code_action_kinds = {
  "quickfix",
  "refactor",
  "refactor.extract",
  "refactor.inline",
  "refactor.rewrite",
  "source",
  "source.organizeImports",
  "source.fixAll",
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup_code_action_format,
  pattern = {
    "*.go",
  },
  callback = function(e)
    if string.find(tostring(vim.uv.fs_realpath(vim.api.nvim_buf_get_name(e.buf))), "bytedance/sonic") then -- ignore bytedance/sonic
      return
    end

    ---@type vim.lsp.buf.code_action.Opts
    local params = vim.lsp.util.make_range_params(vim.api.nvim_get_current_win(), "utf-16")
    params.context = {
      diagnostics = {},
      only = { "source.organizeImports" },
      triggerKind = 2,
    }

    ---@type table<integer, {error: lsp.ResponseError?, result: any}>?
    local result = vim.lsp.buf_request_sync(e.buf, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end

    --- @type vim.lsp.buf.format.Opts
    local opts = {
      async = false,
      -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#formattingOptions
      formatting_options = {
        tabSize = 1,
        insertSpaces = false,
        trimTrailingWhitespace = true,
        insertFinalNewline = true,
        trimFinalNewlines = true,
      },
    }
    vim.lsp.buf.format(opts)
  end,
})

-- FocusGained
-- github.com/vovkasm/input-source-switcher
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    if vim.fn.executable("issw") then
      vim.fn.jobstart("issw com.apple.keylayout.ABC", { detach = true })
    end
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

-- TermOpen
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = autocmd_user,
  callback = function()
    vim.opt_local.number = false
    vim.cmd.startinsert()
  end,
})

---Lanuage
-- Go
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "go.mod",
  callback = function(e)
    vim.api.nvim_buf_create_user_command(e.buf, "GomodPinReplace",
      function()
        vim.cmd("'<,'>s/^\\t\\(.*\\)\\s\\(.*\\)/\\t\\1 => \\1 \\2/g | nohlsearch")
      end,
      {
        range = true,
        desc = "substitutes gomod replace packages",
      }
    )
    vim.api.nvim_buf_create_user_command(e.buf, "GomodLatest",
      function()
        vim.cmd("'<,'>s/ v[a-z0-9.\\+-]*/ latest/g | nohlsearch")
      end,
      {
        range = true,
        desc = "substitutes module version to latest",
      }
    )
  end,
})

-- kitty
local kitty_group = vim.api.nvim_create_augroup("Kitty", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = kitty_group,
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
  end,
})
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = kitty_group,
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
  end,
})

local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        require("snacks").rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "BlinkCmpMenuOpen",
--   callback = function()
--     vim.b.copilot_suggestion_hidden = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "BlinkCmpMenuClose",
--   callback = function()
--     vim.b.copilot_suggestion_hidden = false
--   end,
-- })

-- Debug:
-- vim.api.nvim_create_autocmd(
--   {
--     "BufReadPre",
--     "BufReadPost",
--     "BufWinEnter",
--   },
--   {
--     group = autocmd_user,
--     pattern = { "*" },
--     callback = function(args)
--       local ev = vim.inspect("event: " .. args.event)
--       vim.cmd.echomsg(ev)
--     end,
--   }
-- )
