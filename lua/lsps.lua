return {
  ansiblels = { install = true },
  bashls = { install = true },
  dockerls = { install = true },
  dotls = {},
  hls = {},
  lua_ls = { install = true },
  perlpls = {},
  purescriptls = { install = true },
  ruff = { install = true },
  rust_analyzer = {},
  terraformls = {},
  ty = { install = true },
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
