if vim.b.did_perl_ftplugin then
  return
end
vim.b.did_perl_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.formatprg = "LC_ALL='C' perltidy"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !perl<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
