return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require "telescope.actions"
    local telescope = require "plugins.telescope.actions"

    local global_mappings = {
      n = {
        ["<C-c>"] = actions.close,
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-e>"] = actions.smart_add_to_qflist + actions.open_qflist,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.results_scrolling_up,
        ["d"] = actions.preview_scrolling_down,
        ["u"] = actions.preview_scrolling_up,
      },
      i = {
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-e>"] = actions.smart_add_to_qflist + actions.open_qflist,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.results_scrolling_up,
      },
    }
    local find_files_mappings = {
      n = {
        ["<C-h>"] = telescope.toggle_hidden_in_find_files,
      },
      i = {
        ["<C-h>"] = telescope.toggle_hidden_in_find_files,
      },
    }
    require("telescope").setup {
      defaults = {
        history = {
          path = vim.fn.stdpath "data" .. "/telescope_history",
          limit = 1000,
        },
      },
      pickers = {
        buffers = { mappings = global_mappings },
        colorscheme = { mappings = global_mappings },
        find_files = {
          mappings = vim.tbl_deep_extend(
            "keep",
            find_files_mappings,
            global_mappings
          ),
        },
        grep_string = { mappings = global_mappings },
        live_grep = { mappings = global_mappings },
        marks = { mappings = global_mappings },
        oldfiles = { mappings = global_mappings },
        spell_suggest = { mappings = global_mappings },
        tags = { mappings = global_mappings },
      },
    }
  end,
}
