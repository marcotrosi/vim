" __   _____ __  __ ___  ___
" \ \ / /_ _|  \/  | _ \/ __|
"  \ V / | || |\/| |   / (__
"   \_/ |___|_|  |_|_|_\\___|
"                  marcotrosi


" functions <<<
" cycle spellcheck languages <<<
let s:myLang = 0
let s:myLangList = [ "en", "de", "it" ]
function! CycleSpellLang(direction)
   let s:myLang = s:myLang + a:direction
   if s:myLang >= len(s:myLangList) | let s:myLang = 0 | endif
   if s:myLang < 0 | let s:myLang = len(s:myLangList)-1 | endif
   exe "set spelllang=".s:myLangList[s:myLang]
   echo "language:" s:myLangList[s:myLang]
endf
" >>>

" cycle colorschemes <<<
let s:myColorscheme = 0
let s:myColorschemeList  = []
if has("win32")
   let s:myColorschemeFiles = globpath($VIM . '\vimfiles\colors', "*.vim", 0, 1)      
else
   let s:myColorschemeFiles = globpath("~/.vim/colors", "*.vim", 0, 1)
endif

for cs in s:myColorschemeFiles
   if has("win32")
      call add(s:myColorschemeList, substitute(substitute(cs, "\.vim$", "",""), ".*\\", "", ""))
   else
      call add(s:myColorschemeList, substitute(substitute(cs, "\.vim$", "",""), ".*/", "", ""))
   endif
endfor
unlet s:myColorschemeFiles

function! SetColorscheme(id, result)
   if a:result == -1
      return
   endif

   let s:myColorscheme = a:result-1
   exe "colorscheme ".s:myColorschemeList[a:result-1]
   colorscheme
endfunction

function! CycleColorscheme(direction)
   if a:direction == 0
      let l:WinID = popup_menu(s:myColorschemeList, {'callback': 'SetColorscheme'})
   else
      let s:myColorscheme = s:myColorscheme + a:direction
      if s:myColorscheme >= len(s:myColorschemeList) | let s:myColorscheme = 0 | endif
      if s:myColorscheme < 0 | let s:myColorscheme = len(s:myColorschemeList)-1 | endif
      exe "colorscheme ".s:myColorschemeList[s:myColorscheme]
      redraw
      colorscheme
   endif
endf
" >>>

" get highlight group <<<
function! GetHighlightGroup()
   let l:s = synID(line('.'), col('.'), 1)                                       
   echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
  endfunction " >>>

" cycle notation functions <<<
" general workflow <<<
"    T1              T2              T3               T4               T1
" oneTwoThree -> OneTwoThree -> ONE_TWO_THREE -> one_two_three -> oneTwoThree
"   T5        T6        T7        T5
" foobar -> Foobar -> FOOBAR -> foobar

" step by step workflow
" get word under cursor and store
" detect type and store type
" change to next type (in variable)
" replace word under the cursor
" >>>

" detect notation type <<<
function! s:DetectNotation(str)

   "type one       oneTwoThree
   if(match(a:str, "^\\l\\+\\u") != -1)
      return 1
   endif
   "type two       OneTwoThree
   if(match(a:str, "^\\u\\l\\+") != -1)
      return 2
   endif
   "type three     ONE_TWO_THREE
   if(match(a:str, "^\\u\\+_") != -1)
      return 3
   endif
   "type four      one_two_three
   if(match(a:str, "^\\l\\+_") != -1)
      return 4
   endif

   "type five      one
   if(match(a:str, "^\\l\\+") != -1)
      return 5
   endif

   "type six       One
   if(match(a:str, "^\\u\\l\\+") != -1)
      return 6
   endif

   "type seven     ONE
   if(match(a:str, "^\\u\\+") != -1)
      return 7
   endif

   return 0
endfunction
" >>>

" cycle notation <<<
function! CycleNotation()

   " get and store word under cursor
   let l:symbol = expand('<cword>')

   " detect notation type
   let l:type = s:DetectNotation(l:symbol)

   if l:type == 0
      return
   endif

   " change notation
   if(l:type == 1)
      "echo l:symbol." is type one"
      let l:new_notation = substitute(l:symbol, "^\\(\\l\\)\\(.*\\)", "\\U\\1\\E\\2", "")
      echo l:symbol "=>" l:new_notation
   endif

   if(l:type == 2)
      "echo l:symbol." is type two"
      let l:new_notation = substitute(l:symbol, "\\(\\l\\)\\(\\u\\)", "\\1_\\2", "g")
      let l:new_notation = toupper(l:new_notation)
      echo l:symbol "=>" l:new_notation
   endif

   if(l:type == 3)
      "echo l:symbol." is type three"
      let l:new_notation = tolower(l:symbol)
      echo l:symbol "=>" l:new_notation
   endif

   if(l:type == 4)
      "echo l:symbol." is type four"
      let l:new_notation = substitute(l:symbol, "_\\(\\l\\)", "\\U\\1\\E", "g")
      echo l:symbol "=>" l:new_notation
   endif

   if(l:type == 5)
      "echo l:symbol." is type five"
      let l:new_notation = substitute(l:symbol, "^\\(\\l\\)\\(.*\\)", "\\u\\1\\2", "")
      echo l:symbol "=>" l:new_notation
   endif

   if(l:type == 6)
      "echo l:symbol." is type six"
      let l:new_notation = substitute(l:symbol, "^\\(.*\\)", "\\U\\1\\E", "g")
      echo l:symbol "=>" l:new_notation
   endif

   if(l:type == 7)
      "echo l:symbol." is type seven"
      let l:new_notation = substitute(l:symbol, "^\\(.*\\)", "\\L\\1\\E", "g")
      echo l:symbol "=>" l:new_notation
   endif

   " replace word under cursor
   exe "normal! ciw=l:new_notation\<CR>"

endfunction
" >>>
" >>>

" cycle font type and size <<< 
let s:myFontType     = 6 
let s:myFontSize     = 4 
let s:myFontTypeList = ["Courier\\ New", "Lucida\\ Console", "Consolas", "Hack", "Menlo", "DejaVu\\ Sans\\ Mono", "Fira\\ Code", "JetBrains\\ Mono", "Inconsolata"]
let s:myFontSizeList = ["7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]

function! CycleFontType(direction) 
   let s:myFontType = s:myFontType + a:direction
   if s:myFontType >= len(s:myFontTypeList) | let s:myFontType = 0 | endif 
   if s:myFontType < 0 | let s:myFontType = len(s:myFontTypeList)-1 | endif 
   exe "set guifont=".s:myFontTypeList[s:myFontType].":h".s:myFontSizeList[s:myFontSize] 
   redraw 
   set guifont? 
endfunction

function! CycleFontSize(direction) 
   let s:myFontSize = s:myFontSize + a:direction
   if s:myFontSize >= len(s:myFontSizeList) | let s:myFontSize = 0   | endif 
   if s:myFontSize <  0 | let s:myFontSize = len(s:myFontSizeList)-1 | endif 
   exe "set guifont=".s:myFontTypeList[s:myFontType].":h".s:myFontSizeList[s:myFontSize] 
   redraw 
   set guifont? 
endfunction
" >>> 

" cycle base <<<
"is there a better way of inserting/substituting text?
"connect with repeat.vim or find a similar solution
function! CycleBase()
   let l:value = expand('<cword>')

   if(match(l:value, '^\d\+$') != -1)
      exe "Tobase 16 " . l:value
      let @" = "0x" . @"
      echo l:value . " -> " . @"
      normal viwp
      return
   end

   if(match(l:value, '^0x\x\+$') != -1)
      exe "Tobase 2 " . l:value
      let @" = "0b" . @"
      echo l:value . " -> " . @"
      normal viwp
      return
   end

   if(match(l:value, '^0b[01]\+$') != -1)
      let l:value = substitute(l:value, "0b", "y", "")
      exe "Tobase 10 " . l:value
      echo l:value . " -> " . @"
      normal viwp
      return
   end
endfunction
" >>>

" cycle tabspace <<<
function! CycleTabSpace(direction)
   let g:TabSpace = g:TabSpace + a:direction
   if g:TabSpace > 4
      let g:TabSpace = 2
   elseif g:TabSpace < 2
      let g:TabSpace = 4
   endif
   execute 'set tabstop='.g:TabSpace
   execute 'set softtabstop='.g:TabSpace
   echo "tabspace = ".g:TabSpace
endfunction " >>>

" cycle textwidth <<<
function! CycleTextWidth(direction)
   if g:TextWidth == 0
      let g:TextWidth = 80
   elseif g:TextWidth == 80
      let g:TextWidth = 120
   elseif g:TextWidth == 120
      let g:TextWidth = 180
   else
      let g:TextWidth = 0
   endif
   execute 'set textwidth='.g:TextWidth
   set textwidth?
endfunction " >>>

" make menu <<<
function! Make()
   let l:myMakeTargets = ["quit", "", "tag", "cln", "bld", "tst", "rel", "all", "doc"]
   let l:c=0
   let l:c = confirm("Make Menu","&make\nta&g\n&cln\n&bld\n&tst\n&rel\n&all\n&doc")
   if l:c != 0
      exe "silent! make " . l:myMakeTargets[l:c] . " NOCOLOR=true"
   endif
endfunction
" >>>

" align ctrl menu <<<
function! SetAlignCtrl()
   let l:myAlignCtrls = ["quit", "p0P0", "p1P0", "p0P1", "p1P1"]
   let l:c = confirm("AlignCtrl","&1p0P0\n&2p1P0\n&3p0P1\n&4p1P1\n", 3)
   if l:c != 0
      exe "AlignCtrl " . l:myAlignCtrls[l:c]
   endif
endfunction
" >>>

" grep match colors <<<
let s:Matches= 
\{ 
\  'Match1':'false', 
\  'Match2':'false', 
\  'Match3':'false', 
\  'Match4':'false', 
\  'Match5':'false', 
\  'Match6':'false', 
\  'Match7':'false', 
\  'Match8':'false', 
\  'Match9':'false' 
\} 

function! DefMatchColors() " <<<
   " put after colorscheme load and somehow reload after colorscheme changes or make as part of the colorscheme, latter is the preferred solution
   hi Match0 guifg=White guibg=grey62 
   hi Match1 guifg=White guibg=DarkOrchid4 
   hi Match2 guifg=Black guibg=SkyBlue        gui=bold 
   hi Match3 guifg=Black guibg=OliveDrab2     gui=bold 
   hi Match4 guifg=Black guibg=coral1         gui=bold 
   hi Match5 guifg=Black guibg=plum           gui=bold 
   hi Match6 guifg=Black guibg=orange         gui=bold 
   hi Match7 guifg=White guibg=DeepSkyBlue4 
   hi Match8 guifg=White guibg=DarkOliveGreen 
   hi Match9 guifg=White guibg=firebrick4 
endfunction " >>>

function! ClearMatches()
   call clearmatches()
   for [mgrp, val] in items(s:Matches)
         let s:Matches[mgrp]='false'
   endfor
endfunction

function! NextMatch()
   for [mgrp, val] in items(s:Matches)
      if val == 'false'
         let s:Matches[mgrp]='true'
         return mgrp
      endif
   endfor
   return 'Match0'
endfunction

function! AddMatch(str)
   call matchadd(NextMatch(), MakeRegExSafe(a:str))
endfunction
" >>>

" reverse lines <<<
function! RevSelLines()
   execute 'move'.eval(a:firstline-1)
endfunction
" >>>

" reverse string <<<
function! ReverseString(str)
   return join(reverse(split(a:str, '.\zs')), '')
endfunction
" >>>

" toggle foldcolumn <<<
function! ToggleFoldColumn()
   if &foldcolumn
      setlocal foldcolumn=0
   else
      setlocal foldcolumn=4
   endif
endfunction
" >>>

" toggle quickfix <<<
function! ToggleQuickFix()
   if len(filter(getwininfo(), 'v:val.quickfix'))
      cclose
   else
      copen
   endif
endfunction
" >>>

" toggle location list <<<
function! ToggleLocList()
   if len(filter(getwininfo(), 'v:val.loclist'))
      lclose
   else
      lopen
   endif
endfunction
" >>>

" jump to test <<<
function! JumpToTest(funcname)

   if a:funcname == ''
      " let g:FunctionPattern_s = '^function!\s\+\(\w\+\)'
      " FunctionsPattern are defined globally at the autocommand section

      normal $
      let l:StartOfFunc_n = search(g:FunctionPattern_s, 'bcnWz')
      " echo l:StartOfFunc_n

      if l:StartOfFunc_n == 0
         echo 'JumpToTest() warning: no function found'
         return
      end

      " let l:FuncName = expand('<cword>')
      let l:FuncName = matchlist(getline(l:StartOfFunc_n), g:FunctionPattern_s)[1]
      " echo l:FuncName
   else
      let l:FuncName = a:funcname
   end

   if(match(l:FuncName, '^test_') != -1)
      let l:JumpTo = substitute(l:FuncName, '^test_', '', '')
   else
      let l:JumpTo = "test_".l:FuncName
   end

   echo 'jumping to "'.l:JumpTo.'"'
   exe "silent! tag ".l:JumpTo

   return
endfunction
" >>>

" jump to file-line-column <<<
function! JumpToFLC()
   let m = matchlist(getline("."), '^\(\S\+\):\(\d\+\):\(\d\+\): ')
   if len(m)
      execute 'edit '.m[1].' | call cursor('.m[2].','m[3].')'
   endif
endfunction
" >>>

" jump to start of line <<<
function! JumpToStartOfLine()

   let l:CurCol = col(".")

   if l:CurCol == 1
      normal _
   else
      normal 0
      " call cursor(".", 1)
   endif

endfunction
" >>>

" jump to end line <<<
function! JumpToEndOfLine()

   let l:CurCol = col(".")
   let l:EndCol = col("$")-1

   if l:CurCol == l:EndCol
      normal g_
   else
      normal $
      " exec 'call cursor(".", '.l:EndCol.')'
   endif

endfunction
" >>>

" get byte offset <<<
function! GetByteOffset()
   return line2byte(line('.')) + col('.') - 1
endfunction " >>>

" shorten string <<<
function! ShortenString(string, width, ...)
   let l:where = get(a:, 1, 'r')
   let l:StringWidth = strwidth(a:string)
   if a:width <= 0
      return ''
   endif
   if l:StringWidth <= a:width
      return a:string
   else
      if l:where == 'l'     " left
         return "…" . strpart(a:string, l:StringWidth-(a:width-1))
      elseif l:where == 'm' " middle
         return strpart(a:string, 0, (a:width/2)) . "…" . strpart(a:string, l:StringWidth-(((a:width+1)/2)-1))
      else                  " right
         return strpart(a:string, 0, (a:width-1)) . "…"
      endif
   endif
endfunction " >>>

" balloon & sign <<<
let g:LuaExe="lua"
let g:MsgDir=$Vim."\\vimfiles\\messages\\msg"
let g:MsgFile=$Vim."\\vimfiles\\messages\\messages"

let g:BalloonData=$Vim."\\vimfiles\\messages\\balloondata"
let g:BalloonText=$Vim."\\vimfiles\\messages\\balloontext"
let g:BalloonScript=g:LuaExe." ".$Vim."\\vimfiles\\messages\\balloonscript ".g:BalloonData." ".g:BalloonText." ".g:MsgFile

function! Balloon() " <<<
   let balloondata = ['return', '{']
   call add(balloondata, "  ['filepath']    = [[" . expand('%:p')   . "]],")
   call add(balloondata, "  ['filedir']     = [[" . expand('%:p:h') . "]],")
   call add(balloondata, "  ['filename']    = [[" . expand('%:t')   . "]],")
   call add(balloondata, "  ['fileext']     = [[" . expand('%:e')   . "]],")
   call add(balloondata, "  ['cwd']         = [[" . getcwd()        . "]],")
   call add(balloondata, "  ['line']        = [[" . v:beval_lnum    . "]],")
   call add(balloondata, "  ['column']      = [[" . v:beval_col     . "]],")
   call add(balloondata, "  ['text']        = [[" . v:beval_text    . "]],")
   call add(balloondata, "}")
   call writefile(balloondata, g:BalloonData)
   call system(g:BalloonScript)
   if filereadable(g:BalloonText)
      let l:text = join(readfile(g:BalloonText), "\n")
      call delete(g:BalloonText)
   else
      let l:text = 'balloonscript error: the file balloontext does not exist'
   endif
   return l:text
endfunction " >>>

let g:SignVimFile=$Vim."\\vimfiles\\messages\\signvimfile"
let g:SignScript=g:LuaExe." ".$Vim."\\vimfiles\\messages\\signscript ".g:SignVimFile." ".g:MsgDir." ".g:MsgFile

function! Sign() " <<<
   sign unplace *
   call system(g:SignScript)
   " sign place 1 line=10 name=W file=C:\LegacyApp\_my\tools\vim\.vimrc
   exe 'source '.g:SignVimFile
endfunction " >>>
" >>>

" clean up <<<
function! CleanUp()
      call delete(g:BalloonText)
      call delete(g:MsgFile)
      call delete(g:SignVimFile)
endfunction
" >>>

" change register type <<<
function! ChangeRegType(RegName, ...)
" 1 optional parameter for the new regtype ("c", "l" or "b")
" if omitted cycle through characterwise, linewise, blockwise

   let l:CurRegType = getregtype(a:RegName)

   if l:CurRegType == ""
      echo "regtype for register " . a:RegName . " is unknown"
      return
   endif

   " regtype name conversion for readabilty only
   if l:CurRegType ==# "v"
      let l:CurRegType = "c"
   elseif l:CurRegType ==# "V"
      let l:CurRegType = "l"
   else
      let l:CurRegType = "b"
   endif

   if a:0 == 0 " no new regtype passed to function

      if l:CurRegType == "c"
         let l:NewRegType = "l"
      elseif l:CurRegType == "l"
         let l:NewRegType = "b"
      else
         let l:NewRegType = "c"
      endif

   else
      let l:NewRegType = a:1
   endif

   if (l:NewRegType != "c") && (l:NewRegType != "l") && (l:NewRegType != "b")
      echo "the given regtype " . l:NewRegType . " is invalid
      return
   endif

   echo "changing regtype for register " . a:RegName . " from " . l:CurRegType . " to " . l:NewRegType
   call setreg(a:RegName, getreg(a:RegName), l:NewRegType)
 
endfunction " >>>

" rearrange columns <<<
function! ReArrangeColumns(delimiter, ...) range

   " echo a:delimiter
   " echo a:000

   if a:0 <= 1
      return
   endif

   let l:Pattern = '\(.\{-}\)' . repeat(a:delimiter . '\(.\{-}\)', a:0 - 1) . '$'

   let l:Replace = ''

   for i in a:000
      let l:Replace = l:Replace . a:delimiter . '\' . i
   endfor

   let l:Replace = strpart(l:Replace, 1)

   " echo a:firstline.','.a:lastline.'s/' . l:Pattern . '/' . l:Replace . '/'
   silent execute a:firstline.','.a:lastline.'s/' . l:Pattern . '/' . l:Replace . '/'

endfunction

" >>>

" fix file <<<
function! FixFile()
   %s;\s\+$;;e
   if strlen(getline('$')) != 0
      $put =''
   end
endfunction " >>>

" make regex safe <<<
function! MakeRegExSafe(str)
   return '\V'.substitute(a:str, '\\', '\\\\', 'g')
endfunction " >>>

" edit register <<<
function! EditReg(reg)

   let l:EditRegWinNum = bufwinnr("__EDITREG__")

   if l:EditRegWinNum == -1
      silent! belowright new __EDITREG__
      setlocal modifiable
      put! =getreg(a:reg)
      $d_
      setlocal noshowcmd
      setlocal buftype=nofile
      setlocal bufhidden=wipe
      setlocal noswapfile
      setlocal nowrap
      setlocal nobuflisted
      setlocal nonumber
      setlocal nospell
      execute 'setlocal statusline=editing\ register\ \"'.a:reg.'\ \|\ <CR>\ to\ confirm\ changes\ \|\ <ESC>\ or\ q\ to\ discard\ changes'
      setlocal noruler
      execute 'normal! z'.line('$').'ggG'
      startinsert!
   endif

   execute "nnoremap <buffer> <silent> <CR>  :call setreg('" . a:reg . "', getline(1,'$')) <BAR> silent! bwipeout! __EDITREG__<CR>"

   execute "inoremap <buffer> <silent> <CR>  <ESC>:call setreg('" . a:reg . "', getline(1,'$')) <BAR> silent! bwipeout! __EDITREG__<CR>"

   nnoremap <buffer> <silent> <ESC> :silent! bwipeout! __EDITREG__<CR>

   nnoremap <buffer> <silent>     q :silent! bwipeout! __EDITREG__<CR>

   autocmd  BufLeave <buffer> :silent! bwipeout! __EDITREG__

endfunction
" >>>

" visual block <<<
function! VisualBlock(a, sep)

   " a can be 0 or 1
   "    0 for ib (separator excluded)
   "    1 for ab (separator included)
   " sep is a single separator character
   "    if sep is an empty string '' then the function
   "    will run getchar() to ask for a separator

   "getcurpos returns [bufnum, lnum, col, off, curswant]

   if a:sep == ''
      let l:SepNum = getchar()
      if l:SepNum == 27 " abort on ESC
          return
      endif
      let l:Separator = nr2char(l:SepNum)
   else
      let l:Separator = a:sep
   endif

   " correction of cursor position just in
   " case the cursor was on the separator
   if getline('.')[col('.')-1] == l:Separator
      normal h
   end
   let l:CursorPos = getcurpos()
   let l:CursorCol = l:CursorPos[2] - 1

   " find next sep
   execute 'normal f'.l:Separator
   let l:NewCursorColRight = getcurpos()[2] - 1

   " if cursor hasn't moved we
   " must be in the last column
   let l:AfterLastSep = 0
   if l:NewCursorColRight == l:CursorCol
      let l:AfterLastSep = 1
      let l:BlockRightCol = col('$') - 2
   else
      if a:a
         let l:BlockRightCol = l:NewCursorColRight
      else
         let l:BlockRightCol = l:NewCursorColRight - 1
      endif
   endif

   " find previous sep
   execute 'normal F'.l:Separator
   let l:NewCursorColLeft = getcurpos()[2] - 1
   " if cursor hasn't moved we
   " must be in the first column
   if l:NewCursorColLeft == l:NewCursorColRight
      let l:BlockLeftCol = 0
   else
      " in case of ab and cursor after last
      " separator include the left separator
      if l:AfterLastSep && a:a
         let l:BlockLeftCol = l:NewCursorColLeft
      else
         let l:BlockLeftCol = l:NewCursorColLeft + 1
      endif
   end

   normal vip
   let l:BlockBottomLine = getcurpos()[1]

   normal gvo
   let l:BlockTopLine = getcurpos()[1]

   let l:TopLeftPos     = [l:CursorPos[0], l:BlockTopLine   , l:BlockLeftCol +1, 0]
   let l:BottomRightPos = [l:CursorPos[0], l:BlockBottomLine, l:BlockRightCol+1, 0]

   call setpos('.', l:TopLeftPos)

   normal 

   call setpos('.', l:BottomRightPos)

   if l:AfterLastSep
      normal $
   end

endfunction
" >>>

" get next non-blank line <<<
function! GetNextNonBlankLine()
   let l:LineNum = line(".")
   while v:true
      if getline(l:LineNum) !~ '^\s*$'
         return l:LineNum
      endif
      let l:LineNum = l:LineNum + 1
      if l:LineNum > line("$")
         return -1
      endif
   endwhile
endfunction " >>>

" get previous non-blank line <<<
function! GetPrevNonBlankLine()
   let l:LineNum = line(".")
   while v:true
      if getline(l:LineNum) !~ '^\s*$'
         return l:LineNum
      endif
      let l:LineNum = l:LineNum - 1
      if l:LineNum < 1
         return -1
      endif
   endwhile
endfunction " >>>

" indented text object <<<
function! IndTxtObj(inner, zeroindent)

   " find first non-blank line with highest indent <<<
   let l:StartLine = line(".")
   if getline(l:StartLine) =~ '^\s*$'
      let l:PrevLine = GetPrevNonBlankLine()
      let l:NextLine = GetNextNonBlankLine()
      if (l:PrevLine == -1) && (l:NextLine == -1)
         return
      endif
      if (l:PrevLine == -1)
         let l:StartLine = l:NextLine
      elseif (l:NextLine == -1)
         let l:StartLine = l:PrevLine
      else
         if indent(l:NextLine) >= indent(l:PrevLine)
            let l:StartLine = l:NextLine
         else
            let l:StartLine = l:PrevLine
         endif
      endif
   endif
   " >>>

   " get current indentation <<<
   let l:StartIndent = indent(l:StartLine)
   " echo l:StartLine
   " echo l:StartIndent
   " >>>

   " find upper line <<<
   let l:UpperLine = l:StartLine
   while v:true
      let l:LastUpperLine = l:UpperLine
      let l:UpperLine     = l:UpperLine - 1
      if l:UpperLine < 1
         let l:UpperLine = 1
         break
      endif
      if getline(l:UpperLine) =~ '^\s*$'
         continue
      endif
      let l:UpperIndent = indent(l:UpperLine)
      if a:zeroindent
         if l:UpperIndent == 0
            if a:inner
               let l:UpperLine = l:LastUpperLine
            endif
            break
         endif
      else
         if l:UpperIndent < l:StartIndent
            if a:inner
               let l:UpperLine = l:LastUpperLine
            endif
            break
         endif
      endif
   endwhile
   " >>>

   " find lower line <<<
   let l:LowerLine = l:StartLine
   while v:true
      let l:LastLowerLine = l:LowerLine
      let l:LowerLine     = l:LowerLine + 1
      if l:LowerLine > line("$")
         let l:LowerLine = line("$")
         break
      endif
      if getline(l:LowerLine) =~ '^\s*$'
         continue
      endif
      let l:LowerIndent = indent(l:LowerLine)
      if a:zeroindent
         if l:LowerIndent == 0
            if a:inner
               let l:LowerLine = l:LastLowerLine
            endif
            break
         endif
      else
         if l:LowerIndent < l:StartIndent
            if a:inner
               let l:LowerLine = l:LastLowerLine
            endif
            break
         endif
      endif
   endwhile
   " >>>
   
   call cursor(l:UpperLine, 1)
   normal! V
   call cursor(l:LowerLine, 1)

endfunction " >>>

" find <<<
function! Find(args)
   call delete('/tmp/vimFind.tmp')
   call system('fd ' . a:args . ' > /tmp/vimFind.tmp')
   lgetfile /tmp/vimFind.tmp
   lopen
endfunction " >>>

" grep <<<
function! Grep(args)
   exec 'silent lgrep! ' . a:args
   lopen
endfunction " >>>

" grep buffers <<<
function! GrepBuffers(args)
   call setloclist(winnr(), [])
   exec 'bufdo silent lgrepadd ' . a:args . ' %'
   lopen
endfunction " >>>

" strip string <<<
function! StripString(str, side)
   if a:side == 'l'
      return matchlist(a:str, '^\s*\(.*\)$')[1]
   end
   if a:side == 'r'
      return matchlist(a:str, '^\(.\{-}\)\s*$')[1]
   end
   if a:side == 'b'
      " return matchlist(a:str, '^\s*\(.\{-}\)\s*$')[1]
      return trim(a:str)
   end
   return a:str
endfunction " >>>

" align string <<<
function! AlignString(str, alignment, length)

   " let l:OriginalWidth  = strdisplaywidth(a:str)
   let l:OriginalWidth  = a:length

   if matchstr(a:str, '.$') == "\n"
      let l:HasNewLine = 1
      let l:NewLine    = "\n"
   else
      let l:HasNewLine = 0
      let l:NewLine = ""
   end

   let l:StrippedString = trim(a:str)
   let l:StrippedWidth  = strdisplaywidth(l:StrippedString)

   if a:alignment == 'c'
      let l:LeftPadLength  = float2nr((l:OriginalWidth - l:StrippedWidth)/2)
      if l:HasNewLine == 1
         let l:RightPadLength = 0
      else
         let l:RightPadLength = l:OriginalWidth - l:LeftPadLength - l:StrippedWidth
      end
   end

   if a:alignment == 'r'
      let l:LeftPadLength  = l:OriginalWidth - l:StrippedWidth
      let l:RightPadLength = 0
   end

   if a:alignment == 'l'
      let l:LeftPadLength  = 0
      if l:HasNewLine == 1
         let l:RightPadLength = 0
      else
         let l:RightPadLength = l:OriginalWidth - l:StrippedWidth
      end
   end

   return repeat(" ", l:LeftPadLength) . l:StrippedString . repeat(" ", l:RightPadLength) . l:NewLine

endfunction " >>>

" align block <<<
function! AlignBlock(alignment)

   let l:TopLCurPos = getpos("'<")
   let l:BotRCurPos = getpos("'>")
   let l:StringLen  = l:BotRCurPos[2] - l:TopLCurPos[2] + 1 + l:BotRCurPos[3]

   for line in range(l:TopLCurPos[1], l:BotRCurPos[1])
      call cursor(line, l:TopLCurPos[2])
      normal v
      call cursor(line, l:BotRCurPos[2])
      normal y
      let @" = AlignString(@", a:alignment, l:StringLen)
      silent! call ChangeRegType('"', 'c')
      normal gvp
   endfor

   call setpos("'<", l:TopLCurPos)
   call setpos("'>", l:BotRCurPos)
   normal gv

endfunction " >>>

" get visual selection <<<
function! GetVisualSelection()
    silent! normal! gv"xy
    return @x
endfunction " >>>

" extract numbers from string <<<
function! ExtractNumbersFromString(str)

   let l:Numbers = []
   let l:Match   = ""
   let l:Start   = 0
   let l:End     = 0
   let l:Str     = substitute(a:str, '\n', ' ', 'g')

   while v:true

      " let l:Result = matchstrpos(l:Str, '\([+-]*0x\x\+\)\|\([+-]*0b[01]\+\)\|\([+-]*\d\+\)', l:Start)
      let l:Result = matchstrpos(l:Str, '\([+-]\?0x\x\+\)\|\([+-]\?0b[01]\+\)\|\([-+]\?\d*\.\?\d\+\([eE][-+]\?\d\+\)\?\)', l:Start)
      
      let l:Match  = l:Result[0]
      let l:Start  = l:Result[1]
      let l:End    = l:Result[2]

      if l:Match == ""
         break
      endif

      call add(l:Numbers, l:Match)

      let l:Start = l:End + 1
   endwhile

   " echo l:Numbers
   return l:Numbers
endfunction " >>>

" calculate sum <<<
function! Sum(numbers)
   return eval(join(a:numbers, '+'))
endfunction " >>>

" yank path <<<
function! YankPath()
   let l:Path      = expand('%:p')
   let l:Directory = expand('%:p:h')
   let l:File      = expand('%:p:t')
   let l:Paths = ["quit", l:Path, l:Directory, l:File]
   let l:i=0
   let l:i = confirm("Yank Path","&path\n&directory\n&filename")
   if l:i != 0
      let @+=l:Paths[l:i]
      let @"=l:Paths[l:i]
   endif
endfunction
" >>>

" serialize data <<<
function! SerializeData(var, file)
    " let serialized = string(a:var)
    " call writefile([serialized], a:file)
    call writefile([string(a:var)], a:file)
endfun " >>>

" read data <<<
function! ReadData(file)
    " execute "let result = " . readfile(a:file)[0]
    execute "let result = " . join(readfile(a:file))
    return result
endfun " >>>

" join lines <<<
function! Join(trim, ...) range
   let l:search = getreg('/')
   let l:sep = get(a:, 1, '')
   if a:firstline == a:lastline
      let l:lastsepline  = a:lastline
      let l:lasttrimline = a:lastline + 1
      if l:lasttrimline > line('$')
         let l:lasttrimline = line('$')
      endif
      let l:joinrange = a:firstline
   else
      let l:lastsepline  = a:lastline - 1
      let l:lasttrimline = a:lastline
      let l:joinrange = a:firstline . ';' . a:lastline
   endif
   if (a:trim == "!") && (a:firstline != l:lasttrimline)
         let l:firsttrimline = a:firstline + 1
         silent execute l:firsttrimline . ';' . l:lasttrimline . 's/^.*$/\=trim(getline("."))/'
   endif
   silent execute a:firstline . ';' . l:lastsepline . 's/$/' . l:sep . '/'
   silent execute l:joinrange . 'j!'
   call setreg('/', l:search)
endfunction " >>>

" add timestamp <<<
function! InsertTimeStamp()
   call complete(col('.'), [strftime("%Y-%m-%d"), strftime("%Y-%m-%dT%H:%M"), strftime("%d. %B %Y"), strftime("%H:%M")])
   return ''
endfunction " >>>

" clear registers <<<
function! ClearRegisters()
   let regs=split('abcdefghijklmnopqrstuvwxyz0123456789', '\zs')
   for r in regs
      call setreg(r, [])
   endfor
endfunction " >>>

" UNDER DEVELOPMENT <<<
" get misspelled words <<<
function! GetMisspelledWords()
   let l:LineCnt  = 0
   let l:BufLines = getbufline('%', 1, '$')
   let l:BadWords = []
   for line in l:BufLines
      let l:Start=0
      let l:LineCnt = l:LineCnt + 1
      while v:true
         let l:Match = matchstrpos(line,'\a\+',l:Start)
         if l:Match[0] == ''
            break
         else
            let l:Word  = l:Match[0]
            let l:Start = l:Match[1]
            let l:End   = l:Match[2]
            let l:Check = spellbadword(l:Word)
            if l:Check[0] != ''
               call add(l:Check, l:LineCnt)
               " call add(l:Check, l:Start)
               " call add(l:Check, l:End-1)
               call add(l:Check, l:Start+1)
               call add(l:Check, l:End)
               call add(l:BadWords, l:Check)
            end
            let l:Start = l:End
         endif
      endwhile
   endfor
   return l:BadWords
endfunction
" >>>
" Test Color <<<
"let g:Color = 0
" function! TestColor()
"    execute "hi Normal ctermbg=" . g:Color
"    execute "hi NonText ctermbg=" . g:Color
"    let g:Color=g:Color+1
" endfunction
" nnoremap +c :call TestColor()<CR>:echo g:Color<CR>
" >>>
" User Completion <<<
function! GetWords(String)
   let l:BufLines = getbufline('%', 1, '$')
   let l:WordList = []
   for line in l:BufLines
      " echom "line: " . line
      let l:Start=0
      while v:true
         " let l:Match2 = matchstrpos(line, '\<' . escape(a:String, '\*') . ' ', l:Start)
         " let l:Match = matchstrpos(line, '\<' . escape(a:String, '\*') . ' [^\ ]\+', l:Start)
         let l:Match2 = matchstrpos(line, '\<' . escape(a:String, '\*') . '\s', l:Start)
         let l:Match = matchstrpos(line, '\<' . escape(a:String, '\*') . ' \S\+', l:Start)
         if l:Match[0] == ''
            break
         else
            let l:Start = l:Match2[2]
            " echom "word match: " . l:Match[0]
            call add(l:WordList, matchlist(l:Match[0], ' \(.*\)')[1])
         endif
      endwhile
   endfor
   return l:WordList
endfunction

function! GetLines(String)
   let l:BufLines = getbufline('%', 1, '$')
   let l:LineList = []
   for line in l:BufLines
      " echom "line: " . line
      let l:Start=0
      while v:true
         " let l:Match2 = matchstrpos(line, '\<' . escape(a:String, '\*') . ' ', l:Start)
         " let l:Match = matchstrpos(line, '\<' . escape(a:String, '\*') . ' [^\ ]\+', l:Start)
         let l:Match2 = matchstrpos(line, '\<' . escape(a:String, '\*') . '\s', l:Start)
         let l:Match = matchstrpos(line, '\<' . escape(a:String, '\*') . '.*', l:Start)
         if l:Match[0] == ''
            break
         else
            let l:Start = l:Match2[2]
            " echom "word match: " . l:Match[0]
            call add(l:LineList, matchlist(l:Match[0], ' \(.*\)')[1])
         endif
      endwhile
   endfor
   return l:LineList
endfunction
 
" FEATURES
" super foo bar trouper
" super foo bra trouper
" word completion based on prev word
" 1. foo    -> completes with bar, bra
" 2. foo ba -> completes with bar
" 3.        -> completes with foo
" line completion based on prev word
" 4. foo    -> completes with bar, bra and trouper
" 5. foo ba -> completes with bar trouper
" 6.        -> completes with foo bar trouper, foo bra trouper

function! CompleteWordFromPrevWord(findstart, base)
   if a:findstart
      messages clear
      let l:Line = getline('.')
      let l:Start = col('.') - 1
      if (l:Line[l:Start-1] == ' ') || (l:Start == 0)
         echom "findstart: no word at cursor " . l:Start
         return l:Start
      else
         echom "findstart: word at cursor"
         while (l:Start > 0) && (l:Line[l:Start - 1] =~ '\S')
            let l:Start -= 1
         endwhile
         echom "findstart: word at col: " . l:Start
         echom "findstart: first char of word: " . l:Line[l:Start]
         return l:Start
      endif
   else

      let l:Line = getline('.')

      " if a:base == ''
      " if strlen(a:base) == 0
      " endif

      " let l:IsAtWord = 0
      " echom "complete: is at word: " . l:Line
      " echom "complete: is at word: " . l:IsAtWord . " " .getline('.')[col('.')-1] . " " . getline('.')
      " if l:Line[col('.')-1] =~ "\S"
      "    let l:IsAtWord = 1
      " endif
      " echom "complete: is at word: " . l:IsAtWord

      let start = col('.') - 2
      let l:Length = 0

      while (start > 0) && (l:Line[start] =~ '\s')
         let start -= 1
      endwhile

      if (start <= 0)
         echom "complete: no prev word"
      endif
      echom "complete: start is: " . start
      echom "complete: first char of word: " . l:Line[start]

      " return {'words': ['marco', 'trosi'], 'refresh':'always'}

      if(start <= 0)

         if l:IsAtWord == 1
            echom "complete: oh no prev word but cursor at word"
         endif

         let l:PrevLineNum = GetPrevNonBlankLine()
         echom "complete: previous non blank line num is: " . l:PrevLineNum
         let l:PrevLine = getline(l:PrevLineNum)
         echom "complete: previous non blank line is: " . l:PrevLine
         if g:UserCompletionFunc == 0 " complete word based on previous word
            return {'words': [matchstr(l:PrevLine, '\S\+')], 'refresh':'always'}
         else " complete line based on previous word
            return {'words': [matchstr(l:PrevLine, '\S.*')], 'refresh':'always'}
         endif

      else
         " go back til start of prev word
         while (start > 0) && (l:Line[start - 1] =~ '\S')
            let start -= 1
            let l:Length += 1
         endwhile
         let l:Length += 1

         let l:String = strpart(l:Line, start, l:Length)
         echom "the word before the cursor is: " . l:String
         if g:UserCompletionFunc == 0
            let l:WordList = GetWords(String)
         else
            let l:WordList = GetLines(String)
         endif
         return {'words': l:WordList, 'refresh':'always'}
      endif

   endif
endfunction

function! CompleteLineFromPrevWord(findstart, base)
   messages clear
   echom "complete line from prev word"
endfunction

function! CompleteWordFromEnvVar(findstart, base)
   if a:findstart
      let l:Line = getline('.')
      let l:CursorCol = col('.') - 1
      let l:LastCharCol = l:CursorCol - 1
      let l:FirstCharCol = l:LastCharCol
      while (l:FirstCharCol > 0) && (l:Line[l:FirstCharCol-1] =~ '\w')
         let l:FirstCharCol -= 1
      endwhile
      return l:FirstCharCol
   else
      let l:EnvVars = environ()
      let l:Matches = []
      for [key, value] in items(l:EnvVars)
         if match(key, '^' . a:base) != -1
            if g:UserCompletionFunc == 2 " complete env var name
               call add(l:Matches, {'word':key, 'abbr':key, 'menu':ShortenString(value, 50, 'm')})
            else " expand env var
               call add(l:Matches, {'word':value, 'abbr':key, 'menu':ShortenString(value, 50, 'm')})
            endif
         endif
      endfor
      return {'words':l:Matches, 'refresh':'always'}
   endif
endfunction

function! UserCompletion(findstart, base)
   if g:UserCompletionFunc == 0
      return CompleteWordFromPrevWord(a:findstart, a:base)
   elseif g:UserCompletionFunc == 1
      return CompleteWordFromPrevWord(a:findstart, a:base)
   elseif g:UserCompletionFunc == 2
      return CompleteWordFromEnvVar(a:findstart, a:base)
   elseif g:UserCompletionFunc == 3
      return CompleteWordFromEnvVar(a:findstart, a:base)
   endif
endfunction " >>>
" Popup Test <<<
" let g:BufList = ["foo", "bar", "super", "trooper", "vim magic"]
"
" function! ListBuffersCallback(id, result)
"    echo a:id . " " . a:result . " " . g:BufList[a:result-1]
" endfunction
"
" function! ListBuffers()
"    let l:WinID = popup_menu(g:BufList, {'callback': 'ListBuffersCallback'})
" endfunction
"
" nnoremap <space><space> :call ListBuffers()<cr>
" >>>
" LaTeX <<<
function! LaTeXMenu(modeprecmd)
   let l:FontCmds = ["abort", "FontFamily", "FontSize"]
   let l:c = 0
   let l:c = confirm("LaTeX Menu","Font&Family\nFont&Size")
   if l:c == 1
      call FontFamily(a:modeprecmd)
   endif
   if l:c == 2
      call FontSize(a:modeprecmd)
   endif
endfunction

function! FontFamily(modeprecmd)
   let l:FontFamilies = ["abort", "textbf", "textit", "textup", "textsl", "textsc", "textrm", "textsf", "texttt"]
   let l:c = 0
   let l:c = confirm("Font Family","text&bf\ntext&it\ntext&up\ntext&sl\ntexts&c\ntext&rm\ntexts&f\ntext&tt")
   if l:c != 0
      exe 'call TeXEmbrace("' . a:modeprecmd . '", "' . l:FontFamilies[l:c] . '")'
   endif
endfunction

function! FontSize(modeprecmd)
   let l:FontSizes = ["abort", "tiny", "scriptsize", "footnotesize", "small", "large", "Large", "LARGE", "huge", "Huge", "HUGE"]
   let l:c = 0
   let l:c = confirm("Font Size","&tiny\ns&criptsize\n&footnotesize\n&small\n&large\nL&arge\nLA&RGE\n&huge\nHu&ge\nHUG&E", 3)
   if l:c != 0
      exe 'call TeXEmbrace("' . a:modeprecmd . '", "' . l:FontSizes[l:c] . '")'
   endif
endfunction

function! TeXEmbrace(modeprecmd, texcmd)
   exe "normal " . a:modeprecmd . "xi{}\<ESC>PF{i\\=a:texcmd\<CR>"
endfunction

let s:InitMenu = 'Font'
let s:NextMenu = ''

function! LatexFontContinue()
   let l:NextMenu = get(v:completed_item, 'user_data', '')
   if (l:NextMenu == '') || (l:NextMenu == '_END_')
      let s:NextMenu = ''
   else
      let s:NextMenu = l:NextMenu
      call feedkeys("\<BS>\<C-x>\<C-u>")
   endif
endfunction

function! LatexFont(findstart, base)
   if a:findstart
      let line = getline('.')
      let start = col('.') - 1
      while start > 0 && line[start - 1] =~ '\a'
         let start -= 1
      endwhile
      return start
   else
      let menus = {
               \     'Font':[{'word':a:base, 'abbr':'Font Family', 'dup':1, 'user_data':'FontFamily'},
               \             {'word':a:base, 'abbr':'Font Style' , 'dup':1, 'user_data':'FontStyle' },
               \             {'word':a:base, 'abbr':'Font Size'  , 'dup':1, 'user_data':'FontSize'  }],
               \
               \     'FontFamily':[{'word':'\textrm{'.a:base.'}', 'user_data':'_END_'},
               \                   {'word':'\textsf{'.a:base.'}', 'user_data':'_END_'},
               \                   {'word':'\texttt{'.a:base.'}', 'user_data':'_END_'}],
               \
               \     'FontStyle':[{'word':'\textmd{'.a:base.'}', 'user_data':'_END_'},
               \                  {'word':'\textbf{'.a:base.'}', 'user_data':'_END_'},
               \                  {'word':'\textup{'.a:base.'}', 'user_data':'_END_'},
               \                  {'word':'\textit{'.a:base.'}', 'user_data':'_END_'},
               \                  {'word':'\textsl{'.a:base.'}', 'user_data':'_END_'},
               \                  {'word':'\textsc{'.a:base.'}', 'user_data':'_END_'}],
               \
               \     'FontSize':[{'word':'{\tiny '.a:base.'}'        , 'user_data':'_END_'},
               \                 {'word':'{\scriptsize '.a:base.'}'  , 'user_data':'_END_'},
               \                 {'word':'{\footnotesize '.a:base.'}', 'user_data':'_END_'},
               \                 {'word':'{\small '.a:base.'}'       , 'user_data':'_END_'},
               \                 {'word':'{\normalsize '.a:base.'}'  , 'user_data':'_END_'},
               \                 {'word':'{\large '.a:base.'}'       , 'user_data':'_END_'},
               \                 {'word':'{\Large '.a:base.'}'       , 'user_data':'_END_'},
               \                 {'word':'{\LARGE '.a:base.'}'       , 'user_data':'_END_'},
               \                 {'word':'{\huge '.a:base.'}'        , 'user_data':'_END_'},
               \                 {'word':'{\Huge '.a:base.'}'        , 'user_data':'_END_'}]
               \  }

      if s:NextMenu == ''
         let s:NextMenu = s:InitMenu
      endif

      return {'words':menus[s:NextMenu], 'refresh':'always'}
   endif
endfunction
" >>>
" auto completion <<<
function! Complete(shift_tab)

   "snippets   for if while etc. see snipmate
   "omni  : . ->
   "filename / \
   "tags
   "keywords
   "tab

   let omni_pattern = '\k\+\(\.\|->\|:\)\k*$'
   let file_pattern = (has('win32') || has('win64')) ? '\\\|\/' : '\/'
   let noselect_correction = &completeopt =~ 'noselect' ? "\<C-P>" : "\<C-P>\<C-P>"

   if pumvisible()
      return a:shift_tab ? "\<C-P>" : "\<C-N>"
   else
      if a:shift_tab
         return "\<C-V>\<TAB>"
      end
   endif

   let pos = getpos('.')
   let substr = matchstr(strpart(getline(pos[1]), 0, pos[2]-1), "[^ \t]*$")

   if empty(substr)
      return a:shift_tab ? "\<C-V>\<TAB>" : "\<TAB>"
   endif

   "omni
   if !empty(&omnifunc) && match(substr, omni_pattern) != -1
      return a:shift_tab ? "\<C-X>\<C-O>" : "\<C-X>\<C-O>" . noselect_correction
   endif

   "filename
   if match(substr, file_pattern) != -1
      return a:shift_tab ? "\<C-X>\<C-F>" : "\<C-X>\<C-F>" . noselect_correction
   endif

   "tags & keywords -> complete option is set accordingly
   return a:shift_tab ? "\<C-P>" : "\<C-N>"

   "tab -> never reached, not sure if I need it at all
   "return a:shift_tab ? "\<C-V>\<TAB>" : "\<TAB>"

   " prevent returning 0 -> never reached
   return ""
endfunction " >>>
" test f keys <<<
function! TestFKeys()
   for m in [0,1] " meta/alt
      for c in [0,1] " ctrl
         for s in [0,1] " shift
            for f in range(1,12)
               let l:keys = ""
               if s | let l:keys = l:keys .. "S-" | endif
               if c | let l:keys = l:keys .. "C-" | endif
               if m | let l:keys = l:keys .. "M-" | endif
               let l:keys = l:keys .. "F" .. f
               execute "inoremap <" .. l:keys .. "> " .. l:keys .. " is working<CR>"
            endfor
         endfor
      endfor
   endfor
endfunction " >>>
" run script <<<
function! RunScript() abort
   let l:Interpreters = {'py': 'python', 'lua': 'lua', 'sh': 'bash'}
   let l:TermBufNr = 0
   let l:TerminalOpen = 0
   " get file extension
   let l:FileExt  = expand('%:e')
   " get file path
   let l:FilePath = expand('%:p')
   " get list of windows
   let l:WinList = getwininfo()
   " find terminal window
   for w in l:WinList
      if w["terminal"]
         let l:TermBufNr = w["bufnr"]
         let l:TerminalOpen = 1
         break
      endif
   endfor
   if l:TerminalOpen == 0
      " if not open create one
      vertical terminal
      " back to win
      wincmd p
      let l:WinList = getwininfo()
      for w in l:WinList
         if w["terminal"]
            let l:TermBufNr = w["bufnr"]
            break
         endif
      endfor
   endif
   " run script
   call term_sendkeys(l:TermBufNr, l:Interpreters[l:FileExt] .. " " .. l:FilePath .."\n") " use \r on macos
endfunction " >>>
" >>>
" >>>

" commands <<<
command! -range Left   call AlignBlock('l')
command! -range Center call AlignBlock('c')
command! -range Right  call AlignBlock('r')
command! -nargs=1 EditReg call EditReg(<f-args>)
command! -bang -range -nargs=? Join <line1>,<line2>call Join("<bang>", <f-args>)
command! -range -nargs=* ReArrangeColumns <line1>,<line2>call ReArrangeColumns(<f-args>)
command! -nargs=* Grep call Grep('<args>')
command! -nargs=* GrepBuffers call GrepBuffers('<args>')
command! -nargs=* Find call Find('<args>')
command! -range -nargs=0 Sum echo Sum(ExtractNumbersFromString(GetVisualSelection()))
command! -range=% -nargs=? -complete=file New silent <line1>,<line2>yank x | enew | put! x | $d_ | if(<q-args> != '') | silent write <args> | endif
command! E silent! !explorer .
command! F silent! !open .
command! SD let g:SD=getcwd()
command! RD call chdir(g:SD)
command! -nargs=1 MKCD call mkdir(<f-args>, "p") | call chdir(<f-args>)

" set up scripts <<<
if has("win32")
   " let s:ChangeDirCmd = '/Users/marcotrosi/Code/release/bin/c.sh'
   " let s:ChangeDirTmp = '/tmp/c.tmp'
else
   let s:ChangeDirCmd    = '/Users/marcotrosi/.vim/bin/c.sh'
   let s:ChangeDirTmp    = '/tmp/c.tmp'
   let s:EditFilesCmd    = '/Users/marcotrosi/.vim/bin/e.sh'
   let s:EditFilesTmp    = '/tmp/e.tmp'
   let s:PasteRegCmd     = '/Users/marcotrosi/.vim/bin/r.sh'
   let s:PasteRegTmp     = '/tmp/r.tmp'
   let s:PasteRegPreTmp  = '/tmp/r_pre.tmp'
   let s:SelectCmd       = '/Users/marcotrosi/.vim/bin/b.sh'
   let s:SelectBufTmp    = '/tmp/b.tmp'
   let s:SelectBufPreTmp = '/tmp/b_pre.tmp'
endif
" >>>

" change directory <<<
" command! -nargs=? CD call system('start /wait cmd /c "fd -t d '.<q-args>.' | fzf --reverse > D:\temp\fzf.out || del D:\temp\fzf.out"') | if filereadable('D:\temp\fzf.out') | call chdir(readfile('D:\temp\fzf.out', '', 1)[0]) | endif
function! ChangeDir(j, s)
   if filereadable(s:ChangeDirTmp)
      call chdir(readfile(s:ChangeDirTmp, '', 1)[0])
   endif
endfunction

function! CD()
   let l:TermBufNum = term_start(s:ChangeDirCmd, {'term_name':'change directory', 'hidden':0, 'term_finish':'close', 'norestore':1, 'vertical':1, 'exit_cb':'ChangeDir'})
   " let l:WinID = popup_create(l:TermBufNum, {'minwidth': 50, 'minheight': 20})
endfunction

command! -nargs=? CD call CD()
" >>>

" edit files <<<
" command! -nargs=? Edit call system('start /wait cmd /c "fd -t f '.<q-args>.' | fzf -m --reverse > D:\temp\fzf.out || del D:\temp\fzf.out"') | if filereadable('D:\temp\fzf.out') | for fname in readfile('D:\temp\fzf.out') | silent execute ':e ' . fname | endfor | endif
function! EditFiles(j, s)
   wincmd p
   for fname in readfile(s:EditFilesTmp) 
      silent execute ':e ' . fname
   endfor
endfunction

function! Edit()
   let l:TermBufNum = term_start(s:EditFilesCmd, {'term_name':'edit files', 'hidden':0, 'term_finish':'close', 'norestore':1, 'vertical':1, 'exit_cb':'EditFiles'})
   " let l:WinID = popup_create(l:TermBufNum, {'minwidth': 50, 'minheight': 20})
endfunction

command! -nargs=? Edit call Edit()
" >>>

" paste register <<<
function! PasteReg(direction)
   let l:Cmds = []
   let l:PasteRegDirection = a:direction
   let l:WinID = 0

   function! PasteRegCallback(job, status) closure
      if filereadable(s:PasteRegTmp)
         call add(l:Cmds, 'wincmd p')
         let l:Cmd = 'norm "' . readfile(s:PasteRegTmp, '', 1)[0][0] . l:PasteRegDirection
         call add(l:Cmds, l:Cmd)
         for cmd in l:Cmds
            execute cmd
         endfor
      endif
   endfunction

   execute 'silent redir! > ' . s:PasteRegPreTmp
   registers
   redir END

   let l:TermBufNum = term_start(s:PasteRegCmd, {'term_name':'paste register', 'hidden':0, 'term_finish':'close', 'norestore':1, 'vertical':1, 'exit_cb':'PasteRegCallback'})
   " let l:WinID = popup_create(l:TermBufNum, {'minwidth': 50, 'minheight': 20})
endfunction " >>>

function! SelectBuf()

   let l:Cmds = []
   let l:NumOfBuffers = bufnr('$')
   let l:Buffers = []

   function! SelectBufCallback(job, status) closure

      if filereadable(s:SelectBufTmp)

         call add(l:Cmds, 'wincmd p')
         let l:Cmd = 'norm "' . readfile(s:SelectBufTmp, '', 1)[0][0]
         call add(l:Cmds, l:Cmd)

         for cmd in l:Cmds
            execute cmd
         endfor
      endif
   endfunction

   let l:i = 0 | while l:i <= l:NumOfBuffers | let l:i = l:i + 1
      if buflisted(l:i)
         call add(l:Buffers, l:i . " " . bufname(l:i))
      endif
   endwhile
   call writefile(l:Buffers, s:SelectBufPreTmp)

   " let l:TermBufNum = term_start(s:SelectBufCmd, {'term_name':'select buffer', 'hidden':0, 'term_finish':'close', 'norestore':1, 'vertical':1, 'exit_cb':'SelectBufCallback'})
   " let l:WinID = popup_create(l:TermBufNum, {'minwidth': 50, 'minheight': 20})
endfunction
" >>>

" settings <<<
" off <<<
set noballooneval
set nocompatible
set noconfirm
set nocursorcolumn
set nocursorline
set noerrorbells
set nojoinspaces
set nolinebreak
set nolist
set nosol
set nospell
set nostartofline
set notimeout
set nottimeout
set novisualbell
set nowrap
" >>>

" on <<<
filetype on
filetype plugin on
filetype indent on
syntax on
set number
set expandtab
set hlsearch
set incsearch
set lazyredraw
set magic
set ruler
set shiftround
set showcmd
set showmode
" set splitright
set wildmenu
set wrapscan
set termguicolors
set title
" set undofile
" >>>

" values <<<
let g:TabSpace=3
execute 'set tabstop='.g:TabSpace
execute 'set softtabstop='.g:TabSpace
set shiftwidth=0

set backupdir=~/.vim/backupdir,/tmp
"set balloonexpr=Balloon()
set belloff=all
set complete=.,w,b,u
" set complete=.,w,b,u,t,i
" set completeopt=menu,longest,noinsert,noselect
set completefunc=UserCompletion
set dictionary=/usr/share/dict/words
set directory=~/.vim/swapdir,/tmp
set encoding=utf-8
set errorformat=%f\ %l\ %m
set errorformat+=%f:%l:%c:\ %m
set errorformat+=%f
set errorformat+=luac:\ %f:%l:\ %m
set fillchars=vert:╏,fold:━
set foldmarker=<<<,>>>
set foldmethod=marker
set formatoptions=jlqr
set grepprg=rg\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
set keywordprg=:help
set laststatus=2
set listchars=eol:↲,tab:↦\ ,nbsp:␣,extends:…,trail:⋅
set mousemodel=popup_setpos
set nrformats=bin,hex
set path=.,,** " use :checkpath
set sessionoptions=buffers,curdir
set shortmess=fIlmnxtToO
set spelllang=en
set spellsuggest=9
set tags=.tags
let g:TextWidth=120
execute 'set textwidth='.g:TextWidth
set undodir=~/.vim/undodir,/tmp
set virtualedit=block

sign define E text=× texthl=red
sign define W text=! texthl=org
sign define I text=i texthl=blu
sign define O text=✔ texthl=grn
" https://www.torsten-horn.de/techdocs/ascii.htm
" https://en.wikipedia.org/wiki/Box-drawing_character
" https://en.wikipedia.org/wiki/Box_Drawing_(Unicode_block)
" https://en.wikipedia.org/wiki/Block_Elements
" https://en.wikipedia.org/wiki/Geometric_Shapes
sign define A text=▶︎ texthl=red
sign define B text=■ texthl=red
" ◯ ◑ ●
" ◐ ▲ ◆
" →

"function! Diff()
   " let l:opt = ''
   " if &diffopt =~ 'icase'
   "    let l:opt = opt . '-i '
   " endif
   " if &diffopt =~ 'iwhite'
   "    let l:opt = opt . '-b '
   " endif
"   silent execute '!git diff --patience --no-color ' . v:fname_in . ' ' . v:fname_new
"endfunction
" set diffexpr=Diff()
set diffopt=vertical,filler
if &diff
    set cursorbind
    set scrollbind
 else
    set nocursorbind
    set noscrollbind
endif
" >>>

" auto commands <<<
augroup VIMRC

   autocmd!

   autocmd BufEnter *.c,*.h let C='//' | let g:FunctionPattern_s = '\s\(\w\+\)(.\{-})\s*$'
   autocmd BufEnter *.lua let C='--' | let g:FunctionPattern_s = '\sfunction\s\+\(\w\+\)'
   "autocmd FileType lua setlocal iskeyword+=:
   autocmd BufEnter *.tex let C='%'
   autocmd BufEnter makefile,*.py,*.pl let C='#'
   autocmd BufEnter .vimrc,*.vim let C='"' | let g:FunctionPattern_s = '^function!\s\+\(\w\+\)'
   autocmd BufLeave * let g:FunctionPattern_s=''

   autocmd BufEnter *.dox set filetype=c.doxygen
   autocmd BufEnter *.vba set filetype=vb

   autocmd BufEnter *.py set noexpandtab
   autocmd BufLeave *.py set expandtab

   autocmd BufEnter makefile set noexpandtab
   autocmd BufLeave makefile set expandtab

   autocmd VimLeavePre * call CleanUp()
   autocmd ColorScheme * call DefMatchColors() " TODO temporary til part of colorschemes

   autocmd CmdwinEnter * map <buffer> <S-CR> <C-c><C-e> " don't execute but put cmd in commandline
   autocmd FileType help nnoremap <buffer> q :helpclose<cr>
augroup END
" >>>

" plugin settings <<<
" colorizer <<<
let g:colorizer_auto_color = 0
let g:colorizer_colornames = 0
" >>>
" wildfire <<<
" let g:wildfire_fuel_map  = "<ENTER>"
" let g:wildfire_water_map = "<BS>"
let g:wildfire_objects   = split("iw,iW,ip,i),a),i],a],i},a},i',a',i\",a\",it", ",")
" >>>
" align <<<
let g:DrChipTopLvlMenu= "&Plugins.&Align."
" >>>
" >>>
" >>>

" mappings <<<
" Align <<<
xnoremap öa :Align<SPACE>
nnoremap öa vip:Align<SPACE>
" >>>
" Increment <<<
" requires an @ character
" for visual block the old way should be the goal
" xnoremap öi c@<ESC>gv:Inc s1 i1<CR>
" xnoremap öI c@<ESC>gv:Inc s0 i1<CR>
" let i=0 | '<,'>g/^/ s/@/\=i/ | let i+=1
" :map <expr> <C-X> mode() ==# "V" ? ... : ...
xnoremap öi :Inc s1 i1<CR>
xnoremap öI :Inc s0 i1<CR>
nnoremap öi vip:Inc s1 i1<CR>
nnoremap öI vip:Inc s0 i1<CR>
nnoremap ++ <C-a>
nnoremap -- <C-x>
" >>>
" Tags <<<
" nnoremap gt :tag<SPACE>
nnoremap öt :call Panel('Tags')<CR>
nnoremap öö g<C-]>zz
nnoremap ää <C-t>zz
nnoremap öä :call JumpToTest('')<CR>
nnoremap öÄ :call JumpToTest(expand('<cword>'))<CR>
nnoremap öH :helptags ~/.vim/doc<CR>
nnoremap <F10> :!ltags $(find . -name '*.lua') > .tags<CR>
nnoremap <F11> :!cscope -b -c -R<CR>
nnoremap <F12> :!ctags --langmap=c:.c.h -f .tags -R --tag-relative=yes --extras=+fq --fields=+znimsStK --c-kinds=+lpx --sort=yes<CR>
" >>>
" Grep <<<
" TODO: test with regex searches
let g:RgHint="rg [options] pattern [path, ...]\n
             \-w whole words \| -i case insensitive \| -s case sensitive \| -v invert match\n
             \-F literally \| --hidden search hidden files \| -t type -T non-type \| -e regex\n
             \--max-depth NUM \| -A NUM after \| -B NUM before \| -C NUM context"

let g:FdHint="fd [options] [pattern] [path, ...]\n
             \-s case sensitive \| -i case insensitive \| -g glob based \| -t type\n
             \-F literally \| -H search hidden files \| -E exclude glob\n
             \-d MAXDEPTH \| -S SIZE \| -e extension \| -a absolute paths"

" sh   |map          |cmd           |desc
" -----|-------------|--------------|-----------------------------------------------
" c    |<space>c     |:CD           |find directory and change dir'          done
" f    |<space>f     |:Find -t f    |find files'                             done
" d    |<space>d     |:Find -t d    |find directories'                       done
" e    |<space>e     |:Edit         |find files and edit'                    done
" g    |<space>g     |:Grep in dir  |grep recursive in directory'            done
"      |<space>G     |:Grep in bufs |grep in open buffers'                   done
" fdf  |<space>v     |              |find files and diff files'
" mkcd | none        |MKCD          |create directory and change dir'        done
" sd   | none        |SD            |store directory'                        done
" rd   | none        |RD            |restore directory'                      done

nnoremap <SPACE>b :call SelectBuf()<CR>
" nnoremap <SPACE>t jump to tag fuzzy
" nnoremap <SPACE>p open session fuzzy
nnoremap <SPACE>r :silent call PasteReg('p')<CR>
nnoremap <SPACE>R :silent call PasteReg('P')<CR>
nnoremap <SPACE>f :echo g:FdHint<CR>:Find -t f<SPACE>
nnoremap <SPACE>d :echo g:FdHint<CR>:Find -t d<SPACE>
nnoremap <SPACE>c :CD<CR>
nnoremap <SPACE>C :echo g:FdHint<CR>:CD<SPACE>
nnoremap <SPACE>e :Edit<CR>
nnoremap <SPACE>E :echo g:FdHint<CR>:Edit<SPACE>
nnoremap <SPACE>g :echo g:RgHint<CR>:Grep<SPACE>
nnoremap <SPACE>G :echo g:RgHint<CR>:GrepBuffers<SPACE>
nnoremap <SPACE>h :call CycleColorscheme(0)<CR>

"nnoremap ög
nnoremap gö :call Grep('-F -w -s "' . expand('<cword>') . '" %')<CR>
nnoremap gÖ :call Grep('-F -i "' . expand('<cword>') . '" %')<CR>
xnoremap gö "gy:call Grep('-F -w -s "' . getreg('g') . '" %')<CR>
xnoremap gÖ "gy:call Grep('-F -i "' . getreg('g') . '" %')<CR>

nnoremap gd :call Grep('-F -w -s "' . expand('<cword>') . '"')<CR>
nnoremap gD :call Grep('-F -i "' . expand('<cword>') . '"')<CR>
xnoremap gd "gy:call Grep('-F -w -s "' . getreg('g') . '"')<CR>
xnoremap gD "gy:call Grep('-F -i "' . getreg('g') . '"')<CR>

nnoremap gb :call GrepBuffers('-F -w -s "' . expand('<cword>') . '" %')<CR>
nnoremap gB :call GrepBuffers('-F -i "' . expand('<cword>') . '" %')<CR>
nnoremap gb "gy:call GrepBuffers('-F -w -s "' . getreg('g') . '" %')<CR>
nnoremap gB "gy:call GrepBuffers('-F -i "' . getreg('g') . '" %')<CR>

" >>>
" QuickFix And Location List <<<
nnoremap öe :call ToggleQuickFix()<CR>
nnoremap e :cnext<CR>zz
nnoremap E :cprevious<CR>zz

nnoremap ös :call ToggleLocList()<CR>
nnoremap <C-h> :silent! lolder<CR>
nnoremap <C-l> :silent! lnewer<CR>
nnoremap <C-j> :lnext<CR>zz
nnoremap <C-k> :lprevious<CR>zz
" >>>
" Sessions <<<
nnoremap öp :call Panel('Sessions')<CR>
nnoremap cp :%bd<BAR>let v:this_session=''<CR>
" >>>
" Spell <<<
nnoremap ör ]szz
nnoremap öR [szz
" nnoremap är z=
" >>>
" Search <<<
nnoremap n nzz
nnoremap N Nzz
nnoremap * *N
nnoremap # #N
" TODO use MakeRegExSafe()
xnoremap / y/\V"<CR>
xnoremap ? y/\V\<"\><CR>
xnoremap * y/\V\<"<CR>
xnoremap # y/\V"\><CR>

nnoremap <SPACE><SPACE> /
nnoremap <SPACE><C-SPACE> /\c
nnoremap <SPACE><S-SPACE> /\<\><left><left>
nnoremap <SPACE><C-S-SPACE> /\c\<\><left><left>

" cnoremap <S-SPACE> <C-R><C-A>
" cnoremap <C-SPACE> <C-R><C-W>
cnoremap äw <C-R><C-W>
cnoremap äW <C-R><C-A>
cnoremap äf <C-R><C-F>
cnoremap äp <C-R><C-P>
cnoremap äl <C-R><C-L>

nnoremap g<SPACE> *N
nnoremap g<C-SPACE> g*N
nnoremap ch :nohl<CR>

nnoremap ym :call AddMatch('')<CR>
xnoremap m "my:call AddMatch('m')<CR>
nnoremap cm :call ClearMatches()<CR>
"nnoremap dm :call DeleteMatch()<CR> " TODO: store ID from matchadd

" >>>
" Buffer <<<
nnoremap ön :enew<CR>
nnoremap öN :tabnew<CR>
nnoremap öh :tabp<CR>
nnoremap öl :tabn<CR>
nnoremap öj :bn<CR>
nnoremap ök :bp<CR>
nnoremap öb :call Panel('Buffers')<CR>
nnoremap ö<SPACE> :b#<CR>
nnoremap öw :w!<CR>
nnoremap öd :bd!<CR>
nnoremap öD :silent %bd<BAR>e#<CR>
nnoremap öx :%d<CR>
nnoremap öu :e!<CR>
" >>>
" Vimrc <<<
nnoremap öv :e  $MYVIMRC<CR>
nnoremap öV :so $MYVIMRC<CR>
" >>>
" Slash/Backslash <<<
nnoremap <silent> <Bslash>/ :let tmp=@/<BAR>s:\\:/:ge<BAR>let @/=tmp<BAR>noh<CR>
nnoremap <silent> <Bslash><Bslash> :let tmp=@/<BAR>s:/:\\:ge<BAR>let @/=tmp<BAR>noh<CR>
" >>>
" Moving Cursor <<<
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
snoremap <C-k> <Up>
snoremap <C-j> <Down>
snoremap <C-h> <Left>
snoremap <C-l> <Right>
nnoremap H :call JumpToStartOfLine()<CR>
nnoremap L :call JumpToEndOfLine()<CR>
" nnoremap 0 :call JumpToStartOfLine()<CR>
" nnoremap ß :call JumpToEndOfLine()<CR>
" nnoremap $ :call JumpToEndOfLine()<CR>
nnoremap W e
nnoremap B ge
nnoremap ; ,
nnoremap , ;
" nnoremap <expr> , getcharsearch().forward ? ';' : ','
" nnoremap <expr> ; getcharsearch().forward ? ',' : ';'
nnoremap co <C-o>
xnoremap <C-o> <ESC>:let b:ByteOffset=GetByteOffset()<CR>`<:if(b:ByteOffset<=GetByteOffset())<BAR>let b:VisCmd=""<BAR>else<BAR>let b:VisCmd="o"<BAR>endif<CR>:exe "normal gv".b:VisCmd<CR>
" >>>
" Shift Lines <<<
nnoremap <S-Up>   kddpk
nnoremap <S-Down> ddp
xnoremap <S-Up>   xkP'[V']
xnoremap <S-Down> xp'[V']
" >>>
" Indent <<<
xnoremap <C-l> >gv
xnoremap <C-h> <gv
nnoremap g= gg=Gg``zz
" >>>
" Fold <<<
nnoremap zp vip<ESC>'<A =C<CR> <<<<ESC>'>A =C<CR> >>><ESC>
xnoremap zp <ESC>'<A =C<CR> <<<<ESC>'>A =C<CR> >>><ESC>
nnoremap zP o=C<CR> vim: fmr=<<<,>>> fdm=marker<ESC>
" >>>
" Marks <<<
nnoremap mn ]`zz
nnoremap mN [`zz
nnoremap mm g`Mzz
" >>>
" Registers <<<
nnoremap cr :call ChangeRegType(v:register)<CR>
nnoremap cR :call ClearRegisters()<CR>
" nnoremap äs :call setreg('"', trim(getreg('"')))<CR> TODO find better mapping
inoremap ü <C-r>
cnoremap ü <C-r>
nnoremap Ü :EditReg<SPACE>
" >>>
" Completion <<<
cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>

inoremap <expr> <ESC>   pumvisible() ? "\<C-e>"       : "\<ESC>"
inoremap <expr> <SPACE> pumvisible() ? "\<C-y>"       : "\<SPACE>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<ESC>" : "\<CR>"

" whole lines
inoremap äl <C-x><C-l>
" dictionary
inoremap äd <C-x><C-k>
" current file
inoremap än <C-x><C-n>
" included files
inoremap äi <C-x><C-i>
" filenames
inoremap äf <C-x><C-f>
" vim commandline
inoremap äv <C-x><C-v>
" spelling suggestions
" äs is used for ShowAvailableSnips()
inoremap är <C-x><C-s>
" tags
inoremap ät <C-x><C-]>
" user defined
let g:UserCompletionFunc=0
" inoremap äu <C-x><C-u>
" inoremap <C-SPACE> <C-x><C-u>
inoremap äw <C-o>:let g:UserCompletionFunc=0<CR><C-x><C-u>
inoremap äz <C-o>:let g:UserCompletionFunc=1<CR><C-x><C-u>
inoremap äe <C-o>:let g:UserCompletionFunc=2<CR><C-x><C-u>
inoremap äE <C-o>:let g:UserCompletionFunc=3<CR><C-x><C-u>

inoremap äT <C-R>=InsertTimeStamp()<CR>
" omni completion
inoremap äo <C-x><C-o>
" inoremap <S-SPACE> <C-x><C-o>
" >>>
" Cycle Settings <<<
" nnoremap +a
" nnoremap -a
" nnoremap äa :call SetAlignCtrl()<CR>
nnoremap +b :silent call CycleBase()<CR>
" nnoremap -b
" nnoremap +c :ColorHEX<CR> TODO is not a cycle
" nnoremap -c
" nnoremap +d
" nnoremap -d
" nnoremap +e
" nnoremap -e
nnoremap +f :call CycleFontType(+1)<CR>
nnoremap -f :call CycleFontType(-1)<CR>
" nnoremap +g
" nnoremap -g
nnoremap +h :call CycleColorscheme(+1)<CR>
nnoremap -h :call CycleColorscheme(-1)<CR>
" nnoremap +i
" nnoremap -i
" nnoremap +j
" nnoremap -j
nnoremap +k :if &keywordprg == ":help" <BAR> set keywordprg=man <BAR> else <BAR> set keywordprg=:help <BAR> endif <BAR> set keywordprg?<CR>
nnoremap -k :if &keywordprg == ":help" <BAR> set keywordprg=man <BAR> else <BAR> set keywordprg=:help <BAR> endif <BAR> set keywordprg?<CR>
" nnoremap +l
" nnoremap -l
" nnoremap +m
" nnoremap -m
nnoremap +n :call CycleNotation()<CR>
" nnoremap -n
" nnoremap +o
" nnoremap -o
" nnoremap +p
" nnoremap -p
" nnoremap +q
" nnoremap -q
nnoremap +r :call CycleSpellLang(+1)<CR>
nnoremap -r :call CycleSpellLang(-1)<CR>
nnoremap +s :call CycleFontSize(+1)<CR>
nnoremap -s :call CycleFontSize(-1)<CR>
" nnoremap +t
" nnoremap -t
" nnoremap +u
" nnoremap -u
" nnoremap +v
" nnoremap -v
nnoremap +w :call CycleTextWidth(+1)<CR>
nnoremap -w :call CycleTextWidth(-1)<CR>
" nnoremap +x
" nnoremap -x
" nnoremap +y
" nnoremap -y
" nnoremap +z
" nnoremap -z
nnoremap +<TAB> :call CycleTabSpace(+1)<CR>
nnoremap -<TAB> :call CycleTabSpace(-1)<CR>
" >>>
" Toggle Settings <<<
" nnoremap äa
" nnoremap äb :set ballooneval! ballooneval?<CR>
nnoremap äc :ColorToggle<CR>
" nnoremap äd
" nnoremap äe
nnoremap äf :set fullscreen!<CR>
" nnoremap äg
nnoremap äh :if exists("g:syntax_on") <BAR> syntax off <BAR> else <BAR> syntax on <BAR> endif <CR>
" nnoremap äi
" nnoremap äj
nnoremap äk :if &keywordprg == ":help" <BAR> set keywordprg=man <BAR> else <BAR> set keywordprg=:help <BAR> endif <BAR> set keywordprg?<CR>
nnoremap äl :setlocal list! list?<CR>
nnoremap äm :set cursorcolumn! <BAR> set cursorline!<CR>
nnoremap än :set number! number?<CR>
nnoremap äN :set relativenumber! relativenumber?<CR>
" nnoremap äo
nnoremap äp :set paste! paste?<CR>
" nnoremap äq
nnoremap är :set spell! spell?<CR>
nnoremap äs :set hls!<CR>
" nnoremap ät
" nnoremap äu :sign unplace *<CR>
nnoremap äv :set hidden! hidden?<CR>
nnoremap äV :set modifiable! modifiable?<CR>
nnoremap äw :set wrap! wrap?<CR>
" nnoremap äx
" nnoremap äy
" nnoremap äz
nnoremap ä<TAB> :set expandtab! expandtab?<CR>
" >>>
" Text Objects <<<
" Visual Block <<<
vnoremap ab :<C-U>call VisualBlock(1,',')<CR>
vnoremap ib :<C-U>call VisualBlock(0,',')<CR>
onoremap ab :normal vab<CR>
onoremap ib :normal vib<CR>

vnoremap aB :<C-U>call VisualBlock(1,'')<CR>
vnoremap iB :<C-U>call VisualBlock(0,'')<CR>
onoremap aB :normal vaB<CR>
onoremap iB :normal viB<CR>
" >>>
" Indent Level <<<
vnoremap <silent>ai :<C-U>call IndTxtObj(0, 0)<CR>
vnoremap <silent>ii :<C-U>call IndTxtObj(1, 0)<CR>
onoremap ai :normal Vai<CR>
onoremap ii :normal Vii<CR>

vnoremap <silent>aI :<C-U>call IndTxtObj(0, 1)<CR>
vnoremap <silent>iI :<C-U>call IndTxtObj(1, 1)<CR>
onoremap aI :normal VaI<CR>
onoremap iI :normal ViI<CR>
" >>>
" Folding <<<
vnoremap az :<C-U>silent! normal! [zV]z<CR>
vnoremap iz :<C-U>silent! normal! [zjV]zk<CR>
onoremap az :normal Vaf<CR>
onoremap iz :normal Vif<CR>
" >>>
" >>>
" Misc <<<
nnoremap gA :call GetHighlightGroup()<CR>
nnoremap gG ggVG
nnoremap g. @:
nnoremap gp '[v']
nnoremap gr :r <cfile><CR>
nnoremap gs :%s;;
xnoremap gs :s;\%V;
nnoremap gS V:Sum<CR>
xnoremap gS :Sum<CR>
nnoremap z+ zt5<C-y>
nnoremap z- zb5<C-e>
nnoremap Q @q
nnoremap Y y$
xnoremap Y "+y
nnoremap <C-p> "+p
xnoremap <C-p> c+
xnoremap <silent> P p:call setreg('"', getreg('0'), getregtype('0'))<CR>
" xnoremap P pgvy
nnoremap U <C-R>
nnoremap cd :cd %:p:h<CR>
nnoremap cu :cd ..<CR>
nnoremap yp :call YankPath()<CR>
nnoremap öf :call Panel('Files')<CR>
nnoremap öm :call Make()<CR>
nnoremap öc :call PanelClose()<CR>
nnoremap zq :qa!<CR>
nnoremap cq :%s///gn<CR>
nnoremap cQ :%s///gn<CR>
nnoremap <S-SPACE> i<SPACE><ESC>l
nnoremap <S-CR> o<ESC>0D
nnoremap g<CR> r<CR>kddpk==
nnoremap <C-CR> i<CR><ESC>
nnoremap g<C-CR> i<CR><ESC>kddpk==
nnoremap ü <C-w>
tnoremap ü <C-w>
" nnoremap <C-w>ü :helpclose<CR> TODO preferred solution
nnoremap üü :helpclose<CR>
nnoremap üä :vertical rightbelow terminal<CR>
inoremap ö <C-c>
cnoremap ö <C-c>
inoremap Ö <C-v>
" cnoremap Ö <C-v> ???? what the heck ????
" s-tab gets set by snipmate
inoremap <S-TAB> <C-v><TAB>
vnoremap <expr> <C-u> mode() ==? "\<C-v>" ? ':Left<CR>'   : ':left<CR>'
vnoremap <expr> <C-n> mode() ==? "\<C-v>" ? ':Center<CR>' : ':center<CR>'
vnoremap <expr> <C-i> mode() ==? "\<C-v>" ? ':Right<CR>'  : ':right<CR>'
" >>>
" UNDER DEVELOPMENT <<<
nnoremap yO :call setreg('o', [])<CR>
nnoremap yo "Oyy
" nnoremap <expr> <CR> 'm`' . v:count1 . "GO<ESC>0D``"
" nnoremap öL :call LaTeXMenu("viw")<CR>
" xnoremap öL :call LaTeXMenu("gv")<CR>
"
" augroup COMPLETE
"    autocmd!
"    autocmd CompleteDone <buffer> call LatexFontContinue()
" augroup END
" >>>
" >>>

" menus <<<

" reduce duplicate lines
nmenu &Utils.Red&DuplLines :%s;^\(.*\)\(\n\1\)\+$;\1;<CR>
vmenu &Utils.Red&DuplLines :s;^\(.*\)\(\n\1\)\+$;\1;<CR>

" delete empty lines
nmenu &Utils.Del&EmptyLines :g/^\s*$/d<CR>
vmenu &Utils.Del&EmptyLines :g/^\s*$/d<CR>

" reduce emtpy lines
nmenu &Utils.&RedEmptyLines :g/^$/,/./-j<CR>
vmenu &Utils.&RedEmptyLines :g/^$/,/./-j<CR>
"nmenu &Utils.&RedEmptyLines :%s;^\(\s*\)\(\n\1\)\+$;\1;<CR>
"vmenu &Utils.&RedEmptyLines :s;^\(\s*\)\(\n\1\)\+$;\1;<CR>

" strip
nmenu &Utils.&StripLines :%s;^\s*\(.\{-}\)\s*$;\1;<CR>
vmenu &Utils.&StripLines :s;^\s*\(.\{-}\)\s*$;\1;<CR>

" strip right
nmenu &Utils.StripLines&Right :%s;\s\+$;;<CR>
xmenu &Utils.StripLines&Right :s;\s\+$;;<CR>

" strip left
nmenu &Utils.StripLines&Left :%s;^\s\+;;<CR>
vmenu &Utils.StripLines&Left :s;^\s\+;;<CR>

" reverse lines 
nmenu &Utils.&RevLines :g/^/m0
vmenu &Utils.&RevLines :call RevSelLines()<CR>
" vmenu &Utils.&RevLines2 <ESC>:let top=line("'<")-1<CR>:'<,'>:g/^/exec "m".top<CR>

" forward backward slashes
nmenu &Utils.&BackSlash2Slash :%s;\\;/;ge<CR>
nmenu &Utils.&Slash2BackSlash :%s;/;\\;ge<CR>
vmenu &Utils.&BackSlash2Slash :s;\\;/;ge<CR>
vmenu &Utils.&Slash2BackSlash :s;/;\\;ge<CR>

" hex, binary, octal, decimal, ... 
" >>>

" OS|GUI|Term dependent settings <<<

" Windows <<<
if has("win32")

   command P call chdir('D:\p')

   " let  FD=$VIM . '\vimfiles\bin\fd.exe'
   " let  RG=$VIM . '\vimfiles\bin\rg.exe'
   " let FZF=$VIM . '\vimfiles\bin\fzf.exe'

   set viminfofile=D:\\DSUsers\\uid34241\\tools\\vim\\.viminfo
   set directory=$USERPROFILE\AppData\Local\Temp
   set backspace=2
   set lines=999 columns=999

   if has("gui_running")

      " let $CHERE_INVOKING=1
      " set shell=D:\\Tools\\cygwin\\bin\\bash.exe\ -l
      " set shellcmdflag=-c
      " set shellxquote=\"
      " set shellslash
      " set noshelltemp

      set guioptions-=T
      set guioptions+=c
      set guioptions+=!

      set titlestring=%F

      colorscheme gruvbox

	else

      " Cmder
		set term=xterm
		set t_Co=256
		let &t_AB="\e[48;5;%dm"
		let &t_AF="\e[38;5;%dm"
		" colorscheme zenburn

	endif

else " all Unixoids


endif " >>>

" macOS <<<
if has("macunix")

   if has("gui_running")

      set guioptions+=c

      set background=dark
      let g:gruvbox_italics=0
      colorscheme gruvbox
      " colorscheme monokai

      " hi CursorLine guifg=#232526 guibg=#F92672

      "hi MyBooleanTrue  guifg=green
      "hi MyBooleanFalse guifg=red
      "syn keyword MyBooleanTrue  yes on true enable high contained
      "syn keyword MyBooleanFalse no off false disable low contained

   else

      set background=dark
      let g:gruvbox_italics=0
      colorscheme gruvbox
      " colorscheme default

   endif

endif " >>>

" Linux <<<
if has("unix")
   if has("gui_running")
   else
   endif
endif " >>>

" Cygwin <<<
if has("win32unix")

   set directory=/tmp

   colorscheme gruvbox

   if has("gui_running")

   else

      " for mode dependent cursor shape
      let &t_ti.="\e[1 q"
      let &t_SI.="\e[5 q"
      let &t_EI.="\e[1 q"
      let &t_te.="\e[0 q"

      " for Escape timeout issues
      let &t_ti.="\e[?7727h"
      let &t_te.="\e[?7727l"

      noremap <Esc>O[ <Esc>
      noremap! <Esc>O[ <Esc>

   endif

endif " >>>

" GUI vs. Term <<<
if has("gui_running")

   set titlestring=%F

   set guicursor=n-v-c:block-Cursor/lCursor-blinkwait0-blinkoff0-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver10-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait0-blinkoff0-blinkon0

   exe "set guifont=".s:myFontTypeList[s:myFontType].":h".s:myFontSizeList[s:myFontSize]

   " hi CursorLine   guifg=white guibg=#2b3f4a
   " hi CursorColumn guifg=white guibg=#2b3f4a
   " hi ColorColumn  guifg=#232526 guibg=#F92672
   
   "hi MyBooleanTrue  guifg=green
   "hi MyBooleanFalse guifg=red
   "syn keyword MyBooleanTrue  yes on true enable high contained
   "syn keyword MyBooleanFalse no off false disable low contained

   " hi red guifg=#F92672 guibg=#232526 gui=bold
   " hi grn guifg=#A6E22E guibg=#232526 gui=bold
   " hi org guifg=#FD971F guibg=#232526 gui=bold
   " hi blu guifg=#66D9EF guibg=#232526 gui=bold
   " hi ppl guifg=#AE81FF guibg=#232526 gui=bold
   " hi ylw guifg=#FFE345 guibg=#232526 gui=bold
   " hi wht guifg=#F8F8F0 guibg=#232526 gui=NONE

   " hi red guifg=#fb4934 guibg=#232526 gui=bold
   " hi grn guifg=#b8bb26 guibg=#232526 gui=bold
   " hi org guifg=#d79921 guibg=#232526 gui=bold
   " hi blu guifg=#458588 guibg=#232526 gui=bold
   " hi ppl guifg=#b16286 guibg=#232526 gui=bold
   " hi ylw guifg=#fabd2f guibg=#232526 gui=bold
   " hi wht guifg=#ebdbb2 guibg=#232526 gui=NONE


   " hi Match0 guifg=White guibg=grey62
   " hi Match1 guifg=White guibg=DarkOrchid4
   " hi Match2 guifg=Black guibg=SkyBlue        gui=bold
   " hi Match3 guifg=Black guibg=OliveDrab2     gui=bold
   " hi Match4 guifg=Black guibg=coral1         gui=bold
   " hi Match5 guifg=Black guibg=plum           gui=bold
   " hi Match6 guifg=Black guibg=orange         gui=bold
   " hi Match7 guifg=White guibg=DeepSkyBlue4
   " hi Match8 guifg=White guibg=DarkOliveGreen
   " hi Match9 guifg=White guibg=firebrick4

else

   set ttyfast

   " hi red ctermfg=167 ctermbg=236 cterm=bold
   " hi grn ctermfg=143 ctermbg=236 cterm=bold
   " hi org ctermfg=173 ctermbg=236 cterm=bold
   " hi blu ctermfg=110 ctermbg=236 cterm=bold
   " hi ppl ctermfg=139 ctermbg=236 cterm=bold
   " hi ylw ctermfg=144 ctermbg=236 cterm=bold
   " hi wht ctermfg=15  ctermbg=236 cterm=NONE

   " hi Match0 ctermfg=White ctermbg=1
   " hi Match1 ctermfg=White ctermbg=2
   " hi Match2 ctermfg=Black ctermbg=3
   " hi Match3 ctermfg=Black ctermbg=4
   " hi Match4 ctermfg=Black ctermbg=5
   " hi Match5 ctermfg=Black ctermbg=6
   " hi Match6 ctermfg=Black ctermbg=7
   " hi Match7 ctermfg=White ctermbg=8
   " hi Match8 ctermfg=White ctermbg=9
   " hi Match9 ctermfg=White ctermbg=10

endif " >>>

set statusline=%#SLOrg#CD=%#SLNrm#%{getcwd()}%=\ 
set statusline+=%#SLYlw#SESSION=%#SLNrm#%{GetFileName(v:this_session)}\ 
set statusline+=%#SLRed#\ PERM=%#SLNrm#%{getfperm(expand('%'))}\ 
set statusline+=%#SLRed#FORMAT=%#SLNrm#%{&ff}\ 
set statusline+=%#SLRed#TYPE=%#SLNrm#%Y\ 
set statusline+=%#SLPpl#SPELL=%#SLNrm#%{&spelllang}\ 
set statusline+=%#SLGrn#LINE=%#SLNrm#%l/%L(%p%%)\ 
set statusline+=%#SLGrn#COL=%#SLNrm#%v\ 
set statusline+=%#SLGrn#BYTE=%#SLNrm#%o\ 
set statusline+=%#SLBlu#XTAB=%#SLNrm#%{&expandtab}\ 

" set statusline=%#org#CD=%#wht#%{getcwd()}%=%#ylw#SESSION=%#wht#%{GetFileName(v:this_session)}%#red#\ PERM=%#wht#%{getfperm(expand('%'))}\ %#red#FORMAT=%#wht#%{&ff}\ %#red#TYPE=%#wht#%Y\ %#ppl#SPELL=%#wht#%{&spelllang}\ %#grn#LINE=%#wht#%l/%L(%p%%)\ %#grn#COL=%#wht#%v\ %#grn#BYTE=%#wht#%o\ %#blu#DEC=%#wht#\%b\ %#blu#HEX=%#wht#\%B\ 
" set statusline=%#org#Clip=%#wht#%{ShortenString(getreg('\"'),30,'r')}%=%#red#\ PERM=%#wht#%{getfperm(expand('%'))}\ %#red#FORMAT=%#wht#%{&ff}\ %#red#TYPE=%#wht#%Y\ \ %#ppl#SPELL=%#wht#%{&spelllang}\ \ %#grn#LINE=%#wht#%l/%L(%p%%)\ %#grn#COL=%#wht#%v\ %#grn#BYTE=%#wht#%o\ \ %#blu#DEC=%#wht#\%b\ %#blu#HEX=%#wht#\%B\ 
" >>>

"                 | cycle up/down | confirm menu | popup | panel
" colorschemes    |     x         |       x      |   x   |
" notation        |     x         |       x      |   x   | 
" font type       |     x         |       x      |   x   |   
" font size       |     x         |       x      |   x   | 
" base            |     x         |       x      |   x   | 
" spellcheck lang |     x         |       x      |   x   |
" tabspace        |     x         |       x      |   x   | 
" textwidth       |     x         |       x      |   x   | 
" change reg type |     x         |       x      |   x   | 
" makemenu        |               |       x      |   x   | 
" align ctrl      |               |       x      |   x   | 
" utils menu      |               |              |   x   | 
" buffers         |               |              |   x   | x
" sessions        |               |              |   x   | x
" files           |               |              |   x   | x
" tags            |               |              |   x   | x

" vim: fdm=marker fmr=<<<,>>>
