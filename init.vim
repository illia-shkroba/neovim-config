" Plugins should be enabled before other scripts
runtime src/plugins.vim

" Functions should be defined after enabling plugins and before other scripts
runtime src/functions.vim

" options.vim defines functions that set options for different file types
" Since autocmd.vim uses these functions, options.vim should be executed first
runtime src/options.vim
runtime src/autocmd.vim

" These scripts can be executed in any order
runtime src/abbreviations.vim
runtime src/maps.vim
