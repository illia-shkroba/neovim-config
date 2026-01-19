if vim.b.did_dhall_ftplugin then
  return
end
vim.b.did_dhall_ftplugin = true

vim.opt_local.equalprg = "dhall lint"
vim.opt_local.expandtab = true
vim.opt_local.formatprg = "dhall format"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !dhall-to-json<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal dhall-to-json --file #<CR>]],
  { buffer = true, desc = "Load current buffer to dhall-to-json" }
)
