if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetJSONOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=jq
endfunction

call SetJSONOptions()
