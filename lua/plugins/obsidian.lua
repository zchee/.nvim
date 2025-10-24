local obsidian = require("obsidian")

---@type obsidian.config
obsidian.setup({
  workspaces = {
    {
      name = "knowledge",
      path = "~/.obsidian/vaults/knowledge",
    },
  },
  ---@diagnostic disable-next-line
  completion = {
    nvim_cmp = true,
    blink = true,
    min_chars = 1,
  },
  ---@diagnostic disable-next-line
  picker = {
    name = "snacks.pick",
    ---@diagnostic disable-next-line
    note_mappings = {
      new = "<C-x>",
      insert_link = "<C-l>",
    },
    ---@diagnostic disable-next-line
    tag_mappings = {
      tag_note = "<C-x>",
      insert_tag = "<C-l>",
    },
  },
})
