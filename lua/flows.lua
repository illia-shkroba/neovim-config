local scratch_register = require "scratch.register"

return {
  -- diff
  {
    flow = function()
      vim.cmd.windo "diffthis"
    end,
    name = "Diff all windows",
  },
  {
    flow = function()
      vim.cmd.windo "diffoff"
    end,
    name = "Undiff all windows",
  },

  -- file
  {
    flow = function()
      vim.cmd [[silent !chmod +x %]]
    end,
    name = "Make current file executable",
  },

  -- git
  {
    flow = function()
      vim.cmd [[Git reset --soft HEAD~1]]
    end,
    name = "git reset --soft HEAD~1",
  },

  -- macro
  {
    flow = function()
      vim.fn.setreg("q", [[^"pP$"sp]])
    end,
    name = [[Macro surrounding line with ("p)prefix and ("s)uffix]],
  },

  -- substitute
  {
    flow = function()
      vim.cmd [[cfdo %s//\=@s/gce]]
    end,
    name = [[Substitute last search with "s across quickfix]],
  },
  {
    flow = function()
      vim.cmd [[argdo %s//\=@s/gce]]
    end,
    name = [[Substitute last search with "s across args]],
  },
  {
    flow = function()
      vim.cmd [[windo %s//\=@s/gce]]
    end,
    name = [[Substitute last search with "s across windows]],
  },

  -- quickfix/location
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[cdo yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    name = "Collect quickfix lines",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[ldo yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    name = "Collect location lines",
  },
}
