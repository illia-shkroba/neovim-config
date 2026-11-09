vim.opt_local.expandtab = true
vim.opt_local.formatprg = "pg_format"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.treesitter.start()

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl et< fp< sw< sts< ts<"
  .. "|call v:lua.vim.treesitter.stop()"
