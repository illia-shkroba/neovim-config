return {
  "williamboman/mason.nvim",
  config = function()
    -- By default package definitions are fetched from: <https://github.com/mason-org/mason-registry>.
    require("mason").setup()
  end,
}
