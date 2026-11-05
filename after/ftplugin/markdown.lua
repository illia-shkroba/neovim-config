if vim.b.did_markdown_ftplugin then
  return
end
vim.b.did_markdown_ftplugin = true

vim.opt_local.formatprg = "mdformat --number -"
vim.opt_local.spell = true
vim.opt_local.wrap = false
-- 'expandtab' along with 'shiftwidth', 'softtabstop', 'tabstop' set to `4` is defined at
-- `$VIMRUNTIME/ftplugin/markdown.vim`, because `g:markdown_recommended_style` is not disabled.

vim.treesitter.start()

vim.api.nvim_create_autocmd("BufReadPost", {
  buf = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.treesitter.start()
  end,
})
