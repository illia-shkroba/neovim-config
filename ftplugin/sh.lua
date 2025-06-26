if vim.b.did_sh_ftplugin then
  return
end
vim.b.did_sh_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "shellcheck"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.opt_local.formatprg = "shfmt -s -i "
  .. vim.opt_local.tabstop._value
  .. " -bn -ci -sr"

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !bash<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal bash --init-file #<CR>]],
  { buffer = true, desc = "Load current buffer to bash" }
)
