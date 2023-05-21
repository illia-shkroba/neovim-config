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
endfunction
