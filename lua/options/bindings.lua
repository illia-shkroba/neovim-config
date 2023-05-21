return function()
  local lsp = vim.lsp.buf
  local set = vim.keymap.set

  local telescope = require "telescope.builtin"

  -- cwd
  set("", [[<leader>dd]], [[<Cmd>execute "cd " .. system("dirname " .. @%)<CR>]])
  set("", [[<leader>dl]], [[<Cmd>execute "lcd " .. system("dirname " .. @%)<CR>]])
  set("", [[<leader>dt]], [[<Cmd>execute "tcd " .. system("dirname " .. @%)<CR>]])

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
  set("n", [[<leader>qa]], [[<Cmd>call AddQuickfixListItem(CreateCurrentPositionItem()) \| clast<CR>]])
  set("n", [[<leader>qx]], [[<Cmd>call CreateQuickfixListByPrompt()<CR>]])

  -- tmux
  set("", [[<leader>"]], [[<Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>]])
  set("", [[<leader>%]], [[<Cmd>execute "silent !tmux split-window -h -c '" .. getcwd() .. "'"<CR>]])
  set("", [[<leader>v]], [[<Cmd>execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>]])

  -- telescope
  set("n", [[<leader>=]], telescope.spell_suggest)
  set("n", [[<leader>F]], telescope.grep_string)
  set("n", [[<leader>fC]], telescope.colorscheme)
  set("n", [[<leader>fb]], telescope.buffers)
  set("n", [[<leader>ff]], telescope.find_files)
  set("n", [[<leader>fg]], telescope.live_grep)
  set("n", [[<leader>fm]], telescope.marks)
  set("n", [[<leader>fr]], telescope.oldfiles)
  set("n", [[<leader>ft]], telescope.tags)
  set("", [[<leader>fc]], telescope.lsp_references)
  set("", [[<leader>fd]], telescope.lsp_definitions)
  set("", [[<leader>fi]], telescope.lsp_incoming_calls)
  set("", [[<leader>fo]], telescope.lsp_outgoing_calls)
  set("v", [[<leader>F]], [[:lua require("telescope.builtin").grep_string { search = vim.fn.GetVisualSelection() }<CR>]])

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
