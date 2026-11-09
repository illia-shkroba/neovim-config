vim.treesitter.language.register("latex", "plaintex")
vim.treesitter.start()

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "call v:lua.vim.treesitter.stop()"
