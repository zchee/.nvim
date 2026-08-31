local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("tombi", "tombi"), "lsp" },
  filetypes = { "toml" },
  root_markers = { "tombi.toml", "pyproject.toml", ".git" },
  -- NOTE(zchee): tombi config exists in `~/.config/tombi/config.toml`
  settings = {},
  handlers = {
    ["window/logMessage"] = function(_, result, _)
      if result.type > vim.lsp.protocol.MessageType.Error then
        return
      end
    end,
  },
}
