if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetDotnetOptions()
  setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab

  map <buffer> gh :OmniSharpCodeFormat \| OmniSharpFixUsings<CR>
endfunction

call SetDotnetOptions()
