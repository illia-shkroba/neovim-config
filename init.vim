" plugins should be loaded before executing other scripts
lua require("plugins")

runtime src/options.vim
lua require("options")
