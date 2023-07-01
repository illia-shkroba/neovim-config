if vim.b.did_markdown_ftplugin then
  return
end
vim.b.did_markdown_ftplugin = true

local set = vim.keymap.set

set(
  "",
  [[gqap]],
  [[vap:call StripWS()<CR>gqap]],
  { buffer = true, remap = false }
)
set(
  "",
  [[gqip]],
  [[vip:call StripWS()<CR>gqip]],
  { buffer = true, remap = false }
)
set("", [[gqq]], [[:call StripWS()<CR>gqq]], { buffer = true, remap = false })
set("", [[gww]], [[:call StripWS()<CR>gww]], { buffer = true, remap = false })
