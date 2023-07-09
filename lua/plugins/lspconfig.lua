return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require "lspconfig"

    lspconfig.ansiblels.setup {}
    lspconfig.dockerls.setup {}
    lspconfig.hls.setup {}
    lspconfig.lua_ls.setup {}
    lspconfig.purescriptls.setup {}
    lspconfig.pylsp.setup {}
    lspconfig.rnix.setup {}
    lspconfig.terraformls.setup {}
    lspconfig.vimls.setup {}
  end,
}
