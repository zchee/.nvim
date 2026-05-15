local root = vim.fn.getcwd()

vim.opt.runtimepath:append(root)
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local captured_config
package.loaded["plugins.copilot"] = nil
package.loaded["copilot"] = nil

package.preload["copilot"] = function()
  return {
    setup = function(config)
      assert(captured_config == nil, "copilot.setup should only be called once")
      captured_config = config
    end,
  }
end

vim.fn.setenv("BUN_INSTALL", "/tmp/bun")

require("plugins.copilot")

assert(captured_config ~= nil, "plugins.copilot should call copilot.setup")
assert(captured_config.panel.enabled == false, "copilot panel should stay disabled for cmp-owned UI")
assert(captured_config.suggestion.enabled == false, "inline suggestion UI should stay disabled for cmp-owned UI")

local settings = captured_config.server_opts_overrides and captured_config.server_opts_overrides.settings
local advanced = settings and settings.advanced

assert(type(advanced) == "table", "Copilot advanced settings should be configured")
assert(
  not (settings.github and settings.github.copilot and settings.github.copilot.advanced),
  "advanced completion settings must use copilot.lua's settings.advanced shape, not VS Code's github.copilot shape"
)
assert(
  type(advanced.inlineSuggestCount) == "number" and advanced.inlineSuggestCount > 0,
  "inlineSuggestCount must be positive because copilot-cmp triggers getCompletions"
)
assert(
  type(advanced.listCount) == "number" and advanced.listCount > 0,
  "listCount should remain positive for list/panel completion compatibility"
)
