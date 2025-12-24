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
local function restore_marks(region_)
  vim.api.nvim_buf_set_mark(
    region_.buffer_number,
    "[",
    region_.line_begin,
    region_.column_begin,
    {}
  )
  vim.api.nvim_buf_set_mark(
    region_.buffer_number,
    "]",
    region_.line_end,
    region_.column_end,
    {}
  )
  if vim.tbl_contains({ "v", "V", "" }, mode.mode) then
    vim.api.nvim_buf_set_mark(
      region_.buffer_number,
      "<",
      region_.line_begin,
      region_.column_begin,
      {}
    )
    vim.api.nvim_buf_set_mark(
      region_.buffer_number,
      ">",
      region_.line_end,
      region_.column_end,
      {}
    )
  end
end

---@param region_ Region
---@return nil
local function operator(region_)
  if #region_.lines == 0 then
    vim.notify("Nothing selected with operator.", vim.log.levels.WARN)
    return
  end

  local output_chars = operatorfunc_(region_)

  if output_chars == nil or #output_chars == 0 then
    vim.notify(
      "`operator`'s `expr` expects non-empty output from the provided `function_`."
        .. " Pass `readonly = true` to the `expr` if the `function_` only consumes input.",
      vim.log.levels.ERROR
    )
    return
  end

  local output_lines = vim.split(output_chars, "\n")
  local new_region = region.substitute(region_, output_lines)

  restore_marks(new_region)
end

---@param type_ "line"|"char"|"block"
---@return nil
function M.operatorfunc(type_)
  local buffer_number = vim.api.nvim_get_current_buf()

  local region_ = region.from_marks {
    buffer_number = buffer_number,
    mark_begin = "[",
    mark_end = "]",
    type_ = force_type or type_,
  }

  if readonly then
    operatorfunc_(region_)
  else
    operator(region_)
  end
end

---@param opts {function_: fun(Region): (string|nil), readonly?: boolean, force_type?: "line"|"char"|"block"}
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
