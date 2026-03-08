local M = {}

local utils = require "utils"

function M.retained()
  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer)

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    buffer = buffer,
    callback = function()
      vim.schedule(function()
        utils.try(vim.cmd, [[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
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

function M.onetime()
  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer)

  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    buffer = buffer,
    callback = function()
      vim.schedule(function()
        utils.try(vim.cmd, [[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
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
