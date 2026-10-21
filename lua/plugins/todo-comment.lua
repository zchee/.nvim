local opts = {
  signs = false, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "todo" },
    Deprecated = { icon = " ", color = "warning" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  gui_style = {
    fg = "NONE", -- The gui style to use for the fg highlight group.
    bg = "BOLD", -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    -- The legacy Vim syntax under this plugin already paints the bare keyword
    -- as Todo (#ffcc00) -- tmuxTodo, shTodo and friends -- so the default
    -- 200 ms coalescing window is 200 ms of the WRONG colour on every newly
    -- exposed range before TodoFg<KW> lands on top. The work it coalesces is
    -- 0.001 ms with nothing dirty, 0.002 ms for one new line and 0.33 ms for
    -- a whole cold 20-line viewport, so there is nothing worth batching.
    throttle = 0,
    multiline = true, -- enable multine todo comments
    multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = "", -- "fg" or "bg" or empty
    keyword = "wide_fg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "", -- "fg" or "bg" or empty
    pattern = {
      [[.*<(KEYWORDS):]],
      [[.*<(KEYWORDS)\(.*\):]],
      [[.*<(KEYWORDS)(\([^\)]*\)):]], -- include author name, default: [[.*<(KEYWORDS)\s*:]]
    },
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of highlight groups or use the hex color if hl not found as a fallback
  colors = {
    todo = { "Todo" },
    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
    info = { "#FBBF24", "DiagnosticInfo", "#2563EB" },
    hint = { "DiagnosticHint", "#10B981", "#10B981" },
    default = { "Identifier", "#7C3AED" },
    test = { "Identifier", "#FF00FF" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS)(\([^\)]*\))?\b:]], -- default: [[\b(KEYWORDS):]]
  },
}

-- todo-comments' setup probes `pcall(require, "snacks.picker")` to
-- register its picker source, which loads the ~3.4 ms picker tree
-- that startup otherwise leaves out. An erroring preload stub
-- makes that probe fail fast while it is armed; a picker some other
-- caller already loaded short-circuits through package.loaded, so
-- only todo-as-loader is blocked and the registration still happens
-- whenever the picker is genuinely in. setup() defers its real work
-- past VimEnter, so the disarm mirrors that scheduling to run after.
local function arm()
  package.preload["snacks.picker"] = function()
    error("snacks.picker load deferred during todo-comments setup (lua/plugins/todo-comment.lua)")
  end
end
local function disarm()
  package.preload["snacks.picker"] = nil
  -- a failed require leaves a sentinel in package.loaded that turns
  -- every later require into "loop or previous error"; on this
  -- LuaJIT it is a NaN-boxed lightuserdata whose type() reads
  -- "number", so match anything that is not the module's real table
  local sentinel = package.loaded["snacks.picker"]
  if sentinel ~= nil and type(sentinel) ~= "table" then
    package.loaded["snacks.picker"] = nil
  end
end
arm()
local ok, err = pcall(function()
  require("todo-comments").setup(opts)
end)
if vim.api.nvim_get_vvar("vim_did_enter") == 0 then
  vim.defer_fn(disarm, 0)
else
  disarm()
end
if not ok then
  error(err)
end
-- highlight.start() registers the current window in its own `wins`
-- table, and attach() only repaints when the window is new to it --
-- so a file opened into a window that is already known never gets a
-- repaint and keeps whatever the legacy syntax painted (Todo,
-- #ffcc00, where TodoFg<KW> belongs). Drive the repaint from the
-- events that expose a new range instead, and call _update directly
-- rather than update(): the latter hops through a uv timer and
-- vim.schedule, so the paint lands a frame or more after the event
-- that revealed the text. A cold full viewport costs 0.33 ms and a
-- warm one 0.001 ms, both off any keystroke path. VimEnter is
-- deliberately not in this list -- it runs before the buffer's syntax
-- is applied, and comments_only would reject every keyword and mark
-- the lines clean.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinResized" }, {
  group = vim.api.nvim_create_augroup("todo_comments_repaint", { clear = true }),
  callback = function()
    local loaded, hl = pcall(require, "todo-comments.highlight")
    if not (loaded and hl.enabled) then
      return
    end
    -- This autocmd is created before highlight.start() (setup defers
    -- that past VimEnter) and so runs ahead of the plugin's own
    -- BufWinEnter attach: _update walks only buffers attach() has
    -- registered, and a buffer newly opened into a known window was
    -- not one yet, so it never painted. attach() is idempotent.
    hl.attach()
    if type(hl._update) == "function" then
      hl._update()
    else
      hl.update()
    end
  end,
})
