vim.opt_local.errorformat = "%f:%l %m"
vim.opt_local.expandtab = true
vim.opt_local.makeprg = "hadolint --no-color"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.treesitter.start()

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl efm< et< mp< sw< sts< ts<"
  .. "|call v:lua.vim.treesitter.stop()"
