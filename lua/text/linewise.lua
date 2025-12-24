local M = {}

local mark = require "mark"

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute(region, target)
  target = target or region.lines

  vim.api.nvim_buf_set_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    false,
    target
  )
end

---@param buffer_number integer
---@return nil
function M.remove_top_empty_line(buffer_number)
  -- After removing the top line, marks have to be shifted above by one due to
  -- the removed line.
  local function fix(m)
    return { line = m.line - 1, column = m.column }
  end
  mark.with_marks {
    buffer_number = buffer_number,
    marks = {
      {
        name = "[",
        fix = fix,
      },
      {
        name = "]",
        fix = fix,
      },
    },
    function_ = function()
      vim.api.nvim_buf_set_lines(buffer_number, 0, 1, false, {})
    end,
  }
end

return M
