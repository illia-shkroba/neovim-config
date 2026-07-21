return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup {
      surrounds = {
        ["W"] = {
          add = function()
            return { { [[\b]] }, { [[\b]] } }
          end,
        },
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
