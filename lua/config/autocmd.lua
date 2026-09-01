local util = require("util")

local M = {}

local autocmd_user = vim.api.nvim_create_augroup("AutocmdUser", { clear = false })

-- 'path' is a global option: FileType fires per buffer, so unguarded appends
-- grow it with duplicate entries for the life of the session.
local path_appended = {}
local function append_path_once(dir)
  if not path_appended[dir] then
    path_appended[dir] = true
    vim.opt.path:append(dir)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = "go",
  callback = function()
    append_path_once("/usr/local/go/pkg/include")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    if vim.fn.isdirectory("/usr/local/Frameworks/Python.framework/Headers") == 1 then
      append_path_once("/usr/local/Frameworks/Python.framework/Headers")
    end
  end,
})

-- FileType
vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = {
    "help",
    "man",
    "qf",
    "quickrun",
    "ref",
    "startuptime",
  },
  callback = function()
    vim.opt_local.colorcolumn = ""

    vim.keymap.set("n", "u", "<C-u>", { buffer = true, silent = true })
    vim.keymap.set("n", "d", "<C-d>", { buffer = true, silent = true })
    vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true, silent = true })
  end,
})

--- macOS
if vim.fn.has("mac") == 1 then
  vim.opt.wildignore:append("DS_Store") -- macOS only

  local macos_headers_added = false
  local path_add_macos_headers = function()
    if macos_headers_added then
      return
    end
    macos_headers_added = true

    local developer_dir = "/Applications/Xcode.app/Contents/Developer" -- vim.fn.system("xcode-select -p")
    local sdk_dir = vim.fs.joinpath(developer_dir, "/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
    local toolchain_dir = vim.fs.joinpath(developer_dir, "/Toolchains/XcodeDefault.xctoolchain")

    vim.opt.path:append(vim.fs.joinpath(util.homebrew_prefix(), "include"))
    vim.opt.path:append("/usr/local/include")
    vim.opt.path:append(vim.fs.joinpath(sdk_dir, "/usr/include"))
    vim.opt.path:append(vim.fs.joinpath(toolchain_dir .. "/usr/include/c++/v1"))
    vim.opt.path:append(vim.fs.joinpath(toolchain_dir .. "/usr/include/swift"))
    vim.opt.path:append("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include")
    vim.opt.path:append(vim.fs.joinpath(toolchain_dir .. "/usr/lib/clang/**/include"))

    -- macOS frameworks
    local frameworks_dir = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), "/path/Frameworks")
    if vim.fn.isdirectory(frameworks_dir) == 1 then
      vim.opt.path:append(frameworks_dir)
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = autocmd_user,
    pattern = { "c", "cpp", "objc", "objcpp", "go" },
    callback = path_add_macos_headers,
  })
end
-- C familly
vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = { "c", "cpp", "objc", "objcpp", "go" },
  callback = function()
    if vim.fn.isdirectory(vim.fs.joinpath(util.homebrew_prefix(), "Frameworks/Python.framework/Headers")) == 1 then
      append_path_once(vim.fs.joinpath(util.homebrew_prefix(), "Frameworks/Python.framework/Headers"))
    end
  end,
})
--- Go
vim.api.nvim_create_autocmd("FileType", {
  group = autocmd_user,
  pattern = { "go" },
  callback = function()
    append_path_once(vim.fs.joinpath(util.prefix(), "go/pkg/include"))
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

-- BufWinEnter: jump to the last cursor position (the `"` mark) when it still
-- fits inside the buffer, like the old `g`\"zt` normal-mode dance but through
-- the API (no jumplist entry, mark read directly).
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = autocmd_user,
  pattern = "*",
  callback = function(args)
    --[[ NOTE(zchee): ignore gitcommit filetype ]]
    local ft = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
    if ft == "gitcommit" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      if pcall(vim.api.nvim_win_set_cursor, 0, mark) then
        vim.cmd("keepjumps normal! zt")
      end
    end
  end,
})

-- WinEnter
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    -- http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
    local only_one_window = #vim.api.nvim_tabpage_list_wins(0) == 1
    if only_one_window then
      local is_ft = function(ft)
        return vim.o.filetype == ft
      end

      local tabnr = vim.api.nvim_tabpage_get_number(0)
      local is_nvimtree = vim.fs.basename(vim.api.nvim_buf_get_name(0)) == "NvimTree_" .. tabnr
      if is_nvimtree or is_ft("qt") or is_ft("git") or is_ft("vista_kind") then
        vim.cmd("quit")
      end
    end
  end,
})

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = autocmd_lsp_format,
--   pattern = {
--     "*.lua",
--     -- "*.ts",
--   },
--   callback = function(args)
--     local file = vim.fs.abspath(args.file)
--     if string.find(file, "neovim/neovim") then
--       return
--     end
--
--     vim.lsp.buf.format({
--       async = false,
--       trimTrailingWhitespace = true,
--       insertFinalNewline = true,
--       trimFinalNewlines = true,
--     })
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = autocmd_lsp_format,
--   pattern = {
--     "*.tf",
--     "*.tfvars",
--   },
--   callback = function()
--     vim.lsp.buf.format({
--       async = true,
--       trimTrailingWhitespace = true,
--       insertFinalNewline = true,
--       trimFinalNewlines = true,
--     })
--   end,
-- })

---@class PrioritySemanticTokens
---@field hl_group string semantic tokens hl group name
---@field opts { priority: integer } highlight_token opts (priority precomputed)

-- LspTokenUpdate fires once per semantic token: keyed by token type so
-- non-matching tokens (the overwhelming majority) return after one hash
-- lookup with zero iteration and zero allocation.
---@type table<string, PrioritySemanticTokens>
local priority_semantic_tokens = {
  class = { hl_group = "@lsp.type.class.python", opts = { priority = 200 } },
}

vim.api.nvim_create_autocmd("LspTokenUpdate", {
  group = autocmd_user,
  callback = function(args)
    --- @type SemanticToken
    local token = args.data.token
    local t = priority_semantic_tokens[token.type]
    if not t then
      return
    end

    vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, t.hl_group, t.opts)
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
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = autocmd_lsp_format,
--   pattern = {
--     -- "*.lua",
--     "*.zig",
--   },
--   callback = function(args)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = args.buf,
--       callback = function()
--         vim.lsp.buf.format({
--           async = false,
--           trimTrailingWhitespace = true,
--           insertFinalNewline = true,
--           trimFinalNewlines = true,
--           id = args.data.client_id,
--         })
--       end,
--     })
--   end,
-- })

-- Write-time formatting lives entirely in conform.nvim (lua/plugins/conform.lua),
-- whose BufWritePre autocmd runs last on every buffer. Two hand-rolled
-- BufWritePre groups used to sit in front of it and were removed:
--
--   LspFormat            filtered on client.name == "null-ls", so it stopped
--                        doing anything the moment none-ls was retired.
--   LspCodeActionFormat  ran gopls source.organizeImports plus a second
--                        vim.lsp.buf.format() for *.go/*.toml -- the format
--                        pass duplicated conform's go lsp_format = "first",
--                        and its formatting_options (tabSize = 1,
--                        insertSpaces = false) contradicted the tombi indent
--                        settings for TOML.
--
-- Trade-off accepted with the removal: goimports-rereviser does not add
-- imports for unresolved identifiers (verified), so saving no longer pulls in
-- a missing import the way gopls organizeImports did. Use the LSP code action
-- on demand for that.

-- FocusGained
-- github.com/zchee/imectl
--
-- vim.fn.executable() returns 0/1 and 0 is truthy in Lua, so the guard used
-- to pass with imectl absent and spawned a failing process on every focus
-- gain. Probe once (lazily, on the first FocusGained) and cache the verdict.
-- The deps are injected so specs can drive the truth table without a real
-- binary; production passes the live vim.fn functions.
---@param executable fun(name: string): 0|1
---@param jobstart fun(cmd: string, opts: table): integer
---@return fun() callback FocusGained callback with a probe-once imectl cache
function M.make_imectl_callback(executable, jobstart)
  local has_imectl ---@type boolean?
  local jobstart_opts = { detach = true }
  return function()
    if has_imectl == nil then
      has_imectl = executable("imectl") == 1
    end
    if has_imectl then
      jobstart("imectl set com.apple.keylayout.ABC", jobstart_opts)
    end
  end
end

vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = M.make_imectl_callback(vim.fn.executable, vim.fn.jobstart),
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
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = autocmd_user,
  pattern = "go.mod",
  callback = function(e)
    if vim.b[e.buf].gomod_user_commands then
      return
    end
    vim.b[e.buf].gomod_user_commands = true

    vim.api.nvim_buf_create_user_command(e.buf, "GomodPinReplace", function()
      vim.cmd("'<,'>s/^\\t\\(.*\\)\\s\\(.*\\)/\\t\\1 => \\1 \\2/g | nohlsearch")
    end, {
      range = true,
      desc = "substitutes gomod replace packages",
    })
    vim.api.nvim_buf_create_user_command(e.buf, "GomodLatest", function()
      vim.cmd("'<,'>s/ v[a-z0-9.\\+-]*/ latest/g | nohlsearch")
    end, {
      range = true,
      desc = "substitutes module version to latest",
    })
  end,
})

-- kitty
-- https://sw.kovidgoyal.net/kitty/mapping/#conditional-mappings-depending-on-the-state-of-the-focused-window
-- vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
--   group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
--   callback = function(args)
--     if "snacks_picker_input" == vim.api.nvim_get_option_value("filetype", { buf = args.buf }) then
--       return
--     end
--
--     if vim.api.nvim_ui_send then
--       vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQ==\007")
--     else
--       io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQ==\007")
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
--   group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
--   callback = function(args)
--     if "snacks_picker_input" == vim.api.nvim_get_option_value("filetype", { buf = args.buf }) then
--       return
--     end
--
--     if vim.api.nvim_ui_send then
--       vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor\007")
--     else
--       io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
--     end
--   end,
-- })

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

-- Auto :nohlsearch, replacing the abandoned nvimdev/hlsearch.nvim: search
-- highlighting turns on only for search-related keys and clears as soon as
-- any other normal-mode key is pressed. <C-q> (keymap.lua) still force-clears.
-- Only PHYSICALLY typed keys may toggle (`typed` is empty for keys produced
-- by mapping expansion) -- reacting to mapped keys turned the highlight off
-- mid-expansion of vim-asterisk's <Plug>(asterisk-gz*) and friends.
-- The handler runs on EVERY physical keystroke: the key set is hoisted to a
-- module-scope hash keyed by the raw typed bytes (vim.keycode precomputes the
-- <CR> byte, replacing the per-key vim.fn.keytrans call), the mode check is
-- nvim_get_mode (API, not the vim.fn VimL bridge) compared by first byte
-- (0x6e == "n"; vim.fn.mode() without an arg also reported only the first
-- letter, so "no"/"niI" keep counting as normal mode), and no table is
-- allocated per call.
-- NOTE: <CR> must NOT be in this set. A cmdline search confirm arrives in
-- mode "c" (the guard below returns early), so a <CR> entry only ever
-- matched NORMAL-mode <CR> -- the "open file" key in neo-tree/quickfix/help
-- -- turning stale shada highlights on with every buffer opened that way.
local hlsearch_keys = {
  ["n"] = true,
  ["N"] = true,
  ["*"] = true,
  ["#"] = true,
  ["/"] = true,
  ["?"] = true,
}

---on_key callback for auto hlsearch; exposed for the allocation-free spec.
---@param typed string the physically typed key ("" for mapping expansion)
function M.auto_hlsearch_on_key(_, typed)
  if typed == "" or vim.api.nvim_get_mode().mode:byte(1) ~= 0x6e then
    return
  end
  local searching = hlsearch_keys[typed] or false
  if searching ~= vim.o.hlsearch then
    vim.o.hlsearch = searching
  end
end

vim.on_key(M.auto_hlsearch_on_key, vim.api.nvim_create_namespace("auto_hlsearch"))

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

return M
