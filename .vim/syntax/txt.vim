if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif
let b:current_syntax = 'txt'

syn keyword txtTodo TODO
syn region  txtString start=/"/ end=/"/

hi link txtTodo    Todo
hi link txtString  String
