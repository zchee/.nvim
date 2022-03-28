-- https://github.com/ms-jpq/coq_nvim/blob/coq/config/defaults.yml
vim.g.coq_settings = {
  xdg = true,
  auto_start = "shut-up",
  -- auto_start = false,

  keymap = {
    recommended = false,
    pre_select = false,
    manual_complete = "<C-Space>",
    ["repeat"] = nil,
    bigger_preview = "<C-k>",
    jump_to_mark = "<C-h>",
    eval_snips = nil,
  },

  completion = {
    always = true,
    smart = true,
  },

  match = {
    unifying_chars = {
      "_",
      "-",
    },                     -- These characters count as part of words: default: { "-", "_" }
    max_results = 500,     -- Maximum number of results to return: default: 33, 500
    proximate_lines = 16,  -- How many lines to use, for the purpose of proximity bonus. Neighbouring words in proximity are counted: default: 16
    exact_matches = 1,     -- For word searching, how many exact prefix characters is required: default: 2
    look_ahead = 1,        -- For word searching, how many characters to look ahead, in case of typos: default: 2
    fuzzy_cutoff = 0.6,    -- What is the minimum similarity score, for a word to be proposed by the algorithm: default: 0.6
  },

  weights = {
    prefix_matches = 2.0,  -- Relative weight adjustment of exact prefix matches
    edit_distance = 1.5,   -- Relative weight adjustment of Damerau–Levenshtein distance, normalized and adjusted for look-aheads
    recency = 1.0,         -- Relative weight adjustment of recently inserted items
    proximity = 0.5,       -- Relative weight adjustment of prevalence within the proximate_lines
  },

  display = {
    ghost_text = {
      enabled = true,
      context = {
        "〈  ",
        "  〉",
      },
      highlight_group = "Comment",
    },
    pum = {
      fast_close = true,
      y_max_len = 100,                -- default = 16 -- 100
      y_ratio = 0.3,                  -- default = 0.3 -- 0.8
      x_max_len = 500,                -- default = 66 -- 500
      x_truncate_len = 500,           -- default = 12 -- 500
      ellipsis = "<ellipsis ...>",    -- default = ...
      kind_context = { '"', '"' },    -- default = { " [", "]" }
      source_context = { "[", "]" },  -- default = { "「", "」" }
    },
    preview = {
      x_max_len = 200,         -- default = 88
      resolve_timeout = 1.0,   -- default = 0.09
      border = {               -- "rounded"
      { "╭", "NormalFloat" },
      { "─", "NormalFloat" },
      { "╮", "NormalFloat" },
      { "│", "NormalFloat" },
      { "╯", "NormalFloat" },
      { "─", "NormalFloat" },
      { "╰", "NormalFloat" },
      { "│", "NormalFloat" },
      },
      positions = {
        north = 3,  -- default = 1
        south = 4,  -- default = 2
        west = 1,   -- default = 3
        east = 2,   -- default = 4
      },
    },
    time_fmt = "%Y-%m-%d %H:%M",
    mark_highlight_group = "Pmenu",
    icons = {
      mode = "long",
      spacing = 1,
      aliases = {
        Conditional = "Keyword",
        Float       = "Number",
        Include     = "Property",
        Label       = "Keyword",
        Member      = "Property",
        Repeat      = "Keyword",
        Structure   = "Struct",
        Type        = "TypeParameter",
      },
      mappings = {
        Boolean       = "",
        Character     = "",
        Class         = "",
        Color         = "",
        Constant      = "",
        Constructor   = "",
        Enum          = "",
        EnumMember    = "",
        Event         = "ﳅ",
        Field         = "",
        File          = "",
        Folder        = "ﱮ",
        Function      = "ﬦ",
        Interface     = "",
        Keyword       = "",
        Method        = "",
        Module        = "",
        Number        = "",
        Operator      = "Ψ",
        Parameter     = "",
        Property      = "ﭬ",
        Reference     = "",
        Snippet       = "",
        String        = "",
        Struct        = "ﯟ",
        Text          = "",
        TypeParameter = "",
        Unit          = "",
        Value         = "",
        Variable      = "ﳛ",
      },
    },
  },

  limits = {
    index_cutoff = 10000000,           -- default = 333333
    idle_timeout = 1.88,               -- default = 1.88
    completion_auto_timeout = 1.00,    -- default = 0.088 -- 0.88, 81.0, 1.00
    completion_manual_timeout = 0.66,  -- default = 0.66 -- 1.00
    download_retries = 6,
    download_timeout = 66.0,
  },

  clients = {
    tabnine = {
      enabled = false,
    },
    third_party = {
      enabled       = true,
      short_name    = "3p",
      weight_adjust = 0.05,  -- default = 0 -- 1.00
    },
    tmux = {
      enabled = false,
    },
    buffers = {
      enabled       = true,
      short_name    = "buffer",
      match_syms    = true,
      same_filetype = true,
      weight_adjust = 0.05,  -- default = 0
    },
    tree_sitter = {
      enabled        = false,
      short_name     = "ts",
      path_sep       = " ⇊",
      search_context = 168,
      slow_threshold = 0.168,
      weight_adjust  = 0.05,
    },
    paths = {
      enabled       = true,
      short_name    = "path",
      resolution    = {
        "cwd",
        "file",
      },
      preview_lines = 6,
      weight_adjust = 0.05,  -- default = 0
    },
    snippets = {
      enabled       = true,
      short_name    = "snip",
      weight_adjust = 0.05,  -- default = 0
      user_path     = vim.fn.stdpath("config").."/snippets/coq",
      warn          = {
        "missing",
        "outdated",
      },
    },
    tags = {
      enabled = false,
    },
    lsp = {
      enabled         = true,
      short_name      = "LSP",
      resolve_timeout = 1.0,  -- default = 0.3
      weight_adjust   = 1.5,   -- default = 0.06 -- 1.5
    },
  }
}
