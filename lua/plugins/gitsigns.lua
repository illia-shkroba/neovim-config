return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged_enable = true,
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(buffer_number)
        -- Always show the signcolumn, otherwise it would shift the text each time
        -- diagnostics appeared/became resolved
        vim.opt_local.signcolumn = "yes"

        local gitsigns = require "gitsigns"

        local function set(mode, left, right, opts)
          opts = opts or {}
          opts.buffer = buffer_number
          vim.keymap.set(mode, left, right, opts)
        end

        -- Navigation
        set("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { desc = "Go to next hunk" })

        set("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { desc = "Go to previous hunk" })

        -- Actions
        set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
        set("v", "<leader>hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "Stage hunk" })
        set("v", "<leader>hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "Reset hunk" })
        set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        set(
          "n",
          "<leader>hu",
          gitsigns.undo_stage_hunk,
          { desc = "Undo stage hunk" }
        )
        set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        set("n", "<leader>hb", function()
          gitsigns.blame_line { full = true }
        end)

        -- Text object
        set(
          { "o", "v" },
          "ih",
          ":<C-U>Gitsigns select_hunk<CR>",
          { desc = "Hunk" }
        )
      end,
    }
  end,
}
