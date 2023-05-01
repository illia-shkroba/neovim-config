function SetAnsibleOptions()
  let b:lsp_start="vim.lsp.start({
  \   name = 'ansible-lsp',
  \   cmd = {'ansible-language-server', '--stdio'},
  \ })"
  call LSPCallback()
endfunction
