return {
  "williamboman/mason.nvim",
  config = function()
    -- By default package definitions are fetched from: <https://github.com/mason-org/mason-registry>.
    require("mason").setup()

    -- Non-LSP packages (`mason-lspconfig` installs only LSPs).
    local registry = require "mason-registry"
    registry.refresh(function()
      for _, name in ipairs { "palantir-java-format" } do
        local package_ = registry.get_package(name)
        if not package_:is_installed() then
          package_:install()
        end
      end
    end)
  end,
}
