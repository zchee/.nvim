-- local src_dir = vim.fs.joinpath(vim.uv.os_homedir(), "src")

---@type LazySpec
return {
  {
    "rainbowhxch/accelerated-jk.nvim",
    config = function()
      vim.keymap.set({ "n" }, "j", "<Plug>(accelerated_jk_gj)", { nowait = true, silent = true })
      vim.keymap.set({ "n" }, "k", "<Plug>(accelerated_jk_gk)", { nowait = true, silent = true })

      require('accelerated-jk').setup({
        mode = "time_driven",
        enable_deceleration = true,
        acceleration_motions = {},
        acceleration_limit = 500,
        acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 },
        deceleration_table = { { 200, 3 }, { 300, 7 }, { 450, 11 }, { 600, 15 }, { 750, 21 }, { 900, 9999 } },
      })
    end,
    lazy = false,
  },
}
