return function(_, keys)
  ---@type avante.Config
  local opts = require("lazy.core.plugin").values(
    require("lazy.core.config").spec.plugins["avante.nvim"], "opts",
    false)
  local mappings = {
    {
      opts.mappings.ask,
      function() require("avante.api").ask() end,
      desc = "avante: ask",
      mode = { "n", "v" },
    },
    {
      opts.mappings.edit,
      function() require("avante.api").edit() end,
      desc = "avante: edit",
      mode = { "n", "v" },
    },
    {
      opts.mappings.refresh,
      function() require("avante.api").refresh() end,
      desc = "avante: refresh",
      mode = { "v" },
    },
    {
      opts.mappings.focus,
      function() require("avante.api").focus() end,
      desc = "avante: focus",
      mode = { "n", "v" },
    },
    {
      opts.mappings.toggle.default,
      function() require("avante").toggle() end,
      desc = "avante: toggle sidebar",
      mode = { "n" },
    },
  }
  mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
  return vim.list_extend(mappings, keys)
end
