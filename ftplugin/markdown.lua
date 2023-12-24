if vim.b.did_markdown_ftplugin then
  return
end
vim.b.did_markdown_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.formatoptions = opt_local.formatoptions._value .. "a"
opt_local.spell = true
opt_local.textwidth = 100

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
