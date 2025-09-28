local M = {}

local utils = require "utils"

local function operatorfunc_input(input_chars)
  return input_chars
end

local readonly = true

local function operator_line(operator_input)
  local input_chars = table.concat(operator_input.lines, "\n")
  local output_chars = operatorfunc_input(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  local end_of_file = operator_input.line_end == vim.api.nvim_buf_line_count(0)
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

  local truncated_lines = truncate_charwise(lines, column_begin, column_end)
  local input_chars = table.concat(truncated_lines, "\n")
  local output_chars = operatorfunc_input(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  local end_of_line = (column_end + 1) >= #lines[#lines]
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

  local truncated_lines = truncate_blockwise_with_line_ends(lines, column_begin)
  local input_chars = table.concat(truncated_lines, "\n")
  local output_chars = operatorfunc_input(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  local put_lines = {}
  local n = math.min(#lines, #output_lines)
  for i = 1, n do
    table.insert(put_lines, lines[i]:sub(1, column_begin) .. output_lines[i])
  end
  for i = n + 1, #lines do
    table.insert(put_lines, lines[i]:sub(1, column_begin))
  end

  local end_of_file = line_end == vim.api.nvim_buf_line_count(0)
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
  local output_chars = operatorfunc_input(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  vim.cmd.normal '`["_d`]'
  vim.api.nvim_put(output_lines, "b", false, false)
end

local function ends_with_newline(operator_input)
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  return column_end + 1 > #lines[#lines]
end

local function operator(mode, operator_input)
  if mode == "line" then
    operator_line(operator_input)
  elseif mode == "char" then
    operator_char(operator_input)
  elseif mode == "block" and ends_with_newline(operator_input) then
    operator_block_with_line_ends(operator_input)
  elseif mode == "block" and not ends_with_newline(operator_input) then
    operator_block_normal(operator_input)
  end
end

local function operator_readonly(mode, operator_input)
  local column_begin = operator_input.column_begin
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  local operatorfunc_input_lines

  if mode == "line" then
    operatorfunc_input_lines = lines
  elseif mode == "char" then
    operatorfunc_input_lines =
      truncate_charwise(lines, column_begin, column_end)
  elseif mode == "block" and ends_with_newline(operator_input) then
    operatorfunc_input_lines =
      truncate_blockwise_with_line_ends(lines, column_begin)
  elseif mode == "block" and not ends_with_newline(operator_input) then
    operatorfunc_input_lines =
      truncate_blockwise_normal(lines, column_begin, column_end)
  end

  operatorfunc_input(table.concat(operatorfunc_input_lines, "\n"))
end

function M.operatorfunc(mode)
  local begin = vim.api.nvim_buf_get_mark(0, "[")
  local line_begin, column_begin = begin[1], begin[2]

  local end_ = vim.api.nvim_buf_get_mark(0, "]")
  local line_end, column_end = end_[1], end_[2]

  local lines = vim.api.nvim_buf_get_lines(
    vim.api.nvim_get_current_buf(),
    line_begin - 1,
    line_end,
    true
  )

  local operator_input = {
    line_begin = line_begin,
    column_begin = column_begin,
    line_end = line_end,
    column_end = column_end,
    lines = lines,
  }

  if readonly then
    operator_readonly(mode, operator_input)
  else
    operator(mode, operator_input)
  end
end

function M.expr(f)
  return function()
    vim.opt.operatorfunc = "v:lua.require'operator'.operatorfunc"
    operatorfunc_input = f
    readonly = false
    return [[g@]]
  end
end

function M.expr_readonly(f)
  return function()
    vim.opt.operatorfunc = "v:lua.require'operator'.operatorfunc"
    operatorfunc_input = f
    readonly = true
    return [[g@]]
  end
end

return M
