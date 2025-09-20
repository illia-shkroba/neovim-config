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
  vim.cmd.sbuffer(buffer)

  vim.api.nvim_paste(vim.fn.getreg(register), false, -1)

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    buffer = buffer,
    callback = function()
      local contents = table.concat(
        vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, true),
        "\n"
      )
      vim.fn.setreg(register, contents)
      vim.notify([[Changed register "]] .. register, vim.log.levels.INFO)

      vim.schedule(function()
        vim.cmd([[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
  })
end

return M
