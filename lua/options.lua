local M = {}

function M.set_default_options()
  local cmd = vim.cmd
  local opt = vim.opt

  cmd.filetype "on"

  opt.autoindent = true
  opt.completeopt = "menu"
  opt.encoding = "utf-8"
  opt.expandtab = true
  opt.hidden = true
  opt.incsearch = true
  opt.linebreak = true
  opt.modeline = true
  opt.hlsearch = false
  opt.wrapscan = false
  opt.number = true
  opt.omnifunc = "syntaxcomplete#Complete"
  opt.path = "**,./**"
  opt.relativenumber = true
  opt.shiftwidth = 2
  opt.smartindent = true
  opt.softtabstop = 2
  opt.splitbelow = true
  opt.splitright = true
  opt.tabstop = 2
  opt.termguicolors = true
  opt.wildmenu = true
end

function M.set_default_bindings(options)
  local g = vim.g
  local lsp = vim.lsp.buf
  local set = vim.keymap.set

  if type(options) == "table" and type(options.leader_key) == "string" then
    g.mapleader = options.leader_key
  else
    g.mapleader = " "
  end

  -- cwd
  set("", [[<leader>dD]], [[<Cmd>execute "cd " .. system("dirname " .. @%)<CR>]])
  set("", [[<leader>dL]], [[<Cmd>execute "lcd " .. system("dirname " .. @%)<CR>]])
  set("", [[<leader>dT]], [[<Cmd>execute "tcd " .. system("dirname " .. @%)<CR>]])
  set("", [[<leader>dd]], [[<Cmd>execute "cd " .. system("dirname " .. @%)->split("/")[0]<CR>]])
  set("", [[<leader>dl]], [[<Cmd>execute "lcd " .. system("dirname " .. @%)->split("/")[0]<CR>]])
  set("", [[<leader>dt]], [[<Cmd>execute "tcd " .. system("dirname " .. @%)->split("/")[0]<CR>]])

  -- lsp
  set("", [[<leader>.]], lsp.code_action)
  set("", [[<leader>o]], lsp.hover)
  set("", [[<leader>qc]], lsp.references)
  set("", [[<leader>qi]], lsp.incoming_calls)
  set("", [[<leader>qo]], lsp.outgoing_calls)
  set("n", [[<leader>L]], require("lsp").disable_lsp)
  set("n", [[<leader>gd]], lsp.definition)
  set("n", [[<leader>l]], require("lsp").enable_lsp)

  -- quickfix
  set("n", [[<leader>N]], [[:cprevious<CR>:copen<CR>zt:wincmd p<CR>zz]], { silent = true })
  set("n", [[<leader>n]], [[:cnext<CR>:copen<CR>zt:wincmd p<CR>zz]], { silent = true})
  set("n", [[<leader>qA]], [[<Cmd>call RemoveQuickfixListItem(GetCurrentQuickfixListItem())<CR>]])
  set("n", [[<leader>qX]], [[<Cmd>call ResetQuickfixList()<CR>]])
  set("n", [[<leader>qa]], [[<Cmd>call AddQuickfixListItem(CreateCurrentPositionItem()) | clast<CR>]])
  set("n", [[<leader>qx]], [[<Cmd>call CreateQuickfixListByPrompt()<CR>]])

  -- tmux
  set("", [[<leader>"]], [[<Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>]])
  set("", [[<leader>%]], [[<Cmd>execute "silent !tmux split-window -h -c '" .. getcwd() .. "'"<CR>]])
  set("", [[<leader>v]], [[<Cmd>execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>]])

  -- telescope
  local telescope = require("utils").require_safe "telescope.builtin"
  if telescope then
    set("", [[<leader>fc]], telescope.lsp_references)
    set("", [[<leader>fd]], telescope.lsp_definitions)
    set("", [[<leader>fi]], telescope.lsp_incoming_calls)
    set("", [[<leader>fo]], telescope.lsp_outgoing_calls)
    set("n", [[<leader>=]], telescope.spell_suggest)
    set("n", [[<leader>F]], telescope.grep_string)
    set("n", [[<leader>fC]], telescope.colorscheme)
    set("n", [[<leader>fb]], telescope.buffers)
    set("n", [[<leader>ff]], telescope.find_files)
    set("n", [[<leader>fg]], telescope.live_grep)
    set("n", [[<leader>fm]], telescope.marks)
    set("n", [[<leader>fq]], telescope.quickfixhistory)
    set("n", [[<leader>fr]], telescope.oldfiles)
    set("n", [[<leader>ft]], telescope.tags)
    set("v", [[<leader>F]], [[:lua require("telescope.builtin").grep_string { search = vim.fn.GetVisualSelection() }<CR>]])
  end

  -- nvim-tree
  set("n", [[<leader>T]], [[<Cmd>NvimTreeFindFileToggle<CR>]])
  set("n", [[<leader>t]], [[<Cmd>NvimTreeToggle<CR>]])

  -- other
  set("n", [[<leader>D]], [[<Cmd>call delete(@%)<CR>]])
  set("n", [[<leader>S]], [[<Cmd>call SearchNormal()<CR>]])
  set("n", [[<leader>gq]], [[<Cmd>call QuoteNormal()<CR>]])
  set("n", [[<leader>r]], [[vip:!column -to ' '<CR>]])
  set("n", [[<leader>s]], [[<Cmd>%s/\s\+$//gc<CR>]])
  set("v", [[<C-j>]], [[:move '>+1<CR>gv]])
  set("v", [[<C-k>]], [[:move '<-2<CR>gv]])
  set("v", [[<leader>S]], [[:call SearchVisual()<CR>]])
  set("v", [[<leader>gq]], [[:call QuoteVisual()<CR>]], { silent = true })
  set("v", [[<leader>r]], [[:!column -to ' '<CR>]], { silent = true })
end

function M.set_default_autocommands()
  local autocmd = vim.api.nvim_create_autocmd

  autocmd(
    "BufWritePost",
    { pattern = { ".Xresources", "xresources" }, command = "silent !xrdb %" }
  )
  autocmd(
    "BufWritePost",
    { pattern = "config.h", command = "silent !sudo make install" }
  )
  autocmd(
    "BufWritePost",
    { pattern = "plugins.lua", command = "source % | PackerCompile" }
  )

  local function enable_lsp(pattern)
    autocmd(
      "BufEnter",
      { pattern = pattern, callback = require("lsp").lsp_callback }
    )
  end

  enable_lsp "*.hs"
  enable_lsp "*.lua"
  enable_lsp "*.nix"
  enable_lsp "*.purs"
  enable_lsp "*.py"
  enable_lsp "*.tf"
  enable_lsp "*.vim"
  enable_lsp "*Dockerfile"
  enable_lsp "site.yaml"
end

function M.enable_templates()
  local autocmd = vim.api.nvim_create_autocmd
  local fn = vim.fn

  local templates_dir = fn.stdpath "config" .. "/etc/templates/"

  local function enable_template(extension)
    local template_path = templates_dir .. "template." .. extension
    autocmd("BufNewFile", {
      pattern = "*." .. extension,
      command = "0r " .. template_path .. " | normal Gdd",
    })
  end

  enable_template "cpp"
  enable_template "hs"
  enable_template "java"
  enable_template "md"
  enable_template "scala"
end

return M
