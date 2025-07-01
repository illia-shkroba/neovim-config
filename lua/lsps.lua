return {
  ansiblels = { install = true },
  bashls = { install = true },
  dhall_lsp_server = {},
  dockerls = { install = true },
  dotls = {},
  harper_ls = { install = true },
  hls = {},
  lua_ls = { install = true },
  nil_ls = {},
  perlpls = {},
  purescriptls = { install = true },
  pyright = { install = true },
  rust_analyzer = {},
  terraformls = {},
  typos_lsp = { install = true },
  vimls = { install = true },
  yamlls = {
    install = true,
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
