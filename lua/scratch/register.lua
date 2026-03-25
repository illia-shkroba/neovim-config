local M = {}

local register = require "text.register"
local scratch = require "scratch"
local status = require "status"

---@param register_ string
---@return nil
function M.edit(register_)
  register_ = register.normalize(register_)

  local buffer = scratch.open { liveness = "retained" }
  vim.opt_local.statusline = "@" .. register_ .. " " .. status.statusline

  vim.api.nvim_buf_set_lines(
    buffer,
    0,
    1,
    false,
    vim.split(vim.fn.getreg(register_), "\n")
  )

  vim.keymap.set({ "n" }, [[cr]], function()
    register_ = register.normalize(vim.v.register)
    vim.opt_local.statusline = "@" .. register_ .. " " .. status.statusline
    vim.notify([[Switched to register "]] .. register_, vim.log.levels.INFO)
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

    vim.fn.setreg(register_, table.concat(scratch_lines, "\n"))
    vim.notify([[Changed register "]] .. register_, vim.log.levels.INFO)
  end, {
    buffer = buffer,
    desc = [[Paste scratch buffer's text into register]],
  })
end

return M
