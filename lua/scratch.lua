local M = {}

local utils = require "utils"

function M.retained()
  local origin_buffer = vim.api.nvim_get_current_buf()
  local begin = vim.api.nvim_buf_get_mark(0, "[")
  local line_begin = begin[1]

  local end_ = vim.api.nvim_buf_get_mark(0, "]")
  local line_end = end_[1]

  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer)

  vim.keymap.set({ "n" }, [[ZP]], function()
    local scratch_lines = vim.api.nvim_buf_get_lines(
      buffer,
      0,
      vim.api.nvim_buf_line_count(buffer),
      true
    )
    vim.api.nvim_buf_set_lines(
      origin_buffer,
      line_begin - 1,
      line_end,
      false,
      scratch_lines
    )
  end, {
    buffer = buffer,
    desc = "Paste scratch buffer's text back to the origin buffer in place of the selected lines by motion",
  })

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    buffer = buffer,
    callback = function()
      vim.schedule(function()
        utils.try(vim.cmd, [[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
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

  return buffer
end

return M
