return function()
  local g = vim.g
  local opt = vim.opt

  g.mapleader = " "
  g.netrw_banner = 0

  opt.autoindent = true
  opt.completeopt = "menu"
  opt.encoding = "utf-8"
  opt.expandtab = true
  opt.hidden = true
  opt.incsearch = true
  opt.linebreak = true
  opt.modeline = true
  opt.hlsearch = false
  opt.wrapscan = false
  opt.number = true
  opt.omnifunc = "syntaxcomplete#Complete"
  opt.path = "**,./**"
  opt.relativenumber = true
  opt.shiftwidth = 2
  opt.smartindent = true
  opt.softtabstop = 2
  opt.splitbelow = true
  opt.splitright = true
  opt.tabstop = 2
  opt.termguicolors = true
  opt.wildmenu = true
end
