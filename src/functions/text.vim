function StripWS() range
  let r = @/
  execute a:firstline .. ',' .. a:lastline .. 'substitute/\s\+/ /g'
  let @/ = r
endfunction
