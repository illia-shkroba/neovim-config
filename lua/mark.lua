local M = {}

---@class FrozenMarks
---@field buffer_number integer
---@field marks table<integer, string>
---@field function_ fun(): nil

---@param frozen_marks FrozenMarks
---@return nil
function M.with_marks(frozen_marks)
  local marks_values = {}
  for _, mark in pairs(frozen_marks.marks) do
    marks_values[mark] =
      vim.api.nvim_buf_get_mark(frozen_marks.buffer_number, mark)
  end

  frozen_marks.function_()

  for mark, value in pairs(marks_values) do
    vim.api.nvim_buf_set_mark(
      frozen_marks.buffer_number,
      mark,
      value[1] - 1,
      value[2],
      {}
    )
  end
end

return M
