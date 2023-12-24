local M = {}

function M.set_default_options()
  local cmd = vim.cmd
  local opt = vim.opt

  cmd.filetype "on"

  opt.autoindent = true
  opt.completeopt = "menu"
  opt.encoding = "utf-8"
  opt.expandtab = true
  opt.formatoptions = "tcro/qanl1j"
  opt.hidden = true
  opt.hlsearch = true
  opt.inccommand = "split"
  opt.incsearch = true
  opt.linebreak = true
  opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
  opt.modeline = true
  opt.number = true
  opt.omnifunc = "syntaxcomplete#Complete"
  opt.path = { "**", "./**" }
  opt.pumblend = 10
  opt.relativenumber = true
  opt.shiftround = true
  opt.shiftwidth = 2
  opt.smartindent = true
  opt.softtabstop = 2
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
    [[<Cmd>execute "cd " .. system("dirname " .. @%)<CR>]]
  )
  set(
    "",
    [[<leader>dL]],
    [[<Cmd>execute "lcd " .. system("dirname " .. @%)<CR>]]
  )
  set(
    "",
    [[<leader>dT]],
    [[<Cmd>execute "tcd " .. system("dirname " .. @%)<CR>]]
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

  -- quickfix
  local quickfix = require "quickfix"
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
  set("n", [[<leader>qA]], function()
    local index = quickfix.get_current_item_index()
    local item = quickfix.get_current_item()
    quickfix.remove_item(item)
    utils.try(cmd, [[cc ]] .. index)
    if item.text then
      print("Removed quickfix item: " .. vim.trim(item.text))
    end
  end)
  set("n", [[<leader>qX]], function()
    quickfix.reset()
    print("Removed all quickfix items: " .. quickfix.get_title())
  end)
  set("n", [[<leader>qa]], function()
    quickfix.add_item(quickfix.create_current_position_item())
    cmd.clast()
  end)
  set("n", [[<leader>qe]], diagnostic.setqflist)
  set("n", [[<leader>qx]], quickfix.create_by_prompt)

  -- location
  local location = require "location"
  set("n", [[<leader>S]], function()
    location.search(utils.get_motion_selection())
  end)
  set(
    "v",
    [[<leader>S]],
    [[:lua require("location").search(require("utils").get_visual_selection())<CR>]]
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
    set("", [[<leader>=]], telescope.spell_suggest)
    set("", [[<leader>fc]], telescope.lsp_references)
    set("", [[<leader>fi]], telescope.lsp_incoming_calls)
    set("", [[<leader>fo]], telescope.lsp_outgoing_calls)
    set("n", [[<leader>+]], function()
      cmd.Telescope "neoclip"
    end)
    set("n", [[<leader>F]], function()
      local extension = path.extension(api.nvim_buf_get_name(0))
      if extension then
        extension = "." .. extension
      else
        extension = ""
      end

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
    set("n", [[<leader>fC]], telescope.colorscheme)
    set("n", [[<leader>fG]], function()
      local extension = path.extension(api.nvim_buf_get_name(0))
      if extension then
        extension = "." .. extension
      else
        extension = ""
      end

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
    set("n", [[<leader>ff]], telescope.find_files)
    set("n", [[<leader>fg]], telescope.live_grep)
    set("n", [[<leader>fj]], telescope.jumplist)
    set("n", [[<leader>fm]], telescope.marks)
    set("n", [[<leader>fq]], telescope.quickfixhistory)
    set("n", [[<leader>fr]], telescope.oldfiles)
    set("n", [[<leader>fS]], telescope.resume)
    set("n", [[<leader>fs]], telescope.pickers)
    set("n", [[<leader>ft]], telescope.tags)
    set("n", [[<leader>fT]], telescope.filetypes)
    set(
      "v",
      [[<leader>F]],
      [[:lua require("telescope.builtin").grep_string { search = require("utils").get_visual_selection() }<CR>]]
    )
  end

  -- nvim-tree
  local nvim_tree = utils.require_safe "nvim-tree.api"
  if nvim_tree then
    local nvim_tree_mode
    set("n", [[<leader>T]], function()
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
    set("n", [[<leader>t]], function()
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
  set("n", [[<leader>DS]], [[<Cmd>:wincmd s | wincmd T | Gdiffsplit! HEAD<CR>]])
  set("n", [[<leader>Ds]], [[<Cmd>:Gdiffsplit! HEAD<CR>]])
  set("n", [[<leader>ds]], [[<Cmd>:Gdiffsplit!<CR>]])
  set("n", [[<leader>dS]], [[<Cmd>:wincmd s | wincmd T | Gdiffsplit!<CR>]])
  set("n", [[<leader>P]], [[<Cmd>:Git add --patch -- %<CR>]])

  -- yield
  set("n", [[<leader>YF]], [[<Cmd>let @+ = @%<CR>]])
  set("n", [[<leader>yf]], [[<Cmd>let @" = @%<CR>]])

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
  set("n", [[<leader>cn]], function()
    return substitute_word([[%]], fn.expand "<cword>")
  end, { expr = true })
  set("n", [[<leader>cs]], [[<Cmd>%s/\s\+$//gc<CR>]])

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
  end)

  -- other
  set("c", [[<C-j>]], "<Down>")
  set("c", [[<C-k>]], "<Up>")
  set("n", [[<leader>#]], function()
    return "?" .. fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true })
  set("n", [[<leader>*]], function()
    return "/" .. fn.expand "<cword>" .. "\\c<CR>"
  end, { expr = true })
  set(
    "n",
    [[<leader>Z]],
    [[<Cmd>echo "Removed file: " .. @% | call delete(@%)<CR>]]
  )
  set("n", [[<leader>R]], [[vip:!column -to ' '<CR>]])
  set("n", [[<leader>h]], cmd.nohlsearch)
  set("v", [[<C-j>]], [[:move '>+1<CR>gv]])
  set("v", [[<C-k>]], [[:move '<-2<CR>gv]])
  set("v", [[<leader>r]], [[:!column -to ' '<CR>]], { silent = true })
end

function M.set_default_autocommands()
  local autocmd = vim.api.nvim_create_autocmd
  local del = vim.keymap.del
  local lsp = vim.lsp.buf
  local set = vim.keymap.set

  local utils = require "utils"

  autocmd(
    "BufWritePost",
    { pattern = { ".Xresources", "xresources" }, command = "silent !xrdb %" }
  )
  autocmd("CmdwinEnter", {
    pattern = { "*" },
    callback = function()
      set({ "", "i" }, [[<C-]>]], [[<CR>q:]], { buffer = true })
    end,
  })
  autocmd(
    "BufWritePost",
    { pattern = "config.h", command = "silent !sudo make install" }
  )
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
  enable_template "hs"
  enable_template "java"
  enable_template "md"
  enable_template "pl"
  enable_template "scala"
  enable_template "sh"
end

return M
