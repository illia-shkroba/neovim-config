return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require "lspconfig"

    lspconfig.ansiblels.setup {}
    lspconfig.basedpyright.setup {}
    lspconfig.bashls.setup {}
    lspconfig.dhall_lsp_server.setup {}
    lspconfig.dockerls.setup {}
    lspconfig.dotls.setup {}
    lspconfig.hls.setup {}
    lspconfig.lua_ls.setup {}
    lspconfig.nil_ls.setup {}
    lspconfig.perlpls.setup {}
    lspconfig.purescriptls.setup {}
    lspconfig.rust_analyzer.setup {}
    lspconfig.terraformls.setup {}
    lspconfig.vimls.setup {}
    lspconfig.yamlls.setup {
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/*compose.yaml",
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.1-standalone-strict/all.json"] = "/*.k8s.yaml",
          },
        },
      },
    }
  end,
}
