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
  let lower = char2nr("0")
  let upper = char2nr("9")

  let x = 0
  let c = getchar()
  while lower <= c && c <= upper
    let x = x * 10 + c - lower
    let c = getchar()
  endwhile

  return [x, nr2char(c)]
endfunction

function QuoteVisual()
  let quote = getcharstr()
  execute "normal " .. QuoteExpression(quote)
endfunction
