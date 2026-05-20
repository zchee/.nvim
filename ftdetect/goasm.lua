vim.filetype.add({
  extension = {
    s = require("filetypes.goasm").detect,
  },
})
