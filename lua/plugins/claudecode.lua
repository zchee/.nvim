local claudecode = require("claudecode")

---@type ClaudeCodeConfig
claudecode.setup({
  port_range = { min = 10000, max = 65535 },
  auto_start = true,
  log_level = "error",
  terminal_cmd = "/opt/local/var/bun/bin/omc --yolo", -- "/opt/local/bin/claude --dangerously-skip-permissions",
  focus_after_send = true,
  track_selection = true,
  visual_demotion_delay_ms = 50,
  terminal = {
    -- split_side = "right",
    -- split_width_percentage = 0.30,
    provider = "snacks", -- "auto", "snacks", "native", "external", "none"
    -- show_native_term_exit_tip = true,
    -- auto_close = true,
    -- env = {
    --   COLORTERM = "truecolor",
    -- },
    ---@module "snacks"
    ---@type snacks.win.Config|{}
    snacks_win_opts = {
      position = "float",
      width = 0.9,
      height = 0.9,
      keys = {
        claude_hide = {
          "<C-,>",
          function(self)
            self:hide()
          end,
          mode = "t",
          desc = "Hide",
        },
      },
    },
    ---@module 'snacks'
    ---@class snacks.terminal.Opts: snacks.terminal.Config
    -- snacks_win_opts = {},
    -- provider_opts = {
    --   -- Command for external terminal provider. Can be:
    --   -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
    --   -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
    --   -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
    --   external_terminal_cmd = nil,
    -- },
  },
  diff_opts = {
    layout = "vertical",
    open_in_new_tab = false,
    keep_terminal_focus = false,
    hide_terminal_in_new_tab = true,
    on_new_file_reject = "close_window",
    auto_close_on_accept = true,
    vertical_split = true,
    open_in_current_tab = true,
  },
})
