return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup {
      surrounds = {
        ["?"] = {
          add = function()
            return { { [[(?-i)]] }, { "" } }
          end,
        },
        ["j"] = {
          add = function()
            return { { [["{{ ]] }, { [[ }}"]] } }
          end,
        },
        ["q"] = {
          add = function()
            return { { [[`]] }, { [[`]] } }
          end,
        },
        ["s"] = {
          add = function()
            return { { [[s//]] }, { [[/gc]] } }
          end,
        },
        ["/"] = {
          add = function()
            return { { [[\<]] }, { [[\>]] } }
          end,
        },
      },
    }
  end,
}
