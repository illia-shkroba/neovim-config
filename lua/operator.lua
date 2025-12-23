local M = {}

local region = require "text.region"

---@param region_ Region
---@return string|nil
local function operatorfunc_(region_)
  return nil
end

local mode = {
  blocking = false,
  mode = "n",
}
local readonly = true
local force_type = nil

---@param region_ Region
---@return nil
local function restore_visual_selection(region_)
  local changed_begin = vim.api.nvim_buf_get_mark(region_.buffer_number, "[")
  local changed_end = vim.api.nvim_buf_get_mark(region_.buffer_number, "]")
  vim.api.nvim_buf_set_mark(
    region_.buffer_number,
    "<",
    changed_begin[1],
    changed_begin[2],
    {}
  )
  vim.api.nvim_buf_set_mark(
    region_.buffer_number,
    ">",
    changed_end[1],
    changed_end[2],
    {}
  )
end

---@param region_ Region
---@return nil
local function operator(region_)
  if #region_.lines == 0 then
    vim.notify("Nothing selected with operator.", vim.log.levels.WARN)
    return
  end

  local truncated_region = vim.deepcopy(region_)
  truncated_region.lines = region.truncate(region_)
  local output_chars = operatorfunc_(truncated_region)

  if output_chars == nil or #output_chars == 0 then
    vim.notify(
      "`operator`'s `expr` expects non-empty output from the provided `function_`."
        .. " Pass `readonly = true` to the `expr` if the `function_` only consumes input.",
      vim.log.levels.ERROR
    )
    return
  end

  local output_lines = vim.split(output_chars, "\n")
  region.substitute(region_, output_lines)

  if vim.tbl_contains({ "v", "V", "" }, mode.mode) then
    restore_visual_selection(region_)
  end
end

---@param region_ Region
---@return nil
local function operator_readonly(region_)
  local truncated_region = vim.deepcopy(region_)
  truncated_region.lines = region.truncate(region_)
  operatorfunc_(truncated_region)
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

  local region_ = {
    buffer_number = buffer_number,
    line_begin = line_begin,
    column_begin = column_begin,
    line_end = line_end,
    column_end = column_end,
    type_ = force_type or type_,
    lines = lines,
  }

  if readonly then
    operator_readonly(region_)
  else
    operator(region_)
  end
end

---@param opts {function_: fun(Region): (string|nil), readonly?: boolean, force_type?: string}
---@return fun(): string
function M.expr(opts)
  return function()
    vim.opt.operatorfunc = "v:lua.require'operator'.operatorfunc"
    mode = vim.api.nvim_get_mode()

    operatorfunc_ = opts.function_

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
