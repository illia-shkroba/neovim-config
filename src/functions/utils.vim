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
