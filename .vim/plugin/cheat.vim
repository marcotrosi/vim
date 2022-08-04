let s:MyCheatSheets = []

if has("win32")
   let s:MyCheatSheetFiles = globpath($VIM . '\vimfiles\cheatsheets', "*.cs", 0, 1)      
else
   let s:MyCheatSheetFiles = globpath("~/.vim/cheatsheets", "*.cs", 0, 1)
endif

for cs in s:MyCheatSheetFiles
   if has("win32")
      call add(s:MyCheatSheets, substitute(substitute(substitute(cs, "\.cs$", "",""), ".*\\", "", ""),"_"," ","g"))
   else
      call add(s:MyCheatSheets, substitute(substitute(substitute(cs, "\.cs$", "",""), ".*/", "", ""),"_"," ","g"))
   endif
endfor

function! Cheat() " <<<
   let l:PanelWidth = 20
   return [l:PanelWidth, s:MyCheatSheets, 1]
endfunction " >>>

function! CheatSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ CHEATSHEETS
   map <silent> <nowait> <buffer> o :call CheatOpen()<CR>
   map <silent> <nowait> <buffer> <CR> :call CheatOpen()<CR>
endfunction " >>>

function! CheatOpen() " <<<
   exec "vert botright pedit +set\\ nobuflisted " .. s:MyCheatSheetFiles[line('.')-1]
   call PanelClose()
endfunction " >>>

