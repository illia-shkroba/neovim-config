function CreateQuickfixListByPrompt()
  call CreateQuickfixList(input("Enter quickfix list: "))
endfunction

function CreateQuickfixList(name)
  call setqflist([], " ", {"nr": "$", "title": a:name})
endfunction

function ResetQuickfixList()
  call SetQuickfixListItems([])
endfunction

function SetQuickfixListItems(items)
  let quickfix_list = getqflist({"all": ""})

  let new_quickfix_list = ClearQuickfixList(quickfix_list)
  let new_quickfix_list["items"] = a:items

  call setqflist([], "r", new_quickfix_list)
endfunction

function ClearQuickfixList(quickfix_list)
  let new_quickfix_list = {}
  for key in ['quickfixtextfunc', 'id', 'nr', 'winid', 'title']
    let new_quickfix_list[key] = a:quickfix_list[key]
  endfor
  return new_quickfix_list
endfunction

function AddQuickfixListItem(item)
  call setqflist([a:item], "a")
endfunction

function RemoveQuickfixListItem(item)
  let items = copy(getqflist())
  call SetQuickfixListItems(filter(items, {_, x -> x != a:item}))
endfunction

function GetCurrentQuickfixListItem()
  let items = getqflist()
  return empty(items) ? {} : items[getqflist({"idx": 0}).idx - 1]
endfunction

function CreateCurrentPositionItem()
  let [_, line, column, _, _] = getcurpos()
  return {"filename": @%, "lnum": line, "col": column, "text": getline(line)}
endfunction
