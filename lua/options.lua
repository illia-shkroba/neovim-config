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

  -- quickfix/location
  local list = require "list"
  local quickfix = list.quickfix
  local location = list.location

  set(
    "n",
    [[<leader>N]],
    [[<Cmd>execute v:count1 .. 'cprevious'<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
  )
  set(
    "n",
    [[<leader>n]],
    [[<Cmd>execute v:count1 .. 'cnext'<CR>:copen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
  )
  set(
    "n",
    [[<leader>LN]],
    [[<Cmd>execute v:count1 .. 'lprevious'<CR>:lopen<CR>zt:wincmd p<CR>zz]],
    { silent = true }
  )
  set(
    "n",
    [[<leader>ln]],
    [[<Cmd>execute v:count1 .. 'lnext'<CR>:lopen<CR>zt:wincmd p<CR>zz]],
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
    local pickers = require "plugins.telescope.pickers"

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
    set("n", [[<leader>fB]], function()
      telescope.live_grep {
        grep_open_files = true,
      }
    end)
    set("n", [[<leader>fC]], telescope.git_bcommits)
    set("n", [[<leader>fg]], pickers.live_grep_filetype)
    set("n", [[<leader>fW]], function()
      telescope.grep_string {
        word_match = "-w",
        grep_open_files = true,
      }
    end)
    set("n", [[<leader>fb]], telescope.buffers)
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

  -- git
  set("n", [[<leader>Ds]], [[<Cmd>vertical Gdiffsplit! HEAD<CR>]])
  set("n", [[<leader>ds]], [[<Cmd>vertical Gdiffsplit!<CR>]])
  set("n", [[<leader>P]], [[<Cmd>update ++p | Git add --patch -- %<CR>]])

  -- yield
  set("n", [[<leader>yP]], [[<Cmd>let @+ = expand("%:p")<CR>]])
  set("n", [[<leader>yT]], [[<Cmd>let @+ = expand("%:t")<CR>]])
  set("n", [[<leader>yY]], [[<Cmd>let @+ = expand("%")<CR>]])
  set("n", [[<leader>yp]], [[<Cmd>let @" = expand("%:p")<CR>]])
  set("n", [[<leader>yt]], [[<Cmd>let @" = expand("%:t")<CR>]])
  set("n", [[<leader>yy]], [[<Cmd>let @" = expand("%")<CR>]])
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
  local case = require "text.case"
  set("n", [[<leader>cF]], function()
    utils.map_motion(case.to_camel)
  end)
  set("n", [[<leader>cf]], function()
    utils.map_motion(case.to_snake)
  end)
  set(
    "v",
    [[<leader>cF]],
    [[:lua require("utils").map_visual(require("text.case").to_camel)<CR>]],
    { silent = true }
  )
  set(
    "v",
    [[<leader>cf]],
    [[:lua require("utils").map_visual(require("text.case").to_snake)<CR>]],
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
  set("c", [[<C-j>]], [[<Down>]])
  set("c", [[<C-k>]], [[<Up>]])
  set("c", [[<C-s>]], [[s//]])

  -- shift
  set("v", [[<C-j>]], [[:move '>+1<CR>gv]])
  set("v", [[<C-k>]], [[:move '<-2<CR>gv]])

  -- column
  set("n", [[<leader>gc]], function()
    utils.map_motion(utils.column)
  end)
  set(
    "v",
    [[<leader>gc]],
    [[:lua require("utils").map_visual(require("utils").column)<CR>]],
    { silent = true }
  )

  -- tags
  set("n", [[<leader>gt]], function()
    local language = vim.opt_local.filetype._value
    return [[:!ctags -R --languages=]] .. language .. [[ .]]
  end, { expr = true })

  -- popupmenu
  set("i", [[<C-k>]], function()
    return fn.pumvisible() == 1 and [[<Up>]] or [[<C-k>]]
  end, { expr = true })
  set("i", [[<C-j>]], function()
    return fn.pumvisible() == 1 and [[<Down>]] or [[<C-j>]]
  end, { expr = true })
  set("i", [[<C-z>]], function()
    if fn.pumvisible() == 1 then
      cmd.Telescope "completion"
      return ""
    else
      return [[<C-z>]]
    end
  end, { expr = true })

  -- tabs
  set("n", [[<leader>tc]], [[<Cmd>tabclose<CR>]])
  set("n", [[<leader>to]], [[<Cmd>tabonly<CR>]])
  set("n", [[<leader>tT]], [[<Cmd>-tabmove<CR>]])
  set("n", [[<leader>tt]], [[<Cmd>+tabmove<CR>]])

  -- undo
  set("n", [[<leader>r]], [[<Cmd>execute 'later ' .. v:count1 .. 'f'<CR>]])
  set("n", [[<leader>u]], [[<Cmd>execute 'earlier ' .. v:count1 .. 'f'<CR>]])

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
  set("n", [[<leader>qq]], [[<Cmd>qall<CR>]])
  set("n", [[<leader>w]], [[<Cmd>update ++p<CR>]])
  set("n", [[<leader><leader>]], [[m']])
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
      set({ "", "i" }, [[<C-]>]], [[<CR>q:]], { buffer = true })
    end,
  })
  autocmd("CmdwinEnter", {
    callback = function()
      set({ "i" }, [[<C-s>]], [[s//]], { buffer = true })
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
        set("n", [[<leader>.]], lsp.code_action, { buffer = true })
      end

      if client.supports_method "textDocument/rename" then
        set("n", [[<leader>cN]], lsp.rename, { buffer = true })
      end

      if client.supports_method "textDocument/references" then
        set("n", [[<leader>qc]], lsp.references, { buffer = true })
        if telescope then
          set("n", [[<leader>fc]], telescope.lsp_references, { buffer = true })
        end
      end

      if client.supports_method "callHierarchy/incomingCalls" then
        set("n", [[<leader>qi]], lsp.incoming_calls, { buffer = true })
        if telescope then
          set(
            "n",
            [[<leader>fi]],
            telescope.lsp_incoming_calls,
            { buffer = true }
          )
        end
      end

      if client.supports_method "callHierarchy/outgoingCalls" then
        set("n", [[<leader>qo]], lsp.outgoing_calls, { buffer = true })
        if telescope then
          set(
            "n",
            [[<leader>fo]],
            telescope.lsp_outgoing_calls,
            { buffer = true }
          )
        end
      end

      if client.supports_method "textDocument/hover" then
        set("n", [[K]], lsp.hover, { buffer = true })
      end

      if client.supports_method "textDocument/definition" then
        set("n", [[gd]], lsp.definition, { buffer = true })
        if telescope then
          set("n", [[<leader>fd]], telescope.lsp_definitions, { buffer = true })
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
