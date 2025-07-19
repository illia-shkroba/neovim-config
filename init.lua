-- `mapleader` must be set before loading `package-manager` because bindings can be set within plugins configs.
vim.g.mapleader = " "

require "package-manager"

local case = require "text.case"
local list = require "list"
local path = require "path"
local pickers = require "plugins.telescope.pickers"
local register = require "text.register"
local status = require "status"
local substitute = require "text.substitute"
local telescope = require "telescope.builtin"
local utils = require "utils"

local location = list.location
local quickfix = list.quickfix

function set_options()
  vim.cmd.filetype "on"

  vim.opt.allowrevins = true
  vim.opt.autoindent = true
  vim.opt.complete = { ".", "w", "b", "u" }
  vim.opt.completeopt = { "menuone", "popup" }
  vim.opt.cpoptions = "aABceFMs%>"
  vim.opt.cursorline = true
  vim.opt.encoding = "utf-8"
  vim.opt.expandtab = true
  vim.opt.formatoptions = "tcro/qnl1j"
  vim.opt.hidden = true
  vim.opt.hlsearch = true
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
  vim.opt.pumheight = 10
  vim.opt.relativenumber = true
  vim.opt.shiftround = true
  vim.opt.shiftwidth = 2

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
  vim.opt.wildmenu = true
  vim.opt.wrapscan = false

  vim.g.netrw_banner = 0

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

function set_bindings()
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
      local buffer = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_buf_set_lines(buffer, 0, 1, false, dumped)
      vim.cmd.sbuffer(buffer)
      vim.cmd.file(current_list.get_title())
      vim.opt_local.filetype = "qf"
    end
  end

  local function load_list(current_list, buffer)
    local title = current_list.get_title()
    if #title == 0 then
      title = vim.api.nvim_buf_get_name(buffer)
      current_list.set_title(title)
    end
    current_list.reset()
    current_list.add_from_buffer(buffer)
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

  -- tmux
  vim.keymap.set(
    "n",
    [[<leader>"]],
    [[<Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>]],
    { desc = "Spawn new tmux pane vertically" }
  )

  -- telescope
  vim.keymap.set("n", [[<leader>+]], function()
    vim.cmd.Telescope "neoclip"
  end, { desc = "Open neoclip" })
  vim.keymap.set(
    "n",
    [[<leader>/]],
    telescope.current_buffer_fuzzy_find,
    { desc = "Grep current buffer" }
  )
  vim.keymap.set("n", [[<leader>F]], function()
    local extension = path.extension(vim.api.nvim_buf_get_name(0))
    telescope.grep_string {
      word_match = "-w",
      additional_args = { "--glob", "*" .. extension },
    }
  end, {
    desc = "Search for word under the cursor in files with current buffer's extension",
  })
  vim.keymap.set("n", [[<leader>fB]], function()
    telescope.live_grep {
      grep_open_files = true,
    }
  end, { desc = "Grep buffers" })
  vim.keymap.set(
    "n",
    [[<leader>fC]],
    telescope.git_bcommits,
    { desc = "List commits affecting current buffer" }
  )
  vim.keymap.set("n", [[<leader>fG]], function()
    local extension = path.extension(vim.api.nvim_buf_get_name(0))
    return [[:lua require("telescope.builtin").grep_string ]]
      .. [[{ word_match = "-w"]]
      .. [[, additional_args = { "--glob", "*]]
      .. extension
      .. [[" }, search = "" }<Left><Left><Left>]]
  end, {
    expr = true,
    desc = "Populate cmdline with search for word in files with current buffer's extension",
  })
  vim.keymap.set(
    "n",
    [[<leader>fg]],
    pickers.live_grep_filetype,
    { desc = "Grep files with extension" }
  )
  vim.keymap.set("n", [[<leader>fk]], pickers.yank_from_dictionary, {
    desc = "Yank from dictionary in ~/.local/share/dict.txt (or $XDG_DATA_HOME)",
  })
  vim.keymap.set("n", [[<leader>fw]], function()
    telescope.grep_string {
      word_match = "-w",
      grep_open_files = true,
    }
  end, { desc = "Search for word under the cursor in buffers" })
  vim.keymap.set(
    "n",
    [[<leader>fb]],
    telescope.buffers,
    { desc = "List buffers" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fd]],
    telescope.diagnostics,
    { desc = "List diagnostics" }
  )
  vim.keymap.set("n", [[<leader>fD]], function()
    telescope.diagnostics { bufnr = 0 }
  end, { desc = "List diagnostics for current buffer" })
  vim.keymap.set("n", [[<leader>fF]], function()
    telescope.find_files { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) }
  end, { desc = "List files relative to current buffer" })
  vim.keymap.set("n", [[<leader>fR]], function()
    telescope.oldfiles { cwd_only = true }
  end, { desc = "List old files relative to current buffer" })
  vim.keymap.set(
    "n",
    [[<leader>fQ]],
    telescope.quickfix,
    { desc = "List quickfix" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fS]],
    telescope.pickers,
    { desc = "List previous pickers" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fT]],
    telescope.current_buffer_tags,
    { desc = "List current buffer's tags" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fe]],
    telescope.treesitter,
    { desc = "List treesitter symbols for current buffer" }
  )
  vim.keymap.set(
    "n",
    [[<leader>ff]],
    telescope.find_files,
    { desc = "List files" }
  )
  vim.keymap.set("n", [[<leader>fm]], telescope.marks, { desc = "List marks" })
  vim.keymap.set(
    "n",
    [[<leader>fp]],
    telescope.filetypes,
    { desc = "List filetypes" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fq]],
    telescope.quickfixhistory,
    { desc = "List quickfix lists" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fr]],
    telescope.oldfiles,
    { desc = "List old files" }
  )
  vim.keymap.set(
    "n",
    [[<leader>fs]],
    telescope.resume,
    { desc = "Resume most recent picker" }
  )
  vim.keymap.set("n", [[<leader>ft]], telescope.tags, { desc = "List tags" })
  vim.keymap.set(
    "n",
    [[<leader>j]],
    telescope.jumplist,
    { desc = "List jumplist" }
  )
  vim.keymap.set(
    "v",
    [[<leader>F]],
    [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection().text, additional_args = { "--glob", "*" .. vim.fn.expand "%:e:s/^/\\.\\0/" } }<CR>]],
    {
      desc = "Search for visually selected word in files with current buffer's extension",
    }
  )
  vim.keymap.set(
    "v",
    [[<leader>fw]],
    [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection().text, grep_open_files = true }<CR>]],
    { desc = "Search for visually selected word in buffers" }
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

  -- expression
  local function paste_into_scratch_buffer(lines)
    local listed = false
    local scratch = true
    local buffer = vim.api.nvim_create_buf(listed, scratch)
    vim.api.nvim_buf_set_lines(buffer, 0, 1, false, lines)
    vim.cmd.sbuffer(buffer)

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
      buffer = buffer,
      callback = function()
        vim.schedule(function()
          vim.cmd([[bwipeout! ]] .. buffer)
        end)
      end,
      once = true,
    })
  end

  vim.keymap.set("n", [[<leader>md]], function()
    paste_into_scratch_buffer { os.date "%F" }
  end, { desc = "Paste current buffer's absolute path in a scratch window" })
  vim.keymap.set("n", [[<leader>mp]], function()
    paste_into_scratch_buffer { vim.fn.expand "%:p" }
  end, { desc = "Paste current buffer's absolute path in a scratch window" })
  vim.keymap.set("n", [[<leader>mt]], function()
    paste_into_scratch_buffer { vim.fn.expand "%:t" }
  end, { desc = "Paste current buffer's filename in a scratch window" })
  vim.keymap.set("n", [[<leader>my]], function()
    paste_into_scratch_buffer { vim.fn.expand "%" }
  end, { desc = "Paste current buffer's name in a scratch window" })

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

  -- paste
  vim.keymap.set("n", [[<leader>P]], [[<Cmd>iput! +<CR>]], { desc = "iput! +" })
  vim.keymap.set("n", [[<leader>p]], [[<Cmd>iput +<CR>]], { desc = "iput +" })
  vim.keymap.set("v", [[<leader>P]], [["+P]], { desc = [["+P]] })
  vim.keymap.set("v", [[<leader>p]], [["+p]], { desc = [["+p]] })

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

  -- substitute
  local function substitute_word(scope, text)
    local suffix = [[/gc]]
    return [[:]]
      .. scope
      .. [[s/\<]]
      .. text
      .. [[\>/]]
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
  vim.keymap.set("n", [[<leader><leader>c%]], function()
    local extension = path.extension(vim.api.nvim_buf_get_name(0))
    return substitute_word_globally(extension, vim.fn.expand "<cword>")
  end, {
    expr = true,
    desc = "Add files with current file's extension to location list and substitute word under the cursor in location list files",
  })
  vim.keymap.set(
    "n",
    [[<leader>c*]],
    function()
      return substitute_word([[*]], vim.fn.expand "<cword>")
    end,
    { expr = true, desc = "Substitute word under the cursor in visual area" }
  )
  vim.keymap.set("n", [[<leader>c%]], function()
    return substitute_word([[%]], vim.fn.expand "<cword>")
  end, { expr = true, desc = "Substitute word under the cursor" })
  vim.keymap.set(
    "n",
    [[<leader>cc]],
    function()
      return substitute_word("", vim.fn.expand "<cword>")
    end,
    { expr = true, desc = "Substitute word under the cursor in a current line" }
  )
  vim.keymap.set("n", [[<leader>cv]], function()
    local begin = vim.api.nvim_buf_get_mark(0, "[")
    local end_ = vim.api.nvim_buf_get_mark(0, "]")
    return substitute_word(
      tostring(begin[1]) .. "," .. tostring(end_[1]),
      vim.fn.expand "<cword>"
    )
  end, {
    expr = true,
    desc = "Substitute word under the cursor in previously changed or yanked text area",
  })
  vim.keymap.set(
    "n",
    [[<leader>cs]],
    [[<Cmd>keeppatterns %substitute/\s\+$//gc<CR>]],
    { desc = "Remove trailing whitespaces" }
  )
  vim.keymap.set("n", [[<leader>S]], function()
    utils.map_motion(function(xs)
      return substitute.substitute_char(xs, " ", "_")
    end)
  end, {
    silent = true,
    desc = "Substitute space with _ in area selected by motion",
  })
  vim.keymap.set(
    "n",
    [[<leader>s]],
    function()
      utils.map_motion(substitute.substitute_char_prompt)
    end,
    { silent = true, desc = "Substitute character in area selected by motion" }
  )
  vim.keymap.set(
    "v",
    [[<leader>S]],
    [[:lua require("utils").map_visual(function(xs) return require("text.substitute").substitute_char(xs, " ", "_") end)<CR>]],
    { silent = true, desc = "Substitute space with _ in visual area" }
  )
  vim.keymap.set(
    "v",
    [[<leader>s]],
    [[:lua require("utils").map_visual(require("text.substitute").substitute_char_prompt)<CR>]],
    { silent = true, desc = "Substitute character in visual area" }
  )

  -- case
  vim.keymap.set("n", [[<leader>cF]], function()
    utils.map_motion(case.to_camel)
  end, { desc = "Format selection by motion to camel case" })
  vim.keymap.set("n", [[<leader>cf]], function()
    utils.map_motion(case.to_snake)
  end, { desc = "Format selection by motion to snake case" })
  vim.keymap.set(
    "v",
    [[<leader>cF]],
    [[:lua require("utils").map_visual(require("text.case").to_camel)<CR>]],
    { silent = true, desc = "Format selection by visual to camel case" }
  )
  vim.keymap.set(
    "v",
    [[<leader>cf]],
    [[:lua require("utils").map_visual(require("text.case").to_snake)<CR>]],
    { silent = true, desc = "Format selection by visual to snake case" }
  )

  -- search
  vim.keymap.set("n", [[<leader>#]], function()
    return "?" .. vim.fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true, desc = "Same as #, but without \\< and \\>" })
  vim.keymap.set("n", [[<leader>*]], function()
    return "/" .. vim.fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true, desc = "Same as *, but without \\< and \\>" })
  vim.keymap.set(
    "v",
    [[<leader>#]],
    [[:lua vim.fn.setreg("/", require("utils").get_visual_selection().text .. "\\c"); vim.v.searchforward = false; vim.cmd.norm "n"<CR>]],
    { desc = "Same as #, but without \\< and \\>" }
  )
  vim.keymap.set(
    "v",
    [[<leader>*]],
    [[:lua vim.fn.setreg("/", require("utils").get_visual_selection().text .. "\\c"); vim.v.searchforward = true; vim.cmd.norm "n"<CR>]],
    { desc = "Same as *, but without \\< and \\>" }
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

  -- move
  vim.keymap.set(
    "v",
    [[<C-j>]],
    [[:lua require("text.move").down(require("utils").get_visual_selection())<CR>gv]],
    { desc = "Shift visual area down" }
  )
  vim.keymap.set(
    "v",
    [[<C-k>]],
    [[:lua require("text.move").up(require("utils").get_visual_selection())<CR>gv]],
    { desc = "Shift visual area up" }
  )

  -- register
  vim.keymap.set("n", [[<leader>Q]], function()
    register.edit_register_prompt()
  end, { desc = "Edit register in a buffer" })

  -- tags
  vim.keymap.set("n", [[<leader>gt]], function()
    local language = vim.opt_local.filetype._value
    return [[:!ctags -R --languages=]] .. language .. [[ .]]
  end, { expr = true, desc = "Generate tags" })

  -- popup-menu
  vim.keymap.set("i", [[<C-k>]], function()
    return vim.fn.pumvisible() == 1 and [[<Up>]] or [[<C-k>]]
  end, { expr = true, desc = "Go up in popup-menu" })
  vim.keymap.set("i", [[<C-j>]], function()
    return vim.fn.pumvisible() == 1 and [[<Down>]] or [[<C-j>]]
  end, { expr = true, desc = "Go down in popup-menu" })

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
  vim.keymap.set(
    "n",
    [[<leader>tT]],
    [[<Cmd>-tabmove<CR>]],
    { desc = "Move tab left" }
  )
  vim.keymap.set(
    "n",
    [[<leader>tt]],
    [[<Cmd>+tabmove<CR>]],
    { desc = "Move tab right" }
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

  -- text objects
  vim.keymap.set(
    { "o", "v" },
    "a%",
    ":<C-U>normal va%<CR>",
    { desc = "Missing text object for a% from matchit" }
  )
  vim.keymap.set({ "o", "v" }, "aa", "a<", { desc = "a<" })
  vim.keymap.set({ "o", "v" }, "ar", "a[", { desc = "a[" })
  vim.keymap.set(
    { "o", "v" },
    "av",
    ":<C-U>normal '[V']<CR>",
    { desc = "Previously changed or yanked text area selected linewise" }
  )
  vim.keymap.set(
    { "o", "v" },
    "il",
    ":<C-U>normal _vg_<CR>",
    { desc = "Current line without blanks selected charwise" }
  )
  vim.keymap.set({ "o", "v" }, "ia", "i<", { desc = "i<" })
  vim.keymap.set({ "o", "v" }, "ir", "i[", { desc = "i[" })
  vim.keymap.set(
    { "o", "v" },
    "iv",
    ":<C-U>normal `[v`]<CR>",
    { desc = "Previously changed or yanked text area selected charwise" }
  )

  -- other
  vim.keymap.set(
    "n",
    [[<C-l>]],
    [[<Cmd>mode | nohlsearch | diffupdate | fclose!<CR>]],
    { desc = "<C-l> with :fclose!" }
  )
  vim.keymap.set(
    "n",
    [[<leader>W]],
    [[<Cmd>write ++p<CR>]],
    { desc = "write ++p" }
  )
  vim.keymap.set("n", [[<C-w>a]], function()
    local listed = false
    local scratch = true
    local buffer = vim.api.nvim_create_buf(listed, scratch)
    vim.cmd.sbuffer(buffer)

    vim.opt_local.commentstring = "# %s"
    vim.opt_local.filetype = "sh"

    vim.keymap.set(
      { "n" },
      [[<CR>]],
      [[<Cmd>.w !bash<CR>]],
      { buffer = true, desc = "Run current line" }
    )
    vim.keymap.set(
      { "n" },
      [[<leader><CR>]],
      [[:r!]],
      { buffer = true, desc = "Paste current line's output below" }
    )
    vim.keymap.set(
      { "v" },
      [[<CR>]],
      [[<Cmd>w !bash<CR>]],
      { buffer = true, desc = "Run selected lines" }
    )

    vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
      buffer = buffer,
      callback = function()
        vim.schedule(function()
          vim.cmd([[bwipeout! ]] .. buffer)
        end)
      end,
      once = true,
    })
  end, { desc = "Open a scratch window" })
  vim.keymap.set(
    "n",
    [[<leader>b]],
    [[<Cmd>bwipeout!<CR>]],
    { desc = "bwipeout!" }
  )
  vim.keymap.set("n", [[<leader>o]], function()
    local buffer = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local row = cursor[1] - 1

    vim.api.nvim_buf_set_lines(buffer, row + 1, -1, false, {})
    vim.api.nvim_buf_set_lines(buffer, 0, row, false, {})
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
    desc = "Visually select previously changed or yanked text area",
  })
  vim.keymap.set("n", [[<leader>qQ]], [[<Cmd>qall!<CR>]], { desc = "qall!" })
  vim.keymap.set("n", [[<leader>qq]], [[<Cmd>qall<CR>]], { desc = "qall" })
  vim.keymap.set("n", [[<leader>e]], [[<Cmd>e!<CR>]], { desc = "e!" })
  vim.keymap.set(
    "n",
    [[<leader>w]],
    [[<Cmd>update ++p<CR>]],
    { desc = "update ++p" }
  )
  vim.keymap.set("n", [[<leader>z]], function()
    local buffer = vim.api.nvim_buf_get_name(0)
    if #buffer > 0 then
      vim.fn.delete(buffer)
      vim.notify("Removed file: " .. buffer, vim.log.levels.INFO)
    end
  end, { desc = "Remove current buffer's file" })
  vim.keymap.set({ "n", "v" }, "]", [[g]], { desc = "Remap ] to g" })
  vim.keymap.set({ "n", "v" }, [[]], [[g]], { desc = "Remap  to g" })
  vim.keymap.set({ "n", "v" }, [[]], [[g]], { desc = "Remap  to g" })
  vim.keymap.set({ "n", "v" }, [[<leader>']], [["_]], { desc = [["_]] })
  vim.keymap.set(
    "i",
    [[#]],
    [[<C-v>#]],
    { desc = "Prevent indent removal when 'smartindent' is on" }
  )
end
set_bindings()

function set_commands()
  vim.api.nvim_create_user_command(
    "Config",
    [[split `=stdpath("config") .. "/init.lua"`]],
    {}
  )
  vim.api.nvim_create_user_command("Mv", function(opts)
    local dest
    if vim.fn.isdirectory(opts.fargs[1]) == 1 then
      dest = vim.fs.joinpath(opts.fargs[1], vim.fn.expand "%:t")
    else
      dest = opts.fargs[1]
    end

    vim.cmd("saveas" .. (opts.bang and "!" or "") .. " ++p " .. dest)

    local previous = vim.fn.expand "#"
    if #previous > 0 then
      vim.fn.delete(previous)
      vim.cmd.bwipeout(previous)
    end
  end, { nargs = 1, bang = true, complete = "file" })
end
set_commands()

function set_autocommands()
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      vim.opt_local.include = ""
    end,
  })
  -- Show most recent commit when entering "COMMIT_EDITMSG".
  vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "COMMIT_EDITMSG",
    command = "G log --max-count=100 | wincmd k",
  })
  vim.api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
      vim.opt_local.completeopt = { "fuzzy", "menuone", "popup" }
      vim.keymap.set({ "i" }, [[<C-_>]], [[<Home>\<<End>\><Left><Left>]], {
        desc = [[Wrap current line with \< and \>]],
      })
      vim.keymap.set(
        { "i" },
        [[<C-s>]],
        [[s///gc<Left><Left><Left>]],
        { buffer = true, desc = "Populate cmdline with s///gc" }
      )
      vim.keymap.set(
        { "i" },
        [[<C-z>]],
        [[]],
        { buffer = true, desc = "Skip <C-z> in Cmdwin" }
      )
      vim.keymap.set(
        { "n" },
        [[<C-_>]],
        [[i<Home>\<<End>\><Left><Left><Esc>]],
        {
          desc = [[Wrap current line with \< and \>]],
        }
      )
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

      if client:supports_method "textDocument/publishDiagnostics" then
        vim.diagnostic.config { virtual_text = false }
        vim.lsp.handlers["textDocument/publishDiagnostics"] =
          vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = false,
            update_in_insert = false,
          })
      end

      if client:supports_method "textDocument/completion" then
        vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      end

      if client:supports_method "textDocument/references" then
        vim.keymap.set(
          "n",
          [[<leader>qc]],
          vim.lsp.buf.references,
          { buffer = true, desc = "References" }
        )
        if telescope then
          vim.keymap.set(
            "n",
            [[<leader>fc]],
            telescope.lsp_references,
            { buffer = true, desc = "References" }
          )
        end
      end

      if client:supports_method "callHierarchy/incomingCalls" then
        vim.keymap.set(
          "n",
          [[<leader>qi]],
          vim.lsp.buf.incoming_calls,
          { buffer = true, desc = "Incoming calls" }
        )
        if telescope then
          vim.keymap.set(
            "n",
            [[<leader>fi]],
            telescope.lsp_incoming_calls,
            { buffer = true, desc = "Incoming calls" }
          )
        end
      end

      if client:supports_method "callHierarchy/outgoingCalls" then
        vim.keymap.set(
          "n",
          [[<leader>qo]],
          vim.lsp.buf.outgoing_calls,
          { buffer = true, desc = "Outgoing calls" }
        )
        if telescope then
          vim.keymap.set(
            "n",
            [[<leader>fo]],
            telescope.lsp_outgoing_calls,
            { buffer = true, desc = "Outgoing calls" }
          )
        end
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
        vim.keymap.set(
          "n",
          [[gd]],
          vim.lsp.buf.definition,
          { buffer = true, desc = "Definition" }
        )
      end

      if client:supports_method "workspace/symbol" then
        if telescope then
          vim.keymap.set(
            "n",
            [[<leader>fW]],
            telescope.lsp_dynamic_workspace_symbols,
            { buffer = true, desc = "Dynamic workspace symbols" }
          )
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(event)
      vim.bo[event.buf].omnifunc = "syntaxcomplete#Complete"

      local function unset_bindings()
        vim.keymap.del("n", [[<leader>qc]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>fc]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>qi]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>fi]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>qo]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>fo]], { buffer = event.buf })
        vim.keymap.del("n", [[K]], { buffer = event.buf })
        vim.keymap.del("n", [[gd]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>fd]], { buffer = event.buf })
        vim.keymap.del("n", [[<leader>fW]], { buffer = event.buf })
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
      vim.hl.on_yank { timeout = 300 }
    end,
  })
end
set_autocommands()

function set_templates()
  local function enable_template(pattern, template)
    local template_path =
      vim.fs.joinpath(vim.fn.stdpath "config", "etc", "templates", template)
    vim.api.nvim_create_autocmd("BufNewFile", {
      pattern = pattern,
      command = "0r " .. template_path .. " | normal Gddgg",
    })
  end

  enable_template("*.cpp", "template.cpp")
  enable_template("*.dhall", "template.dhall")
  enable_template("*.dot", "template.dot")
  enable_template("*.hs", "template.hs")
  enable_template("*.java", "template.java")
  enable_template("*.md", "template.md")
  enable_template("*.pl", "template.pl")
  enable_template("*.scala", "template.scala")
  enable_template("*.sh", "template.sh")
  enable_template("tmux.yaml", "tmux-template.yaml")
end
set_templates()
