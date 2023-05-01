function QuoteNormal()
  let quote = getcharstr()
  let [count, text_object] = ReadNumber()

  if index(["i", "a"], text_object) != -1
    let text_object ..= getcharstr()
  endif

  execute "normal v" .. (count ? count : "") .. text_object .. Quote(quote)
endfunction

function QuoteVisual()
  execute "normal " .. Quote(getcharstr())
endfunction

function Quote(quote)
  return "`>a" .. a:quote .. "`<i" .. a:quote .. ""
endfunction
