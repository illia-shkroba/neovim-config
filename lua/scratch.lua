local M = {}

local buffer = require "buffer"
local region = require "text.region"
local status = require "status"
local tracked_region = require "text.tracked_region"
local utils = require "utils"

---@class ScratchInput
---@field liveness "retained"|"onetime"

---@param scratch_input ScratchInput
---@return integer
function M.open_with_current_cursor_as_origin(scratch_input)
  local origin_buffer = vim.api.nvim_get_current_buf()
  local origin_window = vim.api.nvim_get_current_win()

  local cursor = vim.api.nvim_win_get_cursor(origin_window)
  local line, column = cursor[1], cursor[2]

  local region_ = region.from {
    buffer_number = origin_buffer,
    line_begin = line,
    column_begin = column,
    line_end = line,
    column_end = column - 1,
    type_ = "char",
  }

  vim.api.nvim_buf_set_mark(origin_buffer, "[", line, column, {})
  vim.api.nvim_buf_set_mark(origin_buffer, "]", line, column - 1, {})

  local filetype = vim.bo.filetype

  local buffer_ = M.open(scratch_input)
  vim.opt_local.filetype = filetype
  vim.opt_local.statusline = status.buffer_statusline(region_.buffer_number)

  vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, region_.lines)

  M.bind_substitute_origin {
    binding_buffer_number = buffer_,
    origin_region = region_,
    origin_window_number = origin_window,
  }

  return buffer_
end

---@param scratch_input ScratchInput
---@return integer
function M.open(scratch_input)
  local events
  if scratch_input.liveness == "retained" then
    events = { "BufWinLeave" }
  elseif scratch_input.liveness == "onetime" then
    events = { "BufLeave" }
  end

  local listed = false
  local scratch = true
  local buffer_ = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer_)

  vim.cmd.clearjumps()

  vim.api.nvim_create_autocmd(events, {
    buffer = buffer_,
    callback = function()
      vim.schedule(function()
        utils.try(vim.cmd, [[bwipeout! ]] .. buffer_)
      end)
    end,
    once = true,
  })
  vim.keymap.set("n", [[ZM]], function()
    buffer.as_temporary(buffer_)
  end, {
    buffer = buffer_,
    desc = [[Make scratch window a temporary file]],
  })

  return buffer_
end

---@class SubstituteOriginInput
---@field binding_buffer_number integer
---@field origin_region Region
---@field origin_window_number integer

---@param substitute_origin_input SubstituteOriginInput
---@return nil
function M.bind_substitute_origin(substitute_origin_input)
  local tracked =
    tracked_region.from_region(substitute_origin_input.origin_region)

  ---@param lines table<integer, string>
  ---@return table<integer, string>
  local function normalize_substitution(lines)
    if #lines == 1 and lines[1] == "" then
      return {}
    else
      return lines
    end
  end

  ---@return nil
  local function fix_marks()
    vim.api.nvim_buf_set_mark(
      tracked.region.buffer_number,
      "[",
      tracked.region.line_begin,
      tracked.region.column_begin,
      {}
    )
    vim.api.nvim_buf_set_mark(
      tracked.region.buffer_number,
      "]",
      tracked.region.line_end,
      tracked.region.column_end,
      {}
    )
  end
  ---@return nil
  local function highlight()
    tracked_region.highlight(tracked)
  end

  vim.keymap.set("n", [[ZP]], function()
    local lines = normalize_substitution(
      vim.api.nvim_buf_get_lines(
        substitute_origin_input.binding_buffer_number,
        0,
        vim.api.nvim_buf_line_count(
          substitute_origin_input.binding_buffer_number
        ),
        true
      )
    )

    tracked = tracked_region.substitute(tracked, lines)

    fix_marks()
    highlight()
  end, {
    buffer = substitute_origin_input.binding_buffer_number,
    desc = "Paste scratch buffer's text back to the origin buffer in place of the selected lines by motion",
  })
  vim.keymap.set("n", [[ZD]], function()
    tracked = tracked_region.substitute(tracked, {})

    fix_marks()
  end, {
    buffer = substitute_origin_input.binding_buffer_number,
    desc = "Delete lines selected by motion in the origin buffer",
  })
  vim.keymap.set("n", [[ZE]], function()
    local lines = tracked_region.lines(tracked)

    vim.api.nvim_buf_set_lines(
      substitute_origin_input.binding_buffer_number,
      0,
      vim.api.nvim_buf_line_count(substitute_origin_input.binding_buffer_number),
      false,
      lines
    )
  end, {
    buffer = substitute_origin_input.binding_buffer_number,
    desc = "Read origin buffer lines selected by motion in place of the scratch buffer's text",
  })
  vim.keymap.set("n", [[ZO]], function()
    local origin_lines = tracked_region.lines(tracked)

    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

    local scratch_line, scratch_column = cursor[1], cursor[2]

    local origin_line = math.min(
      tracked.region.line_begin + scratch_line - 1,
      vim.api.nvim_buf_line_count(tracked.region.buffer_number)
    )

    local column_offset
    if tracked.region.type_ == "line" then
      column_offset = 0
    elseif tracked.region.type_ == "char" then
      column_offset = scratch_line == 1 and tracked.region.column_begin or 0
    else
      column_offset = tracked.region.column_begin
    end
    local line_offset = origin_line - tracked.region.line_begin + 1
    local line_text = origin_lines[line_offset <= 0 and #origin_lines or line_offset]
      or ""
    local origin_column =
      math.max(0, math.min(scratch_column + column_offset, #line_text - 1))

    vim.api.nvim_win_set_cursor(
      substitute_origin_input.origin_window_number,
      { origin_line, origin_column }
    )

    vim.api.nvim_set_current_win(substitute_origin_input.origin_window_number)

    fix_marks()
    highlight()
  end, {
    buffer = substitute_origin_input.binding_buffer_number,
    desc = "Enter origin window and restore '[ and '] marks",
  })

  vim.keymap.set("n", [[ZS]], [["sZXZO<C-w>m]], {
    buffer = substitute_origin_input.binding_buffer_number,
    remap = true,
    desc = [[Paste buffer's text into register "s, enter origin window and close scratch window]],
  })
  vim.keymap.set("n", [[ZW]], [[ZPZQ]], {
    buffer = substitute_origin_input.binding_buffer_number,
    remap = true,
    desc = "ZP ZQ",
  })
end

return M
