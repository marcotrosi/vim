" Vim syntax file
" Language:	todo files
" Maintainer:	Marco Trosi
" Last change:	2017 March 6

" quit when a syntax file was already loaded
if exists ("b:current_syntax")
    finish
endif

hi Done guifg=#000000 guibg=#A6E22E gui=bold
hi Wait guifg=#000000 guibg=#F92672 gui=bold
hi ToDo guifg=#000000 guibg=#66D9EF gui=bold

" case off
syn case ignore

syn match ToDoComment   "#.*"
syn match ToDoPrioHigh  "!!! .*$"
syn match ToDoPrioMid   "!! .*$"
syn match ToDoPrioLow   "! .*$"
syn match ToDoDate      "\d\d\.\d\d.\d\d\d\d"
syn match ToDoEmph      "'.*'"
syn match ToDoResp      "=>"
syn match ToDoList      "\d\+\. "
syn match ToDoDone      "DONE"
syn match ToDoWait      "WAIT"
syn match ToDoToDo      "TODO"

hi def link ToDoComment   Comment
hi def link ToDoPrioHigh  Operator
hi def link ToDoPrioMid   Identifier
hi def link ToDoPrioLow   String

hi def link ToDoDate   Number
hi def link ToDoEmph   Define
hi def link ToDoResp   Define
hi def link ToDoList   Function
hi def link ToDoDone   Done
hi def link ToDoWait   Wait
hi def link ToDoToDo   ToDo

let b:current_syntax = "cfg"
" vim:ts=4
