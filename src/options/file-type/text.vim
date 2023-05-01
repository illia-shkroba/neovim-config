function SetTextOptions()
  noremap <buffer> gqap vap:call StripWS()<CR>gqap
  noremap <buffer> gqip vip:call StripWS()<CR>gqip
  noremap <buffer> gqq :call StripWS()<CR>gqq
  noremap <buffer> gww :call StripWS()<CR>gww
endfunction
