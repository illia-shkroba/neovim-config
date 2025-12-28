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
---@field marks table<integer, {
---  name: string,
---  adjustment?: (fun(Mark): Position),
---  on_error?: (fun(Mark): Position),
---}>
---@field function_ fun(): nil

---@param frozen_marks FrozenMarks
---@return nil
function M.with_marks(frozen_marks)
  local marks = {}
  local adjustments = {}
  local on_errors = {}

  for _, mark_input in pairs(frozen_marks.marks) do
    local raw_mark =
      vim.api.nvim_buf_get_mark(frozen_marks.buffer_number, mark_input.name)

    table.insert(marks, {
      buffer_number = frozen_marks.buffer_number,
      name = mark_input.name,
      line = raw_mark[1],
      column = raw_mark[2],
    })
    adjustments[mark_input.name] = mark_input.adjustment
    on_errors[mark_input.name] = mark_input.on_error
  end

  frozen_marks.function_()

  for _, mark in pairs(marks) do
    local function set_mark(position)
      return pcall(
        vim.api.nvim_buf_set_mark,
        frozen_marks.buffer_number,
        mark.name,
        position.line,
        position.column,
        {}
      )
    end

    local adjustment = adjustments[mark.name]
      or function(m)
        return { line = m.line, column = m.column }
      end
    local position = adjustment(mark)

    local success = set_mark(position)
    if not success then
      if on_errors[mark.name] ~= nil then
        local on_error = on_errors[mark.name]
        set_mark(on_error(mark))
      else
        vim.notify(
          "Caught an error while setting mark '"
            .. mark.name
            .. "' in the buffer "
            .. frozen_marks.buffer_number
            .. " to line "
            .. position.line
            .. " and column "
            .. position.column
            .. ". Consider providing `on_error` for the mark.",
          vim.log.levels.ERROR
        )
      end
    end
  end
end

return M
