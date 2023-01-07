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
endfunction

call SetDefaultOptions()

runtime! src/options/file-type-options/**.vim
