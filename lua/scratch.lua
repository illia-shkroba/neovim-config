local M = {}

local utils = require "utils"

---@class ScratchInput
---@field liveness "retained"|"onetime"

---@param scratch_input ScratchInput
---@return integer
function M.scratch(scratch_input)
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
  vim.keymap.set({ "n" }, [[ZR]], function()
    local register = vim.v.register:lower()
    local scratch_lines = vim.api.nvim_buf_get_lines(
      buffer,
      0,
      vim.api.nvim_buf_line_count(buffer),
      true
    )

    vim.fn.setreg(register, table.concat(scratch_lines, "\n"))
    vim.notify([[Changed register "]] .. register, vim.log.levels.INFO)
  end, {
    buffer = buffer,
    desc = [[Paste scratch buffer's text into register]],
  })
  vim.keymap.set({ "n" }, [[ZS]], function()
    local scratch_lines = vim.api.nvim_buf_get_lines(
      buffer,
      0,
      vim.api.nvim_buf_line_count(buffer),
      true
    )

    vim.fn.setreg("s", table.concat(scratch_lines, "\n"))
    vim.notify([[Changed register "s]], vim.log.levels.INFO)
  end, {
    buffer = buffer,
    desc = [[Paste scratch buffer's text into register "s]],
  })

  return buffer
end

return M
