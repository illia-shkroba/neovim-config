local M = {}

local tracked_region = require "text.tracked_region"
local utils = require "utils"

---@class ScratchInput
---@field liveness "retained"|"onetime"

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
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer)

  vim.api.nvim_create_autocmd(events, {
    buffer = buffer,
    callback = function()
      vim.schedule(function()
        utils.try(vim.cmd, [[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
  })
  vim.keymap.set("n", [[ZM]], function()
    vim.opt_local.buflisted = true
    vim.opt_local.buftype = ""
    vim.cmd [[file `=tempname()`]]
  end, {
    buffer = buffer,
    desc = [[Make scratch window a temporary file]],
  })

  return buffer
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
    vim.api.nvim_set_current_win(substitute_origin_input.origin_window_number)

    fix_marks()
  end, {
    buffer = substitute_origin_input.binding_buffer_number,
    desc = "Enter origin window and restore '[ and '] marks",
  })

  vim.keymap.set("n", [[ZW]], [[ZPZQ]], {
    buffer = substitute_origin_input.binding_buffer_number,
    remap = true,
    desc = "ZP ZQ",
  })
end

return M
