vim.opt_local.expandtab = true
vim.opt_local.formatprg = "LC_ALL='C' perltidy"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.treesitter.start()

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !perl<CR>]],
  { buffer = true, desc = "Run current buffer" }
)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl et< fp< sw< sts< ts<"
  .. "|call v:lua.vim.treesitter.stop()"
  .. "|sil! nunmap <buffer> <leader><CR>|sil! vunmap <buffer> <leader><CR>"
