vim.g["denops#deno"] = '/usr/local/bin/deno'

vim.fn["ddc#custom#patch_global"]( {
  sources = {
    'nvim-lsp',
  },
  sourceOptions = {
    _ = {
      keyworkPattern = '[a-zA-Z_]\\w*',
      matchers = { "matcher_head" },
      sorters = { "sorter_rank" },
      sourceParams = {
        maxSize = 10000,
      },
      converters = {'converter_remove_overlap'},
      autoCompleteEvents = { 'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged' },
    },

    ["nvim-lsp"] = {
      mark = "LSP",
      forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*',
      minAutoCompleteLength = 1,
      backspaceCompletion = true,
      completionMenu = "pum.vim",
      completionMode = "popupmenu",
    },
  },
})

vim.api.nvim_buf_set_keymap(0, "i", "<C-Space>", "<cmd>call ddc#map#manual_complete()<CR>", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, "i", "<BS>", "'ddc#map#pum_visible()' ? '<BS>'.'ddc#map#manual_complete()' : '<BS>'", { noremap = false, silent = false, expr = true })
vim.call("ddc#enable")
