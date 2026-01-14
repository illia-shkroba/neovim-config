return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
        },
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    }

    -- select keymaps
    local select = require "nvim-treesitter-textobjects.select"

    vim.keymap.set({ "o", "v" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "v" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end)

    vim.keymap.set({ "o", "v" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "v" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end)

    vim.keymap.set({ "o", "v" }, "aP", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end)
    vim.keymap.set({ "o", "v" }, "iP", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end)

    vim.keymap.set({ "o", "v" }, "aS", function()
      select.select_textobject("@local.scope", "locals")
    end)

    -- move keymaps
    local move = require "nvim-treesitter-textobjects.move"

    vim.keymap.set({ "n", "v", "o" }, "]m", function()
      move.goto_next_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "]M", function()
      move.goto_next_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[m", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[M", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "v", "o" }, "]]", function()
      move.goto_next_start("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "][", function()
      move.goto_next_end("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[[", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[]", function()
      move.goto_previous_end("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "v", "o" }, "]#", function()
      move.goto_next_start("@comment.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[#", function()
      move.goto_previous_start("@comment.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "v", "o" }, "]e", function()
      move.goto_next_start("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "]E", function()
      move.goto_next_end("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[e", function()
      move.goto_previous_start("@call.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[E", function()
      move.goto_previous_end("@call.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "v", "o" }, "]o", function()
      move.goto_next_start("@local.scope", "locals")
    end)
    vim.keymap.set({ "n", "v", "o" }, "]O", function()
      move.goto_next_end("@local.scope", "locals")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[o", function()
      move.goto_previous_start("@local.scope", "locals")
    end)
    vim.keymap.set({ "n", "v", "o" }, "[O", function()
      move.goto_previous_end("@local.scope", "locals")
    end)

    -- ;, and fFtT keymaps
    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

    vim.keymap.set({ "n", "v", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set(
      { "n", "v", "o" },
      ",",
      ts_repeat_move.repeat_last_move_opposite
    )

    vim.keymap.set(
      { "n", "v", "o" },
      "f",
      ts_repeat_move.builtin_f_expr,
      { expr = true }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      "F",
      ts_repeat_move.builtin_F_expr,
      { expr = true }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      "t",
      ts_repeat_move.builtin_t_expr,
      { expr = true }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      "T",
      ts_repeat_move.builtin_T_expr,
      { expr = true }
    )
  end,
}
