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
  map <leader>o :lua vim.lsp.buf.hover()<CR>
  map <leader>v :execute "silent !tmux new-window -c '" .. getcwd() .. "'"<CR>
  nmap <leader>= :Telescope spell_suggest<CR>
  nmap <leader>A :call RemoveQuickfixListItem(GetCurrentQuickfixListItem())<CR>
  nmap <leader>D :call delete(@%)<CR>
  nmap <leader>F :Telescope live_grep<CR>
  nmap <leader>L :call DisableLSP()<CR>
  nmap <leader>S :call SearchNormal()<CR>
  nmap <leader>T :NvimTreeFindFileToggle<CR>
  nmap <leader>X :call ResetQuickfixList()<CR>
  nmap <leader>a :call AddQuickfixListItem(CreateCurrentPositionItem()) \| clast<CR>
  nmap <leader>fb :Telescope buffers<CR>
  nmap <leader>fc :Telescope colorscheme<CR>
  nmap <leader>ff :Telescope find_files<CR>
  nmap <leader>fm :Telescope marks<CR>
  nmap <leader>fr :Telescope oldfiles<CR>
  nmap <leader>ft :Telescope tags<CR>
  nmap <leader>l :call EnableLSP()<CR>
  nmap <leader>q :call QuoteNormal()<CR>
  nmap <leader>r vip:!column -to ' '<CR>
  nmap <leader>s :%s/\s\+$//gc<CR>
  nmap <leader>t :NvimTreeToggle<CR>
  nmap <leader>x :call CreateQuickfixListByPrompt()<CR>
  vmap <C-j> :move '>+1<CR>gv
  vmap <C-k> :move '<-2<CR>gv
  vmap <leader>S :call SearchVisual()<CR>
  vmap <leader>q :call QuoteVisual()<CR>
  vmap <leader>r :!column -to ' '<CR>
endfunction
