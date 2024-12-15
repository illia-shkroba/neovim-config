if vim.b.did_norg_ftplugin then
  return
end
vim.b.did_norg_ftplugin = true

local set = vim.keymap.set

set("", [[gO]], [[<Cmd>Neorg toc left<CR>]], { buffer = true })
