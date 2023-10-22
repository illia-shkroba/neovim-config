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
        ["<C-y>"] = telescope.add_arguments,
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
        ["<C-y>"] = telescope.add_arguments,
      },
    }
    local buffers_mappings = {
      n = {
        ["<C-r>"] = telescope.wipe_out_buffers,
      },
      i = {
        ["<C-r>"] = telescope.wipe_out_buffers,
      },
    }
    local find_files_mappings = {
      n = {
        ["<C-h>"] = telescope.hide_in_find_files,
        ["<C-s>"] = telescope.unhide_in_find_files,
        ["<C-r>"] = telescope.remove_files,
      },
      i = {
        ["<C-h>"] = telescope.hide_in_find_files,
        ["<C-s>"] = telescope.unhide_in_find_files,
        ["<C-r>"] = telescope.remove_files,
      },
    }
    local grep_string_mappings = {
      n = {
        ["<C-g>"] = telescope.search_globally_in_grep_string,
      },
      i = {
        ["<C-g>"] = telescope.search_globally_in_grep_string,
      },
    }
    require("telescope").setup {
      defaults = {
        scroll_strategy = "limit",
        mappings = global_mappings,
        history = {
          path = vim.fn.stdpath "data" .. "/telescope_history",
          limit = 1000,
        },
      },
      pickers = {
        buffers = {
          mappings = vim.tbl_deep_extend(
            "keep",
            buffers_mappings,
            global_mappings
          ),
        },
        find_files = {
          mappings = vim.tbl_deep_extend(
            "keep",
            find_files_mappings,
            global_mappings
          ),
        },
        grep_string = {
          mappings = vim.tbl_deep_extend(
            "keep",
            grep_string_mappings,
            global_mappings
          ),
        },
      },
      extensions = {
        coc = {
          theme = "ivy",
          prefer_locations = true,
        },
      },
    }
  end,
}
