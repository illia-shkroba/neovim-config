local M = {}

function M.shell()
  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer)

  vim.opt_local.filetype = "sh"

  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    buffer = buffer,
    callback = function()
      vim.schedule(function()
        vim.cmd([[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
  })
end

function M.onetime(lines)
  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.api.nvim_buf_set_lines(buffer, 0, 1, false, lines)
  vim.cmd.sbuffer(buffer)

  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    buffer = buffer,
    callback = function()
      vim.schedule(function()
        vim.cmd([[bwipeout! ]] .. buffer)
      end)
    end,
    once = true,
  })
end

return M
