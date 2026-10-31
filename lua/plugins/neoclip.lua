return {
  "AckslD/nvim-neoclip.lua",
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    local scratch = require "scratch"
    local status = require "status"
    local window = require "window"

    ---@param selected { register_names: string[], entry: { contents: string[], filetype: string, regtype: string } }
    ---@return nil
    local function edit_entry(selected)
      local buffer_ = scratch.open()
      vim.opt_local.filetype = selected.entry.filetype
      vim.opt_local.statusline = "neoclip " .. status.statusline

      vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, selected.entry.contents)
    end

    require("neoclip").setup {
      keys = {
        fzf = {
          select = "default",
          paste = false,
          paste_behind = false,
          custom = {
            ["ctrl-t"] = function(selected)
              edit_entry(selected)
              vim.cmd.wincmd "T"
            end,
            ["ctrl-v"] = function(selected)
              edit_entry(selected)
              window.to_vertical(vim.api.nvim_get_current_win())
            end,
            ["ctrl-x"] = edit_entry,
          },
        },
      },
    }
  end,
}
