local M = {}

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

function M.pick_with_leap(buf)
  require("leap").leap {
    targets = function()
      return get_targets(buf)
    end,
    action = function(target)
      target.pick:set_selection(target.pos[1] - 1)
    end,
  }
end

return M
