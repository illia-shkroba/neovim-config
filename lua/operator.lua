local M = {}

local text = require "text"
local linewise = require "text.linewise"
local charwise = require "text.charwise"
local blockwise = require "text.blockwise"

---@param input_chars string
---@return string
local function operatorfunc_(input_chars)
  return input_chars
end

---@param input_lines table<integer, string>
---@return table<integer, string>
local function operatorfunc_lines_(input_lines)
  return input_lines
end

local mode = {
  blocking = false,
  mode = "n",
}
local readonly = true
local force_type = nil

---@param region Region
---@return nil
local function operator_line(region)
  local output_lines = operatorfunc_lines_(region.lines)
  linewise.substitute(region, output_lines)
end

---@param region Region
---@return nil
local function operator_char(region)
  local truncated_lines = charwise.truncate(region)
  local output_lines = operatorfunc_lines_(truncated_lines)
  charwise.substitute(region, output_lines)
end

---@param region Region
---@return nil
local function operator_block_with_line_ends(region)
  local truncated_lines = blockwise.truncate_with_line_ends(region)
  local output_lines = operatorfunc_lines_(truncated_lines)
  blockwise.substitute_with_line_ends(region, output_lines)
end

---@param region Region
---@return nil
local function operator_block_normal(region)
  local truncated_lines = blockwise.truncate_normal(region)
  local output_lines = operatorfunc_lines_(truncated_lines)
  blockwise.substitute_normal(region, output_lines)
end

---@param type_ "line"|"char"|"block"
---@param region Region
---@return nil
local function operator(type_, region)
  if #region.lines == 0 then
    vim.notify("Nothing selected with operator.", vim.log.levels.WARN)
    return
  end

  if type_ == "line" then
    operator_line(region)
  elseif type_ == "char" then
    operator_char(region)
  elseif type_ == "block" and text.ends_with_newline(region) then
    operator_block_with_line_ends(region)
  elseif type_ == "block" and not text.ends_with_newline(region) then
    operator_block_normal(region)
  end

  if vim.tbl_contains({ "v", "V", "" }, mode.mode) then
    local changed_begin = vim.api.nvim_buf_get_mark(region.buffer_number, "[")
    local changed_end = vim.api.nvim_buf_get_mark(region.buffer_number, "]")
    vim.api.nvim_buf_set_mark(
      region.buffer_number,
      "<",
      changed_begin[1],
      changed_begin[2],
      {}
    )
    vim.api.nvim_buf_set_mark(
      region.buffer_number,
      ">",
      changed_end[1],
      changed_end[2],
      {}
    )
  end
end

---@param type_ "line"|"char"|"block"
---@param region Region
---@return nil
local function operator_readonly(type_, region)
  local truncated_lines

  if type_ == "line" then
    truncated_lines = region.lines
  elseif type_ == "char" then
    truncated_lines = charwise.truncate(region)
  elseif type_ == "block" and text.ends_with_newline(region) then
    truncated_lines = blockwise.truncate_with_line_ends(region)
  elseif type_ == "block" and not text.ends_with_newline(region) then
    truncated_lines = blockwise.truncate_normal(region)
  end

  operatorfunc_(table.concat(truncated_lines, "\n"))
end

---@param type_ "line"|"char"|"block"
---@return nil
function M.operatorfunc(type_)
  local buffer_number = vim.api.nvim_get_current_buf()

  local begin = vim.api.nvim_buf_get_mark(buffer_number, "[")
  local line_begin, column_begin = begin[1], begin[2]

  local end_ = vim.api.nvim_buf_get_mark(buffer_number, "]")
  local line_end, column_end = end_[1], end_[2]

  local lines =
    vim.api.nvim_buf_get_lines(buffer_number, line_begin - 1, line_end, true)

  local region = {
    buffer_number = buffer_number,
    line_begin = line_begin,
    column_begin = column_begin,
    line_end = line_end,
    column_end = column_end,
    lines = lines,
  }

  local forced_type = force_type or type_

  if readonly then
    operator_readonly(forced_type, region)
  else
    operator(forced_type, region)
  end
end

---@param opts {function_: fun, readonly?: boolean, force_type?: string}
---@return fun(): string
function M.expr(opts)
  return function()
    vim.opt.operatorfunc = "v:lua.require'operator'.operatorfunc"
    mode = vim.api.nvim_get_mode()

    operatorfunc_ = opts.function_
    operatorfunc_lines_ = text.with_lines(opts.function_)

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
