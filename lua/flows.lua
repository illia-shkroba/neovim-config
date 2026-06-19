local buffer = require "buffer"
local scratch_register = require "scratch.register"

return {
  -- args
  {
    flow = function()
      vim.cmd [[silent cfdo arga]]
    end,
    name = "cfdo arga",
  },
  {
    flow = function()
      vim.cmd [[silent lfdo arga]]
    end,
    name = "lfdo arga",
  },
  {
    flow = function()
      vim.cmd [[sall]]
    end,
    name = "sall",
  },

  -- diff
  {
    flow = function()
      vim.cmd.windo "diffthis"
    end,
    name = "windo diffthis",
  },
  {
    flow = function()
      vim.cmd.windo "diffoff"
    end,
    name = "windo diffoff",
  },

  -- file
  {
    flow = function()
      vim.cmd [[silent !chmod +x %]]
    end,
    name = "!chmod +x %",
  },
  {
    flow = function()
      local listed = true
      local scratch = false
      local buffer_ = vim.api.nvim_create_buf(listed, scratch)

      vim.cmd.sbuffer(buffer_)
      buffer.as_temporary(buffer_)
    end,
    name = "sp `=tempname()`",
  },

  -- git
  {
    flow = function()
      vim.cmd [[Git pull]]
      vim.cmd [[Git submodule init]]
      vim.cmd [[Git submodule update]]
    end,
    name = "Git pull",
  },
  {
    flow = function()
      vim.cmd [[Git push --force-with-lease]]
    end,
    name = "Git push --force-with-lease",
  },
  {
    flow = function()
      vim.cmd [[Git reflog]]
    end,
    name = "Git reflog",
  },
  {
    flow = function()
      vim.cmd [[Git reset --soft HEAD~]]
    end,
    name = "Git reset --soft HEAD~",
  },
  {
    flow = function()
      vim.cmd [[Git reset --mixed HEAD~]]
    end,
    name = "Git reset --mixed HEAD~",
  },
  {
    flow = function()
      vim.cmd [[Git reset --hard HEAD~]]
    end,
    name = "Git reset --hard HEAD~",
  },
  {
    flow = function()
      vim.cmd [[Git stash list --patch]]
    end,
    name = "Git stash list --patch",
  },
  {
    flow = function()
      vim.cmd [[Git stash pop]]
    end,
    name = "Git stash pop",
  },

  -- macro
  {
    flow = function()
      vim.fn.setreg("q", [[^"pP$"sp]])
    end,
    name = [["q surround line with ("p)prefix and ("s)uffix]],
  },
  {
    flow = function()
      vim.cmd [[argdo norm @q]]
    end,
    name = "argdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[cdo norm @q]]
    end,
    name = "cdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[cfdo norm @q]]
    end,
    name = "cfdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[ldo norm @q]]
    end,
    name = "ldo norm @q",
  },
  {
    flow = function()
      vim.cmd [[lfdo norm @q]]
    end,
    name = "lfdo norm @q",
  },

  -- substitute
  {
    flow = function()
      vim.cmd [[cfdo %s//\=@s/gce]]
    end,
    name = [[cfdo %s//\=@s/gce]],
  },
  {
    flow = function()
      vim.cmd [[argdo %s//\=@s/gce]]
    end,
    name = [[argdo %s//\=@s/gce]],
  },
  {
    flow = function()
      vim.cmd [[windo %s//\=@s/gce]]
    end,
    name = [[windo %s//\=@s/gce]],
  },

  -- quickfix/location
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[silent cdo yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    name = "cdo yank A",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[silent ldo yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    name = "ldo yank A",
  },
}
