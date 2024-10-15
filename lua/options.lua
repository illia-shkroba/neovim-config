local M = {}

function M.set_default_options()
  local cmd = vim.cmd
  local opt = vim.opt

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

  opt.autoindent = true
  opt.completeopt = { "menuone", "preview", "popup" }
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

  set("", [[<leader>DD]], [[<Cmd>execute "cd .."<CR>]])
  set("", [[<leader>DL]], [[<Cmd>execute "lcd .."<CR>]])
  set("", [[<leader>DT]], [[<Cmd>execute "tcd .."<CR>]])
  set(
    "",
    [[<leader>dD]],
    [[<Cmd>execute "cd " .. system("dirname '" .. @% .. "'")<CR>]]
  )
  set(
    "",
    [[<leader>dL]],
    [[<Cmd>execute "lcd " .. system("dirname '" .. @% .. "'")<CR>]]
  )
  set(
    "",
    [[<leader>dT]],
    [[<Cmd>execute "tcd " .. system("dirname '" .. @% .. "'")<CR>]]
  )
  set("", [[<leader>dd]], function()
    cmd.cd(step_into_buffer_dir())
  end)
  set("", [[<leader>dl]], function()
    cmd.lcd(step_into_buffer_dir())
  end)
  set("", [[<leader>dt]], function()
    cmd.tcd(step_into_buffer_dir())
  end)

  -- diagnostic
  set("n", "]e", diagnostic.goto_next)
  set("n", "[e", diagnostic.goto_prev)
  set("n", [[<leader>e]], diagnostic.open_float)

  -- quickfix/location
  local list = require "list"
  local quickfix = list.quickfix
  local location = list.location

  set(
    "n",
    [[<leader>N]],
    [[:cprevious<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
  )
  set(
    "n",
    [[<leader>n]],
    [[:cnext<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
  )
  set(
    "n",
    [[<leader>LN]],
    [[:lprevious<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
  )
  set(
    "n",
    [[<leader>ln]],
    [[:lnext<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
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
  end)
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
  end)

  set("n", [[<leader>qX]], function()
    quickfix.reset()
    vim.notify(
      "Removed all quickfix items: " .. quickfix.get_title(),
      vim.log.levels.INFO
    )
  end)
  set("n", [[<leader>lX]], function()
    location.reset()
    vim.notify(
      "Removed all location items: " .. location.get_title(),
      vim.log.levels.INFO
    )
  end)

  set("n", [[<leader>qa]], function()
    quickfix.add_item(list.create_current_position_item())
    cmd.clast()
  end)
  set("n", [[<leader>la]], function()
    location.add_item(list.create_current_position_item())
    cmd.llast()
  end)

  set("n", [[<leader>qe]], diagnostic.setqflist)
  set("n", [[<leader>le]], diagnostic.setloclist)

  set("n", [[<leader>qx]], function()
    local name = utils.try(fn.input, "Enter quickfix list: ")
    if name then
      quickfix.create(name)
    end
  end)
  set("n", [[<leader>lx]], function()
    local name = utils.try(fn.input, "Enter location list: ")
    if name then
      location.create(name)
    end
  end)

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
  end)
  set("n", [[<leader>ld]], function()
    dump_list(location)
  end)

  set("n", [[<leader>S]], function()
    cmd.lvimgrep(utils.get_motion_selection().text, "##")
  end)
  set(
    "v",
    [[<leader>S]],
    [[:lua vim.cmd.lvimgrep(require("utils").get_visual_selection().text, "##")<CR>]]
  )

  -- tmux
  set(
    "",
    [[<leader>"]],
    [[<Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>]]
  )
  set(
    "",
    [[<leader>%]],
    [[<Cmd>execute "silent !tmux split-window -h -c '" .. getcwd() .. "'"<CR>]]
  )
  set(
    "",
    [[<leader>v]],
    [[<Cmd>execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>]]
  )

  -- telescope
  local telescope = utils.require_safe "telescope.builtin"
  if telescope then
    set("", [[<leader>fc]], telescope.lsp_references)
    set("", [[<leader>fi]], telescope.lsp_incoming_calls)
    set("", [[<leader>fo]], telescope.lsp_outgoing_calls)
    set("n", [[<leader>+]], function()
      cmd.Telescope "neoclip"
    end)
    set("n", [[<leader>F]], function()
      local extension = path.extension(api.nvim_buf_get_name(0))
      telescope.grep_string {
        word_match = "-w",
        additional_args = { "--glob", "*" .. extension },
      }
    end)
    set("n", [[<leader>f/]], telescope.search_history)
    set("n", [[<leader>fB]], function()
      telescope.live_grep {
        grep_open_files = true,
      }
    end)
    set("n", [[<leader>fC]], telescope.git_bcommits)
    set("n", [[<leader>fg]], function()
      local extension = path.extension(api.nvim_buf_get_name(0))
      local prefix, suffix =
        [[:lua require("telescope.builtin").live_grep { glob_pattern = { "*]],
        [[" } }]]
      return prefix .. extension .. suffix .. string.rep("<Left>", #suffix)
    end, { expr = true })
    set("n", [[<leader>fW]], function()
      telescope.grep_string {
        word_match = "-w",
        grep_open_files = true,
      }
    end)
    set("n", [[<leader>fb]], telescope.buffers)
    set("n", [[<leader>fd]], telescope.lsp_definitions)
    set("n", [[<leader>fF]], function()
      telescope.find_files { cwd = fs.dirname(api.nvim_buf_get_name(0)) }
    end)
    set("n", [[<leader>fG]], telescope.current_buffer_fuzzy_find)
    set("n", [[<leader>fR]], function()
      telescope.oldfiles { cwd_only = true }
    end)
    set("n", [[<leader>ff]], telescope.find_files)
    set("n", [[<leader>fj]], telescope.jumplist)
    set("n", [[<leader>fm]], telescope.marks)
    set("n", [[<leader>fq]], telescope.quickfixhistory)
    set("n", [[<leader>fr]], telescope.oldfiles)
    set("n", [[<leader>fs]], telescope.resume)
    set("n", [[<leader>fS]], telescope.pickers)
    set("n", [[<leader>ft]], telescope.tags)
    set("n", [[<leader>fT]], telescope.filetypes)
    set(
      "v",
      [[<leader>F]],
      [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection().text, additional_args = { "--glob", "*" .. vim.fn.expand "%:e:s/^/\\.\\0/" } }<CR>]]
    )
    set(
      "v",
      [[<leader>fW]],
      [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection().text, grep_open_files = true }<CR>]]
    )
  end

  -- nvim-tree
  local nvim_tree = utils.require_safe "nvim-tree.api"
  if nvim_tree then
    local nvim_tree_mode
    set("n", [[<leader>R]], function()
      if not nvim_tree.tree.is_visible() then
        nvim_tree_mode = nil
      end

      if nvim_tree_mode == 2 then
        nvim_tree.tree.close()
      end

      nvim_tree.tree.toggle {
        path = fs.dirname(api.nvim_buf_get_name(0)),
        find_file = true,
        focus = true,
      }
      nvim_tree_mode = 1
    end)
    set("n", [[<leader>r]], function()
      if not nvim_tree.tree.is_visible() then
        nvim_tree_mode = nil
      end

      if nvim_tree_mode == 1 then
        nvim_tree.tree.close()
      end

      nvim_tree.tree.toggle {
        path = fn.getcwd(),
        focus = true,
      }
      nvim_tree_mode = 2
    end)
  end

  -- git
  set(
    "n",
    [[<leader>DS]],
    [[<Cmd>wincmd s | wincmd T | vertical Gdiffsplit! HEAD<CR>]]
  )
  set("n", [[<leader>Ds]], [[<Cmd>vertical Gdiffsplit! HEAD<CR>]])
  set("n", [[<leader>ds]], [[<Cmd>vertical Gdiffsplit!<CR>]])
  set(
    "n",
    [[<leader>dS]],
    [[<Cmd>wincmd s | wincmd T | vertical Gdiffsplit!<CR>]]
  )
  set("n", [[<leader>P]], [[<Cmd>update ++p | Git add --patch -- %<CR>]])

  -- yield
  set("n", [[<leader>yP]], [[<Cmd>let @+ = expand("%:p")<CR>]])
  set("n", [[<leader>yT]], [[<Cmd>let @+ = expand("%:t")<CR>]])
  set("n", [[<leader>yp]], [[<Cmd>let @" = expand("%:p")<CR>]])
  set("n", [[<leader>yt]], [[<Cmd>let @" = expand("%:t")<CR>]])
  set("n", [[<leader>Y]], function()
    local selection = utils.get_motion_selection()
    fn.system {
      "tmux",
      "set-buffer",
      selection.text,
    }
  end)
  set(
    "v",
    [[<leader>Y]],
    [[:lua vim.fn.system { "tmux", "set-buffer", require("utils").get_visual_selection().text, }<CR>]]
  )

  -- substitute
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
  set("n", [[<leader>CN]], function()
    return substitute_word([[*]], fn.expand "<cword>")
  end, { expr = true })
  set("n", [[<leader>Cn]], function()
    local begin = api.nvim_buf_get_mark(0, "[")
    local end_ = api.nvim_buf_get_mark(0, "]")
    return substitute_word(
      tostring(begin[1]) .. "," .. tostring(end_[1]),
      fn.expand "<cword>"
    )
  end, { expr = true })
  set("n", [[<leader>cn]], function()
    return substitute_word([[%]], fn.expand "<cword>")
  end, { expr = true })
  set("n", [[<leader>cs]], [[<Cmd>keeppatterns %substitute/\s\+$//gc<CR>]])

  -- case
  local case = require "format.case"
  set("n", [[<leader>cF]], function()
    utils.map_motion(case.to_camel)
  end)
  set("n", [[<leader>cf]], function()
    utils.map_motion(case.to_snake)
  end)
  set(
    "v",
    [[<leader>cF]],
    [[:lua require("utils").map_visual(require("format.case").to_camel)<CR>]],
    { silent = true }
  )
  set(
    "v",
    [[<leader>cf]],
    [[:lua require("utils").map_visual(require("format.case").to_snake)<CR>]],
    { silent = true }
  )

  -- quote
  set("n", [[<leader>gq]], function()
    utils.map_motion(utils.quote)
  end)
  set(
    "v",
    [[<leader>gq]],
    [[:lua require("utils").map_visual(require("utils").quote)<CR>]],
    { silent = true }
  )

  -- fold
  set("n", [[<leader>gf]], function()
    opt.foldmethod = "indent"
  end)
  set("n", [[<leader>gF]], function()
    opt.foldmethod = "manual"
    cmd.normal "zE"
  end)

  -- search
  set("n", [[<leader>#]], function()
    return "?" .. fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true })
  set("n", [[<leader>*]], function()
    return "/" .. fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true })
  set(
    "v",
    [[<leader>#]],
    [[:lua vim.fn.setreg("/", require("utils").get_visual_selection().text .. "\\c"); vim.v.searchforward = false; vim.cmd.norm "n"<CR>]]
  )
  set(
    "v",
    [[<leader>*]],
    [[:lua vim.fn.setreg("/", require("utils").get_visual_selection().text .. "\\c"); vim.v.searchforward = true; vim.cmd.norm "n"<CR>]]
  )

  -- cmdline
  set("c", [[<C-j>]], "<Down>")
  set("c", [[<C-k>]], "<Up>")

  -- shift
  set("v", [[<C-j>]], [[:move '>+1<CR>gv]])
  set("v", [[<C-k>]], [[:move '<-2<CR>gv]])

  -- column
  set("n", [[<leader>gc]], [[:'{+1,'}-1!column -to ' '<CR>]])
  set("v", [[<leader>gc]], [[:!column -to ' '<CR>]], { silent = true })

  -- tags
  set("n", [[<leader>gt]], function()
    local language = vim.opt_local.filetype._value
    return [[:!ctags -R --languages=]] .. language .. [[ .]]
  end, { expr = true })

  -- popupmenu
  set("i", [[<C-l>]], function()
    return fn.pumvisible() == 1 and [[<C-l>]] or [[<C-n><C-p>]]
  end, { expr = true })
  set("i", [[<C-k>]], function()
    return fn.pumvisible() == 1 and [[<Up>]] or [[<C-k>]]
  end, { expr = true })
  set("i", [[<C-j>]], function()
    return fn.pumvisible() == 1 and [[<Down>]] or [[<C-j>]]
  end, { expr = true })
  set("i", [[<C-q>]], function()
    if fn.pumvisible() == 1 then
      cmd.Telescope "completion"
      return ""
    else
      return [[<C-q>]]
    end
  end, { expr = true })

  -- other
  set("n", [[<leader>QQ]], [[<Cmd>qall!<CR>]])
  set("n", [[<leader>Z]], function()
    local buffer = api.nvim_buf_get_name(0)
    if #buffer > 0 then
      fn.delete(buffer)
      vim.notify("Removed file: " .. buffer, vim.log.levels.INFO)
    end
  end)
  set("n", [[<leader>gv]], function()
    local mode = fn.visualmode()
    if string.len(mode) == 0 then
      mode = "v"
    elseif mode == "" then
      mode = "<C-v>"
    end
    return "`[" .. mode .. "`]"
  end, { expr = true })
  set("n", [[<leader>h]], cmd.nohlsearch)
  set("n", [[<leader>qq]], [[<Cmd>qall<CR>]])
  set("n", [[<leader>tc]], [[<Cmd>tabclose<CR>]])
  set("n", [[<leader>to]], [[<Cmd>tabonly<CR>]])
  set("n", [[<leader>tT]], [[<Cmd>-tabmove<CR>]])
  set("n", [[<leader>tt]], [[<Cmd>+tabmove<CR>]])
  set("n", [[<leader>u]], [[<Cmd>update ++p<CR>]])
  set("n", [[<leader><leader>]], [[m']])
end

function M.set_default_commands()
  local command = vim.api.nvim_create_user_command
  command("Config", [[split `=stdpath("config") .. "/init.lua"`]], {})
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
      set({ "", "i" }, [[<C-]>]], [[<CR>q:]], { buffer = true })
    end,
  })
  autocmd("LspAttach", {
    callback = function(event)
      vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      set("", [[<leader>.]], lsp.code_action, { buffer = true })
      set("", [[<leader>cN]], lsp.rename, { buffer = true })
      set("", [[<leader>qc]], lsp.references, { buffer = true })
      set("", [[<leader>qi]], lsp.incoming_calls, { buffer = true })
      set("", [[<leader>qo]], lsp.outgoing_calls, { buffer = true })
      set("", [[K]], lsp.hover, { buffer = true })
      set("n", [[gd]], lsp.definition, { buffer = true })
    end,
  })
  autocmd("LspDetach", {
    callback = function(event)
      vim.bo[event.buf].omnifunc = "syntaxcomplete#Complete"

      local function unset_bindings()
        del("", [[<leader>.]], { buffer = event.buf })
        del("", [[<leader>cN]], { buffer = event.buf })
        del("", [[<leader>qc]], { buffer = event.buf })
        del("", [[<leader>qi]], { buffer = event.buf })
        del("", [[<leader>qo]], { buffer = event.buf })
        del("", [[K]], { buffer = event.buf })
        del("n", [[gd]], { buffer = event.buf })
      end

      -- For some reasone `del` produces errors when triggered by `LspStop`
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
