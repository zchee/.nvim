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

    map("n", "<leader>ra", function()
      vim.cmd.RustLsp("codeAction")
    end, vim.tbl_extend("force", kopts, { desc = "Rust code action" }))
    map("n", "<leader>rd", function()
      vim.cmd.RustLsp("debuggables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust debuggables" }))
    map("n", "<leader>rr", function()
      vim.cmd.RustLsp("runnables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust runnables" }))
    map("n", "<leader>rR", function()
      vim.cmd.RustLsp({ "runnables", bang = true })
    end, vim.tbl_extend("force", kopts, { desc = "Rerun last runnable" }))
    map("n", "<leader>rt", function()
      vim.cmd.RustLsp("testables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust testables" }))
    map("n", "<leader>rT", function()
      vim.cmd.RustLsp({ "testables", bang = true })
    end, vim.tbl_extend("force", kopts, { desc = "Rerun last test" }))
    map("n", "<leader>rm", function()
      vim.cmd.RustLsp("expandMacro")
    end, vim.tbl_extend("force", kopts, { desc = "Expand macro" }))
    map("n", "<leader>rc", function()
      vim.cmd.RustLsp("openCargo")
    end, vim.tbl_extend("force", kopts, { desc = "Open Cargo.toml" }))
    map("n", "<leader>rp", function()
      vim.cmd.RustLsp("parentModule")
    end, vim.tbl_extend("force", kopts, { desc = "Parent module" }))
    map("n", "<leader>rj", function()
      vim.cmd.RustLsp("joinLines")
    end, vim.tbl_extend("force", kopts, { desc = "Join lines" }))
    map("n", "<leader>rs", function()
      vim.cmd.RustLsp("ssr")
    end, vim.tbl_extend("force", kopts, { desc = "Structural search replace" }))
    map("n", "<leader>re", function()
      vim.cmd.RustLsp("explainError")
    end, vim.tbl_extend("force", kopts, { desc = "Explain error" }))
    map("n", "<leader>rD", function()
      vim.cmd.RustLsp("renderDiagnostic")
    end, vim.tbl_extend("force", kopts, { desc = "Render diagnostic" }))
    map("n", "<leader>rv", function()
      vim.cmd.RustLsp({ "view", "hir" })
    end, vim.tbl_extend("force", kopts, { desc = "View HIR" }))
    map("n", "<leader>rV", function()
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

-- rust-analyzer holds its whole index in memory and has no on-disk cache, so
-- every nvim restart re-pays it (~3.9s on ganja-code once the build-script
-- cache is warm). lspmux keeps one rust-analyzer per workspace alive between
-- editor sessions and hands the already-indexed instance to the next client
-- -- the same trick lua/lsp/gopls.lua uses with `-remote=unix;`. Only
-- rust-analyzer is routed through it; every other server in lua/lsp keeps its
-- own direct cmd.
--
-- lspmux needs a single executable path, so the toolchain is resolved here
-- instead of wrapping the rustup shim. Anything that fails -- no lspmux, no
-- rustup, daemon refuses to start -- falls back to spawning rust-analyzer
-- directly, because a slow LSP beats no LSP.
---@return string[]
local function rust_analyzer_cmd()
  -- Escape hatch: RUSTACEANVIM_NO_LSPMUX=1 nvim ... spawns rust-analyzer
  -- directly, for comparing against the shared instance or for bisecting a
  -- problem that might be the proxy's fault.
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
  -- `status` exits non-zero when nothing is listening on lspmux's socket;
  -- detach a daemon in that case so no launchd/systemd unit is needed.
  if vim.system({ lspmux, "status" }):wait().code ~= 0 then
    vim.system({ lspmux, "server" }, { detach = true })
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
-- evaluates server.cmd only when it actually starts the server
-- (config/internal.lua's types.evaluate). Calling it here would put a
-- `rustup which` plus an `lspmux status` subprocess on the startup path of
-- every nvim session, Rust or not. Re-evaluating per start is also what
-- restarts the daemon if it died between sessions.
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
      exclude = { ".git", "node_modules", ".direnv", "target/debug/build" },
    },
  },
}
opts.dap = { autoload_configurations = true }
vim.g.rustaceanvim = opts
