function SetDefaultOptions()
  set autoindent
  set background=dark
  set encoding=utf-8
  set expandtab
  set hidden
  set incsearch
  set linebreak
  set noerrorbells vb t_vb= " disable beeping no error bells
  set nohlsearch
  set nowrapscan
  set number
  set path=**,./**
  set relativenumber
  set shiftwidth=2
  set smartindent
  set softtabstop=2
  set splitbelow splitright
  set tabstop=2
  set wildignore=*.pyc,*venv/*
  set wildmenu
  set modeline
  set omnifunc=syntaxcomplete#Complete
  set completeopt=menu
  let g:netrw_banner = 0
  let g:mapleader = ' '

  map <leader>o :lua vim.lsp.buf.hover()<CR>
  nmap <leader>A :call RemoveQuickfixListItem(GetCurrentQuickfixListItem())<CR>
  nmap <leader>L :call DisableLSP()<CR>
  nmap <leader>S :call SearchNormal()<CR>
  nmap <leader>X :call ResetQuickfixList()<CR>
  nmap <leader>a :call AddQuickfixListItem(CreateCurrentPositionItem()) \| clast<CR>
  nmap <leader>d :call delete(@%)<CR>
  nmap <leader>fb :Telescope buffers<CR>
  nmap <leader>ff :Telescope find_files<CR>
  nmap <leader>fm :Telescope marks<CR>
  nmap <leader>l :call EnableLSP()<CR>
  nmap <leader>q :call QuoteNormal()<CR>
  nmap <leader>s :%s/\s\+$//gc<CR>
  nmap <leader>t vip:!column -ts ' '<CR>
  nmap <leader>x :call CreateQuickfixListByPrompt()<CR>
  vmap <leader>S :call SearchVisual()<CR>
  vmap <leader>q :call QuoteVisual()<CR>
  vmap <leader>t :!column -ts ' '<CR>
endfunction
