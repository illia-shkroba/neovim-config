local M = {}

local utils = require "utils"

local function operator(input_chars)
  return input_chars
end

local function operator_line(operator_input)
  local end_of_file = operator_input.line_end == vim.api.nvim_buf_line_count(0)

  local input_chars = table.concat(operator_input.lines, "\n")
  local output_chars = operator(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  vim.cmd.normal "'[\"_d']"
  vim.api.nvim_put(output_lines, "l", end_of_file, false)
end

local function truncate_charwise(lines, column_begin, column_end)
  local truncated_lines = utils.deepcopy(lines)
  truncated_lines[#lines] = lines[#lines]:sub(1, column_end + 1)
  truncated_lines[1] = truncated_lines[1]:sub(column_begin + 1)
  return truncated_lines
end

local function operator_char(operator_input)
  local column_begin = operator_input.column_begin
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  local end_of_line = (column_end + 1) >= #lines[#lines]

  local truncated_lines = truncate_charwise(lines, column_begin, column_end)
  local input_chars = table.concat(truncated_lines, "\n")
  local output_chars = operator(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  vim.cmd.normal '`["_dv`]'
  vim.api.nvim_put(output_lines, "c", end_of_line, false)
end

local function truncate_blockwise_with_line_ends(lines, column_begin)
  local truncated_lines = {}
  for _, line in pairs(lines) do
    table.insert(truncated_lines, line:sub(column_begin + 1))
  end
  return truncated_lines
end

local function operator_block_with_line_ends(operator_input)
  local column_begin = operator_input.column_begin
  local line_end = operator_input.line_end
  local lines = operator_input.lines

  local end_of_file = line_end == vim.api.nvim_buf_line_count(0)

  local truncated_lines = truncate_blockwise_with_line_ends(lines, column_begin)
  local input_chars = table.concat(truncated_lines, "\n")
  local output_chars = operator(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  local put_lines = {}
  local n = math.min(#lines, #output_lines)
  for i = 1, n do
    table.insert(put_lines, lines[i]:sub(1, column_begin) .. output_lines[i])
  end
  for i = n + 1, #lines do
    table.insert(put_lines, lines[i]:sub(1, column_begin))
  end

  vim.cmd.normal "'[\"_d']"
  vim.api.nvim_put(put_lines, "l", end_of_file, false)
end

local function truncate_blockwise_normal(lines, column_begin, column_end)
  local truncated_lines = {}
  for _, line in pairs(lines) do
    table.insert(
      truncated_lines,
      line:sub(1, column_end + 1):sub(column_begin + 1)
    )
  end
  return truncated_lines
end

local function operator_block_normal(operator_input)
  local column_begin = operator_input.column_begin
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  local truncated_lines =
    truncate_blockwise_normal(lines, column_begin, column_end)
  local input_chars = table.concat(truncated_lines, "\n")
  local output_chars = operator(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  vim.cmd.normal '`["_d`]'
  vim.api.nvim_put(output_lines, "b", false, false)
end

local function operator_block(operator_input)
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  local ends_with_newline = (column_end + 1) > #lines[#lines]

  if ends_with_newline then
    operator_block_with_line_ends(operator_input)
  else
    operator_block_normal(operator_input)
  end
end

function M.operatorfunc(mode)
  local begin = vim.api.nvim_buf_get_mark(0, "[")
  local line_begin, column_begin = begin[1], begin[2]

  local end_ = vim.api.nvim_buf_get_mark(0, "]")
  local line_end, column_end = end_[1], end_[2]

  local operator_input = {
    line_begin = line_begin,
    column_begin = column_begin,
    line_end = line_end,
    column_end = column_end,
    lines = vim.api.nvim_buf_get_lines(
      vim.api.nvim_get_current_buf(),
      line_begin - 1,
      line_end,
      true
    ),
  }

  if mode == "line" then
    operator_line(operator_input)
  elseif mode == "char" then
    operator_char(operator_input)
  else
    operator_block(operator_input)
  end
end

function M.expr(f)
  return function()
    operator = f
    return [[g@]]
  end
end

return M
