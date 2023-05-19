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

  map <leader>" :execute "silent !tmux split-window -v -c '" .. getcwd() .. "'"<CR>
  map <leader>% :execute "silent !tmux split-window -h -c '" .. getcwd() .. "'"<CR>
  map <leader>. :lua vim.lsp.buf.code_action()<CR>
  map <leader>dd :execute "cd " .. system("dirname " .. @%)<CR>
  map <leader>dl :execute "lcd " .. system("dirname " .. @%)<CR>
  map <leader>dt :execute "tcd " .. system("dirname " .. @%)<CR>
  map <leader>fc :lua require("telescope.builtin").lsp_references()<CR>
  map <leader>fd :lua require("telescope.builtin").lsp_definitions()<CR>
  map <leader>fi :lua require("telescope.builtin").lsp_incoming_calls()<CR>
  map <leader>fo :lua require("telescope.builtin").lsp_outgoing_calls()<CR>
  map <leader>o :lua vim.lsp.buf.hover()<CR>
  map <leader>qc :lua vim.lsp.buf.references()<CR>
  map <leader>qi :lua vim.lsp.buf.incoming_calls()<CR>
  map <leader>qo :lua vim.lsp.buf.outgoing_calls()<CR>
  map <leader>v :execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>
  nmap <leader>= :Telescope spell_suggest<CR>
  nmap <leader>D :call delete(@%)<CR>
  nmap <leader>F :Telescope live_grep<CR>
  nmap <leader>L :call DisableLSP()<CR>
  nmap <leader>N :cprevious<CR>:copen<CR>zt:wincmd p<CR>zz
  nmap <leader>S :call SearchNormal()<CR>
  nmap <leader>T :NvimTreeFindFileToggle<CR>
  nmap <leader>fC :Telescope colorscheme<CR>
  nmap <leader>fb :Telescope buffers<CR>
  nmap <leader>ff :Telescope find_files<CR>
  nmap <leader>fm :Telescope marks<CR>
  nmap <leader>fr :Telescope oldfiles<CR>
  nmap <leader>ft :Telescope tags<CR>
  nmap <leader>gd :lua vim.lsp.buf.definition()<CR>
  nmap <leader>gq :call QuoteNormal()<CR>
  nmap <leader>l :call EnableLSP()<CR>
  nmap <leader>n :cnext<CR>:copen<CR>zt:wincmd p<CR>zz
  nmap <leader>qA :call RemoveQuickfixListItem(GetCurrentQuickfixListItem())<CR>
  nmap <leader>qX :call ResetQuickfixList()<CR>
  nmap <leader>qa :call AddQuickfixListItem(CreateCurrentPositionItem()) \| clast<CR>
  nmap <leader>qx :call CreateQuickfixListByPrompt()<CR>
  nmap <leader>r vip:!column -to ' '<CR>
  nmap <leader>s :%s/\s\+$//gc<CR>
  nmap <leader>t :NvimTreeToggle<CR>
  vmap <C-j> :move '>+1<CR>gv
  vmap <C-k> :move '<-2<CR>gv
  vmap <leader>S :call SearchVisual()<CR>
  vmap <leader>gq :call QuoteVisual()<CR>
  vmap <leader>r :!column -to ' '<CR>
endfunction
