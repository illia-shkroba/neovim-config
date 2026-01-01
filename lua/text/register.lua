local M = {}

local scratch = require "scratch"
local utils = require "utils"

function M.edit_register_prompt()
  vim.print "Enter register name: "
  local raw_register = utils.try(vim.fn.getcharstr)
  if not raw_register then
    return
  end

  local register = string.lower(raw_register)

  local buffer = scratch.retained()
  vim.api.nvim_buf_set_lines(
    buffer,
    0,
    1,
    false,
    vim.split(vim.fn.getreg(register), "\n")
  )

  vim.keymap.set({ "n" }, [[ZP]], function()
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
    desc = [[Paste scratch buffer's text into register "]] .. register,
  })
end

return M
