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
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]e"] = "@call.outer",
            ["]]"] = "@class.outer",
            ["]#"] = "@comment.outer",
            ["]m"] = "@function.outer",
          },
          goto_next_end = {
            ["]E"] = "@call.outer",
            ["]["] = "@class.outer",
            ["]M"] = "@function.outer",
          },
          goto_previous_start = {
            ["[e"] = "@call.outer",
            ["[["] = "@class.outer",
            ["[#"] = "@comment.outer",
            ["[m"] = "@function.outer",
          },
          goto_previous_end = {
            ["[E"] = "@call.outer",
            ["[]"] = "@class.outer",
            ["[M"] = "@function.outer",
          },
        },
      },
    }

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

    set({ "n", "v", "o" }, ";", ts_repeat_move.repeat_last_move)
    set({ "n", "v", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    set({ "n", "v", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    set({ "n", "v", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    set({ "n", "v", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    set({ "n", "v", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
