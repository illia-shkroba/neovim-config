packadd cfilter

call plug#begin()
Plug 'LnL7/vim-nix'
Plug 'nvim-lua/plenary.nvim' " dependency for telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' " icons used by nvim-tree
Plug 'pearofducks/ansible-vim'
Plug 'tpope/vim-fugitive'
call plug#end()

function s:EnableNvimTree()
  " disable netrw
  lua vim.g.loaded_netrw = 1
  lua vim.g.loaded_netrwPlugin = 1

  lua require("nvim-tree").setup()
endfunction

call s:EnableNvimTree()

delfunction s:EnableNvimTree
