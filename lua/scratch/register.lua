local M = {}

local register = require "text.register"
local scratch = require "scratch"
local status = require "status"

---@param register_ string
---@return nil
function M.edit(register_)
  register_ = register_:lower()

  local buffer = scratch.open { liveness = "retained" }
  vim.opt_local.statusline = "@" .. register_ .. " " .. status.statusline

  vim.api.nvim_buf_set_lines(
    buffer,
    0,
    1,
    false,
    vim.split(vim.fn.getreg(register_), "\n")
  )

  vim.keymap.set("n", [[ZP]], function()
    local scratch_lines = vim.api.nvim_buf_get_lines(
      buffer,
      0,
      vim.api.nvim_buf_line_count(buffer),
      true
    )

    register.put(register_, scratch_lines)
  end, {
    buffer = buffer,
    desc = [[Paste scratch buffer's text into register]],
  })
  vim.keymap.set("n", [[ZW]], [[ZPZQ]], {
    buffer = buffer,
    remap = true,
    desc = "ZP ZQ",
  })
end

return M
