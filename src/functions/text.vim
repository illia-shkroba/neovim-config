function StripWS() range
  let register = @/
  execute a:firstline .. ',' .. a:lastline .. 'substitute/\s\+/ /g'
  let @/ = register
endfunction
