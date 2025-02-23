local M = {}

function M.set_default_options()
  local cmd = vim.cmd
  local opt = vim.opt
  local g = vim.g

  cmd.filetype "on"

  vim.cmd [[
    func Thesaur(findstart, base)
      if a:findstart
        return searchpos('\<', 'bnW', line('.'))[1] - 1
      endif
      let res = []
      let h = ''
      for l in systemlist('aiksaurus ' .. shellescape(a:base))
        if l[:3] == '=== '
          let h = '(' .. substitute(l[4:], ' =*$', ')', '')
        elseif l ==# 'Alphabetically similar known words are: '
          let h = "\U0001f52e"
        elseif l[0] =~ '\a' || (h ==# "\U0001f52e" && l[0] ==# "\t")
          call extend(res, map(split(substitute(l, '^\t', '', ''), ', '), {_, val -> {'word': val, 'menu': h}}))
        endif
      endfor
      return res
    endfunc

    if exists('+thesaurusfunc')
      set thesaurusfunc=Thesaur
    endif
  ]]

  g.netrw_banner = 0

  opt.allowrevins = true
  opt.autoindent = true
  opt.completeopt = { "menuone", "popup" }
  opt.cpoptions = "aABceFMs%>"
  opt.encoding = "utf-8"
  opt.expandtab = true
  opt.formatoptions = "tcro/qnl1j"
  opt.hidden = true
  opt.hlsearch = true
  opt.inccommand = "split"
  opt.incsearch = true
  opt.jumpoptions = { "stack" }
  opt.linebreak = true
  opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
  opt.modeline = true
  opt.number = true
  opt.omnifunc = "syntaxcomplete#Complete"
  opt.path = { "**", "./**" }
  opt.pumblend = 10
  opt.pumheight = 10
  opt.relativenumber = true
  opt.shiftround = true
  opt.shiftwidth = 2
  opt.smartindent = true
  opt.softtabstop = 2
  opt.spell = true
  opt.splitbelow = true
  opt.splitright = true
  opt.statusline =
    "%<%f %h%m%r<%{v:searchforward ? 'f' : 'b'}>%=%-14.(%l,%c%V%) %P"
  opt.tabstop = 2
  opt.termguicolors = true
  opt.wildmenu = true
  opt.wrapscan = false
end

function M.set_default_bindings()
  local api = vim.api
  local cmd = vim.cmd
  local diagnostic = vim.diagnostic
  local fn = vim.fn
  local fs = vim.fs
  local opt = vim.opt
  local set = vim.keymap.set

  local path = require "path"
  local utils = require "utils"

  -- cwd
  local function step_into_buffer_dir()
    local src_dir, dest_dir = fn.getcwd(), api.nvim_buf_get_name(0)
    local step = path.step_into(src_dir, dest_dir)
    if fn.isdirectory(step) == 1 then
      return step
    else
      return fs.dirname(step)
    end
  end

  set("n", [[<leader>DD]], function()
    for _ = 1, vim.v.count1 do
      cmd.cd ".."
    end
  end, { desc = "cd .." })
  set("n", [[<leader>DL]], function()
    for _ = 1, vim.v.count1 do
      cmd.lcd ".."
    end
  end, { desc = "lcd .." })
  set("n", [[<leader>DT]], function()
    for _ = 1, vim.v.count1 do
      cmd.tcd ".."
    end
  end, { desc = "tcd .." })
  set(
    "n",
    [[<leader>dD]],
    [[<Cmd>execute "cd " .. system("dirname '" .. @% .. "'")<CR>]],
    { desc = "cd into current buffer's directory" }
  )
  set(
    "n",
    [[<leader>dL]],
    [[<Cmd>execute "lcd " .. system("dirname '" .. @% .. "'")<CR>]],
    { desc = "lcd into current buffer's directory" }
  )
  set(
    "n",
    [[<leader>dT]],
    [[<Cmd>execute "tcd " .. system("dirname '" .. @% .. "'")<CR>]],
    { desc = "tcd into current buffer's directory" }
  )
  set("n", [[<leader>dd]], function()
    for _ = 1, vim.v.count1 do
      cmd.cd(step_into_buffer_dir())
    end
  end, { desc = "cd by one level into current buffer's directory" })
  set("n", [[<leader>dl]], function()
    for _ = 1, vim.v.count1 do
      cmd.lcd(step_into_buffer_dir())
    end
  end, { desc = "lcd by one level into current buffer's directory" })
  set("n", [[<leader>dt]], function()
    for _ = 1, vim.v.count1 do
      cmd.tcd(step_into_buffer_dir())
    end
  end, { desc = "tcd by one level into current buffer's directory" })

  -- quickfix/location
  local list = require "list"
  local quickfix = list.quickfix
  local location = list.location

  set(
    "n",
    [[<leader><leader>N]],
    [[<Cmd>execute v:count1 .. 'cpfile'<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "cpfile" }
  )
  set(
    "n",
    [[<leader><leader>n]],
    [[<Cmd>execute v:count1 .. 'cnfile'<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "cnfile" }
  )
  set(
    "n",
    [[<leader><leader>LN]],
    [[<Cmd>execute v:count1 .. 'lpfile'<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "lpfile" }
  )
  set(
    "n",
    [[<leader><leader>ln]],
    [[<Cmd>execute v:count1 .. 'lnfile'<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "lnfile" }
  )
  set(
    "n",
    [[<leader>N]],
    [[<Cmd>execute v:count1 .. 'cprevious'<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "cprevious" }
  )
  set(
    "n",
    [[<leader>n]],
    [[<Cmd>execute v:count1 .. 'cnext'<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "cnext" }
  )
  set(
    "n",
    [[<leader>LN]],
    [[<Cmd>execute v:count1 .. 'lprevious'<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "lprevious" }
  )
  set(
    "n",
    [[<leader>ln]],
    [[<Cmd>execute v:count1 .. 'lnext'<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true, desc = "lnext" }
  )

  set("n", [[<leader>qA]], function()
    local index = quickfix.get_current_item_index()
    local item = quickfix.get_current_item()
    quickfix.remove_item(item)
    utils.try(cmd, [[cc ]] .. index)
    if item.text then
      vim.notify(
        "Removed quickfix item: " .. vim.trim(item.text),
        vim.log.levels.INFO
      )
    end
  end, { desc = "Remove current quickfix item" })
  set("n", [[<leader>lA]], function()
    local index = location.get_current_item_index()
    local item = location.get_current_item()
    location.remove_item(item)
    utils.try(cmd, [[ll ]] .. index)
    if item.text then
      vim.notify(
        "Removed location item: " .. vim.trim(item.text),
        vim.log.levels.INFO
      )
    end
  end, { desc = "Remove current location item" })

  set("n", [[<leader>qX]], function()
    quickfix.reset()
    vim.notify(
      "Removed all quickfix items: " .. quickfix.get_title(),
      vim.log.levels.INFO
    )
  end, { desc = "Remove all quickfix items" })
  set("n", [[<leader>lX]], function()
    location.reset()
    vim.notify(
      "Removed all location items: " .. location.get_title(),
      vim.log.levels.INFO
    )
  end, { desc = "Remove all location items" })

  set("n", [[<leader>qa]], function()
    quickfix.add_item(list.create_current_position_item())
    cmd.clast()
  end, { desc = "Add current line as quickfix item" })
  set("n", [[<leader>la]], function()
    location.add_item(list.create_current_position_item())
    cmd.llast()
  end, { desc = "Add current line as location item" })

  set(
    "n",
    [[<leader>qe]],
    diagnostic.setqflist,
    { desc = "Load diagnostic to quickfix list" }
  )
  set(
    "n",
    [[<leader>le]],
    diagnostic.setloclist,
    { desc = "Load diagnostic to location list" }
  )

  set("n", [[<leader>qx]], function()
    local name = utils.try(fn.input, "Enter quickfix list: ")
    if name then
      quickfix.create(name)
    end
  end, { desc = "Create new quickfix list" })
  set("n", [[<leader>lx]], function()
    local name = utils.try(fn.input, "Enter location list: ")
    if name then
      location.create(name)
    end
  end, { desc = "Create new location list" })

  local function dump_list(current_list)
    local dumped = current_list.dump()
    if #dumped > 0 then
      local buffer = api.nvim_create_buf(true, false)
      api.nvim_buf_set_lines(buffer, 0, 1, false, dumped)
      cmd.sbuffer(buffer)
      cmd.file(current_list.get_title())
    end
  end

  set("n", [[<leader>qd]], function()
    dump_list(quickfix)
  end, { desc = "Dump quickfix list to a buffer" })
  set("n", [[<leader>ld]], function()
    dump_list(location)
  end, { desc = "Dump location list to a buffer" })

  -- tmux
  set(
    "n",
    [[<leader>"]],
    [[<Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>]],
    { desc = "Spawn new tmux pane vertically" }
  )
  set(
    "n",
    [[<leader>%]],
    [[<Cmd>execute "silent !tmux split-window -h -c '" .. getcwd() .. "'"<CR>]],
    { desc = "Spawn new tmux pane horizontally" }
  )
  set(
    "n",
    [[<leader>v]],
    [[<Cmd>execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>]],
    { desc = "Spawn new tmux window" }
  )

  -- telescope
  local telescope = utils.require_safe "telescope.builtin"
  if telescope then
    local pickers = require "plugins.telescope.pickers"

    set("n", [[<leader>+]], function()
      cmd.Telescope "neoclip"
    end, { desc = "Open neoclip" })
    set(
      "n",
      [[<leader>/]],
      telescope.current_buffer_fuzzy_find,
      { desc = "Grep current buffer" }
    )
    set("n", [[<leader>F]], function()
      local extension = path.extension(api.nvim_buf_get_name(0))
      telescope.grep_string {
        word_match = "-w",
        additional_args = { "--glob", "*" .. extension },
      }
    end, {
      desc = "Search for word under the cursor in files with current buffer's extension",
    })
    set("n", [[<leader>fB]], function()
      telescope.live_grep {
        grep_open_files = true,
      }
    end, { desc = "Grep buffers" })
    set(
      "n",
      [[<leader>fC]],
      telescope.git_bcommits,
      { desc = "List commits affecting current buffer" }
    )
    set("n", [[<leader>fG]], function()
      local extension = path.extension(api.nvim_buf_get_name(0))
      return [[:lua require("telescope.builtin").grep_string ]]
        .. [[{ word_match = "-w"]]
        .. [[, additional_args = { "--glob", "*]]
        .. extension
        .. [[" }, search = "" }<Left><Left><Left>]]
    end, {
      expr = true,
      desc = "Populate cmdline with search for word in files with current buffer's extension",
    })
    set(
      "n",
      [[<leader>fg]],
      pickers.live_grep_filetype,
      { desc = "Grep files with extension" }
    )
    set("n", [[<leader>fw]], function()
      telescope.grep_string {
        word_match = "-w",
        grep_open_files = true,
      }
    end, { desc = "Search for word under the cursor in buffers" })
    set("n", [[<leader>fb]], telescope.buffers, { desc = "List buffers" })
    set(
      "n",
      [[<leader>fd]],
      telescope.diagnostics,
      { desc = "List diagnostics" }
    )
    set("n", [[<leader>fD]], function()
      telescope.diagnostics { bufnr = 0 }
    end, { desc = "List diagnostics for current buffer" })
    set("n", [[<leader>fF]], function()
      telescope.find_files { cwd = fs.dirname(api.nvim_buf_get_name(0)) }
    end, { desc = "List files relative to current buffer" })
    set("n", [[<leader>fR]], function()
      telescope.oldfiles { cwd_only = true }
    end, { desc = "List old files relative to current buffer" })
    set("n", [[<leader>fQ]], telescope.quickfix, { desc = "List quickfix" })
    set(
      "n",
      [[<leader>fS]],
      telescope.pickers,
      { desc = "List previous pickers" }
    )
    set(
      "n",
      [[<leader>fT]],
      telescope.current_buffer_tags,
      { desc = "List current buffer's tags" }
    )
    set(
      "n",
      [[<leader>fe]],
      telescope.treesitter,
      { desc = "List treesitter symbols for current buffer" }
    )
    set("n", [[<leader>ff]], telescope.find_files, { desc = "List files" })
    set("n", [[<leader>fj]], telescope.jumplist, { desc = "List jumplist" })
    set("n", [[<leader>fm]], telescope.marks, { desc = "List marks" })
    set("n", [[<leader>fp]], telescope.filetypes, { desc = "List filetypes" })
    set(
      "n",
      [[<leader>fq]],
      telescope.quickfixhistory,
      { desc = "List quickfix lists" }
    )
    set("n", [[<leader>fr]], telescope.oldfiles, { desc = "List old files" })
    set(
      "n",
      [[<leader>fs]],
      telescope.resume,
      { desc = "Resume most recent picker" }
    )
    set("n", [[<leader>ft]], telescope.tags, { desc = "List tags" })
    set(
      "v",
      [[<leader>F]],
      [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection().text, additional_args = { "--glob", "*" .. vim.fn.expand "%:e:s/^/\\.\\0/" } }<CR>]],
      {
        desc = "Search for visually selected word in files with current buffer's extension",
      }
    )
    set(
      "v",
      [[<leader>fw]],
      [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection().text, grep_open_files = true }<CR>]],
      { desc = "Search for visually selected word in buffers" }
    )
  end

  -- git
  set(
    "n",
    [[<leader>DS]],
    [[<Cmd>vertical Gdiffsplit! HEAD<CR>]],
    { desc = "Show git diff with HEAD" }
  )
  set(
    "n",
    [[<leader>Ds]],
    [[<Cmd>vertical Gdiffsplit! HEAD<CR>]],
    { desc = "Show git diff with HEAD" }
  )
  set(
    "n",
    [[<leader>ds]],
    [[<Cmd>vertical Gdiffsplit!<CR>]],
    { desc = "Show git diff" }
  )
  set(
    "n",
    [[<leader>P]],
    [[<Cmd>update ++p | Git add --patch -- %<CR>]],
    { desc = "git add --patch" }
  )

  -- yank
  set(
    "n",
    [[<leader>yP]],
    [[<Cmd>let @+ = expand("%:p")<CR>]],
    { desc = "Yank current buffer's absolute path to clipboard" }
  )
  set(
    "n",
    [[<leader>yT]],
    [[<Cmd>let @+ = expand("%:t")<CR>]],
    { desc = "Yank current buffer's filename to clipboard" }
  )
  set(
    "n",
    [[<leader>yY]],
    [[<Cmd>let @+ = expand("%")<CR>]],
    { desc = "Yank current buffer's name to clipboard" }
  )
  set(
    "n",
    [[<leader>yp]],
    [[<Cmd>let @" = expand("%:p")<CR>]],
    { desc = "Yank current buffer's absolute path" }
  )
  set(
    "n",
    [[<leader>yt]],
    [[<Cmd>let @" = expand("%:t")<CR>]],
    { desc = "Yank current buffer's filename" }
  )
  set(
    "n",
    [[<leader>yy]],
    [[<Cmd>let @" = expand("%")<CR>]],
    { desc = "Yank current buffer's name" }
  )
  set({ "n", "v" }, [[<leader>Y]], [["+y]], { desc = [[Alias for: "+y]] })

  -- substitute
  local substitute = require "text.substitute"
  local function substitute_word(scope, text)
    local suffix = [[/gc]]
    return [[:]]
      .. scope
      .. [[s/\<]]
      .. text
      .. [[\>/]]
      .. text
      .. suffix
      .. string.rep("<Left>", #suffix)
  end
  local function substitute_word_globally(extension, text)
    return [[:]]
      .. [[lvimgrepadd/\<]]
      .. text
      .. [[\>/]]
      .. [[gj **/*]]
      .. extension
      .. [[ | ]]
      .. [[lfdo! ]]
      .. substitute_word([[%]], text)
  end
  set("n", [[<leader><leader>cn]], function()
    local extension = path.extension(api.nvim_buf_get_name(0))
    return substitute_word_globally(extension, fn.expand "<cword>")
  end, {
    expr = true,
    desc = "Add files with current file's extension to location list and substitute word under the cursor in location list files",
  })
  set(
    "n",
    [[<leader>CN]],
    function()
      return substitute_word([[*]], fn.expand "<cword>")
    end,
    { expr = true, desc = "Substitute word under the cursor in visual area" }
  )
  set("n", [[<leader>Cn]], function()
    local begin = api.nvim_buf_get_mark(0, "[")
    local end_ = api.nvim_buf_get_mark(0, "]")
    return substitute_word(
      tostring(begin[1]) .. "," .. tostring(end_[1]),
      fn.expand "<cword>"
    )
  end, {
    expr = true,
    desc = "Substitute word under the cursor in previously changed or yanked text area",
  })
  set("n", [[<leader>cn]], function()
    return substitute_word([[%]], fn.expand "<cword>")
  end, { expr = true, desc = "Substitute word under the cursor" })
  set(
    "n",
    [[<leader>cs]],
    [[<Cmd>keeppatterns %substitute/\s\+$//gc<CR>]],
    { desc = "Remove trailing whitespaces" }
  )
  set("n", [[<leader>S]], function()
    utils.map_motion(function(xs)
      return substitute.substitute_char(xs, " ", "_")
    end)
  end, {
    silent = true,
    desc = "Substitute space with _ in area selected by motion",
  })
  set(
    "n",
    [[<leader>s]],
    function()
      utils.map_motion(substitute.substitute_char_prompt)
    end,
    { silent = true, desc = "Substitute character in area selected by motion" }
  )
  set(
    "v",
    [[<leader>S]],
    [[:lua require("utils").map_visual(function(xs) return require("text.substitute").substitute_char(xs, " ", "_") end)<CR>]],
    { silent = true, desc = "Substitute space with _ in visual area" }
  )
  set(
    "v",
    [[<leader>s]],
    [[:lua require("utils").map_visual(require("text.substitute").substitute_char_prompt)<CR>]],
    { silent = true, desc = "Substitute character in visual area" }
  )

  -- case
  local case = require "text.case"
  set("n", [[<leader>cF]], function()
    utils.map_motion(case.to_camel)
  end, { desc = "Format selection by motion to camel case" })
  set("n", [[<leader>cf]], function()
    utils.map_motion(case.to_snake)
  end, { desc = "Format selection by motion to snake case" })
  set(
    "v",
    [[<leader>cF]],
    [[:lua require("utils").map_visual(require("text.case").to_camel)<CR>]],
    { silent = true, desc = "Format selection by visual to camel case" }
  )
  set(
    "v",
    [[<leader>cf]],
    [[:lua require("utils").map_visual(require("text.case").to_snake)<CR>]],
    { silent = true, desc = "Format selection by visual to snake case" }
  )

  -- fold
  set("n", [[<leader>gf]], function()
    opt.foldmethod = "indent"
  end, { desc = "Fold by indentation" })
  set("n", [[<leader>gF]], function()
    opt.foldmethod = "manual"
    cmd.normal "zE"
  end, { desc = "Turn off folds" })

  -- search
  set("n", [[<leader>#]], function()
    return "?" .. fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true, desc = "Same as #, but without \\< and \\>" })
  set("n", [[<leader>*]], function()
    return "/" .. fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true, desc = "Same as *, but without \\< and \\>" })
  set(
    "v",
    [[<leader>#]],
    [[:lua vim.fn.setreg("/", require("utils").get_visual_selection().text .. "\\c"); vim.v.searchforward = false; vim.cmd.norm "n"<CR>]],
    { desc = "Same as #, but without \\< and \\>" }
  )
  set(
    "v",
    [[<leader>*]],
    [[:lua vim.fn.setreg("/", require("utils").get_visual_selection().text .. "\\c"); vim.v.searchforward = true; vim.cmd.norm "n"<CR>]],
    { desc = "Same as *, but without \\< and \\>" }
  )

  -- cmdline
  set("c", [[<C-j>]], [[<Down>]], {
    desc = "Go to next item matching command that was typed so far in cmdline",
  })
  set("c", [[<C-k>]], [[<Up>]], {
    desc = "Go to previous item matching command that was typed so far in cmdline",
  })
  set(
    "c",
    [[<C-s>]],
    [[s///gc<Left><Left><Left>]],
    { desc = "Populate cmdline with s///gc" }
  )

  -- move
  set(
    "v",
    [[<C-j>]],
    [[:lua require("text.move").down(require("utils").get_visual_selection())<CR>gv]],
    { desc = "Shift visual area down" }
  )
  set(
    "v",
    [[<C-k>]],
    [[:lua require("text.move").up(require("utils").get_visual_selection())<CR>gv]],
    { desc = "Shift visual area up" }
  )

  -- column
  set("n", [[<leader>gc]], function()
    utils.map_motion(utils.column)
  end, { desc = "Use `column` on selection by motion" })
  set(
    "v",
    [[<leader>gc]],
    [[:lua require("utils").map_visual(require("utils").column)<CR>]],
    { silent = true, desc = "Use `column` on selection by visual" }
  )

  -- tags
  set("n", [[<leader>gt]], function()
    local language = vim.opt_local.filetype._value
    return [[:!ctags -R --languages=]] .. language .. [[ .]]
  end, { expr = true, desc = "Generate tags" })

  -- popupmenu
  set("i", [[<C-k>]], function()
    return fn.pumvisible() == 1 and [[<Up>]] or [[<C-k>]]
  end, { expr = true, desc = "Go up in popupmenu" })
  set("i", [[<C-j>]], function()
    return fn.pumvisible() == 1 and [[<Down>]] or [[<C-j>]]
  end, { expr = true, desc = "Go down in popupmenu" })
  set("i", [[<C-z>]], function()
    if fn.pumvisible() == 1 then
      cmd.Telescope "completion"
      return ""
    else
      return [[<C-z>]]
    end
  end, { expr = true, desc = "List popupmenu completion in Telescope" })

  -- tabs
  set("n", [[<leader>tc]], [[<Cmd>tabclose<CR>]], { desc = "Close tab" })
  set("n", [[<leader>to]], [[<Cmd>tabonly<CR>]], { desc = "Focus tab" })
  set("n", [[<leader>tT]], [[<Cmd>-tabmove<CR>]], { desc = "Move tab left" })
  set("n", [[<leader>tt]], [[<Cmd>+tabmove<CR>]], { desc = "Move tab right" })

  -- undo
  set(
    "n",
    [[<leader>r]],
    [[<Cmd>execute 'later ' .. v:count1 .. 'f'<CR>]],
    { desc = "later [count]f" }
  )
  set(
    "n",
    [[<leader>u]],
    [[<Cmd>execute 'earlier ' .. v:count1 .. 'f'<CR>]],
    { desc = "earlier [count]f" }
  )

  -- text objects
  set(
    { "o" },
    "a%",
    ":<C-U>normal va%<CR>",
    { desc = "Missing text object for a% from matchit" }
  )
  set(
    { "o", "v" },
    "av",
    ":<C-U>normal '[V']<CR>",
    { desc = "Previously changed or yanked text area selected charwise" }
  )
  set(
    { "o", "v" },
    "il",
    ":<C-U>normal _vg_<CR>",
    { desc = "Current line without blanks selected charwise" }
  )
  set(
    { "o", "v" },
    "iv",
    ":<C-U>normal '[v']<CR>",
    { desc = "Previously changed or yanked text area selected linewise" }
  )

  -- other
  set(
    "n",
    [[<C-l>]],
    [[<Cmd>mode | nohlsearch | diffupdate | fclose!<CR>]],
    { desc = "<C-l> with :fclose!" }
  )
  set({ "n", "v" }, [[<leader>D]], [["_d]], { desc = [[Alias for: "_d]] })
  set("n", [[<leader>QQ]], [[<Cmd>qall!<CR>]], { desc = "qall!" })
  set("n", [[<leader>W]], [[<Cmd>write ++p<CR>]], { desc = "write ++p" })
  set("n", [[<leader>b]], [[<Cmd>bwipeout!<CR>]], { desc = "bwipeout!" })
  set("n", [[<leader>gv]], function()
    local mode = fn.visualmode()
    if string.len(mode) == 0 then
      mode = "v"
    elseif mode == "" then
      mode = "<C-v>"
    end
    return "`[" .. mode .. "`]"
  end, {
    expr = true,
    desc = "Visually select previously changed or yanked text area",
  })
  set(
    "n",
    [[<leader>p]],
    [[<Cmd>tab new | 0put + | file clipboard<CR>]],
    { desc = "Paste clipboard into a new buffer" }
  )
  set("n", [[<leader>qQ]], [[<Cmd>qall!<CR>]], { desc = "qall!" })
  set("n", [[<leader>qq]], [[<Cmd>qall<CR>]], { desc = "qall" })
  set("n", [[<leader>w]], [[<Cmd>update ++p<CR>]], { desc = "update ++p" })
  set("n", [[<leader>z]], function()
    local buffer = api.nvim_buf_get_name(0)
    if #buffer > 0 then
      fn.delete(buffer)
      vim.notify("Removed file: " .. buffer, vim.log.levels.INFO)
    end
  end, { desc = "Remove current buffer's file" })
  set({ "n", "v" }, "]", [[g]], { desc = "Remap ] to g" })
  set({ "n", "v" }, [[]], [[g]], { desc = "Remap  to g" })
  set({ "n", "v" }, [[]], [[g]], { desc = "Remap  to g" })
  set({ "n", "v" }, [[']], [[`]], { desc = "Remap ' to `" })
end

function M.set_default_commands()
  local cmd = vim.cmd
  local command = vim.api.nvim_create_user_command
  local fn = vim.fn
  command("Config", [[split `=stdpath("config") .. "/init.lua"`]], {})
  command("Mv", function(opts)
    cmd("saveas" .. (opts.bang and "!" or "") .. " ++p " .. opts.fargs[1])
    local previous = fn.expand "#"
    if #previous > 0 then
      fn.delete(previous)
      cmd.bwipeout(previous)
    end
  end, { nargs = 1, bang = true, complete = "file" })
end

function M.set_default_autocommands()
  local autocmd = vim.api.nvim_create_autocmd
  local del = vim.keymap.del
  local lsp = vim.lsp.buf
  local set = vim.keymap.set

  local utils = require "utils"

  autocmd(
    "BufWritePost",
    { pattern = "config.h", command = "silent !sudo make install" }
  )
  autocmd(
    "BufWritePost",
    { pattern = { ".Xresources", "xresources" }, command = "silent !xrdb %" }
  )
  autocmd("CmdwinEnter", {
    callback = function()
      set({ "n", "i" }, [[<C-]>]], [[<CR>q:]], {
        buffer = true,
        desc = "Run current command and open back command window",
      })
    end,
  })
  autocmd("CmdwinEnter", {
    callback = function()
      set(
        { "i" },
        [[<C-s>]],
        [[s///gc<Left><Left><Left>]],
        { buffer = true, desc = "Populate cmdline with s///gc" }
      )
    end,
  })
  autocmd("LspAttach", {
    callback = function(event)
      local telescope = utils.require_safe "telescope.builtin"

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client.supports_method "textDocument/completion" then
        vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      end

      if client.supports_method "textDocument/codeAction" then
        set(
          "n",
          [[<leader>.]],
          lsp.code_action,
          { buffer = true, desc = "Code action" }
        )
      end

      if client.supports_method "textDocument/rename" then
        set(
          "n",
          [[<leader>cN]],
          lsp.rename,
          { buffer = true, desc = "Rename with LSP" }
        )
      end

      if client.supports_method "textDocument/references" then
        set(
          "n",
          [[<leader>qc]],
          lsp.references,
          { buffer = true, desc = "References" }
        )
        if telescope then
          set(
            "n",
            [[<leader>fc]],
            telescope.lsp_references,
            { buffer = true, desc = "References" }
          )
        end
      end

      if client.supports_method "callHierarchy/incomingCalls" then
        set(
          "n",
          [[<leader>qi]],
          lsp.incoming_calls,
          { buffer = true, desc = "Incoming calls" }
        )
        if telescope then
          set(
            "n",
            [[<leader>fi]],
            telescope.lsp_incoming_calls,
            { buffer = true, desc = "Incoming calls" }
          )
        end
      end

      if client.supports_method "callHierarchy/outgoingCalls" then
        set(
          "n",
          [[<leader>qo]],
          lsp.outgoing_calls,
          { buffer = true, desc = "Outgoing calls" }
        )
        if telescope then
          set(
            "n",
            [[<leader>fo]],
            telescope.lsp_outgoing_calls,
            { buffer = true, desc = "Outgoing calls" }
          )
        end
      end

      if client.supports_method "textDocument/hover" then
        set("n", [[K]], lsp.hover, { buffer = true, desc = "Hover" })
      end

      if client.supports_method "textDocument/definition" then
        set("n", [[gd]], lsp.definition, { buffer = true, desc = "Definition" })
      end

      if client.supports_method "workspace/symbol" then
        if telescope then
          set(
            "n",
            [[<leader>fW]],
            telescope.lsp_dynamic_workspace_symbols,
            { buffer = true, desc = "Dynamic workspace symbols" }
          )
        end
      end
    end,
  })
  autocmd("LspDetach", {
    callback = function(event)
      vim.bo[event.buf].omnifunc = "syntaxcomplete#Complete"

      local function unset_bindings()
        del("n", [[<leader>.]], { buffer = event.buf })
        del("n", [[<leader>cN]], { buffer = event.buf })
        del("n", [[<leader>qc]], { buffer = event.buf })
        del("n", [[<leader>fc]], { buffer = event.buf })
        del("n", [[<leader>qi]], { buffer = event.buf })
        del("n", [[<leader>fi]], { buffer = event.buf })
        del("n", [[<leader>qo]], { buffer = event.buf })
        del("n", [[<leader>fo]], { buffer = event.buf })
        del("n", [[K]], { buffer = event.buf })
        del("n", [[gd]], { buffer = event.buf })
        del("n", [[<leader>fd]], { buffer = event.buf })
        del("n", [[<leader>fW]], { buffer = event.buf })
      end

      utils.try(unset_bindings)
    end,
  })
  autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank { timeout = 300 }
    end,
  })
end

function M.enable_templates()
  local autocmd = vim.api.nvim_create_autocmd
  local fn = vim.fn

  local templates_dir = fn.stdpath "config" .. "/etc/templates/"

  local function enable_template(extension)
    local template_path = templates_dir .. "template." .. extension
    autocmd("BufNewFile", {
      pattern = "*." .. extension,
      command = "0r " .. template_path .. " | normal Gddgg",
    })
  end

  enable_template "cpp"
  enable_template "dhall"
  enable_template "dot"
  enable_template "hs"
  enable_template "java"
  enable_template "md"
  enable_template "pl"
  enable_template "scala"
  enable_template "sh"
end

return M
