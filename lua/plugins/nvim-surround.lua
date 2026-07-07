return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup {
      surrounds = {
        ["j"] = {
          add = function()
            return { { [["{{ ]] }, { [[ }}"]] } }
          end,
        },
        ["s"] = {
          add = function()
            return { { [[s//]] }, { [[/gc]] } }
          end,
        },
        ["w"] = {
          add = function()
            return { { [[\<]] }, { [[\>]] } }
          end,
        },
      },
    }
  end,
}
