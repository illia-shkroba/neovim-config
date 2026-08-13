local buffer = require "buffer"
local scratch_register = require "scratch.register"

--- Yank lines matching (or not matching) the `/` register into `opts.register`.
--- Keeps `:g` semantics, but avoids the quadratic register append of `:g//yank A`.
---@param opts { invert: boolean, register: string }
local function global_yank(opts)
  vim.cmd(([[
    let g:global_yank = []
    silent %s//call add(g:global_yank, getline('.'))
    call setreg('%s', g:global_yank, 'l')
    unlet! g:global_yank
  ]]):format(opts.invert and "v" or "g", opts.register))
end

--- Yank the lines pointed at by the quickfix or location list into `opts.register`.
--- Reads the entries directly, since `:cdo` pays a window jump per entry.
---@param opts { type: "quickfix" | "location", register: string }
local function list_yank(opts)
  local lists = { quickfix = "getqflist()", location = "getloclist(0)" }

  vim.cmd(([[
    let g:list_yank = []
    for g:list_yank_entry in %s
      if g:list_yank_entry.valid
        call bufload(g:list_yank_entry.bufnr)
        call add(g:list_yank, getbufoneline(g:list_yank_entry.bufnr, g:list_yank_entry.lnum))
      endif
    endfor
    call setreg('%s', g:list_yank, 'l')
    unlet! g:list_yank g:list_yank_entry
  ]]):format(lists[opts.type], opts.register))
end

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

  -- linewise
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      global_yank { invert = false, register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "g-yank",
    name = "g//yank",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      global_yank { invert = true, register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "v-yank",
    name = "v//yank",
  },

  -- quickfix/location
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      list_yank { type = "quickfix", register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "cdo-yank",
    name = "cdo yank",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      list_yank { type = "location", register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "ldo-yank",
    name = "ldo yank",
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
      vim.cmd [[Git stash drop]]
    end,
    key = "git-stash-drop",
    name = "Git stash drop",
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
      vim.cmd [[windo norm @q]]
    end,
    key = "windo-q",
    name = "windo norm @q",
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

  -- register
  {
    flow = function()
      vim.fn.setreg("a", "")
    end,
    key = "clear-a",
    name = "let @a = ''",
  },
}
