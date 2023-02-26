function SetNixOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=nixpkgs-fmt

  let b:lsp_start="vim.lsp.start({
  \   name = 'nix-lsp',
  \   cmd = {'rnix-lsp'},
  \ })"
  call LSPCallback()
endfunction
