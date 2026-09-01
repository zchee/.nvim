-- Hand-rolled statusline + tabline replacing lualine.nvim and
-- bufferline.nvim (round-3 W3.2). Parity contract:
-- .omc/plans/round3-chrome-parity.md. Palette copied verbatim from the
-- retired lua/lualine/themes/equinusocio_material.lua theme table.
--
-- Redraw path (statusline()/tabline()) uses nvim_* API + table.concat only;
-- everything slow (diagnostics, newfile stat) is cached event-driven.

local api = vim.api

local M = {}

local palette = {
  black = "#000000",
  green = "#c3e88d",
  white = "#eeffff",
  gray = "#545454",
  darkgray = "#2f2f2f",
  cyan = "#89ddff",
  red = "#ff5370",
  yellow = "#ffcb6b",
}

local TAB_SIZE = 18 -- bufferline tab_size + enforce_regular_tabs
local MAX_PREFIX = 15 -- bufferline max_prefix_length (dedup)

local mode_word = {
  n = "NORMAL",
  no = "O-PENDING",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  R = "REPLACE",
  c = "COMMAND",
  t = "TERMINAL",
  ["!"] = "SHELL",
  r = "PROMPT",
}
local mode_hl = {
  i = "ChromeAInsert",
  R = "ChromeAReplace",
  v = "ChromeAVisual",
  V = "ChromeAVisual",
  ["\22"] = "ChromeAVisual",
  s = "ChromeAVisual",
  S = "ChromeAVisual",
  ["\19"] = "ChromeAVisual",
}

-- statusline diagnostics: lualine default icons; tabline: bufferline's
-- custom indicator (icon only on error level).
local sev_stl = {
  { "ChromeDiagError", " " },
  { "ChromeDiagWarn", " " },
  { "ChromeDiagInfo", " " },
  { "ChromeDiagHint", "󰌶 " },
}

local order = {} -- tabline buffer order (insert_after_current)
local diag_counts = {} -- bufnr -> vim.diagnostic.count() table
local diag_dirty = {} -- deferred while in insert mode
local newfile = {} -- bufnr -> true for BufNewFile until first write
local modstate = {} -- bufnr -> last seen 'modified' (redraw on transition)
local home = vim.env.HOME

-- filetype devicons (lualine icons_enabled parity). The provider is
-- nvim-web-devicons -- the same one lualine used, so the glyph family
-- matches (mini.icons draws a different md-style set). Resolution checks
-- lazy's plugin state, never package.loaded via require: a bare require
-- would trip lazy's module autoloader inside the first statusline draw.
-- Before the plugin loads (setup() schedules it shortly after UIEnter),
-- entries render without an icon and the next redraw picks them up.
-- Cache holds the full "%#group#icon " prefix per (filetype, section-bg).
local icon_cache = {}

local function icon_provider()
  local lz = package.loaded["lazy.core.config"]
  local plugin = lz and lz.plugins["nvim-web-devicons"]
  if not (plugin and plugin._ and plugin._.loaded) then
    return nil
  end
  local ok, devicons = pcall(require, "nvim-web-devicons")
  return ok and devicons or nil
end

local function ft_icon(ft, on_dark)
  local devicons = icon_provider()
  if not devicons then
    return ""
  end
  local key = ft .. (on_dark and "\1" or "\2")
  local hit = icon_cache[key]
  if hit ~= nil then
    return hit
  end
  local ok, icon, color = pcall(devicons.get_icon_color_by_filetype, ft, { default = true })
  if not ok or not icon then
    icon_cache[key] = ""
    return ""
  end
  local group = "ChromeIcon" .. (on_dark and "X" or "B") .. ft:gsub("%W", "_")
  api.nvim_set_hl(0, group, { fg = color, bg = on_dark and palette.darkgray or palette.gray })
  local pre = "%#" .. group .. "#" .. icon .. " "
  icon_cache[key] = pre
  return pre
end

local function esc(s)
  return (s:gsub("%%", "%%%%"))
end

local function fg_of(name, fallback)
  local hl = api.nvim_get_hl(0, { name = name, link = false })
  return hl.fg or fallback
end

local function define_highlights()
  local set = api.nvim_set_hl
  set(0, "ChromeANormal", { fg = palette.black, bg = palette.green, bold = true })
  set(0, "ChromeAInsert", { fg = palette.darkgray, bg = palette.cyan, bold = true })
  set(0, "ChromeAVisual", { fg = palette.black, bg = palette.yellow, bold = true })
  set(0, "ChromeAReplace", { fg = palette.black, bg = palette.red, bold = true })
  set(0, "ChromeB", { fg = palette.white, bg = palette.gray })
  set(0, "ChromeBBold", { fg = palette.white, bg = palette.gray, bold = true })
  set(0, "ChromeC", { fg = palette.white, bg = palette.darkgray })
  set(0, "ChromeDiffAdd", { fg = palette.green, bg = palette.gray })
  set(0, "ChromeDiffChange", { fg = palette.yellow, bg = palette.gray })
  set(0, "ChromeDiffDelete", { fg = palette.red, bg = palette.gray })
  set(0, "ChromeDiagError", { fg = fg_of("DiagnosticError", palette.red), bg = palette.gray })
  set(0, "ChromeDiagWarn", { fg = fg_of("DiagnosticWarn", palette.yellow), bg = palette.gray })
  set(0, "ChromeDiagInfo", { fg = fg_of("DiagnosticInfo", palette.cyan), bg = palette.gray })
  set(0, "ChromeDiagHint", { fg = fg_of("DiagnosticHint", palette.white), bg = palette.gray })
  -- powerline section separators (lualine section_separators \u{e0b0}/\u{e0b2}):
  -- fg = the departing segment's bg, drawn on the entered segment's bg
  for suffix, color in pairs({
    Normal = palette.green,
    Insert = palette.cyan,
    Visual = palette.yellow,
    Replace = palette.red,
  }) do
    set(0, "ChromeSepA" .. suffix, { fg = color, bg = palette.gray })
    set(0, "ChromeSepZ" .. suffix, { fg = color, bg = palette.darkgray })
  end
  set(0, "ChromeSepBC", { fg = palette.gray, bg = palette.darkgray })
  -- tabline: fill/separators blend into Pmenu bg (bufferline live overrides)
  local pmenu = api.nvim_get_hl(0, { name = "Pmenu", link = false }).bg or palette.darkgray
  local normal = api.nvim_get_hl(0, { name = "Normal", link = false })
  local selbg = normal.bg or palette.darkgray
  set(0, "ChromeTabFill", { bg = pmenu })
  set(0, "ChromeTab", { fg = fg_of("TabLine", palette.white), bg = pmenu })
  set(0, "ChromeTabSel", { fg = normal.fg or palette.white, bg = selbg, bold = true })
  set(0, "ChromeTabMod", { fg = palette.green, bg = pmenu })
  set(0, "ChromeTabModSel", { fg = palette.green, bg = selbg })
  set(0, "ChromeTabSep", { fg = pmenu, bg = pmenu })
  set(0, "ChromeTabSepSel", { fg = pmenu, bg = selbg })
  set(0, "ChromeTabIndicator", { fg = palette.cyan, bg = selbg })
  set(0, "ChromeTabBadge", { fg = palette.black, bg = palette.cyan, bold = true })
end

local redraw_queued = false
local function redraw()
  if redraw_queued then
    return
  end
  redraw_queued = true
  vim.schedule(function()
    redraw_queued = false
    vim.cmd("redrawtabline")
    vim.cmd("redrawstatus")
  end)
end

local function update_diag(buf)
  if not api.nvim_buf_is_valid(buf) then
    diag_counts[buf] = nil
    return
  end
  local c = vim.diagnostic.count(buf)
  diag_counts[buf] = next(c) and c or nil
end

local function order_remove(buf)
  for i, b in ipairs(order) do
    if b == buf then
      table.remove(order, i)
      return
    end
  end
end

local function order_insert_after_current(buf)
  order_remove(buf)
  local cur = api.nvim_get_current_buf()
  for i, b in ipairs(order) do
    if b == cur then
      table.insert(order, i + 1, buf)
      return
    end
  end
  order[#order + 1] = buf
end

--- Click handler for tabline entries (%@ label). Receives
--- (minwid=bufnr, clicks, button, mods); parity with bufferline's
--- left_mouse_command "buffer %d" / right_mouse_command "bdelete! %d",
--- middle disabled.
function M.click(bufnr, _, button, _)
  if not api.nvim_buf_is_valid(bufnr) then
    return
  end
  if button == "l" then
    api.nvim_set_current_buf(bufnr)
  elseif button == "r" then
    pcall(api.nvim_buf_delete, bufnr, { force = true })
  end
end
_G.Chrome_click = M.click

-- lualine filename path=3: absolute, ~ for home, shorting_target=40.
local function stl_filename(buf)
  local name = api.nvim_buf_get_name(buf)
  if name == "" then
    return "[No Name]"
  end
  if home and name:sub(1, #home) == home then
    name = "~" .. name:sub(#home + 1)
  end
  local budget = vim.o.columns - 40
  if #name > budget then
    local parts = vim.split(name, "/", { plain = true })
    for i = 1, #parts - 1 do
      if #name <= budget then
        break
      end
      if #parts[i] > 1 then
        parts[i] = parts[i]:sub(1, parts[i]:sub(1, 1) == "." and 2 or 1)
        name = table.concat(parts, "/")
      end
    end
  end
  return esc(name)
end

function M.statusline()
  local buf = api.nvim_get_current_buf()
  local bo = vim.bo[buf]
  if bo.filetype == "snacks_picker_input" then
    return ""
  end
  local mode = api.nvim_get_mode().mode
  local mchar = mode:sub(1, 1)
  local a_hl = mode_hl[mchar] or "ChromeANormal"
  local asuf = a_hl:sub(8) -- "ChromeA<suffix>" -> "<suffix>"
  -- section b: lualine components joined by the thin chevron
  -- (component_separators.left " "); an absent component drops its
  -- separator with it, exactly as lualine renders
  local comps = {}
  local fn = { stl_filename(buf), "%<" }
  if bo.modified then
    fn[#fn + 1] = "[+]"
  elseif bo.readonly or not bo.modifiable then
    fn[#fn + 1] = "[-]"
  elseif newfile[buf] then
    fn[#fn + 1] = "[New]"
  end
  comps[#comps + 1] = table.concat(fn)
  local b = vim.b[buf]
  local head = b.gitsigns_head
  if type(head) == "string" and head ~= "" then
    comps[#comps + 1] = " " .. esc(head)
  end
  if bo.filetype ~= "" then
    comps[#comps + 1] = ft_icon(bo.filetype, false) .. "%#ChromeBBold#" .. bo.filetype .. "%#ChromeB#"
  end
  local gs = b.gitsigns_status_dict
  if type(gs) == "table" then
    local d = {}
    if (gs.added or 0) > 0 then
      d[#d + 1] = "%#ChromeDiffAdd#+" .. gs.added .. "%#ChromeB#"
    end
    if (gs.changed or 0) > 0 then
      d[#d + 1] = "%#ChromeDiffChange#~" .. gs.changed .. "%#ChromeB#"
    end
    if (gs.removed or 0) > 0 then
      d[#d + 1] = "%#ChromeDiffDelete#-" .. gs.removed .. "%#ChromeB#"
    end
    if #d > 0 then
      comps[#comps + 1] = table.concat(d, " ")
    end
  end
  local dc = diag_counts[buf]
  if dc then
    local d = {}
    for sev = 1, 4 do
      local n = dc[sev]
      if n and n > 0 then
        d[#d + 1] = "%#" .. sev_stl[sev][1] .. "#" .. sev_stl[sev][2] .. n .. "%#ChromeB#"
      end
    end
    if #d > 0 then
      comps[#comps + 1] = table.concat(d, " ")
    end
  end
  comps[#comps + 1] = "%3l:%-2c"
  comps[#comps + 1] = bo.fileformat
  local s = {
    "%#",
    a_hl,
    "# ",
    mode_word[mode] or mode_word[mchar] or mchar:upper(),
    " %#ChromeSepA",
    asuf,
    "#%#ChromeB# ",
    table.concat(comps, "  "),
  }
  s[#s + 1] = " %#ChromeSepBC#%#ChromeC#%="
  if bo.filetype ~= "" then
    s[#s + 1] = ft_icon(bo.filetype, true) .. "%#ChromeC#" .. bo.filetype .. "  "
  end
  s[#s + 1] = bo.fileencoding ~= "" and bo.fileencoding or vim.o.encoding
  local cur = api.nvim_win_get_cursor(0)[1]
  local total = api.nvim_buf_line_count(buf)
  local progress = cur == 1 and "Top"
    or (cur == total and "Bot" or string.format("%2d%%%%", math.floor(cur / total * 100)))
  s[#s + 1] = " %#ChromeSepZ" .. asuf .. "#%#" .. a_hl .. "# " .. progress .. " "
  return table.concat(s)
end

-- drop one trailing UTF-8 character
local function chop_char(s)
  local n = #s
  while n > 1 and s:byte(n) >= 0x80 and s:byte(n) < 0xC0 do
    n = n - 1
  end
  return s:sub(1, n - 1)
end

local function tab_diag(buf)
  local dc = diag_counts[buf]
  if not dc then
    return ""
  end
  local out = {}
  for sev = 1, 4 do
    local n = dc[sev]
    if n and n > 0 then
      out[#out + 1] = " " .. (sev == 1 and " " or "") .. n
    end
  end
  return table.concat(out)
end

--- Current tabline buffer order (copy); test/introspection hook.
function M.buffer_order()
  return vim.list_slice(order)
end

function M.tabline()
  -- reconcile order with reality (missed BufAdd/BufDelete are healed here)
  local listed = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      listed[buf] = true
    end
  end
  local i = 1
  while i <= #order do
    if listed[order[i]] then
      listed[order[i]] = nil
      i = i + 1
    else
      table.remove(order, i)
    end
  end
  for buf in pairs(listed) do
    order_insert_after_current(buf)
  end

  local cur = api.nvim_get_current_buf()
  -- dedup: same tail names get a parent-dir prefix (max_prefix_length)
  local tails, seen = {}, {}
  for _, buf in ipairs(order) do
    local name = api.nvim_buf_get_name(buf)
    local tail = name:match("[^/]+$") or "[No Name]"
    tails[buf] = { name = name, tail = tail }
    seen[tail] = (seen[tail] or 0) + 1
  end

  local entries, cur_idx = {}, 1
  for idx, buf in ipairs(order) do
    local t = tails[buf]
    local label = t.tail
    if seen[t.tail] > 1 then
      local parent = t.name:match("([^/]+)/[^/]+$")
      if parent then
        label = parent:sub(1, MAX_PREFIX) .. "/" .. label
      end
    end
    local sel = buf == cur
    if sel then
      cur_idx = idx
    end
    local mod = vim.bo[buf].modified
    local diag = tab_diag(buf)
    local text = " " .. buf .. " " .. label .. diag
    local w = 1 + api.nvim_strwidth(text) + (mod and 2 or 0)
    while w > TAB_SIZE and #label > 1 do
      label = chop_char(label)
      text = " " .. buf .. " " .. label .. diag
      w = 1 + api.nvim_strwidth(text) + (mod and 2 or 0)
    end
    local ehl = sel and "ChromeTabSel" or "ChromeTab"
    local shl = sel and "ChromeTabSepSel" or "ChromeTabSep"
    local e = {
      "%",
      buf,
      "@v:lua.Chrome_click@%#",
      shl,
      "#%#",
      ehl,
      "#",
      sel and "%#ChromeTabIndicator#▎%#" .. ehl .. "#" or " ",
      esc(text),
      mod and ("%#" .. (sel and "ChromeTabModSel" or "ChromeTabMod") .. "# ●%#" .. ehl .. "#") or "",
      string.rep(" ", math.max(0, TAB_SIZE - w)),
      "%#",
      shl,
      "#%X",
    }
    entries[idx] = table.concat(e)
  end

  -- overflow: window around the current entry with truncation markers
  local per = TAB_SIZE + 2
  local maxn = math.max(1, math.floor((vim.o.columns - 4) / per))
  local lo, hi = 1, #entries
  if #entries > maxn then
    lo = math.max(1, math.min(cur_idx - math.floor((maxn - 1) / 2), #entries - maxn + 1))
    hi = lo + maxn - 1
  end
  local out = {}
  if lo > 1 then
    out[#out + 1] = "%#ChromeTab# "
  end
  for idx = lo, hi do
    out[#out + 1] = entries[idx]
  end
  if hi < #entries then
    out[#out + 1] = "%#ChromeTab# "
  end
  out[#out + 1] = "%#ChromeTabFill#"
  local ntabs = #api.nvim_list_tabpages()
  if ntabs > 1 then
    out[#out + 1] = "%=%#ChromeTabBadge# " .. ntabs .. " "
  end
  return table.concat(out)
end

function M.setup()
  define_highlights()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      order[#order + 1] = buf
      update_diag(buf)
    end
  end
  vim.o.statusline = "%!v:lua.require'config.chrome'.statusline()"
  vim.o.tabline = "%!v:lua.require'config.chrome'.tabline()"

  -- icon provider load, off the startup path: devicons costs ~0.35ms and
  -- lualine parity needs its glyphs, so pull it in shortly after UIEnter
  -- and repaint once it lands (no-op if something else loaded it first)
  api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      vim.defer_fn(function()
        pcall(function()
          require("lazy").load({ plugins = { "nvim-web-devicons" } })
        end)
        vim.cmd.redrawstatus()
        vim.cmd.redrawtabline()
      end, 200)
    end,
  })

  local g = api.nvim_create_augroup("config_chrome", { clear = true })
  local au = api.nvim_create_autocmd
  au("BufAdd", {
    group = g,
    callback = function(a)
      if vim.bo[a.buf].buflisted then
        order_insert_after_current(a.buf)
      end
      redraw()
    end,
  })
  au({ "BufDelete", "BufWipeout" }, {
    group = g,
    callback = function(a)
      order_remove(a.buf)
      diag_counts[a.buf], diag_dirty[a.buf], newfile[a.buf], modstate[a.buf] = nil, nil, nil, nil
      redraw()
    end,
  })
  au({ "BufFilePost", "ModeChanged" }, {
    group = g,
    callback = function()
      redraw()
    end,
  })
  -- this nightly dropped BufModifiedSet: redraw only on the modified-state
  -- transition so the ● marker and [+] flip without per-keystroke churn
  au({ "TextChanged", "TextChangedI" }, {
    group = g,
    callback = function(a)
      local mod = vim.bo[a.buf].modified
      if modstate[a.buf] ~= mod then
        modstate[a.buf] = mod
        redraw()
      end
    end,
  })
  -- bufferline parity: diagnostics_update_in_insert = false
  au("DiagnosticChanged", {
    group = g,
    callback = function(a)
      if api.nvim_get_mode().mode:sub(1, 1) == "i" then
        diag_dirty[a.buf] = true
      else
        update_diag(a.buf)
        redraw()
      end
    end,
  })
  au("InsertLeave", {
    group = g,
    callback = function()
      for buf in pairs(diag_dirty) do
        update_diag(buf)
      end
      diag_dirty = {}
      redraw()
    end,
  })
  au("User", {
    group = g,
    pattern = "GitSignsUpdate",
    callback = function()
      redraw()
    end,
  })
  au("BufNewFile", {
    group = g,
    callback = function(a)
      newfile[a.buf] = true
    end,
  })
  au("BufWritePost", {
    group = g,
    callback = function(a)
      newfile[a.buf] = nil
      modstate[a.buf] = false
      redraw()
    end,
  })
  au("ColorScheme", {
    group = g,
    callback = function()
      define_highlights()
      redraw()
    end,
  })
end

return M
