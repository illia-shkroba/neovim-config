return {
  "purescript-contrib/purescript-vim",
  config = function()
    vim.g.purescript_unicode_conceal_enable = 0
  end,
  ft = { "purescript" },
}
