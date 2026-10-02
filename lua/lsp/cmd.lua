-- lua/lsp/cmd.lua -- a function `cmd` for lsp/<server>.lua whose argv is
-- built when the server starts, not when the config resolves.
--
-- vim.lsp.enable() loads every lsp/<name>.lua, and the first FileType loads
-- them again (see AGENTS.md), so a table `cmd` pays its binary lookups
-- (util.bun_prefix, util.nodenv_prefix, vim.fn.exepath) in every session. A
-- function `cmd` defers them, but vim.lsp then hands it only the dispatchers
-- and the config: the spawn options it passes for a table `cmd` have to be
-- passed again here. Required as `lsp.cmd`, never through `require("lsp")`,
-- whose init.lua runs the vim.lsp.enable() that loads these files.
local M = {}

---Wrap `argv` in a function `cmd` that spawns it with the options vim.lsp
---passes for a table `cmd` (runtime lua/vim/lsp/client.lua, Client.create).
---@param argv fun(): string[] builds the command line; runs at each server start
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers, config: vim.lsp.ClientConfig): vim.lsp.rpc.Client
function M.lazy(argv)
  return function(dispatchers, config)
    return vim.lsp.rpc.start(argv(), dispatchers, {
      cwd = config.cmd_cwd or config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
  end
end

return M
