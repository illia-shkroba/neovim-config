local M = {}

function M.shell()
  local listed = false
  local scratch = true
  local buffer = vim.api.nvim_create_buf(listed, scratch)
  vim.cmd.sbuffer(buffer)

  vim.opt_local.commentstring = "# %s"
  vim.opt_local.filetype = "sh"

  vim.keymap.set(
    { "n" },
    [[<CR>]],
    [[<Cmd>.w !bash<CR>]],
    { buffer = true, desc = "Run current line" }
  )
  vim.keymap.set({ "n" }, [[<leader><CR>]], function()
    vim.api.nvim_put({ vim.api.nvim_get_current_line() }, "l", true, false)
    vim.cmd ".!bash"
  end, { buffer = true, desc = "Paste current line's output below" })
  vim.keymap.set(
    { "v" },
    [[<CR>]],
    [[<Cmd>w !bash<CR>]],
    { buffer = true, desc = "Run selected lines" }
  )

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
