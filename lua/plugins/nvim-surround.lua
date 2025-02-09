return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup {
      keymaps = {
        insert = "<C-g><C-s>",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "<C-g><C-s>",
        visual_line = "<C-g>S",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    }
  end,
}
