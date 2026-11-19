return {
  ansiblels = { install = true },
  bashls = { install = true },
  dockerls = { install = true },
  dotls = {},
  helm_ls = { install = true },
  hls = {},
  jdtls = { install = true },
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
          },
        },
      },
    },
  },
  yamlls_kubernetes = {
    setup = {
      filetypes = { "yaml.kubernetes" },
      settings = { yaml = { schemas = { kubernetes = "*" } } },
    },
  },
}
