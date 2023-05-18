function SetVimOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  let b:lsp_start="vim.lsp.start({
  \   name = 'vim-lsp',
  \   cmd = {'vim-language-server', '--stdio'},
  \ })"
endfunction
