local M = {}

local scratch = require "scratch"
local status = require "status"

---@param register string
---@return nil
function M.edit_register(register)
  local buffer = scratch.retained()
  vim.opt_local.statusline = "@" .. register .. " " .. status.statusline

  vim.api.nvim_buf_set_lines(
    buffer,
    0,
    1,
    false,
    vim.split(vim.fn.getreg(register), "\n")
  )

  vim.keymap.set({ "n" }, [[cq]], function()
    vim.opt_local.statusline = "@" .. vim.v.register .. " " .. status.statusline
    vim.notify(
      [[Switched to register "]] .. vim.v.register,
      vim.log.levels.INFO
    )
  end, {
    buffer = buffer,
    desc = [[Switch to register without changing scratch buffer]],
  })
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
    desc = [[Paste scratch buffer's text into register]],
  })
end

return M
