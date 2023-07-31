return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local set = vim.keymap.set

    require("nvim-treesitter.configs").setup {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",

            ["af"] = "@function.outer",
            ["if"] = "@function.inner",

            ["aP"] = "@parameter.outer",
            ["iP"] = "@parameter.inner",
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          include_surrounding_whitespace = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sf"] = "@function.outer",
            ["<leader>sp"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>sF"] = "@function.outer",
            ["<leader>sP"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]]"] = "@class.outer",
            ["]m"] = "@function.outer",
            ["]o"] = {
              query = "@scope",
              query_group = "locals",
            },
          },
          goto_next_end = {
            ["]["] = "@class.outer",
            ["]M"] = "@function.outer",
            ["]O"] = {
              query = "@scope",
              query_group = "locals",
            },
          },
          goto_previous_start = {
            ["[["] = "@class.outer",
            ["[m"] = "@function.outer",
            ["[o"] = {
              query = "@scope",
              query_group = "locals",
            },
          },
          goto_previous_end = {
            ["[]"] = "@class.outer",
            ["[M"] = "@function.outer",
            ["[O"] = {
              query = "@scope",
              query_group = "locals",
            },
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          goto_next = {
            ["]d"] = "@block.outer",
          },
          goto_previous = {
            ["[d"] = "@block.outer",
          },
        },
      },
    }

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

    set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
