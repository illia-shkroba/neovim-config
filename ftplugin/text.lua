if vim.b.did_text_ftplugin then
  return
end
vim.b.did_text_ftplugin = true

local set = vim.keymap.set

set(
  "",
  [[gqap]],
  [[:'{,'}substitute/\s\+/ /g<CR>gqap]],
  { buffer = true, remap = false }
)
set(
  "",
  [[gqip]],
  [[:'{,'}substitute/\s\+/ /g<CR>gqip]],
  { buffer = true, remap = false }
)
set(
  "",
  [[gqq]],
  [[:substitute/\s\+/ /g<CR>gqq]],
  { buffer = true, remap = false }
)
set(
  "",
  [[gww]],
  [[:substitute/\s\+/ /g<CR>gww]],
  { buffer = true, remap = false }
)
