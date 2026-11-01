return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        selection_modes = {
          ["@class.outer"] = "V",
          ["@class.inner"] = "V",
          ["@function.inner"] = "V",
          ["@function.outer"] = "V",
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    }

    -- select keymaps
    local select = require "nvim-treesitter-textobjects.select"

    vim.keymap.set({ "o", "v" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end, { desc = "Around class" })
    vim.keymap.set({ "o", "v" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end, { desc = "Inside class" })

    vim.keymap.set({ "o", "v" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Around function" })
    vim.keymap.set({ "o", "v" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Inside function" })

    vim.keymap.set({ "o", "v" }, "aP", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end, { desc = "Around parameter" })
    vim.keymap.set({ "o", "v" }, "iP", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end, { desc = "Inside parameter" })

    vim.keymap.set({ "o", "v" }, "aS", function()
      select.select_textobject("@local.scope", "locals")
    end, { desc = "Around scope" })

    -- move keymaps
    local move = require "nvim-treesitter-textobjects.move"

    vim.keymap.set({ "n", "v", "o" }, "]m", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function start" })
    vim.keymap.set({ "n", "v", "o" }, "]M", function()
      move.goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next function end" })
    vim.keymap.set({ "n", "v", "o" }, "[m", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function start" })
    vim.keymap.set({ "n", "v", "o" }, "[M", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Previous function end" })

    vim.keymap.set({ "n", "v", "o" }, "]]", function()
      move.goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next class start" })
    vim.keymap.set({ "n", "v", "o" }, "][", function()
      move.goto_next_end("@class.outer", "textobjects")
    end, { desc = "Next class end" })
    vim.keymap.set({ "n", "v", "o" }, "[[", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Previous class start" })
    vim.keymap.set({ "n", "v", "o" }, "[]", function()
      move.goto_previous_end("@class.outer", "textobjects")
    end, { desc = "Previous class end" })

    vim.keymap.set({ "n", "v", "o" }, "]#", function()
      move.goto_next_start("@comment.outer", "textobjects")
    end, { desc = "Next comment" })
    vim.keymap.set({ "n", "v", "o" }, "[#", function()
      move.goto_previous_start("@comment.outer", "textobjects")
    end, { desc = "Previous comment" })

    vim.keymap.set({ "n", "v", "o" }, "]e", function()
      move.goto_next_start("@call.outer", "textobjects")
    end, { desc = "Next call start" })
    vim.keymap.set({ "n", "v", "o" }, "]E", function()
      move.goto_next_end("@call.outer", "textobjects")
    end, { desc = "Next call end" })
    vim.keymap.set({ "n", "v", "o" }, "[e", function()
      move.goto_previous_start("@call.outer", "textobjects")
    end, { desc = "Previous call start" })
    vim.keymap.set({ "n", "v", "o" }, "[E", function()
      move.goto_previous_end("@call.outer", "textobjects")
    end, { desc = "Previous call end" })

    vim.keymap.set({ "n", "v", "o" }, "]o", function()
      move.goto_next_start("@local.scope", "locals")
    end, { desc = "Next scope start" })
    vim.keymap.set({ "n", "v", "o" }, "]O", function()
      move.goto_next_end("@local.scope", "locals")
    end, { desc = "Next scope end" })
    vim.keymap.set({ "n", "v", "o" }, "[o", function()
      move.goto_previous_start("@local.scope", "locals")
    end, { desc = "Previous scope start" })
    vim.keymap.set({ "n", "v", "o" }, "[O", function()
      move.goto_previous_end("@local.scope", "locals")
    end, { desc = "Previous scope end" })

    -- ;, and fFtT keymaps
    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

    vim.keymap.set(
      { "n", "v", "o" },
      ";",
      ts_repeat_move.repeat_last_move,
      { desc = "Repeat last move" }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      ",",
      ts_repeat_move.repeat_last_move_opposite,
      { desc = "Repeat last move in opposite direction" }
    )

    vim.keymap.set(
      { "n", "v", "o" },
      "f",
      ts_repeat_move.builtin_f_expr,
      { expr = true, desc = "Repeatable f" }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      "F",
      ts_repeat_move.builtin_F_expr,
      { expr = true, desc = "Repeatable F" }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      "t",
      ts_repeat_move.builtin_t_expr,
      { expr = true, desc = "Repeatable t" }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      "T",
      ts_repeat_move.builtin_T_expr,
      { expr = true, desc = "Repeatable T" }
    )
  end,
}
