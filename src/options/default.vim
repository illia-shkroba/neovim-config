function SetDefaultOptions()
  let g:mapleader = ' '
  let g:netrw_banner = 0
  set autoindent
  set completeopt=menu
  set encoding=utf-8
  set expandtab
  set hidden
  set incsearch
  set linebreak
  set modeline
  set noerrorbells vb t_vb= " disable beeping no error bells
  set nohlsearch
  set nowrapscan
  set number
  set omnifunc=syntaxcomplete#Complete
  set path=**,./**
  set relativenumber
  set shiftwidth=2
  set smartindent
  set softtabstop=2
  set splitbelow splitright
  set tabstop=2
  set termguicolors
  set wildmenu

  map <leader>" <Cmd>execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>
  map <leader>% <Cmd>execute "silent !tmux split-window -h -c '" .. getcwd() .. "'"<CR>
  map <leader>. <Cmd>lua vim.lsp.buf.code_action()<CR>
  map <leader>dd <Cmd>execute "cd " .. system("dirname " .. @%)<CR>
  map <leader>dl <Cmd>execute "lcd " .. system("dirname " .. @%)<CR>
  map <leader>dt <Cmd>execute "tcd " .. system("dirname " .. @%)<CR>
  map <leader>fc <Cmd>lua require("telescope.builtin").lsp_references()<CR>
  map <leader>fd <Cmd>lua require("telescope.builtin").lsp_definitions()<CR>
  map <leader>fi <Cmd>lua require("telescope.builtin").lsp_incoming_calls()<CR>
  map <leader>fo <Cmd>lua require("telescope.builtin").lsp_outgoing_calls()<CR>
  map <leader>o <Cmd>lua vim.lsp.buf.hover()<CR>
  map <leader>qc <Cmd>lua vim.lsp.buf.references()<CR>
  map <leader>qi <Cmd>lua vim.lsp.buf.incoming_calls()<CR>
  map <leader>qo <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>
  map <leader>v <Cmd>execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>
  nmap <leader>= <Cmd>Telescope spell_suggest<CR>
  nmap <leader>D <Cmd>call delete(@%)<CR>
  nmap <leader>F <Cmd>lua require("telescope.builtin").grep_string()<CR>
  nmap <leader>L <Cmd>lua require("lsp").disable_lsp()<CR>
  nmap <silent> <leader>N :cprevious<CR>:copen<CR>zt:wincmd p<CR>zz
  nmap <leader>S <Cmd>call SearchNormal()<CR>
  nmap <leader>T <Cmd>NvimTreeFindFileToggle<CR>
  nmap <leader>fC <Cmd>Telescope colorscheme<CR>
  nmap <leader>fb <Cmd>Telescope buffers<CR>
  nmap <leader>ff <Cmd>Telescope find_files<CR>
  nmap <leader>fg <Cmd>Telescope live_grep<CR>
  nmap <leader>fm <Cmd>Telescope marks<CR>
  nmap <leader>fr <Cmd>Telescope oldfiles<CR>
  nmap <leader>ft <Cmd>Telescope tags<CR>
  nmap <leader>gd <Cmd>lua vim.lsp.buf.definition()<CR>
  nmap <leader>gq <Cmd>call QuoteNormal()<CR>
  nmap <leader>l <Cmd>lua require("lsp").enable_lsp()<CR>
  nmap <silent> <leader>n :cnext<CR>:copen<CR>zt:wincmd p<CR>zz
  nmap <leader>qA <Cmd>call RemoveQuickfixListItem(GetCurrentQuickfixListItem())<CR>
  nmap <leader>qX <Cmd>call ResetQuickfixList()<CR>
  nmap <leader>qa <Cmd>call AddQuickfixListItem(CreateCurrentPositionItem()) \| clast<CR>
  nmap <leader>qx <Cmd>call CreateQuickfixListByPrompt()<CR>
  nmap <leader>r vip:!column -to ' '<CR>
  nmap <leader>s <Cmd>%s/\s\+$//gc<CR>
  nmap <leader>t <Cmd>NvimTreeToggle<CR>
  vmap <C-j> :move '>+1<CR>gv
  vmap <C-k> :move '<-2<CR>gv
  vmap <leader>F :lua require("telescope.builtin").grep_string { search = vim.fn.GetVisualSelection() }<CR>
  vmap <leader>S :call SearchVisual()<CR>
  vmap <silent> <leader>gq :call QuoteVisual()<CR>
  vmap <silent> <leader>r :!column -to ' '<CR>
endfunction
