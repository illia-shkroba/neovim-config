if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetJavaOptions()
  setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab makeprg=javac
endfunction

call SetJavaOptions()
