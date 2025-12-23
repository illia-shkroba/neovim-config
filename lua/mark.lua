local M = {}

---@class Mark
---@field buffer_number integer
---@field name string
---@field line integer
---@field column integer

---@class Position
---@field line integer
---@field column integer

---@class FrozenMarks
---@field buffer_number integer
---@field marks table<integer, {name: string, fix?: fun(Mark): Position}>
---@field function_ fun(): nil

---@param frozen_marks FrozenMarks
---@return nil
function M.with_marks(frozen_marks)
  local marks = {}
  local fixes = {}

  for _, mark_input in pairs(frozen_marks.marks) do
    local raw_mark =
      vim.api.nvim_buf_get_mark(frozen_marks.buffer_number, mark_input.name)

    table.insert(marks, {
      buffer_number = frozen_marks.buffer_number,
      name = mark_input.name,
      line = raw_mark[1],
      column = raw_mark[2],
    })
    fixes[mark_input.name] = mark_input.fix
  end

  frozen_marks.function_()

  for _, mark in pairs(marks) do
    local fix = fixes[mark.name]
      or function(m)
        return { line = m.line, column = m.column }
      end
    local position = fix(mark)
    vim.api.nvim_buf_set_mark(
      frozen_marks.buffer_number,
      mark.name,
      position.line,
      position.column,
      {}
    )
  end
end

return M
