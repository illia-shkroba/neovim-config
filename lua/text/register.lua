local M = {}

local utils = require "utils"

function M.edit_register_prompt()
  vim.print "Enter register name: "
  local raw_register = utils.try(vim.fn.getcharstr)
  if not raw_register then
    return nil
  end

  -- Appending to a register is not allowed.
  local register = string.lower(raw_register)
  if not string.match(register, '[a-z"0-9-#=*+_/]') then
    vim.notify(
      'Unable to modify register "' .. raw_register,
      vim.log.levels.INFO
    )
    return nil
  end

  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd([[sbuffer ]] .. buffer .. [[ | normal "]] .. register .. [[p]])

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    buffer = buffer,
    callback = function()
      vim.cmd.normal([[go"]] .. register .. [[y$]])
      vim.notify([[Changed register "]] .. register, vim.log.levels.INFO)
      vim.schedule(function()
        vim.cmd([[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
  })
end

return M
