return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require "telescope.actions"
    local telescope = require "plugins.telescope.actions"
    local leap = require "plugins.telescope.leap"

    local global_mappings = {
      n = {
        ["<C-c>"] = actions.close,
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-e>"] = actions.smart_send_to_loclist + actions.open_loclist,
        ["<C-g><C-t>"] = actions.toggle_all,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.results_scrolling_up,
        ["<C-y>"] = telescope.add_arguments,
        ["<Esc>"] = false,
        ["<"] = actions.preview_scrolling_left,
        [">"] = actions.preview_scrolling_right,
        ["J"] = actions.preview_scrolling_down,
        ["K"] = actions.preview_scrolling_up,
        ["<C-s>"] = leap.pick_with_leap,
      },
      i = {
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-e>"] = actions.smart_send_to_loclist + actions.open_loclist,
        ["<C-g><C-t>"] = actions.toggle_all,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.results_scrolling_up,
        ["<C-y>"] = telescope.add_arguments,
        ["<C-s>"] = leap.pick_with_leap,
      },
    }
    local buffers_mappings = {
      n = {
        ["<C-z>"] = telescope.wipe_out_buffers,
      },
      i = {
        ["<C-z>"] = telescope.wipe_out_buffers,
      },
    }
    local find_files_mappings = {
      n = {
        ["<C-g><C-h>"] = telescope.hide_in_find_files,
        ["<C-g><C-g>"] = telescope.unhide_in_find_files,
        ["<C-z>"] = telescope.remove_files,
      },
      i = {
        ["<C-g><C-h>"] = telescope.hide_in_find_files,
        ["<C-g><C-g>"] = telescope.unhide_in_find_files,
        ["<C-z>"] = telescope.remove_files,
      },
    }
    local grep_string_mappings = {
      n = {
        ["<C-g><C-g>"] = telescope.search_globally_in_grep_string,
      },
      i = {
        ["<C-g><C-g>"] = telescope.search_globally_in_grep_string,
      },
    }
    local live_grep_mappings = {
      n = {
        ["<C-g><C-g>"] = telescope.search_globally_in_live_grep,
      },
      i = {
        ["<C-g><C-g>"] = telescope.search_globally_in_live_grep,
      },
    }
    require("telescope").setup {
      defaults = {
        cache_picker = { num_pickers = 10 },
        scroll_strategy = "limit",
        mappings = global_mappings,
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
        live_grep = {
          mappings = vim.tbl_deep_extend(
            "keep",
            live_grep_mappings,
            global_mappings
          ),
        },
      },
    }
  end,
}
