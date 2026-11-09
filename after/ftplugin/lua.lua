vim.opt_local.expandtab = true
vim.opt_local.formatprg =
  "stylua --call-parentheses=none --column-width=80 --indent-type=spaces --indent-width=2 -- -"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.treesitter.start()

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !lua<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal lua -i #:S<CR>]],
  { buffer = true, desc = "Load current buffer to lua" }
)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl et< fp< sw< sts< ts<"
  .. "|call v:lua.vim.treesitter.stop()"
  .. "|sil! nunmap <buffer> <leader><CR>|sil! vunmap <buffer> <leader><CR>"
  .. "|sil! nunmap <buffer> <leader><Tab>"
