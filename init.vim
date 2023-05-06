" plugins should be loaded before executing other scripts
lua require("plugins")

" options.vim defines functions that set options for different file types
runtime src/options.vim
