function SearchNormal()
  let register = @"
  normal ""yiW
  let word = @"
  let @" = register
  call Search(word)
endfunction

function SearchVisual()
  let word = GetVisualSelection()
  call Search(word)
endfunction

function Search(word)
  execute "lvimgrep/\\<" .. substitute(a:word, "\/", "\\\\\/", "g") .. "\\>/##"
endfunction
