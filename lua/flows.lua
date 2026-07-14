local buffer = require "buffer"
local scratch_register = require "scratch.register"

return {
  -- diff
  {
    flow = function()
      vim.cmd.windo "diffthis"
    end,
    key = "diffthis",
    name = "windo diffthis",
  },
  {
    flow = function()
      vim.cmd.windo "diffoff"
    end,
    key = "diffoff",
    name = "windo diffoff",
  },

  -- delete
  {
    flow = function()
      vim.cmd [[v//delete _]]
    end,
    key = "v-delete",
    name = "v//delete _",
  },
  {
    flow = function()
      vim.cmd [[g//delete _]]
    end,
    key = "g-delete",
    name = "g//delete _",
  },
  {
    flow = function()
      vim.cmd [[g/^$/delete _]]
    end,
    key = "g-blank-delete",
    name = "g/^$/delete _",
  },

  -- register
  {
    flow = function()
      vim.fn.setreg("a", "")
    end,
    key = "clear-a",
    name = "let @a = ''",
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
    key = "cdo-yank",
    name = "cdo yank",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[silent ldo yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "ldo-yank",
    name = "ldo yank",
  },

  -- linewise
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[g//yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "g-yank",
    name = "g//yank",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      vim.fn.setreg("a", "")

      vim.cmd [[v//yank A]]
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "v-yank",
    name = "v//yank",
  },

  -- substitute
  {
    flow = function()
      vim.cmd [[cfdo %s//\=@s/gce]]
    end,
    key = "cfdo-sub",
    name = [[cfdo %s//\=@s/gce]],
  },
  {
    flow = function()
      vim.cmd [[argdo %s//\=@s/gce]]
    end,
    key = "argdo-sub",
    name = [[argdo %s//\=@s/gce]],
  },
  {
    flow = function()
      vim.cmd [[windo %s//\=@s/gce]]
    end,
    key = "windo-sub",
    name = [[windo %s//\=@s/gce]],
  },

  -- args
  {
    flow = function()
      vim.cmd [[silent cfdo arga]]
    end,
    key = "cfdo-arga",
    name = "cfdo arga",
  },
  {
    flow = function()
      vim.cmd [[silent lfdo arga]]
    end,
    key = "lfdo-arga",
    name = "lfdo arga",
  },

  -- file
  {
    flow = function()
      vim.cmd [[silent !chmod +x %]]
    end,
    key = "chmod-x",
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
    key = "split-temp",
    name = "sp `=tempname()`",
  },

  -- git
  {
    flow = function()
      vim.cmd [[Git pull]]
      vim.cmd [[Git submodule init]]
      vim.cmd [[Git submodule update]]
    end,
    key = "git-pull",
    name = "Git pull",
  },
  {
    flow = function()
      vim.cmd [[Git push --force-with-lease]]
    end,
    key = "git-push-force",
    name = "Git push --force-with-lease",
  },
  {
    flow = function()
      vim.cmd [[Git reflog]]
    end,
    key = "git-reflog",
    name = "Git reflog",
  },
  {
    flow = function()
      vim.cmd [[Git reset --soft HEAD~]]
    end,
    key = "git-reset-soft",
    name = "Git reset --soft HEAD~",
  },
  {
    flow = function()
      vim.cmd [[Git reset --mixed HEAD~]]
    end,
    key = "git-reset-mixed",
    name = "Git reset --mixed HEAD~",
  },
  {
    flow = function()
      vim.cmd [[Git reset --hard HEAD~]]
    end,
    key = "git-reset-hard",
    name = "Git reset --hard HEAD~",
  },
  {
    flow = function()
      vim.cmd [[Git stash list --patch]]
    end,
    key = "git-stash-list",
    name = "Git stash list --patch",
  },
  {
    flow = function()
      vim.cmd [[Git stash pop]]
    end,
    key = "git-stash-pop",
    name = "Git stash pop",
  },

  -- macro
  {
    flow = function()
      vim.fn.setreg("q", [[^"pP$"sp]])
    end,
    key = "surround-macro",
    name = [["q surround line with ("p)prefix and ("s)uffix]],
  },
  {
    flow = function()
      vim.cmd [[argdo norm @q]]
    end,
    key = "argdo-q",
    name = "argdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[cdo norm @q]]
    end,
    key = "cdo-q",
    name = "cdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[cfdo norm @q]]
    end,
    key = "cfdo-q",
    name = "cfdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[ldo norm @q]]
    end,
    key = "ldo-q",
    name = "ldo norm @q",
  },
  {
    flow = function()
      vim.cmd [[lfdo norm @q]]
    end,
    key = "lfdo-q",
    name = "lfdo norm @q",
  },
  {
    flow = function()
      vim.cmd [[g//norm @q]]
    end,
    key = "g-q",
    name = "g//norm @q",
  },
  {
    flow = function()
      vim.cmd [[v//norm @q]]
    end,
    key = "v-q",
    name = "v//norm @q",
  },
}
