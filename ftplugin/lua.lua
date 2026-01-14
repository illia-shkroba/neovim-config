if vim.b.did_lua_ftplugin then
  return
end
vim.b.did_lua_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.formatprg =
  "stylua --call-parentheses=none --column-width=80 --indent-type=spaces --indent-width=2 -- -"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !lua<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal lua -i #<CR>]],
  { buffer = true, desc = "Load current buffer to lua" }
)
