if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetNixOptions()
  map <buffer> <leader>c :up \| !nix-instantiate --eval --strict % <CR>
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=nixfmt

  let b:lsp_start="vim.lsp.start({
  \   name = 'nix-lsp',
  \   cmd = {'rnix-lsp'},
  \ })"
endfunction

call SetNixOptions()
