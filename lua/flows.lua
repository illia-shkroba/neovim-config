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

  -- git
  {
    flow = function()
      vim.cmd [[Git reset --soft HEAD~1]]
    end,
    name = "Git reset --soft HEAD~1",
  },
  {
    flow = function()
      vim.cmd [[Git reset --hard HEAD~1]]
    end,
    name = "Git reset --hard HEAD~1",
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
