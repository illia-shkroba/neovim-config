local scratch_register = require "scratch.register"

return {
  -- args
  {
    flow = function()
      vim.cmd [[silent cfdo arga]]
    end,
    name = "args: populate from quickfix",
  },
  {
    flow = function()
      vim.cmd [[silent lfdo arga]]
    end,
    name = "args: populate from location",
  },

  -- diff
  {
    flow = function()
      vim.cmd.windo "diffthis"
    end,
    name = "diff: all windows",
  },
  {
    flow = function()
      vim.cmd.windo "diffoff"
    end,
    name = "diff: undiff all windows",
  },

  -- file
  {
    flow = function()
      vim.cmd [[silent !chmod +x %]]
    end,
    name = "file: chmod +x",
  },

  -- git
  {
    flow = function()
      vim.cmd [[Git reset --soft HEAD~1]]
    end,
    name = "git: reset --soft HEAD~1",
  },
  {
    flow = function()
      vim.cmd [[Git reset --hard HEAD~1]]
    end,
    name = "git: reset --hard HEAD~1",
  },

  -- macro
  {
    flow = function()
      vim.fn.setreg("q", [[^"pP$"sp]])
    end,
    name = [[macro: "q surround line with ("p)prefix and ("s)uffix]],
  },
  {
    flow = function()
      vim.cmd [[argdo norm @q]]
    end,
    name = "macro: @q across args",
  },
  {
    flow = function()
      vim.cmd [[cdo norm @q]]
    end,
    name = "macro: @q across quickfix",
  },
  {
    flow = function()
      vim.cmd [[cfdo norm @q]]
    end,
    name = "macro: @q across quickfix files",
  },
  {
    flow = function()
      vim.cmd [[ldo norm @q]]
    end,
    name = "macro: @q across location",
  },
  {
    flow = function()
      vim.cmd [[lfdo norm @q]]
    end,
    name = "macro: @q across location files",
  },

  -- substitute
  {
    flow = function()
      vim.cmd [[cfdo %s//\=@s/gce]]
    end,
    name = [[sub: last search with "s across quickfix]],
  },
  {
    flow = function()
      vim.cmd [[argdo %s//\=@s/gce]]
    end,
    name = [[sub: last search with "s across args]],
  },
  {
    flow = function()
      vim.cmd [[windo %s//\=@s/gce]]
    end,
    name = [[sub: last search with "s across windows]],
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
    name = "qf: collect lines",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[silent ldo yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    name = "loc: collect lines",
  },
}
