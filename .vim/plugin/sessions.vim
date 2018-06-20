let s:ListOfDisplayedSessions = [] " linenumber as index; modified session names as displayed

if has("win32") || has("dos32") || has("dos16") || has("os2")
	let s:SessionsPath = ($HOME != '') ? $HOME . '/vimfiles' : ($APPDATA != '') ? $APPDATA . '/Vim' : $VIM
	let s:SessionsPath = substitute(s:SessionsPath, '\\', '/', 'g') . '/sessions'
else
	let s:SessionsPath = $HOME . '/.vim/sessions'
endif

function! Sessions() " <<<

   let l:PanelWidth = 20

   let s:ListOfSessions = glob(s:SessionsPath . '/*', 0, 1)
   call filter(s:ListOfDisplayedSessions, 0)

   for str in s:ListOfSessions
      let l:FileName = substitute(str, '\\', '/', 'g')
      let l:FileName = substitute(l:FileName, '.*/', '', '')
      let l:FileName = substitute(l:FileName, '\.vim$', '', '')

      call add(s:ListOfDisplayedSessions, l:FileName)
   endfor

   let l:Content = join(s:ListOfDisplayedSessions, "\n")

   return [l:PanelWidth, l:Content, 1]

endfunction " >>>

function! SessionsSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ SESSIONS
   map <silent> <nowait> <buffer> o :call SessionOpen()<CR>
   map <silent> <nowait> <buffer> a :call SessionAppend()<CR>
   map <silent> <nowait> <buffer> d :call SessionDelete()<CR>
   map <silent> <nowait> <buffer> r :call SessionRename()<CR>
   map <silent> <nowait> <buffer> w :call SessionWrite()<CR>
   map <silent> <nowait> <buffer> s :call SessionSave()<CR>
endfunction " >>>

function! SessionOpen() " <<<
   let l:SessionFile = s:ListOfSessions[line('.')-1]
   set eventignore=all
   exec 'silent! %bwipeout!'
   let l:n = bufnr('%')
   exec 'silent! so ' . l:SessionFile
   exec 'silent! bwipeout! ' . l:n
   set eventignore=
   doautoall BufRead
   doautoall FileType
   doautoall BufEnter
   doautoall BufWinEnter
   doautoall TabEnter
   doautoall SessionLoadPost
endfunction " >>>

function! SessionAppend() " <<<
   let l:SessionFile = s:ListOfSessions[line('.')-1]
   let l:CurrentSession = v:this_session
   set eventignore=all
   exec 'silent! so ' . l:SessionFile
   set eventignore=
   doautoall BufRead
   doautoall FileType
   doautoall BufEnter
   doautoall BufWinEnter
   doautoall TabEnter
   doautoall SessionLoadPost
   let v:this_session = l:CurrentSession
endfunction " >>>

function! SessionDelete() " <<<
   let l:idx = line('.')-1
   let l:SessionFile = s:ListOfSessions[l:idx]
   let l:SessionName = s:ListOfDisplayedSessions[l:idx]
   if confirm('are you sure you want to delete "' . l:SessionName . '" session?', "&yes\n&no", 2) == 1
      if delete(l:SessionFile) != 0
         redraw | echohl ErrorMsg | echo 'error: could not delete session file  "' . l:SessionFile . '"' | echohl None
      else
         call PanelUpdate()
      endif
   endif
endfunction " >>>

function! SessionRename() " <<<
   let l:SessionName = input('rename session to: ')
   if l:SessionName != ''
       let l:idx = line('.')-1
       let l:OldName = s:ListOfSessions[l:idx]
       let l:NewName = s:SessionsPath . '/' . l:SessionName . '.vim'
       if rename(l:OldName, l:NewName) != 0
          redraw | echohl ErrorMsg | echo 'error: could not rename session from "' . l:OldName . '" to "' . l:NewName . '"' | echohl None
       else
          call PanelUpdate()
       endif
   endif
endf " >>>

function! SessionWrite() " <<<
   if v:this_session != ''
      silent! argdel *
      execute 'silent mksession! ' . v:this_session
		redraw | echo 'session "' . GetFileName(v:this_session) . '" written'
   else
      redraw | echohl ErrorMsg | echo 'error: use s to save session with a name' | echohl None
   endif
endf " >>>

function! SessionSave() " <<<
   let l:SessionName = input('save session as: ')
   if l:SessionName != ''
      if finddir(s:SessionsPath, '/') == '' " not needed  in NeoVim
         call mkdir(s:SessionsPath, 'p')
      endif
      silent! argdel *
      execute 'silent mksession! ' . s:SessionsPath . '/' . l:SessionName . '.vim' 
      call PanelUpdate()
   endif
endf " >>>
