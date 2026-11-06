local M = {}

local register = require "text.register"
local scratch = require "scratch"
local status = require "status"

---@param register_ string
---@return nil
function M.edit(register_)
  register_ = register_:lower()

  local buffer = scratch.open()
  vim.opt_local.statusline = "@" .. register_ .. " " .. status.statusline

  ---@param name string
  ---@return Regtype
  local function fill(name)
    vim.api.nvim_buf_set_lines(
      buffer,
      0,
      -1,
      false,
      vim.fn.getreg(name, 1, true)
    )
    return vim.fn.getregtype(name):sub(1, 1)
  end

  local regtype = fill(register_)

  vim.keymap.set("n", [[ZP]], function()
    local scratch_lines = vim.api.nvim_buf_get_lines(
      buffer,
      0,
      vim.api.nvim_buf_line_count(buffer),
      true
    )

    register.put(register_, scratch_lines, regtype)
  end, {
    buffer = buffer,
    desc = [[Paste scratch buffer's text into register]],
  })
  vim.keymap.set("n", [[ZE]], function()
    local input_register = vim.v.register:lower()
    local target_register = input_register == [["]] and register_
      or input_register

    regtype = fill(target_register)
  end, {
    buffer = buffer,
    desc = "Read register in place of the scratch buffer's text",
  })
  vim.keymap.set("n", [[ZO]], function()
    local input_register = vim.v.register:lower()
    local target_register = input_register == [["]] and register_
      or input_register

    local scratch_lines = vim.api.nvim_buf_get_lines(
      buffer,
      0,
      vim.api.nvim_buf_line_count(buffer),
      true
    )

    register.put(target_register, scratch_lines, regtype)
    vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
  end, {
    buffer = buffer,
    desc = [[Paste scratch buffer's text into given register (default register if none given) and close scratch window]],
  })
end

return M
