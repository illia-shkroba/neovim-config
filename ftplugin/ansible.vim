if exists("b:did_ftplugin") && b:did_ftplugin > 1
  finish
endif
let b:did_ftplugin += 1

function SetAnsibleOptions()
  let b:lsp_start="vim.lsp.start({
  \   name = 'ansible-lsp',
  \   cmd = {'ansible-language-server', '--stdio'},
  \ })"
endfunction

call SetAnsibleOptions()
