function SetHaskellOptions()
  map <buffer> <leader>c :w !stack ghci <CR>
  nmap <buffer> <leader>C :up <CR>n:terminal stack ghci # <CR>
  map <buffer> gh :up \| %!hlint --refactor % <CR>
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=hindent makeprg=hlint

  let b:lsp_start="vim.lsp.start({
  \   name = 'haskell-lsp',
  \   cmd = {'haskell-language-server-wrapper', 'lsp'},
  \   root_dir = vim.fs.dirname(vim.fs.find({'package.yaml', 'stack.yaml', 'Setup.hs'}, { upward = true })[1])
  \ })"
  call LSPCallback()
endfunction
