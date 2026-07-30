-- Returned as `opts` for folke/which-key.nvim in lua/plugins/init.lua.

---@module 'wk'
---@type wk.Opts
return {
  preset = "modern",
  delay = function(ctx)
    return ctx.plugin and 0 or 1000
  end,
  ---@param mapping wk.Mapping
  filter = function(mapping)
    -- return mapping.desc and mapping.desc ~= ""
    _ = mapping
    return true
  end,
  ---@type wk.Spec
  spec = {},
  notify = true,
  ---@type wk.Spec
  triggers = {
    {
      "<auto>",
      mode = "nxso",
    },
  },
  ---@param ctx { mode: string, operator: string }
  defer = function(ctx)
    return ctx.mode == "V" or ctx.mode == "<C-V>"
  end,
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  ---@type wk.Win.opts
  win = {
    relative = "editor",
    style = "minimal",
    focusable = false,
    noautocmd = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- wo = {
    --   -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    -- },
    -- bo = {},
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 },
    no_overlap = true,
    title = true,
    title_pos = "center",
    -- zindex = 1000,
  },
  layout = {
    width = {
      min = 50,
    },
    spacing = 3,
  },
  keys = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  ---@type (string|wk.Sorter)[]
  sort = {
    "local",
    "order",
    "group",
    "alphanum",
    "mod",
    "manual",
    "case",
  },
  ---@type number|fun(node: wk.Node):boolean?
  expand = 0,
  -- expand = function(node)
  --   return not node.desc -- expand all nodes without a description
  -- end,
  ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
    },
    desc = {
      { "<Plug>%(?(.*)%)?", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
    },
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
    ellipsis = "…",
    mappings = true,
    ---@type wk.IconRule[]|false
    rules = {},
    colors = true,
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "󰁮",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
  },
  show_help = true,
  show_keys = true,
  disable = {
    ft = {},
    bt = {},
  },
  debug = false,
}
