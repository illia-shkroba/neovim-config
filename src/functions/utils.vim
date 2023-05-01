function GetVisualSelection()
  let [_, line_begin, column_begin, _] = getpos("'<")
  let [_, line_end, column_end, _] = getpos("'>")
  let lines = getline(line_begin, line_end)

  if empty(lines)
    return ""
  endif

  let lines[-1] = lines[-1][:column_end - 1]
  let lines[0] = lines[0][column_begin - 1:]

  return join(lines, "\n")
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
