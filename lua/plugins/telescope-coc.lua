return {
  "fannheyward/telescope-coc.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension "coc"
  end,
}
