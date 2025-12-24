local M = {}

-- Lift function to work with lines.
---@param f fun(string, ...): string
---@return fun(table, ...): table<integer, string>
function M.with_lines(f)
  return function(lines, ...)
    local xs = table.concat(lines, "\n")
    return vim.split(f(xs, ...), "\n")
  end
end

return M
