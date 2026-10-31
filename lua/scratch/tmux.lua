local M = {}

local scratch = require "scratch"
local status = require "status"

---@param buffer_name string?
---@return integer?
function M.edit(buffer_name)
  local command = { "tmux", "show-buffer" }
  if buffer_name then
    vim.list_extend(command, { "-b", buffer_name })
  end

  local result = vim.system(command, { text = true }):wait()
  if result.code == 0 then
    local buffer_ = scratch.open()
    vim.opt_local.filetype = "markdown"
    vim.opt_local.statusline = "tmux " .. status.statusline

    vim.api.nvim_buf_set_lines(
      buffer_,
      0,
      1,
      false,
      vim.split(result.stdout, "\n")
    )

    return buffer_
  else
    vim.notify(
      "Command `"
        .. table.concat(command, " ")
        .. "` has failed with code "
        .. result.code
        .. " and stderr:\n"
        .. result.stderr,
      vim.log.levels.ERROR
    )
  end
end

return M
