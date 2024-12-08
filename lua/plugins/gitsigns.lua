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
        local opt_local = vim.opt_local

        -- Always show the signcolumn, otherwise it would shift the text each time
        -- diagnostics appeared/became resolved
        opt_local.signcolumn = "yes"

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
        end)

        set("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end)

        -- Actions
        set("n", "<leader>hs", gitsigns.stage_hunk)
        set("n", "<leader>hr", gitsigns.reset_hunk)
        set("v", "<leader>hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)
        set("v", "<leader>hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)
        set("n", "<leader>hS", gitsigns.stage_buffer)
        set("n", "<leader>hu", gitsigns.undo_stage_hunk)
        set("n", "<leader>hR", gitsigns.reset_buffer)
        set("n", "<leader>hp", gitsigns.preview_hunk)
        set("n", "<leader>hb", function()
          gitsigns.blame_line { full = true }
        end)
        set("n", "<leader>hd", gitsigns.diffthis)
        set("n", "<leader>hD", function()
          gitsigns.diffthis "~"
        end)

        -- Text object
        set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    }
  end,
}
