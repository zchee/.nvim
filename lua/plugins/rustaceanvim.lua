-- Loaded from the rustaceanvim spec's `init` in lua/plugins/init.lua, so it
-- runs before rustaceanvim's own ftplugin reads `vim.g.rustaceanvim`.

-- Keymaps live on LspAttach rather than in `server.on_attach`: rustaceanvim
-- merges `vim.lsp.config["rust-analyzer"]` over its own `server` table with
-- "force", so the global `vim.lsp.config("*")` on_attach set in lua/lsp/init.lua
-- would silently replace ours.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("rustaceanvim_keymaps", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "rust-analyzer" then
      return
    end

    local kopts = { silent = true, buffer = args.buf }
    local map = vim.keymap.set

    map("n", "<Leader>ra", function()
      vim.cmd.RustLsp("codeAction")
    end, vim.tbl_extend("force", kopts, { desc = "Rust code action" }))
    map("n", "<Leader>rd", function()
      vim.cmd.RustLsp("debuggables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust debuggables" }))
    map("n", "<Leader>rr", function()
      vim.cmd.RustLsp("runnables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust runnables" }))
    map("n", "<Leader>rR", function()
      vim.cmd.RustLsp({ "runnables", bang = true })
    end, vim.tbl_extend("force", kopts, { desc = "Rerun last runnable" }))
    map("n", "<Leader>rt", function()
      vim.cmd.RustLsp("testables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust testables" }))
    map("n", "<Leader>rT", function()
      vim.cmd.RustLsp({ "testables", bang = true })
    end, vim.tbl_extend("force", kopts, { desc = "Rerun last test" }))
    map("n", "<Leader>rm", function()
      vim.cmd.RustLsp("expandMacro")
    end, vim.tbl_extend("force", kopts, { desc = "Expand macro" }))
    map("n", "<Leader>rc", function()
      vim.cmd.RustLsp("openCargo")
    end, vim.tbl_extend("force", kopts, { desc = "Open Cargo.toml" }))
    map("n", "<Leader>rp", function()
      vim.cmd.RustLsp("parentModule")
    end, vim.tbl_extend("force", kopts, { desc = "Parent module" }))
    map("n", "<Leader>rj", function()
      vim.cmd.RustLsp("joinLines")
    end, vim.tbl_extend("force", kopts, { desc = "Join lines" }))
    map("n", "<Leader>rs", function()
      vim.cmd.RustLsp("ssr")
    end, vim.tbl_extend("force", kopts, { desc = "Structural search replace" }))
    map("n", "<Leader>re", function()
      vim.cmd.RustLsp("explainError")
    end, vim.tbl_extend("force", kopts, { desc = "Explain error" }))
    map("n", "<Leader>rD", function()
      vim.cmd.RustLsp("renderDiagnostic")
    end, vim.tbl_extend("force", kopts, { desc = "Render diagnostic" }))
    map("n", "<Leader>rv", function()
      vim.cmd.RustLsp({ "view", "hir" })
    end, vim.tbl_extend("force", kopts, { desc = "View HIR" }))
    map("n", "<Leader>rV", function()
      vim.cmd.RustLsp({ "view", "mir" })
    end, vim.tbl_extend("force", kopts, { desc = "View MIR" }))
    map("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, vim.tbl_extend("force", kopts, { desc = "Rust hover actions" }))
  end,
})

---@class rustaceanvim.Opts
local opts = {}
opts.tools = {
  -- auto_focus is what makes `K` jump the cursor into the hover window
  -- (hover_actions.lua calls nvim_set_current_win only when it is set). Left
  -- at the upstream default so the cursor stays in the buffer; the float is
  -- still focusable, so a second `K` enters it to pick an action -- that is
  -- vim.lsp.util.open_floating_preview's focus_id path, not rustaceanvim's.
  float_win_config = { border = "rounded", auto_focus = false },
  code_actions = { ui_select_fallback = true },
  rustc = { default_edition = "2024" },
}
opts.server = {}
-- Resolve rust-analyzer through rustup, not PATH: mason.nvim prepends its
-- bin dir, so a bare "rust-analyzer" picks up Mason's stale standalone
-- binary, which cannot load nightly-toolchain crate graphs (E0432
-- "unresolved import" on every external crate).
local rustup_cmd = { "rustup", "run", "nightly", "rust-analyzer" }

-- rust-analyzer holds its whole index in memory and has no on-disk cache,
-- so every nvim restart re-pays it (~4.5s on ganja-code once the
-- build-script cache is warm). github.com/zchee/lspmux keeps one
-- rust-analyzer per workspace alive between editor sessions. This is NOT
-- the upstream lspmux 0.3 multiplexer that broke lsp_definitions: the
-- rewrite allows a single active client per instance and hands documents
-- and in-flight requests over explicitly on reconnect, and its test suite
-- pins exactly the two-sessions-then-definition regression that killed
-- the old proxy.
--
-- Anything that fails -- no lspmux, no rustup, daemon refuses to start --
-- falls back to spawning rust-analyzer directly, because a slow LSP beats
-- no LSP. RUSTACEANVIM_NO_LSPMUX=1 bypasses the daemon for bisecting.
---@return string[]
local function rust_analyzer_cmd()
  if vim.env.RUSTACEANVIM_NO_LSPMUX then
    return rustup_cmd
  end
  local lspmux = vim.fn.exepath("lspmux")
  if lspmux == "" then
    return rustup_cmd
  end
  local which = vim.system({ "rustup", "which", "--toolchain", "nightly", "rust-analyzer" }):wait()
  local server_path = vim.trim(which.stdout or "")
  if which.code ~= 0 or server_path == "" then
    return rustup_cmd
  end
  -- `status` exits non-zero when no daemon is listening; detach one in
  -- that case so no launchd unit is needed. The daemon resolves its own
  -- socket path (it knows about the broken-XDG_RUNTIME_DIR trap).
  if vim.system({ lspmux, "status" }):wait().code ~= 0 then
    local log_file = vim.fs.joinpath(vim.fn.stdpath("log"), "lspmux.log")
    vim.system({ lspmux, "server", "--log-file", log_file }, { detach = true })
    vim.wait(2000, function()
      return vim.system({ lspmux, "status" }):wait().code == 0
    end, 100)
    if vim.system({ lspmux, "status" }):wait().code ~= 0 then
      return rustup_cmd
    end
  end
  return { lspmux, "client", "--server-path", server_path }
end

-- Passed as a function, not its result: this module is required from the
-- spec's `init`, which lazy.nvim runs on every startup, and rustaceanvim
-- evaluates server.cmd only when it actually starts the server. Calling
-- it here would put subprocess probes on every session's startup path,
-- Rust or not; re-evaluating per start also respawns a died daemon.
opts.server.cmd = rust_analyzer_cmd

-- rust-analyzer compiles every build script and proc macro itself before it
-- can expand macros, and it inherits this shell's RUSTFLAGS. The release
-- tuning in there (lto=fat, opt-level=3, codegen-units=1, mir-opt-level=4,
-- ...) buys nothing for analysis but dominates a cold start: measured on
-- ganja-code with an empty target dir, the build phase took 39.1s with the
-- full flags versus 8.1s with only target-cpu. Those artifacts are never
-- linked into a real binary -- they live in cargo.extraEnv's own target dir
-- and exist purely to be run at expansion time.
--
-- Only the flags that change cfg evaluation are kept: crates gated on
-- target_feature (gxhash needs aes) mis-analyze or fail to build without the
-- matching target-cpu/target-feature. Parsing rather than hardcoding keeps
-- this correct when .zprofile's RUSTFLAGS change.
---@return string
local function analysis_rustflags()
  local tokens = vim.split(os.getenv("RUSTFLAGS") or "", "%s+", { trimempty = true })
  local kept = {}
  local i = 1
  while i <= #tokens do
    local token = tokens[i]
    -- "-C target-cpu=native" (two tokens) and "-Ctarget-cpu=native" (one)
    local value = (token == "-C" or token == "-Z") and tokens[i + 1] or token:match("^%-[CZ](.+)$")
    local width = (token == "-C" or token == "-Z") and 2 or 1
    if value and (vim.startswith(value, "target-cpu=") or vim.startswith(value, "target-feature=")) then
      vim.list_extend(kept, vim.list_slice(tokens, i, i + width - 1))
    end
    i = i + width
  end
  return table.concat(kept, " ")
end
opts.server.default_settings = {
  ["rust-analyzer"] = {
    cargo = {
      features = "all",
      allTargets = false,
      buildScripts = {
        enable = true,
        invocationStrategy = "once",
      },
      extraEnv = {
        RUSTFLAGS = analysis_rustflags(),
        CARGO_TARGET_DIR = "target/rust-analyzer",
        SKIP_WASM_BUILD = "1",
      },
    },
    check = {
      command = "clippy",
      extraArgs = { "--all", "--", "-W", "clippy::all" },
      extraEnv = {
        CC = "clang",
        CXX = "clang++",
        VIRTUAL_ENV = vim.fn.getcwd() .. "/.venv",
      },
    },
    procMacro = {
      enable = true,
      attributes = { enable = true },
    },
    checkOnSave = true,
    diagnostics = {
      enable = true,
      experimental = { enable = true },
      styleLints = { enable = true },
    },
    inlayHints = {
      chainingHints = { enable = true },
      typeHints = { enable = true, hideClosureInitialization = true },
      parameterHints = { enable = true },
      closureReturnTypeHints = { enable = "with_block" },
      lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
      maxLength = 25,
      bindingModeHints = { enable = true },
      closureCaptureHints = { enable = true },
      discriminantHints = { enable = "fieldless" },
      expressionAdjustmentHints = { enable = "reborrow" },
      rangeExclusiveHints = { enable = true },
    },
    completion = {
      autoimport = { enable = true },
      postfix = { enable = true },
      callable = { snippets = "fill_arguments" },
      fullFunctionSignatures = { enable = true },
      privateEditable = { enable = true },
      hideDeprecated = true,
    },
    imports = {
      granularity = { group = "module" },
      prefix = "self",
      preferNoStd = false,
    },
    lens = {
      enable = true,
      references = {
        adt = { enable = true },
        enumVariant = { enable = true },
        method = { enable = true },
        trait = { enable = true },
      },
      implementations = { enable = true },
      run = { enable = true },
      debug = { enable = true },
    },
    semanticHighlighting = {
      operator = {
        specialization = { enable = true },
      },
      punctuation = {
        enable = true,
        specialization = { enable = true },
      },
      strings = { enable = true },
    },
    hover = {
      actions = {
        enable = true,
        references = { enable = true },
        run = { enable = true },
        debug = { enable = true },
        gotoTypeDef = { enable = true },
        implementations = { enable = true },
      },
      documentation = {
        enable = true,
        keywords = { enable = true },
      },
      links = { enable = true },
    },
    workspace = {
      symbol = {
        search = { kind = "all_symbols" },
      },
    },
    files = {
      exclude = { ".git", "node_modules", ".direnv", "target/debug/build", "target/release/build" },
    },
  },
}
opts.dap = { autoload_configurations = true }
vim.g.rustaceanvim = opts
