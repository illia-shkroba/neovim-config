local M = {}

---@param lines table List of lines to get common prefix indent length on.
---@return integer
local function prefix_indent_length(lines)
  local min_indent = math.huge

  for _, line in pairs(lines) do
    if #line > 0 then
      local indent = 0

      for i = 1, #line do
        local char = line:sub(i, i)
        if vim.tbl_contains({ " ", "\r", "\t" }, char) then
          indent = indent + 1
        else
          break
        end
      end

      min_indent = math.min(min_indent, indent)
    end
  end

  return min_indent
end

---@param xs string Input string.
---@return string
function M.align(xs)
  local input_lines = vim.split(xs, "\n")

  local indent = prefix_indent_length(input_lines)
  if indent == math.huge then
    return xs
  end

  local offset = indent + 1
  local output_lines = {}

  for _, line in pairs(input_lines) do
    table.insert(output_lines, line:sub(offset))
  end

  return table.concat(output_lines, "\n")
end

return M
