if vim.b.did_haskell_ftplugin then
  return
end
vim.b.did_haskell_ftplugin = true

vim.opt_local.equalprg = "fourmolu"
  .. " --indentation 2"
  .. " --column-limit 80"
  .. " --function-arrows leading"
  .. " --comma-style leading"
  .. " --import-export-style leading"
  .. " --indent-wheres true"
  .. " --record-brace-space true"
  .. " --haddock-style single-line"
  .. " --let-style auto"
  .. " --in-style right-align"
  .. " --single-constraint-parens never"
  .. " --unicode never"
  .. " --no-cabal"
vim.opt_local.expandtab = true
vim.opt_local.makeprg = "stack build --cabal-verbosity 0"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.opt_local.errorformat = "%-G,"
  .. "%-Z,"
  .. "%W%\\S%#> %f:%l:%c: Warning: %m,"
  .. "%E%\\S%#> %f:%l:%c: Error:,"
  .. "%W%f:%l:%c: Warning: %m,"
  .. "%E%f:%l:%c: Error:,"
  .. "%E%>%f:%l:%c:,"
  .. "%W%>%f:%l:%c:,"

local stylish_config = vim.fn.stdpath "config"
  .. "/etc/options/file-type-options/haskell/stylish-haskell.yaml"
vim.opt_local.formatprg = "stylish-haskell --config " .. stylish_config

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !stack ghci<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal stack ghci #<CR>]],
  { buffer = true, desc = "Load current buffer to ghci" }
)
vim.keymap.set(
  "n",
  [[<leader>gt]],
  [[:!fast-tags -R --qualified .]],
  { buffer = true, desc = "Generate tags" }
)
