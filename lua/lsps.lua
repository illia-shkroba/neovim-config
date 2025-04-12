return {
  ansiblels = {},
  bashls = {},
  dhall_lsp_server = {},
  dockerls = {},
  dotls = {},
  hls = {},
  lua_ls = {},
  nil_ls = {},
  perlpls = {},
  purescriptls = {},
  pyright = {},
  rust_analyzer = {},
  terraformls = {},
  vimls = {},
  yamlls = {
    setup = {
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/*compose.yaml",
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.1-standalone-strict/all.json"] = "/*.k8s.yaml",
          },
        },
      },
    },
  },
}
