local buffer = require "buffer"
local scratch = require "scratch"
local scratch_register = require "scratch.register"

--- Yank lines matching (or not matching) the `/` register into `opts.register`.
--- Keeps `:g` semantics, but avoids the quadratic register append of `:g//yank A`.
---@param opts { invert: boolean, register: string }
---@return nil
local function global_yank(opts)
  if vim.fn.getreg "/" == "" then
    vim.notify("No previous regular expression", vim.log.levels.ERROR)
    return
  end

  vim.cmd(([[
    let g:global_yank = []
    silent %s//call add(g:global_yank, getline('.'))
    call setreg('%s', g:global_yank, 'l')
    unlet! g:global_yank
  ]]):format(opts.invert and "v" or "g", opts.register))
end

--- Yank every match of the `/` register in the current buffer into `opts.register`.
--- `matchbufline` reports each match separately, so a line matching twice yields two lines.
---@param opts { register: string }
---@return nil
local function global_yank_match(opts)
  if vim.fn.getreg "/" == "" then
    vim.notify("No previous regular expression", vim.log.levels.ERROR)
    return
  end

  vim.cmd(([[
    call setreg('%s', map(
      \ matchbufline(bufnr(), @/, 1, '$'),
      \ {_, val -> val.text}
      \ ), 'l')
  ]]):format(opts.register))
end

--- Yank text from the lines pointed at by the quickfix or location list into `opts.register`.
--- With `opts.match`, yanks each match of the `/` register rather than the whole line.
---@param opts { type: "quickfix" | "location", match: boolean, register: string }
---@return nil
local function list_yank(opts)
  if vim.fn.getreg "/" == "" then
    vim.notify("No previous regular expression", vim.log.levels.ERROR)
    return
  end

  local lists = { quickfix = "getqflist()", location = "getloclist(0)" }
  local collect = opts.match
      and [[extend(g:list_yank, map(matchbufline(
        \ g:list_yank_entry.bufnr,
        \ @/,
        \ g:list_yank_entry.lnum,
        \ g:list_yank_entry.lnum
        \ ), {_, val -> val.text}))]]
    or [[add(g:list_yank, getbufoneline(
      \ g:list_yank_entry.bufnr,
      \ g:list_yank_entry.lnum
      \ ))]]

  vim.cmd(([[
    let g:list_yank = []
    for g:list_yank_entry in %s
      if g:list_yank_entry.valid
        call bufload(g:list_yank_entry.bufnr)
        call %s
      endif
    endfor
    call setreg('%s', g:list_yank, 'l')
    unlet! g:list_yank g:list_yank_entry
  ]]):format(lists[opts.type], collect, opts.register))
end

---@param opts { staged: boolean }
---@return nil
local function git_diff_args(opts)
  local toplevel = vim
    .system({ "git", "rev-parse", "--show-toplevel" }, { text = true })
    :wait()
  if toplevel.code ~= 0 then
    vim.notify(toplevel.stderr, vim.log.levels.ERROR)
    return
  end
  local root = vim.trim(toplevel.stdout)

  local result = vim
    .system({
      "git",
      "-C",
      root,
      "diff",
      "--name-only",
      "--diff-filter=d",
      opts.staged and "--staged" or nil,
    }, { text = true })
    :wait()
  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  local names = vim.tbl_map(function(line)
    return vim.fn.fnameescape(root .. "/" .. line)
  end, vim.split(result.stdout, "\n", { trimempty = true }))

  local count = #names
  if count == 0 then
    vim.notify("No changed files", vim.log.levels.WARN)
    return
  end

  vim.cmd.arglocal { bang = true }
  pcall(vim.cmd.argdelete, "*")
  vim.cmd.argadd(names)
  vim.cmd.argdedupe()
  vim.cmd.first()

  vim.notify("Local args set to " .. count .. " file(s)", vim.log.levels.INFO)
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
  {
    flow = function()
      vim.cmd.argdo "diffoff"
    end,
    key = "argdo-diffoff",
    name = "argdo diffoff",
  },

  -- linewise
  {
    flow = function()
      local filetype = vim.bo.filetype
      local register_ = vim.fn.getreg "a"

      global_yank { invert = false, register = "a" }
      scratch_register.edit "a"
      vim.opt_local.filetype = filetype

      vim.fn.setreg("a", register_)
    end,
    key = "g-yank",
    name = "g//yank",
  },
  {
    flow = function()
      local filetype = vim.bo.filetype
      local register_ = vim.fn.getreg "a"

      global_yank { invert = true, register = "a" }
      scratch_register.edit "a"
      vim.opt_local.filetype = filetype

      vim.fn.setreg("a", register_)
    end,
    key = "v-yank",
    name = "v//yank",
  },
  {
    flow = function()
      local filetype = vim.bo.filetype
      local register_ = vim.fn.getreg "a"

      global_yank_match { register = "a" }
      scratch_register.edit "a"
      vim.opt_local.filetype = filetype

      vim.fn.setreg("a", register_)
    end,
    key = "g-yank-match",
    name = "g//yank match",
  },

  -- quickfix/location
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      list_yank { type = "quickfix", match = false, register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "cdo-yank",
    name = "cdo yank",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      list_yank { type = "location", match = false, register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "ldo-yank",
    name = "ldo yank",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      list_yank { type = "quickfix", match = true, register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "cdo-yank-match",
    name = "cdo yank match",
  },
  {
    flow = function()
      local register_ = vim.fn.getreg "a"

      list_yank { type = "location", match = true, register = "a" }
      scratch_register.edit "a"

      vim.fn.setreg("a", register_)
    end,
    key = "ldo-yank-match",
    name = "ldo yank match",
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
      vim.cmd [[cdo s//\=@s/ge]]
    end,
    key = "cdo-sub",
    name = [[cdo s//\=@s/ge]],
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
  {
    flow = function()
      local timestamp = vim.fn.strftime "%Y-%m-%dT%H:%M:%S%z"

      local buffer_ = scratch.open { liveness = "retained" }
      vim.opt_local.filetype = "sh"

      vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, {
        ([[GIT_COMMITTER_DATE='%s' git commit --date='%s' --no-edit --amend]]):format(
          timestamp,
          timestamp
        ),
      })
    end,
    key = "git-commit-date-amend",
    name = "Git commit --date --amend",
  },

  -- args
  {
    flow = function()
      git_diff_args { staged = false }
    end,
    key = "arglocal-git-unstaged",
    name = "arglocal git diff --name-only",
  },
  {
    flow = function()
      git_diff_args { staged = true }
    end,
    key = "arglocal-git-staged",
    name = "arglocal git diff --name-only --staged",
  },
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
