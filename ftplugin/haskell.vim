if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetHaskellOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab makeprg=stack\ build\ --cabal-verbosity\ 0
  setl errorformat=
    \%-G,
    \%-Z,
    \%W%\\S%#>\ %f:%l:%c:\ Warning:\ %m,
    \%E%\\S%#>\ %f:%l:%c:\ Error:,
    \%W%f:%l:%c:\ Warning:\ %m,
    \%E%f:%l:%c:\ Error:,
    \%E%>%f:%l:%c:,
    \%W%>%f:%l:%c:,

  let stylish_config = stdpath("config") .. "/etc/options/file-type-options/haskell/stylish-haskell.yaml"
  execute "setl formatprg=stylish-haskell\\ --config\\ " .. stylish_config

  map <buffer> <leader><CR> :w !stack ghci<CR>
  map <buffer> gh :up \| %!hlint --refactor %<CR>
  nmap <buffer> <leader><Tab> :up <CR>n:terminal stack ghci #<CR>
  nmap <buffer> <leader>g :silent !fast-tags -R --qualified .<CR>

  let b:lsp_start="vim.lsp.start({
  \   name = 'haskell-lsp',
  \   cmd = {'haskell-language-server-wrapper', 'lsp'},
  \   root_dir = vim.fs.dirname(vim.fs.find({'package.yaml', 'stack.yaml', 'Setup.hs'}, { upward = true })[1])
  \ })"
endfunction

call SetHaskellOptions()
