return {
  "neovim/nvim-lspconfig",
  config = function()
    for name, config in pairs(require "lsps") do
      vim.lsp.config(name, config.setup or {})
    end
  end,
}
