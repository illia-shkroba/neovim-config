" plugins should be loaded before executing other scripts
lua require("plugins")
lua require("lsp")

runtime src/options.vim
