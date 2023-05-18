if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetPureScriptOptions()
  nmap <buffer> <leader>g :silent !fast-tags -R --qualified . <CR>
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab makeprg=spago\ build
  setl errorformat=
    \%-G,
    \%-Z,
    \%W%f:%l:%c:\ Warning:\ %m,
    \%E%f:%l:%c:\ Error:,
    \%E%>%f:%l:%c:,
    \%W%>%f:%l:%c:,

  let stylish_config = stdpath("config") .. "/etc/options/file-type-options/haskell/stylish-haskell.yaml"
  execute "setl formatprg=stylish-haskell\\ --config\\ " .. stylish_config

  let b:lsp_start="vim.lsp.start({
  \   name = 'purescript-lsp',
  \   cmd = {'purescript-language-server', '--stdio'},
  \   root_dir = vim.fs.dirname(vim.fs.find({'spago.dhall', 'packages.dhall', 'package.json'}, { upward = true })[1])
  \ })"
endfunction

call SetPureScriptOptions()
