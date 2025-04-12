return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local mason_lspconfig = require "mason-lspconfig"
    local lsps = require "lsps"

    local ensure_installed = {}
    for name, config in pairs(lsps) do
      if config.install then
        table.insert(ensure_installed, name)
      end
    end

    mason_lspconfig.setup {
      ensure_installed = ensure_installed,
    }
  end,
}
