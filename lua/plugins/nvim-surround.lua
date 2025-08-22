return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup {
      keymaps = {
        insert = "<C-l>",
        insert_line = false,
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "<C-l>",
        visual_line = false,
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
      surrounds = {
        ["j"] = {
          add = function()
            return { { [["{{ ]] }, { [[ }}"]] } }
          end,
        },
      },
    }
  end,
}
