return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require "lspconfig"
    local lsps = require "lsps"

    for name, config in pairs(lsps) do
      lspconfig[name].setup(config.setup or {})
    end
  end,
}
