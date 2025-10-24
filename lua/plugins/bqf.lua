local bqf = require("bqf")

---@type BqfConfig
bqf.setup({
  auto_enable = true,
  magic_window = true,
  auto_resize_height = true,
  previous_winid_ft_skip = {},

  ---@type BqfConfigPreview
  ---@diagnostic disable-next-line
  preview = {
    auto_preview = true,
    border = "rounded",
    show_title = true,
    show_scroll_bar = true,
    delay_syntax = 50, -- defalut: 50
    win_height = 60,   -- defalut: 15
    win_vheight = 30,  -- defalut: 15
    winblend = 0,
    wrap = true,       -- defalut: false
    buf_label = true,
    -- should_preview_cb = function(bufnr, qwinid)
    --   _, _ = bufnr, qwinid
    --   return false
    -- end,
  },

  func_map = {
    open = "<CR>",
    openc = "o",
    drop = "O",
    split = "<C-x>",
    vsplit = "<C-v>",
    tab = "t",
    tabb = "T",
    tabc = "<C-t>",
    tabdrop = "",
    ptogglemode = "zp",
    ptoggleitem = "p",
    ptoggleauto = "P",
    pscrollup = "<C-b>",
    pscrolldown = "<C-f>",
    pscrollorig = "zo",
    prevfile = "<C-p>",
    nextfile = "<C-n>",
    prevhist = "<",
    nexthist = ">",
    lastleave = [['"]],
    stoggleup = "<S-Tab>",
    stoggledown = "<Tab>",
    stogglevm = "<Tab>",
    stogglebuf = [["<Tab>]],
    sclear = "z<Tab>",
    filter = "zn",
    filterr = "zN",
    fzffilter = "zf",
  },

  filter = {
    fzf = {
      action_for = {
        ["ctrl-t"] = "tabedit",
        ["ctrl-v"] = "vsplit",
        ["ctrl-x"] = "split",
        ["ctrl-q"] = "signtoggle",
        ["ctrl-c"] = "closeall",
      },
      extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
    },
  },
})
