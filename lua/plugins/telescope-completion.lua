return {
  "illia-shkroba/telescope-completion.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension "completion"
  end,
}
