local M = {}

local function operatorfunc_input(input_chars)
  return input_chars
end

local readonly = true
local force_type = nil

local function empty_buffer(buffer_number)
  return vim.api.nvim_buf_line_count(buffer_number) == 1
    and vim.api.nvim_buf_get_lines(buffer_number, 0, 1, true)[1] == ""
end

local function operator_line(operator_input)
  local input_chars = table.concat(operator_input.lines, "\n")
  local output_chars = operatorfunc_input(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  local end_of_file = operator_input.line_end == vim.api.nvim_buf_line_count(0)
  vim.cmd.normal "'[\"_d']"

  local empty_buffer_before_put = empty_buffer(vim.api.nvim_get_current_buf())
  vim.api.nvim_put(output_lines, "l", end_of_file, false)

  -- Remove empty line on top of the file after put.
  if end_of_file and empty_buffer_before_put then
    vim.cmd.normal 'gg"_dd'
  end
end

local function truncate_charwise(lines, column_begin, column_end)
  if #lines == 0 then
    return lines
  end

  local truncated_lines = vim.deepcopy(lines)
  truncated_lines[#lines] = lines[#lines]:sub(1, column_end + 1)
  truncated_lines[1] = truncated_lines[1]:sub(column_begin + 1)
  return truncated_lines
end

local function ends_with_eol(operator_input)
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  if #lines > 0 then
    return (column_end + 1) >= #lines[#lines]
  else
    return false
  end
end

local function operator_char(operator_input)
  local column_begin = operator_input.column_begin
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  local truncated_lines = truncate_charwise(lines, column_begin, column_end)
  local input_chars = table.concat(truncated_lines, "\n")
  local output_chars = operatorfunc_input(input_chars)
  local output_lines = vim.split(output_chars, "\n")

  vim.cmd.normal '`["_dv`]'
  vim.api.nvim_put(output_lines, "c", ends_with_eol(operator_input), false)
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

  local empty_buffer_before_put = empty_buffer(vim.api.nvim_get_current_buf())
  vim.api.nvim_put(put_lines, "l", end_of_file, false)

  -- Remove empty line on top of the file after put.
  if end_of_file and empty_buffer_before_put then
    vim.cmd.normal 'gg"_dd'
  end
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

  if #lines > 0 then
    return column_end + 1 > #lines[#lines]
  else
    return false
  end
end

local function operator(type_, operator_input)
  local lines = operator_input.lines
  if #lines == 0 then
    vim.notify("Nothing selected with operator.", vim.log.levels.WARN)
    return
  end

  if type_ == "line" then
    operator_line(operator_input)
  elseif type_ == "char" then
    operator_char(operator_input)
  elseif type_ == "block" and ends_with_newline(operator_input) then
    operator_block_with_line_ends(operator_input)
  elseif type_ == "block" and not ends_with_newline(operator_input) then
    operator_block_normal(operator_input)
  end
end

local function operator_readonly(type_, operator_input)
  local column_begin = operator_input.column_begin
  local column_end = operator_input.column_end
  local lines = operator_input.lines

  local operatorfunc_input_lines

  if type_ == "line" then
    operatorfunc_input_lines = lines
  elseif type_ == "char" then
    operatorfunc_input_lines =
      truncate_charwise(lines, column_begin, column_end)
  elseif type_ == "block" and ends_with_newline(operator_input) then
    operatorfunc_input_lines =
      truncate_blockwise_with_line_ends(lines, column_begin)
  elseif type_ == "block" and not ends_with_newline(operator_input) then
    operatorfunc_input_lines =
      truncate_blockwise_normal(lines, column_begin, column_end)
  end

  operatorfunc_input(table.concat(operatorfunc_input_lines, "\n"))
end

function M.operatorfunc(type_)
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

  local forced_type = force_type == nil and type_ or force_type

  if readonly then
    operator_readonly(forced_type, operator_input)
  else
    operator(forced_type, operator_input)
  end
end

---@param opts {function_: fun, readonly?: boolean, force_type?: string}
---@return fun(): string
function M.expr(opts)
  return function()
    vim.opt.operatorfunc = "v:lua.require'operator'.operatorfunc"

    operatorfunc_input = opts.function_

    if opts.readonly == nil then
      readonly = false
    else
      readonly = opts.readonly
    end
    if opts.force_type == nil then
      force_type = nil
    else
      force_type = opts.force_type
    end

    return [[g@]]
  end
end

return M
