if vim.b.did_ftplugin then
  return
end

vim.cmd("runtime! ftplugin/html.lua")
