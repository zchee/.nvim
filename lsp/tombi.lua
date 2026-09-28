local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("tombi", "tombi"), "lsp" },
  filetypes = { "toml" },
  root_markers = { "tombi.toml", "pyproject.toml", ".git" },
  -- NOTE(zchee): tombi config exists in `~/.config/tombi/config.toml`
  settings = {},
  handlers = {
    -- Everything below Error is dropped rather than sent to the LSP log;
    -- errors reach the user. The old early return dropped errors as well,
    -- since nothing followed it.
    ["window/logMessage"] = function(_, result, _)
      if result.type == vim.lsp.protocol.MessageType.Error then
        vim.notify(("tombi: %s"):format(result.message), vim.log.levels.ERROR)
      end
    end,
  },
}
