return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require "telescope.actions"
    local telescope = require "plugins.telescope.actions"

    local function get_targets(buf)
      local pick = require("telescope.actions.state").get_current_picker(buf)
      local scroller = require "telescope.pickers.scroller"
      local wininfo = vim.fn.getwininfo(pick.results_win)[1]
      local top = math.max(
        scroller.top(
          pick.sorting_strategy,
          pick.max_results,
          pick.manager:num_results()
        ),
        wininfo.topline - 1
      )
      local bottom = wininfo.botline - 2 -- skip the current row
      local targets = {}
      for lnum = bottom, top, -1 do -- start labeling from the closest (bottom) row
        table.insert(
          targets,
          { wininfo = wininfo, pos = { lnum + 1, 1 }, pick = pick }
        )
      end
      return targets
    end

    local function pick_with_leap(buf)
      require("leap").leap {
        targets = function()
          return get_targets(buf)
        end,
        action = function(target)
          target.pick:set_selection(target.pos[1] - 1)
        end,
      }
    end

    require("telescope").setup {
      defaults = {
        mappings = {
          i = { ["<a-p>"] = pick_with_leap },
        },
      },
    }

    local global_mappings = {
      n = {
        ["<C-c>"] = actions.close,
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-e>"] = actions.smart_add_to_qflist + actions.open_qflist,
        ["<C-g><C-t>"] = actions.toggle_all,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.results_scrolling_up,
        ["<C-y>"] = telescope.add_arguments,
        ["<Esc>"] = false,
        ["<"] = actions.preview_scrolling_left,
        [">"] = actions.preview_scrolling_right,
        ["J"] = actions.preview_scrolling_down,
        ["K"] = actions.preview_scrolling_up,
        ["<C-g><C-s>"] = pick_with_leap,
        ["gs"] = pick_with_leap,
      },
      i = {
        ["<C-d>"] = actions.results_scrolling_down,
        ["<C-e>"] = actions.smart_add_to_qflist + actions.open_qflist,
        ["<C-g><C-t>"] = actions.toggle_all,
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.results_scrolling_up,
        ["<C-y>"] = telescope.add_arguments,
        ["<C-g><C-s>"] = pick_with_leap,
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
        ["<C-s>h"] = telescope.hide_in_find_files,
        ["<C-s>s"] = telescope.unhide_in_find_files,
        ["<C-z>"] = telescope.remove_files,
      },
      i = {
        ["<C-s>h"] = telescope.hide_in_find_files,
        ["<C-s>s"] = telescope.unhide_in_find_files,
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
