-- `mapleader` must be set before loading `package-manager` because bindings can be set within plugins configs.
vim.g.mapleader = " "

require "package-manager"

local buffer = require "buffer"
local case = require "text.case"
local char = require "text.char"
local completion = require "plugins.fzf.pickers.completion"
local fzf = require "fzf-lua"
local list = require "list"
local mark = require "mark"
local operator = require "operator"
local path = require "path"
local pickers = require "plugins.fzf.pickers"
local recordings = require "recordings"
local region = require "text.region"
local register = require "text.register"
local scratch = require "scratch"
local scratch_register = require "scratch.register"
local status = require "status"
local utils = require "utils"
local window_picker = require "window-picker"

local location = list.location
local quickfix = list.quickfix

local function set_options()
  vim.cmd.filetype "on"

  vim.opt.allowrevins = true
  vim.opt.autoindent = true
  vim.opt.cindent = true
  vim.opt.complete = { ".", "w", "b", "u", "k" }
  vim.opt.completeopt = { "menuone", "popup" }
  vim.opt.cpoptions = "aABceFMs%>"
  vim.opt.cursorline = true
  vim.opt.encoding = "utf-8"
  vim.opt.expandtab = true
  vim.opt.formatoptions = "tcro/qnl1j"
  vim.opt.hidden = true
  vim.opt.hlsearch = true
  vim.opt.ignorecase = false
  vim.opt.inccommand = "split"
  vim.opt.incsearch = true
  vim.opt.jumpoptions = { "stack" }
  vim.opt.linebreak = true
  vim.opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
  vim.opt.modeline = true
  vim.opt.mouse = ""
  vim.opt.number = true
  vim.opt.omnifunc = "syntaxcomplete#Complete"
  vim.opt.path = { "**", "./**" }
  vim.opt.pumblend = 10
  vim.opt.pumborder = "rounded"
  vim.opt.pumheight = 10
  vim.opt.relativenumber = true
  vim.opt.shiftround = true
  vim.opt.shiftwidth = 2
  vim.opt.timeout = false

  -- Enable insertion of an indent on a next line after {, before } (with "O",
  -- and after 'cinwords'. Also, disables ">>" on lines starting with #.
  vim.opt.smartindent = true

  vim.opt.softtabstop = 2
  vim.opt.spell = true
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.statusline = status.statusline
  vim.opt.tabstop = 2
  vim.opt.tagcase = "smart"
  vim.opt.termguicolors = true
  vim.opt.undofile = true
  vim.opt.wildmenu = true
  vim.opt.wrapscan = false

  vim.g.netrw_banner = 0
  vim.g.no_python_maps = 1

  vim.cmd [[
    func! Thesaurus(findstart, base)
      if a:findstart
        return searchpos('\<', 'bnW', line('.'))[1] - 1
      endif
      let xdg_data_home = getenv("XDG_DATA_HOME")
      let data_home = expand(empty(xdg_data_home) ? "~/.local/share" : xdg_data_home)
      let dict_file = data_home .. "/dict.txt"
      let lines = readfile(dict_file)
      call filter(lines, {_, line -> stridx(line, a:base) == 0}) " Keep lines starting from `a:base`.
      return lines
    endfunc

    if exists('+thesaurusfunc')
      set thesaurusfunc=Thesaurus
    endif
  ]]
end
set_options()

local function set_bindings()
  -- args
  vim.keymap.set("n", [[<leader>A]], function()
    vim.cmd.argadd()
    vim.cmd.argdedupe()

    vim.notify("Added to args: " .. buffer.short_name(0), vim.log.levels.INFO)
  end, { desc = "argadd" })
  vim.keymap.set("n", [[<leader>ad]], function()
    local ok = pcall(vim.cmd.argdelete, "%")

    if not ok then
      vim.notify("Not in args: " .. buffer.short_name(0), vim.log.levels.WARN)
      return
    end

    vim.notify(
      "Removed from args: " .. buffer.short_name(0),
      vim.log.levels.INFO
    )
  end, { desc = "argdelete %" })
  vim.keymap.set("n", [[<leader>ae]], function()
    local ok = pcall(vim.cmd.argdelete, "*")

    if not ok then
      vim.notify("Args already empty", vim.log.levels.WARN)
      return
    end

    vim.notify("Args emptied", vim.log.levels.INFO)
  end, { desc = "argdelete *" })
  vim.keymap.set("n", [[<leader>ar]], vim.cmd.args, { desc = "args" })

  -- case
  vim.keymap.set(
    { "n", "v" },
    [[<leader>cF]],
    operator.expr { function_ = case.to_camel },
    { expr = true, desc = "Format selection to camel case" }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>cf]],
    operator.expr { function_ = case.to_snake },
    { expr = true, desc = "Format selection to snake case" }
  )

  -- cmdline
  vim.keymap.set("c", [[<C-j>]], [[<Down>]], {
    desc = "Go to next item matching command that was typed so far in cmdline",
  })
  vim.keymap.set("c", [[<C-k>]], [[<Up>]], {
    desc = "Go to previous item matching command that was typed so far in cmdline",
  })
  vim.keymap.set("c", [[<C-_>]], [[<Home>\<<End>\><Left><Left>]], {
    desc = [[Wrap current line with \< and \>]],
  })
  vim.keymap.set(
    "c",
    [[<C-s>]],
    [[s///gc<Left><Left><Left>]],
    { desc = "Populate cmdline with s///gc" }
  )

  -- cwd
  local function step_into_buffer_dir()
    local src_dir, dest_dir = vim.fn.getcwd(), vim.api.nvim_buf_get_name(0)
    local step = path.step_into(src_dir, dest_dir)
    if vim.fn.isdirectory(step) == 1 then
      return step
    else
      return vim.fs.dirname(step)
    end
  end

  vim.keymap.set("n", [[<leader>-d]], function()
    vim.cmd.cd "-"
  end, { desc = "cd -" })
  vim.keymap.set("n", [[<leader>-l]], function()
    vim.cmd.lcd "-"
  end, { desc = "lcd -" })
  vim.keymap.set("n", [[<leader>-t]], function()
    vim.cmd.tcd "-"
  end, { desc = "tcd -" })
  vim.keymap.set("n", [[<leader>CD]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd.cd ".."
    end
  end, { desc = "cd .." })
  vim.keymap.set("n", [[<leader>CL]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd.lcd ".."
    end
  end, { desc = "lcd .." })
  vim.keymap.set("n", [[<leader>CT]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd.tcd ".."
    end
  end, { desc = "tcd .." })
  vim.keymap.set(
    "n",
    [[<leader>cD]],
    [[<Cmd>execute "cd " .. system("dirname '" .. @% .. "'")<CR>]],
    { desc = "cd into current buffer's directory" }
  )
  vim.keymap.set(
    "n",
    [[<leader>cL]],
    [[<Cmd>execute "lcd " .. system("dirname '" .. @% .. "'")<CR>]],
    { desc = "lcd into current buffer's directory" }
  )
  vim.keymap.set(
    "n",
    [[<leader>cT]],
    [[<Cmd>execute "tcd " .. system("dirname '" .. @% .. "'")<CR>]],
    { desc = "tcd into current buffer's directory" }
  )
  vim.keymap.set("n", [[<leader>cd]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd.cd(step_into_buffer_dir())
    end
  end, { desc = "cd by one level into current buffer's directory" })
  vim.keymap.set("n", [[<leader>cl]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd.lcd(step_into_buffer_dir())
    end
  end, { desc = "lcd by one level into current buffer's directory" })
  vim.keymap.set("n", [[<leader>ct]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd.tcd(step_into_buffer_dir())
    end
  end, { desc = "tcd by one level into current buffer's directory" })

  -- delete
  vim.keymap.set(
    { "n", "v" },
    [[<leader>D]],
    [["_D]],
    { desc = [[Alias for: "_D]] }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>d]],
    [["_d]],
    { desc = [[Alias for: "_d]] }
  )

  -- expression
  vim.keymap.set("n", [[<leader>mb]], function()
    local command = { "tmux", "show-buffer" }

    local result = vim.system(command, { text = true }):wait()
    if result.code == 0 then
      local buffer_ = scratch.open { liveness = "retained" }
      vim.opt_local.statusline = "tmux " .. status.statusline

      vim.api.nvim_buf_set_lines(
        buffer_,
        0,
        1,
        false,
        vim.split(result.stdout, "\n")
      )
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
  end, { desc = "Paste tmux buffer's contents in a scratch window" })
  vim.keymap.set("n", [[<leader>md]], function()
    local buffer_ = scratch.open { liveness = "onetime" }
    vim.opt_local.statusline = "date " .. status.statusline
    vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, { os.date "%F" })
  end, { desc = "Paste current date in a scratch window" })
  vim.keymap.set("n", [[<leader>mP]], function()
    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local line = cursor[1]

    local buffer_ = scratch.open { liveness = "onetime" }
    vim.opt_local.statusline = "home-relative-line " .. status.statusline
    vim.api.nvim_buf_set_lines(
      buffer_,
      0,
      1,
      false,
      { vim.fn.expand "#:p:~" .. ":" .. line }
    )
  end, {
    desc = "Paste current buffer's home-relative path with cursor line in a scratch window",
  })
  vim.keymap.set("n", [[<leader>mp]], function()
    local buffer_ = scratch.open { liveness = "onetime" }
    vim.opt_local.statusline = "absolute " .. status.statusline
    vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, { vim.fn.expand "#:p" })
  end, { desc = "Paste current buffer's absolute path in a scratch window" })
  vim.keymap.set("n", [[<leader>mt]], function()
    local buffer_ = scratch.open { liveness = "onetime" }
    vim.opt_local.statusline = "filename " .. status.statusline
    vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, { vim.fn.expand "#:t" })
  end, { desc = "Paste current buffer's filename in a scratch window" })
  vim.keymap.set("n", [[<leader>mw]], function()
    local buffer_ = scratch.open { liveness = "onetime" }
    vim.opt_local.statusline = "cwd " .. status.statusline
    vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, { vim.fn.getcwd() })
  end, { desc = "Paste current working directory in a scratch window" })
  vim.keymap.set(
    "n",
    [[<leader>my]],
    function()
      local buffer_ = scratch.open { liveness = "onetime" }
      vim.opt_local.statusline = "cwd-relative " .. status.statusline
      vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, { vim.fn.expand "#" })
    end,
    { desc = "Paste current buffer's cwd-relative path in a scratch window" }
  )

  -- git
  vim.keymap.set(
    "n",
    [[<leader>hD]],
    [[<Cmd>vertical Gdiffsplit! HEAD<CR>]],
    { desc = "Show git diff with HEAD" }
  )
  vim.keymap.set(
    "n",
    [[<leader>hP]],
    [[<Cmd>update ++p | Git add --patch -- %<CR>]],
    { desc = "git add --patch" }
  )
  vim.keymap.set(
    "n",
    [[<leader>hd]],
    [[<Cmd>vertical Gdiffsplit!<CR>]],
    { desc = "Show git diff" }
  )
  vim.keymap.set(
    "n",
    [[<leader>ib]],
    [[<Cmd>Git blame<CR>]],
    { desc = "Git blame" }
  )
  vim.keymap.set("n", [[<leader>iw]], [[<Cmd>Gwrite<CR>]], { desc = "Gwrite" })
  vim.keymap.set(
    "n",
    [[<leader>il]],
    [[<Cmd>Git log<CR>]],
    { desc = "Git log" }
  )
  vim.keymap.set("n", [[<leader>is]], [[<Cmd>Git<CR>]], { desc = "Git" })

  -- indent
  local function align(size, region_)
    return vim.text.indent(
      size,
      table.concat(region_.lines, "\n"),
      { expandtab = 1 }
    )
  end

  vim.keymap.set(
    "n",
    [[<p]],
    operator.expr {
      function_ = function(region_)
        return align(0, region_)
      end,
      force_type = "line",
    },
    {
      expr = true,
      desc = "Align indentation",
    }
  )
  vim.keymap.set(
    "v",
    [[<p]],
    operator.expr {
      function_ = function(region_)
        return align(vim.v.count, region_)
      end,
      force_type = "line",
    },
    {
      expr = true,
      desc = "Align indentation",
    }
  )

  -- leap
  vim.keymap.set(
    { "n", "o" },
    [[<C-z>]],
    require("leap.remote").action,
    { desc = "Perform remote action with Leap" }
  )
  vim.keymap.set(
    { "n", "v", "o" },
    [[<C-s>]],
    "<Plug>(leap)",
    { silent = true, desc = "Leap" }
  )
  vim.keymap.set(
    "n",
    [[<C-q>]],
    "<Plug>(leap-from-window)",
    { silent = true, desc = "Leap to other windows" }
  )
  vim.keymap.set(
    "i",
    [[<C-s>]],
    "<Plug>(leap)",
    { silent = true, desc = "Leap" }
  )
  vim.keymap.set(
    "i",
    [[<C-q>]],
    "<Plug>(leap-from-window)",
    { silent = true, desc = "Leap to other windows" }
  )
  vim.keymap.set("i", [[<C-z>]], function()
    if vim.fn.pumvisible() == 1 then
      return completion.completion_expr()
    else
      return [[:lua require("leap.remote").action()<CR>]]
    end
  end, {
    expr = true,
    desc = "Display popup-menu completions using fzf when the menu is visible; otherwise, perform remote action with Leap",
  })

  -- move
  vim.keymap.set(
    "v",
    [[<C-j>]],
    [[:lua require("text.move").down(vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">"))<CR>gv]],
    { desc = "Shift down" }
  )
  vim.keymap.set(
    "v",
    [[<C-k>]],
    [[:lua require("text.move").up(vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">"))<CR>gv]],
    { desc = "Shift up" }
  )

  -- other
  local function pick_windows(opts)
    local windows = {}

    local window = window_picker.pick_window(opts)

    -- Handle `autoselect_one = true`.
    if window ~= nil then
      local current_tabpage = vim.api.nvim_get_current_tabpage()
      local all_windows = vim.api.nvim_tabpage_list_wins(current_tabpage)
      if #all_windows == 1 then
        return all_windows
      end
    end

    while window ~= nil do
      table.insert(windows, window)
      window = window_picker.pick_window(opts)
    end

    return windows
  end

  local function with_change_marks(buffer_number, function_)
    mark.with_marks {
      buffer_number = buffer_number,
      marks = {
        {
          name = "[",
          on_error = function()
            return { line = 1, column = 0 }
          end,
        },
        {
          name = "]",
          on_error = function()
            return {
              line = vim.api.nvim_buf_line_count(buffer_number),
              column = 0,
            }
          end,
        },
      },
      function_ = function_,
    }
  end

  vim.keymap.set("n", [[<leader>E]], function()
    local window = vim.api.nvim_get_current_win()
    vim.cmd.windo "wincmd J"
    vim.api.nvim_set_current_win(window)
    vim.cmd.wincmd "H"
  end, { desc = "Apply tall layout" })
  vim.keymap.set("n", [[<leader>J]], function()
    local picked_windows = pick_windows {
      filter_rules = { autoselect_one = true, include_current_win = true },
    }
    if #picked_windows == 0 then
      return
    end

    local selected_tabpage = vim.v.count
    local origin_tabpage_current_window = vim.api.nvim_get_current_win()

    -- Reversing is needed to put windows in order these were picked.
    local windows = vim.iter(picked_windows):rev():totable()

    if selected_tabpage == 0 then
      -- When a window is moved to a new tab page it's window options are preserved.
      vim.api.nvim_set_current_win(table.remove(windows))
      vim.cmd.wincmd "T"
    else
      local current_tabpage_id = vim.api.nvim_get_current_tabpage()
      vim.cmd.normal(selected_tabpage .. "gt")
      local selected_tabpage_id = vim.api.nvim_get_current_tabpage()

      if current_tabpage_id == selected_tabpage_id then
        vim.notify(
          "Cannot move windows to the current tab page.",
          vim.log.levels.WARN
        )
        return
      end
    end

    local target_tabpage_current_window = vim.api.nvim_get_current_win()

    for _, window in pairs(windows) do
      local buffer_ = vim.api.nvim_win_get_buf(window)
      vim.cmd.sbuffer(buffer_)

      -- Ensuring scratch windows `statusline`s are preserved.
      vim.opt_local.statusline = vim.wo[window].statusline

      vim.api.nvim_set_current_win(target_tabpage_current_window)
    end

    for _, window in pairs(windows) do
      vim.api.nvim_set_current_win(window)
      vim.cmd.wincmd "q"
    end

    if not vim.list_contains(picked_windows, origin_tabpage_current_window) then
      vim.api.nvim_set_current_win(origin_tabpage_current_window)
    end

    vim.api.nvim_set_current_win(target_tabpage_current_window)
  end, { desc = "Move picked windows to a new tab page" })
  vim.keymap.set("n", [[<leader>W]], function()
    with_change_marks(vim.api.nvim_get_current_buf(), function()
      local buffer_ = vim.api.nvim_buf_get_name(0)
      if path.remote(buffer_) then
        -- `++p` option causes an error when used with a "remote buffer".
        vim.cmd [[write]]
      else
        vim.cmd [[write ++p]]
      end
    end)
  end, { desc = "Like write ++p, but keep the [ and ] marks" })
  vim.keymap.set({ "n", "v" }, { [[<C-w>y]], [[<C-w><C-y>]] }, function()
    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

    local origin_line, origin_column = cursor[1], cursor[2]

    local expr = operator.expr {
      function_ = function(region_)
        local origin_window = vim.api.nvim_get_current_win()

        local filetype = vim.bo.filetype

        local buffer_ = scratch.open { liveness = "retained" }
        vim.opt_local.filetype = filetype
        vim.opt_local.statusline =
          status.buffer_statusline(region_.buffer_number)

        vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, region_.lines)

        -- Fix the cursor position as it was before spawning the scratch window
        local scratch_line = math.max(
          1,
          math.min(origin_line - region_.line_begin + 1, #region_.lines)
        )

        local column_offset
        if region_.type_ == "line" then
          column_offset = 0
        elseif region_.type_ == "char" then
          column_offset = scratch_line == 1 and region_.column_begin or 0
        else
          column_offset = region_.column_begin
        end
        local line_text = region_.lines[scratch_line] or ""
        local scratch_column =
          math.max(0, math.min(origin_column - column_offset, #line_text - 1))

        vim.api.nvim_win_set_cursor(
          vim.api.nvim_get_current_win(),
          { scratch_line, scratch_column }
        )

        scratch.bind_substitute_origin {
          binding_buffer_number = buffer_,
          origin_region = region_,
          origin_window_number = origin_window,
        }
      end,
      readonly = true,
    }
    return expr()
  end, { expr = true, desc = "Open a scratch window with selected lines" })
  vim.keymap.set("n", { [[<C-w>a]], [[<C-w><C-a>]] }, function()
    local window = window_picker.pick_window()
    if window ~= nil then
      vim.api.nvim_set_current_win(window)
    end
  end, { desc = "Pick window" })
  vim.keymap.set("n", [[<leader>hh]], function()
    vim.cmd.History()
  end, { desc = "History" })
  vim.keymap.set("n", { [[<C-w>e]], [[<C-w><C-e>]] }, function()
    scratch.open_with_current_cursor_as_origin { liveness = "retained" }
  end, { desc = "Empty scratch window" })
  vim.keymap.set("n", { [[<C-w>m]], [[<C-w><C-m>]] }, function()
    local last_accessed_window = vim.fn.winnr "#"
    if last_accessed_window > 0 then
      vim.cmd.wincmd(last_accessed_window .. " q")
    else
      vim.notify("No last accessed window.", vim.log.levels.INFO)
    end
  end, { desc = "Close last accessed window" })
  vim.keymap.set("n", { [[<C-w>u]], [[<C-w><C-u>]] }, function()
    local windows =
      pick_windows { filter_rules = { include_current_win = true } }
    if #windows == 0 then
      return
    end

    local current_window = vim.api.nvim_get_current_win()

    for _, window in pairs(windows) do
      vim.api.nvim_set_current_win(window)
      vim.cmd.wincmd "q"
    end

    if not vim.list_contains(windows, current_window) then
      vim.api.nvim_set_current_win(current_window)
    end
  end, { desc = "Quit picked window" })
  vim.keymap.set("n", { [[<C-w>yy]], [[<C-w><C-y><C-y>]] }, function()
    local origin_buffer = vim.api.nvim_get_current_buf()
    local origin_window = vim.api.nvim_get_current_win()

    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local line = cursor[1]

    local region_ = region.from {
      buffer_number = origin_buffer,
      line_begin = line,
      column_begin = 0,
      line_end = line - 1 + vim.v.count1,
      column_end = 0,
      type_ = "line",
    }

    vim.api.nvim_buf_set_mark(origin_buffer, "[", line, 0, {})
    vim.api.nvim_buf_set_mark(
      origin_buffer,
      "]",
      line - 1 + vim.v.count1,
      0,
      {}
    )

    local filetype = vim.bo.filetype

    local buffer_ = scratch.open { liveness = "retained" }
    vim.opt_local.filetype = filetype
    vim.opt_local.statusline = status.buffer_statusline(region_.buffer_number)

    vim.api.nvim_buf_set_lines(buffer_, 0, 1, false, region_.lines)

    scratch.bind_substitute_origin {
      binding_buffer_number = buffer_,
      origin_region = region_,
      origin_window_number = origin_window,
    }
  end, { desc = "Open a scratch window with [count] lines" })
  vim.keymap.set(
    "n",
    [[<leader>b]],
    [[<Cmd>bwipeout!<CR>]],
    { desc = "bwipeout!" }
  )
  vim.keymap.set("n", [[<leader>lo]], function()
    local buffer_ = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local line = cursor[1]

    vim.api.nvim_buf_set_lines(buffer_, line, -1, false, {})
    vim.api.nvim_buf_set_lines(buffer_, 0, line - 1, false, {})
  end, { desc = "Keep only the current line" })
  vim.keymap.set("n", [[<leader>v]], function()
    local mode = vim.fn.visualmode()
    if string.len(mode) == 0 then
      mode = "v"
    elseif mode == "" then
      mode = "<C-v>"
    end
    return "`[" .. mode .. "`]"
  end, {
    expr = true,
    desc = "Visually select previously changed or yanked text region",
  })
  vim.keymap.set("n", [[<leader>qQ]], [[<Cmd>qall!<CR>]], { desc = "qall!" })
  vim.keymap.set("n", [[<leader>qq]], [[<Cmd>qall<CR>]], { desc = "qall" })
  vim.keymap.set("n", [[<leader>qw]], [[<Cmd>xall<CR>]], { desc = "xall" })
  vim.keymap.set("n", [[<leader>e]], [[<Cmd>e!<CR>]], { desc = "e!" })
  vim.keymap.set("n", [[<leader>w]], function()
    with_change_marks(vim.api.nvim_get_current_buf(), function()
      local buffer_ = vim.api.nvim_buf_get_name(0)
      if path.remote(buffer_) then
        -- `++p` option causes an error when used with a "remote buffer".
        vim.cmd [[update]]
      else
        vim.cmd [[update ++p]]
      end
    end)
  end, { desc = "Like update ++p, but keep the [ and ] marks" })
  vim.keymap.set("n", [[<leader>z]], function()
    local buffer_ = vim.api.nvim_buf_get_name(0)
    if #buffer_ > 0 then
      vim.fs.rm(buffer_)
      vim.notify("Removed file: " .. buffer_, vim.log.levels.INFO)
    end
  end, { desc = "Remove current buffer's file" })
  vim.keymap.set("n", [[@"]], [[<Cmd>@"<CR>]], { desc = [[@"]] })
  vim.keymap.set("n", [[@+]], [[<Cmd>@+<CR>]], { desc = [[@+]] })
  vim.keymap.set({ "n", "v" }, [[<leader>']], [["_]], { desc = [["_]] })
  vim.keymap.set("i", [[<C-f>]], function()
    scratch.open_with_current_cursor_as_origin { liveness = "retained" }
  end, {
    desc = "Open a scratch window for insertion into current cursor position",
  })
  vim.keymap.set(
    "i",
    [[<C-g><C-s>]],
    vim.lsp.buf.signature_help,
    { desc = "Signature help" }
  )
  vim.keymap.set(
    "i",
    [[#]],
    [[<C-v>#]],
    { desc = "Prevent indent removal when 'smartindent' is on" }
  )

  -- overloads
  vim.keymap.set({ "n", "v" }, [["]], register.normalized_expr, {
    expr = true,
    desc = [[Same as "{register} binding but "unshifts" 1-0 and ? keys]],
  })
  vim.keymap.set(
    "n",
    [[<C-l>]],
    [[<Cmd>mode | nohlsearch | diffupdate | fclose!<CR>]],
    { desc = "<C-l> with :fclose!" }
  )
  vim.keymap.set("n", { [[<C-w>d]], [[<C-w><C-d>]] }, function()
    vim.diagnostic.open_float { border = "rounded" }
  end, { desc = "Show diagnostics under the cursor" })

  -- paste
  vim.keymap.set(
    "n",
    [[<leader>O]],
    [[<Cmd>execute "put! " .. v:register<CR>]],
    { desc = "put! v:register" }
  )
  vim.keymap.set(
    "n",
    [[<leader>o]],
    [[<Cmd>execute "put " .. v:register<CR>]],
    { desc = "put v:register" }
  )
  vim.keymap.set(
    "n",
    [[<leader>P]],
    [[<Cmd>execute "iput! " .. v:register<CR>]],
    { desc = "iput! v:register" }
  )
  vim.keymap.set(
    "n",
    [[<leader>p]],
    [[<Cmd>execute "iput " .. v:register<CR>]],
    { desc = "iput v:register" }
  )

  -- pickers
  vim.keymap.set(
    "n",
    [[<leader>+]],
    require "neoclip.fzf",
    { desc = "Open neoclip" }
  )
  vim.keymap.set(
    "n",
    [[<leader>=]],
    fzf.tmux_buffers,
    { desc = "Tmux buffers" }
  )
  vim.keymap.set(
    "n",
    [[<leader>;]],
    fzf.command_history,
    { desc = "Command history" }
  )
  vim.keymap.set("n", [[<leader>F]], pickers.grep_cword_by_filetype, {
    desc = "Search for word under the cursor in files with current buffer's extension",
  })
  vim.keymap.set("n", [[<leader>M]], fzf.marks, { desc = "List marks" })
  vim.keymap.set("n", "<leader>]", fzf.tagstack, { desc = "Tag-stack" })
  vim.keymap.set(
    { "n", "v" },
    [[<leader>:]],
    fzf.blines,
    { desc = "Grep current buffer or visually selected lines" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fA]],
    fzf.builtin,
    { desc = "All builtin pickers" }
  )
  vim.keymap.set("n", [[<leader>fW]], fzf.lines, { desc = "Grep buffers" })
  vim.keymap.set(
    "n",
    [[<leader>fC]],
    fzf.git_bcommits,
    { desc = "List commits affecting current buffer" }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>g]],
    operator.expr {
      function_ = pickers.grep_by_filetype,
      readonly = true,
    },
    {
      expr = true,
      desc = "Grep files with extension using search",
    }
  )
  vim.keymap.set(
    "n",
    [[<leader>G]],
    pickers.live_grep_by_filetype,
    { desc = "Grep files with extension" }
  )
  vim.keymap.set("n", [[<leader>fm]], function()
    pickers.recordings {
      register = "f",
      recordings = recordings,
    }
  end, { desc = [[List recordings and paste selected into "f register]] })
  vim.keymap.set(
    "n",
    [[<leader>fv]],
    pickers.directories,
    { desc = "List directories" }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>fw]],
    operator.expr {
      function_ = function(region_)
        fzf.lines { query = "'" .. table.concat(region_.lines, "\n") }
      end,
      readonly = true,
    },
    { expr = true, desc = "Search in buffers" }
  )
  vim.keymap.set("n", [[<leader>fa]], fzf.args, { desc = "Args" })
  vim.keymap.set("n", [[<leader>fb]], fzf.buffers, { desc = "List buffers" })
  vim.keymap.set(
    "n",
    [[<leader>fc]],
    fzf.lsp_references,
    { desc = "References" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fd]],
    fzf.diagnostics_workspace,
    { desc = "List diagnostics" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fi]],
    fzf.lsp_incoming_calls,
    { desc = "Incoming calls" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fo]],
    fzf.lsp_outgoing_calls,
    { desc = "Outgoing calls" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fE]],
    fzf.lsp_live_workspace_symbols,
    { desc = "Dynamic workspace symbols" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fD]],
    fzf.lsp_document_diagnostics,
    { desc = "List diagnostics for current buffer" }
  )
  vim.keymap.set("n", [[<leader>fF]], function()
    fzf.files { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) }
  end, { desc = "List files relative to current buffer" })
  vim.keymap.set(
    "n",
    [[<leader>fl]],
    fzf.loclist,
    { desc = "List location list" }
  )
  vim.keymap.set("n", [[<leader>fR]], function()
    fzf.oldfiles { cwd = vim.fn.getcwd() }
  end, { desc = "List old files under cwd" })
  vim.keymap.set(
    "n",
    [[<leader>fL]],
    fzf.loclist_stack,
    { desc = "List location lists" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fQ]],
    fzf.quickfix_stack,
    { desc = "List quickfix lists" }
  )
  vim.keymap.set("n", [[<leader>ft]], fzf.tabs, { desc = "List tabs" })
  vim.keymap.set(
    "n",
    [[<leader>fe]],
    fzf.treesitter,
    { desc = "List treesitter symbols for current buffer" }
  )
  vim.keymap.set("n", [[<leader>ff]], fzf.files, { desc = "List files" })
  vim.keymap.set(
    "n",
    [[<leader>fp]],
    fzf.filetypes,
    { desc = "List filetypes" }
  )
  vim.keymap.set("n", [[<leader>fq]], fzf.quickfix, { desc = "List quickfix" })
  vim.keymap.set("n", [[<leader>fr]], fzf.oldfiles, { desc = "List old files" })
  vim.keymap.set(
    "n",
    [[<leader>fs]],
    fzf.resume,
    { desc = "Resume most recent picker" }
  )
  vim.keymap.set("n", [[<leader>j]], fzf.jumps, { desc = "List jumplist" })
  vim.keymap.set("n", [[<leader>k]], fzf.changes, { desc = "List changes" })
  vim.keymap.set("n", [[<leader>x]], fzf.zoxide, { desc = "Open zoxide" })
  vim.keymap.set("n", [[<leader>K]], fzf.manpages, { desc = "List man pages" })
  vim.keymap.set("n", [[<leader>T]], fzf.tags, { desc = "List tags" })

  -- popup-menu
  vim.keymap.set("i", [[<C-k>]], function()
    return vim.fn.pumvisible() == 1 and [[<Up>]] or [[<C-k>]]
  end, { expr = true, desc = "Go up in popup-menu" })
  vim.keymap.set("i", [[<C-j>]], function()
    return vim.fn.pumvisible() == 1 and [[<Down>]] or [[<C-j>]]
  end, { expr = true, desc = "Go down in popup-menu" })

  -- quickfix/location
  vim.keymap.set("n", [[<leader>qA]], function()
    local index = quickfix.get_current_item_index()
    local item = quickfix.get_current_item()
    quickfix.remove_item(item)
    utils.try(vim.cmd, [[cc ]] .. index)
    if item.text then
      vim.notify(
        "Removed quickfix item: " .. vim.trim(item.text),
        vim.log.levels.INFO
      )
    end
  end, { desc = "Remove current quickfix item" })
  vim.keymap.set("n", [[<leader>lA]], function()
    local index = location.get_current_item_index()
    local item = location.get_current_item()
    location.remove_item(item)
    utils.try(vim.cmd, [[ll ]] .. index)
    if item.text then
      vim.notify(
        "Removed location item: " .. vim.trim(item.text),
        vim.log.levels.INFO
      )
    end
  end, { desc = "Remove current location item" })

  vim.keymap.set("n", [[<leader>qX]], function()
    quickfix.reset()
    vim.notify(
      "Removed all quickfix items: " .. quickfix.get_title(),
      vim.log.levels.INFO
    )
  end, { desc = "Remove all quickfix items" })
  vim.keymap.set("n", [[<leader>lX]], function()
    location.reset()
    vim.notify(
      "Removed all location items: " .. location.get_title(),
      vim.log.levels.INFO
    )
  end, { desc = "Remove all location items" })

  vim.keymap.set("n", [[<leader>qa]], function()
    quickfix.add_item(list.create_current_position_item())
    vim.cmd.clast()
  end, { desc = "Add current line as quickfix item" })
  vim.keymap.set("n", [[<leader>la]], function()
    location.add_item(list.create_current_position_item())
    vim.cmd.llast()
  end, { desc = "Add current line as location item" })

  vim.keymap.set(
    "n",
    [[<leader>qe]],
    vim.diagnostic.setqflist,
    { desc = "Load diagnostic to quickfix list" }
  )
  vim.keymap.set(
    "n",
    [[<leader>le]],
    vim.diagnostic.setloclist,
    { desc = "Load diagnostic to location list" }
  )

  vim.keymap.set(
    "n",
    [[<leader>qi]],
    vim.lsp.buf.incoming_calls,
    { desc = "Incoming calls" }
  )
  vim.keymap.set(
    "n",
    [[<leader>qo]],
    vim.lsp.buf.outgoing_calls,
    { desc = "Outgoing calls" }
  )

  vim.keymap.set(
    { "n", "o" },
    [[<leader>qj]],
    [[<Cmd>execute v:count1 .. 'cbelow'<CR>]],
    { desc = "cbelow" }
  )
  vim.keymap.set(
    { "n", "o" },
    [[<leader>lj]],
    [[<Cmd>execute v:count1 .. 'lbelow'<CR>]],
    { desc = "lbelow" }
  )
  vim.keymap.set(
    { "n", "o" },
    [[<leader>qk]],
    [[<Cmd>execute v:count1 .. 'cabove'<CR>]],
    { desc = "cabove" }
  )
  vim.keymap.set(
    { "n", "o" },
    [[<leader>lk]],
    [[<Cmd>execute v:count1 .. 'labove'<CR>]],
    { desc = "labove" }
  )

  vim.keymap.set("n", [[<leader>qx]], function()
    local name = utils.try(vim.fn.input, "Enter quickfix list: ")
    if name then
      quickfix.create(name)
    end
  end, { desc = "Create new quickfix list" })
  vim.keymap.set("n", [[<leader>lx]], function()
    local name = utils.try(vim.fn.input, "Enter location list: ")
    if name then
      location.create(name)
    end
  end, { desc = "Create new location list" })

  local function dump_list(current_list)
    local dumped = current_list.dump()
    if #dumped > 0 then
      local title = current_list.get_title()

      if utils.try(vim.cmd.drop, title) == nil then
        -- Buffer named `title` __is not__ available.
        local buffer_ = vim.api.nvim_create_buf(true, false)
        vim.cmd.drop(buffer_)
        vim.cmd.file(current_list.get_title())
      else
        -- Buffer named `title` __is__ available.
        -- No need to open it since it was opened with `drop` already.
      end

      local buffer_ = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buffer_, 0, -1, false, dumped)
      vim.opt_local.filetype = "sh"
    end
  end

  local function load_list(current_list, buffer_)
    local title = current_list.get_title()
    if #title == 0 then
      title = vim.api.nvim_buf_get_name(buffer_)
      current_list.set_title(title)
    end
    current_list.reset()
    current_list.add_from_buffer(buffer_)
    vim.notify(
      "Load list from the current buffer: " .. title,
      vim.log.levels.INFO
    )
  end

  vim.keymap.set("n", [[<leader>qd]], function()
    dump_list(quickfix)
  end, { desc = "Dump quickfix list to a buffer" })
  vim.keymap.set("n", [[<leader>ql]], function()
    load_list(quickfix, vim.api.nvim_get_current_buf())
  end, { desc = "Load quickfix list from the current buffer" })
  vim.keymap.set("n", [[<leader>ld]], function()
    dump_list(location)
  end, { desc = "Dump location list to a buffer" })
  vim.keymap.set("n", [[<leader>ll]], function()
    load_list(location, vim.api.nvim_get_current_buf())
  end, { desc = "Load location list from the current buffer" })

  -- register
  vim.keymap.set("n", [[<leader>X]], function()
    scratch_register.edit(vim.v.register)
  end, { desc = "Edit register in a buffer" })
  vim.keymap.set("n", [[ZX]], function()
    local register_ = vim.v.register:lower()

    local buffer_ = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(
      buffer_,
      0,
      vim.api.nvim_buf_line_count(buffer_),
      true
    )

    register.put(register_, lines)
  end, {
    desc = "Paste buffer's text into register",
  })
  vim.keymap.set("n", [[ZS]], function()
    local last_accessed_window = vim.fn.winnr "#"
    return last_accessed_window > 0 and [["sZX<C-w>p<C-w>m]] or [["sZXZQ]]
  end, {
    expr = true,
    remap = true,
    desc = [[Paste buffer's text into register "s, and close window]],
  })

  -- search
  local function lvimgrep_current_buffer()
    if vim.api.nvim_buf_get_name(0) == "" then
      vim.notify(
        "Cannot call `lvimgrep` in unnamed buffer.",
        vim.log.levels.WARN
      )
      return
    end

    vim.cmd [[lvimgrep//gj %]]
    vim.opt.hlsearch = true
  end

  ---@param region_ Region
  ---@return nil
  local function put_region_to_search_register(region_)
    local esc_lines = vim
      .iter(region_.lines)
      :map(function(v)
        return vim.fn.escape(v, [[\]])
      end)
      :totable()
    local search = [[\V]] .. table.concat(esc_lines, [[\n]])

    vim.fn.setreg("/", search)
    vim.fn.histadd("/", search)
    vim.opt.hlsearch = true
  end

  vim.keymap.set("n", [[<leader>#]], function()
    return "?" .. vim.fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true, desc = "Same as #, but without \\< and \\>" })
  vim.keymap.set("n", [[<leader>*]], function()
    return "/" .. vim.fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true, desc = "Same as *, but without \\< and \\>" })
  vim.keymap.set("n", [[<leader>L]], function()
    local buffer_ = vim.api.nvim_get_current_buf()
    if buffer.type_(buffer_) == "scratch" then
      buffer.as_temporary(buffer_)
    end

    lvimgrep_current_buffer()
  end, { desc = "lvimgrep//gj %" })
  vim.keymap.set(
    { "n", "v" },
    [[<leader>/]],
    operator.expr {
      function_ = put_region_to_search_register,
      readonly = true,
    },
    { expr = true, desc = "Set selection to / register" }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>?]],
    operator.expr {
      function_ = function(region_)
        if buffer.type_(region_.buffer_number) == "scratch" then
          buffer.as_temporary(region_.buffer_number)
        end

        put_region_to_search_register(region_)
        lvimgrep_current_buffer()
      end,
      readonly = true,
    },
    {
      expr = true,
      desc = "Set selection to / register and then `lvimgrep//gj %`",
    }
  )
  vim.keymap.set(
    "v",
    [[<leader>#]],
    operator.expr {
      function_ = function(region_)
        vim.fn.setreg("/", table.concat(region_.lines, "\n") .. "\\c")
        vim.v.searchforward = false
        vim.cmd.normal "n"
      end,
      readonly = true,
    },
    { expr = true, desc = "Same as #, but without \\< and \\>" }
  )
  vim.keymap.set(
    "v",
    [[<leader>*]],
    operator.expr {
      function_ = function(region_)
        vim.fn.setreg("/", table.concat(region_.lines, "\n") .. "\\c")
        vim.v.searchforward = true
        vim.cmd.normal "n"
      end,
      readonly = true,
    },
    { expr = true, desc = "Same as *, but without \\< and \\>" }
  )

  -- surround
  vim.keymap.set("i", "<C-b>", "<Plug>(nvim-surround-insert)", {
    desc = "Add a surrounding pair around the cursor (insert mode)",
  })
  vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {
    desc = "Add a surrounding pair around a motion (normal mode)",
  })
  vim.keymap.set("v", "<C-b>", "<Plug>(nvim-surround-visual)", {
    desc = "Add a surrounding pair around a visual selection",
  })
  vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {
    desc = "Delete a surrounding pair",
  })
  vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {
    desc = "Change a surrounding pair",
  })

  -- tabs
  vim.keymap.set(
    "n",
    [[<leader>tc]],
    [[<Cmd>tabclose<CR>]],
    { desc = "Close tab" }
  )
  vim.keymap.set(
    "n",
    [[<leader>to]],
    [[<Cmd>tabonly<CR>]],
    { desc = "Focus tab" }
  )
  vim.keymap.set("n", [[<leader>tw]], function()
    if #vim.api.nvim_list_tabpages() == 1 then
      vim.cmd.xall()
    else
      vim.cmd.windo "update"
      vim.cmd.tabclose()
    end
  end, { desc = "Update tab's buffers and close" })
  vim.keymap.set("n", [[<leader>tT]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd "-tabmove"
    end
  end, { desc = "Move tab left" })
  vim.keymap.set("n", [[<leader>tt]], function()
    for _ = 1, vim.v.count1 do
      vim.cmd "+tabmove"
    end
  end, { desc = "Move tab right" })

  -- tags
  vim.keymap.set("n", [[<leader>tg]], function()
    local language = vim.bo.filetype
    return [[:!ctags -R --languages=]] .. language .. [[ .]]
  end, { expr = true, desc = "Generate tags" })

  -- text manipulation
  vim.keymap.set(
    { "n", "v" },
    [[<leader>ta]],
    operator.expr { function_ = char.append_prompt },
    {
      expr = true,
      desc = "Append character",
    }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>tp]],
    operator.expr { function_ = char.prepend_prompt },
    {
      expr = true,
      desc = "Prepend character",
    }
  )
  vim.keymap.set(
    "n",
    [[<leader>cs]],
    [[<Cmd>keeppatterns %substitute/\s\+$//gc<CR>]],
    { desc = "Remove trailing whitespaces" }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>S]],
    [[<Cmd>%substitute//\=@s/gc<CR>]],
    {
      desc = [[Substitute with the contents of "s register]],
    }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>s]],
    operator.expr { function_ = char.substitute_prompt },
    {
      expr = true,
      desc = "Substitute character",
    }
  )
  vim.keymap.set("n", [[<leader>tf]], function()
    local window = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(window)

    vim.cmd.normal [[gqal]]

    utils.try(vim.api.nvim_win_set_cursor, window, cursor)
  end, { desc = "Format the buffer" })

  -- text objects
  vim.keymap.set(
    "o",
    [[<C-q>]],
    [[V<C-s>]],
    { remap = true, desc = "Leap select linewise" }
  )
  vim.keymap.set(
    "o",
    "a%",
    ":<C-U>execute 'normal v' .. v:count1 .. 'a%'<CR>",
    { desc = "Missing text object for a% from matchit" }
  )
  vim.keymap.set({ "o", "v" }, "a;", function()
    return "a" .. vim.fn.getcharsearch().char
  end, { expr = true, desc = "Around last search char" })
  vim.keymap.set({ "o", "v" }, "aa", "a<", { desc = "a<" })
  vim.keymap.set({ "o", "v" }, "ar", "a[", { desc = "a[" })
  vim.keymap.set(
    { "o", "v" },
    "av",
    ":<C-U>normal '[V']<CR>",
    { desc = "Previously changed or yanked text region selected linewise" }
  )
  vim.keymap.set({ "o", "v" }, "i;", function()
    return "i" .. vim.fn.getcharsearch().char
  end, { expr = true, desc = "Inside last search char" })
  vim.keymap.set({ "o", "v" }, "ia", "i<", { desc = "i<" })
  vim.keymap.set({ "o", "v" }, "ir", "i[", { desc = "i[" })
  vim.keymap.set(
    { "o", "v" },
    "iv",
    ":<C-U>normal `[v`]<CR>",
    { desc = "Previously changed or yanked text region selected charwise" }
  )
  vim.keymap.set({ "o", "v" }, "q", function()
    require("leap.treesitter").select {
      opts = require("leap.user").with_traversal_keys("<C-n>", "<C-p>"),
    }
  end, { desc = "Leap select treesitter node" })

  -- tmux
  vim.keymap.set(
    "n",
    [[<leader>"]],
    [[<Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>]],
    { desc = "Spawn new tmux pane vertically" }
  )
  vim.keymap.set(
    "n",
    [[<leader>l"]],
    [[<Cmd>execute "silent !tmux split-window -v -c '" .. expand('%:p:h') .. "'"<CR>]],
    {
      desc = "Spawn new tmux pane vertically with buffer's parent directory as CWD",
    }
  )

  -- undo
  vim.keymap.set(
    "n",
    [[<leader>r]],
    [[<Cmd>execute 'later ' .. v:count1 .. 'f'<CR>]],
    { desc = "later [count]f" }
  )
  vim.keymap.set(
    "n",
    [[<leader>u]],
    [[<Cmd>execute 'earlier ' .. v:count1 .. 'f'<CR>]],
    { desc = "earlier [count]f" }
  )

  -- yank
  vim.keymap.set(
    { "n", "v" },
    [[<leader>Y]],
    [["+yg_]],
    { desc = [[Alias for: "+yg_]] }
  )
  vim.keymap.set(
    { "n", "v" },
    [[<leader>y]],
    [["+y]],
    { desc = [[Alias for: "+y]] }
  )
end
set_bindings()

local function set_commands()
  vim.api.nvim_create_user_command(
    "Config",
    [[split `=stdpath("config") .. "/init.lua"`]],
    {}
  )
  vim.api.nvim_create_user_command(
    "History",
    function()
      scratch.open { liveness = "retained" }
      vim.opt_local.filetype = "sh"
      vim.opt_local.statusline = "history " .. status.statusline

      vim.cmd [[0r !atuin search --reverse --format "{command}"]]
      vim.cmd.normal [[gg]]
    end,
    { desc = "Open a scratch window with a Shell history fetched from atuin" }
  )
  vim.api.nvim_create_user_command("Mails", function(opts)
    local root = vim.env.MAIL
    if #opts.fargs > 0 then
      local topic = opts.fargs[1]
      root = vim.fs.joinpath(root, topic)
    end

    fzf.live_grep {
      cwd = root,
      silent = true,
      rg_opts = "--column --line-number"
        .. " --pre markitdown-wrapper --smart-case --text --hidden --no-ignore",
    }
  end, {
    nargs = "?",
    complete = function(arg_lead)
      local root = vim.env.MAIL
      local topics = {}

      for item, type_ in vim.fs.dir(root, { depth = 1 }) do
        if type_ == "directory" and item:sub(1, #arg_lead) == arg_lead then
          table.insert(topics, item)
        end
      end
      return topics
    end,
  })
  vim.api.nvim_create_user_command("Mv", function(opts)
    local dest
    if
      vim.fn.isdirectory(opts.fargs[1]) == 1
      or vim.fs.basename(opts.fargs[1]) == ""
    then
      dest = vim.fs.joinpath(opts.fargs[1], vim.fn.expand "%:t")
    else
      dest = opts.fargs[1]
    end

    vim.cmd("saveas" .. (opts.bang and "!" or "") .. " ++p " .. dest)

    local previous = vim.fn.expand "#"
    if #previous > 0 then
      vim.fs.rm(previous)
      vim.cmd.bwipeout(previous)
    end
  end, { nargs = 1, bang = true, complete = "file" })
end
set_commands()

local function set_autocommands()
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      vim.opt_local.include = ""
    end,
  })
  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.msg",
    callback = function()
      scratch.open { liveness = "retained" }
      vim.opt_local.filetype = "markdown"

      vim.cmd [[0r !markitdown-wrapper '#']]
      vim.cmd.normal [[gg]]
    end,
  })
  -- Show most recent commit when entering "COMMIT_EDITMSG".
  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "COMMIT_EDITMSG",
    command = "G log --max-count=100 | wincmd k",
  })
  vim.api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
      vim.opt_local.completeopt = { "fuzzy", "menuone", "noinsert", "popup" }
      vim.keymap.set("i", [[<C-_>]], [[<Home>\<<End>\><Left><Left>]], {
        desc = [[Wrap current line with \< and \>]],
      })
      vim.keymap.set(
        "i",
        [[<C-s>]],
        [[s///gc<Left><Left><Left>]],
        { buffer = true, desc = "Populate cmdline with s///gc" }
      )
      vim.keymap.set(
        { "i", "n", "o" },
        [[<C-z>]],
        [[]],
        { buffer = true, desc = "Skip <C-z> in Cmdwin" }
      )
      vim.keymap.set("n", [[<C-_>]], [[i<Home>\<<End>\><Left><Left><Esc>]], {
        desc = [[Wrap current line with \< and \>]],
      })
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
      vim.opt_local.cursorline = true
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
      vim.opt_local.cursorline = false
    end,
  })
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client:supports_method "textDocument/completion" then
        vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      end

      if client:supports_method "textDocument/hover" then
        vim.keymap.set(
          "n",
          [[K]],
          vim.lsp.buf.hover,
          { buffer = true, desc = "Hover" }
        )
      end

      if client:supports_method "textDocument/definition" then
        vim.bo[event.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
        vim.keymap.set(
          "n",
          [[gd]],
          vim.lsp.buf.definition,
          { buffer = true, desc = "Definition" }
        )
      end
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(event)
      vim.bo[event.buf].omnifunc = "syntaxcomplete#Complete"
      vim.bo[event.buf].tagfunc = ""

      local function unset_bindings()
        vim.keymap.del("n", [[K]], { buffer = event.buf })
        vim.keymap.del("n", [[gd]], { buffer = event.buf })
      end

      utils.try(unset_bindings)
    end,
  })
  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.opt_local.spell = false
    end,
  })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.hl.hl_op { higroup = "Visual", timeout = 300 }
    end,
  })
end
set_autocommands()

local function set_templates()
  local function enable_template(pattern, template)
    local template_path =
      vim.fs.joinpath(vim.fn.stdpath "config", "etc", "templates", template)
    vim.api.nvim_create_autocmd("BufNewFile", {
      pattern = pattern,
      callback = function(ev)
        local lines = vim.api.nvim_buf_get_lines(
          ev.buf,
          0,
          vim.api.nvim_buf_line_count(ev.buf),
          true
        )
        if #lines == 1 and lines[1] == "" then
          vim.cmd([[0r ]] .. template_path .. [[ | normal G"_ddgg]])
        end
      end,
    })
  end

  enable_template("*.cpp", "template.cpp")
  enable_template("*.dot", "template.dot")
  enable_template("*.hs", "template.hs")
  enable_template("*.java", "template.java")
  enable_template("*.md", "template.md")
  enable_template("*.pl", "template.pl")
  enable_template("*.scala", "template.scala")
  enable_template("tmux.sh", "tmux-template.sh")
  enable_template("*.sh", "template.sh")
end
set_templates()
