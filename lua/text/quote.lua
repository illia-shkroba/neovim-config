local M = {}

---Pick the quote char of the latest-starting pair around `column`, else the
---next pair after it.
---@param line string
---@param column integer 0-based
---@return string
function M.nearest(line, column)
  local enclosing, enclosing_begin = nil, -1
  local next_, next_begin = nil, math.huge

  for _, quote in ipairs { '"', "'", "`" } do
    local columns = {}
    for i = 1, #line do
      if line:sub(i, i) == quote then
        local backslashes = 0
        while line:sub(i - 1 - backslashes, i - 1 - backslashes) == "\\" do
          backslashes = backslashes + 1
        end
        if backslashes % 2 == 0 then
          table.insert(columns, i - 1)
        end
      end
    end

    -- Quotes pair up in order like `i'`, unpaired quote shifts the pairs.
    for i = 1, #columns - 1, 2 do
      local begin, end_ = columns[i], columns[i + 1]
      if begin <= column and column <= end_ and begin > enclosing_begin then
        enclosing, enclosing_begin = quote, begin
      elseif column < begin and begin < next_begin then
        next_, next_begin = quote, begin
      end
    end
  end

  return enclosing or next_ or '"'
end

---@return string
function M.nearest_at_cursor()
  local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
  local column = cursor[2]
  return M.nearest(vim.api.nvim_get_current_line(), column)
end

return M
