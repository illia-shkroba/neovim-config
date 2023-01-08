function QuoteNormal()
  let quote = getcharstr()
  let [count, text_object] = ReadNumber()

  if index(["i", "a"], text_object) != -1
    let text_object ..= getcharstr()
  endif

  execute "normal v" .. (count ? count : "") .. text_object .. QuoteExpression(quote)
endfunction

function QuoteExpression(quote)
  return "`>a" .. a:quote .. "`<i" .. a:quote .. ""
endfunction

function ReadNumber()
  let [lower, upper] = map(["0", "9"], {x -> char2nr(x)})

  let acc = 0
  let char = getchar()
  while lower <= char && char <= upper
    let acc = acc * 10 + char - lower
    let char = getchar()
  endwhile

  return [acc, nr2char(char)]
endfunction

function QuoteVisual()
  execute "normal " .. QuoteExpression(getcharstr())
endfunction
