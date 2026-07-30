-- Returned as `opts` for 3rd/image.nvim in lua/plugins/init.lua.
--
-- Shape matters: neorg/typst/html/css are *integrations* and must live under
-- `integrations`, and the sizing/behavior keys are top-level setup options.
-- Both used to sit at the lazy spec level, where lazy.nvim silently ignored
-- them (so e.g. the typst/neorg integrations — enabled by default upstream —
-- were never actually disabled).
return {
  backend = "kitty",
  processor = "magick_cli",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = true,
      only_render_image_at_cursor_mode = "popup",
      floating_windows = true, -- if true, images will be rendered in floating markdown windows
      filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = false,
      filetypes = { "norg" },
    },
    typst = {
      enabled = false,
      filetypes = { "typst" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = 800,
  max_height = 600,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = {
    "cmp_menu",
    "cmp_docs",
    "snacks_picker_input",
    "snacks_notif",
    "scrollview",
    "scrollview_sign",
  },
  editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
}
