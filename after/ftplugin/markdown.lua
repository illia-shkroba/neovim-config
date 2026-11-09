vim.opt_local.formatprg = "mdformat --number -"
vim.opt_local.spell = true
vim.opt_local.wrap = false
-- 'expandtab' along with 'shiftwidth', 'softtabstop', 'tabstop' set to `4` is defined at
-- `$VIMRUNTIME/ftplugin/markdown.vim`, because `g:markdown_recommended_style` is not disabled.

vim.treesitter.start()
