" functions <<<

" cycle spellcheck languages <<<
let s:myLang = 0
let s:myLangList = [ "en", "de", "it" ]
function! CycleSpellLang()
   let s:myLang = s:myLang + 1
   if s:myLang >= len(s:myLangList) | let s:myLang = 0 | endif
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

function! CycleColorscheme()
   let s:myColorscheme = s:myColorscheme + 1
   if s:myColorscheme >= len(s:myColorschemeList) | let s:myColorscheme = 0 | endif
   exe "colorscheme ".s:myColorschemeList[s:myColorscheme]
   redraw
   echo "colorscheme:" s:myColorschemeList[s:myColorscheme]
endf
" >>>

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
let s:myFontType     = 0 
let s:myFontSize     = 2 
let s:myFontTypeList = ["Menlo", "Monaco", "Andale\\ Mono"] 
let s:myFontSizeList = ["9", "10", "11", "12", "13", "14", "15", "16"]

function! CycleFontType() 
   let s:myFontType = s:myFontType + 1 
   if s:myFontType >= len(s:myFontTypeList) | let s:myFontType = 0 | endif 
   exe "set guifont=".s:myFontTypeList[s:myFontType].":h".s:myFontSizeList[s:myFontSize] 
   redraw 
   set guifont? 
endfunction

function! CycleFontSize() 
   let s:myFontSize = s:myFontSize + 1 
   if s:myFontSize >= len(s:myFontSizeList) | let s:myFontSize = 0 | endif 
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
function! CycleTabSpace()
   let g:TabSpace = g:TabSpace + 1
   if g:TabSpace > 4
      let g:TabSpace = 2
   endif
   execute 'set tabstop='.g:TabSpace
   execute 'set softtabstop='.g:TabSpace
   echo "tabspace = ".g:TabSpace
endfunction " >>>

" cycle textwidth <<<
function! CycleTextWidth()
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
      call cursor(".", 1)
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
      exec 'call cursor(".", '.l:EndCol.')'
   endif

endfunction
" >>>

" get byte offset <<<
function! GetByteOffset()
   return line2byte(line('.')) + col('.') - 1
endfunction " >>>

" shorten string <<<
"ShortenString(getreg('\"'),60,'r')
function! ShortenString(string, width, end)
   let l:StringWidth = strwidth(a:string)

   if l:StringWidth <= a:width
      return a:string
   else
      if a:end == 'l' " left
         return "…" . strpart(a:string, l:StringWidth-(a:width-1))
      else            " right
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

" clean up <<<
function! CleanUp()
      call delete(g:BalloonText)
      call delete(g:MsgFile)
      call delete(g:SignVimFile)
endfunction
" >>>

" change register type <<<
function! ChangeRegType(RegName, ...)
" 1 optional parameter for the new regtype ("c", "l" or "v")
" if omitted cycle through characterwise, linewise, blockwise

   let l:CurRegType = getregtype(a:RegName)

   if l:CurRegType == ""
      echo "regtype for register " . a:RegName . " is unknown"
      return
   endif

   " regtype name conversion for readabilty only
   if l:CurRegType == "v"
      let l:CurRegType = "c"
   elseif l:CurRegType == "V"
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

   execute 'nnoremap <buffer> <silent> <CR>  :call setreg("'.a:reg.'", getline(1,"$")) <BAR> silent! bwipeout! __EDITREG__<CR>'

   execute 'inoremap <buffer> <silent> <CR>  <ESC>:call setreg("'.a:reg.'", getline(1,"$")) <BAR> silent! bwipeout! __EDITREG__<CR>'

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

" grep <<<
function! Grep(args)
   exec 'silent lgrep ' . a:args
   lopen
endfunction " >>>

" grep buffers <<<
function! GrepBuffers(args)
   call setloclist(winnr(), [])
   exec 'bufdo silent lgrepadd ' . a:args
   lopen
endfunction " >>>

" UNDER DEVELOPMENT <<<
function! GetVisualSelection() " <<<
    silent! normal! gv"xy
    return @x
endfunction " >>>

function! ExtractNumbersFromString(str) " <<<

   let l:Numbers = []
   let l:Match   = ""
   let l:Start   = 0
   let l:End     = 0
   let l:Str     = substitute(a:str, '\n', ' ', 'g')

   while v:true

      " TODO float numbers
      let l:Result = matchstrpos(l:Str, '\([+-]*0x\x\+\)\|\([+-]*0b[01]\+\)\|\([+-]*\d\+\)', l:Start)
      let l:Match  = l:Result[0]
      let l:Start  = l:Result[1]
      let l:End    = l:Result[2]

      if l:Match == ""
         break
      endif

      " if strpart(l:Match, 0, 2) == '0b'
      "    let l:value = substitute(l:Match, "0b", "y", "")
      "    exe "silent Tobase 10 " . l:value
      "    let l:Match = @@
      " endif
      " echo l:Match

      " call add(l:Numbers, str2nr(l:Match))
      call add(l:Numbers, l:Match)

      let l:Start = l:End + 1
   endwhile

   " echo l:Numbers
   return l:Numbers
endfunction " >>>

function! Sum(numbers) " <<<
   " let l:Sum = 0
   " for nr in a:numbers
      " let l:Sum += nr
   " endfor
   " return l:Sum
   return eval(join(a:numbers, '+'))
endfunction " >>>

function! JumpToSOBFW() " <<<
   normal $
   let g:BlockPattern_s = '^\s*\(if\|else\|while\|for\|func\)'
   call search(g:BlockPattern_s, 'cW')
endfunction " >>>

function! JumpToSOBBW() " <<<
   normal $
   let g:BlockPattern_s = '^\s*\(if\|else\|while\|for\|func\)'
   call search(g:BlockPattern_s, 'bcWz')
endfunction " >>>

" function! UserCompletion(findstart, base) " <<<
"    if a:findstart
"       let line = getline('.')
"       let start = col('.') - 1
"       if start > 0
"          if line[start] == '('
"             return start
"          else
"             return -3
"          endif
"       else
"          return -3
"       endif
"    else
"       return {'words':menus[s:NextMenu], 'refresh':'always'}
"    endif
" endfunction " >>>

function! StripString(str, side) " <<<
   if a:side == 'l'
      return matchlist(a:str, '^\s*\(.*\)$')[1]
   end
   if a:side == 'r'
      return matchlist(a:str, '^\(.\{-}\)\s*$')[1]
   end
   if a:side == 'b'
      return trim(a:str)
      " return matchlist(a:str, '^\s*\(.\{-}\)\s*$')[1]
   end
   return a:str
endfunction " >>>

function! AlignString(str, alignment, length) " <<<

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

function! AlignBlock(alignment) " <<<

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
" >>>
" >>>

" commands <<<
command! -range Left   call AlignBlock('l')
command! -range Center call AlignBlock('c')
command! -range Right  call AlignBlock('r')
command! -nargs=1 EditReg call EditReg(<f-args>)
command! -range -nargs=* ReArrangeColumns <line1>,<line2>call ReArrangeColumns(<f-args>)
command! -nargs=1 Grep call Grep('<args>')
command! -range -nargs=0 Sum echo Sum(ExtractNumbersFromString(GetVisualSelection()))
command! -range=% -nargs=? -complete=file New silent <line1>,<line2>yank x | enew | put! x | $d_ | if(<q-args> != '') | silent write <args> | endif
command! E silent! !explorer .
command! F silent! !open .
" :w !cat - >> /foo/samples
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
set showcmd
set showmode
set wildmenu
set wrapscan
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
" set complete=.,w,b,u,t,i
" set completeopt=menu,preview
set directory=~/.vim/swapdir,/tmp
set encoding=utf-8
set errorformat=%f:%l:%c:\ %m
set errorformat+=luac:\ %f:%l:\ %m
set fillchars=vert:╏,fold:━
set foldmarker=<<<,>>>
set foldmethod=marker
set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
set keywordprg=:help
set laststatus=2
set listchars=eol:↲,tab:↦\ ,nbsp:␣,extends:…,trail:⋅
set mousemodel=popup_setpos
set nrformats=bin,hex
set path=.,,** " use :checkpath
set sessionoptions=buffers,curdir
set shortmess="fIlmnxtToO"
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
   "autocmd BufWritePre * call FixFile()

   autocmd VimLeavePre * call CleanUp()
   autocmd ColorScheme * call DefMatchColors() " TODO temporary til part of colorschemes
   "autocmd WinLeave * let g:prevwin=win_getid()
   "autocmd BufWritePost .crontab !crontab ~/.crontab

   "set completefunc=LatexFont
   "set completefunc=UserCompletion

augroup END
" >>>

" plugin settings <<<
" colorizer <<<
let g:colorizer_startup = 0
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
" alphabetically - comments only <<<

" do
" yo

" cs -> surround
" ds -> surround
" ys -> surround

" gb
" gc -> tcomment plugin
" gl
" gy
" gz

" gö
" gä
" gü
" gß
" öb
" ög
" öF
" öB
" öG

" zp -> fold put
" zy

" zö
" zä
" zü
" zß



" dangerous insert and command mode mappings <<<
" cnoremap <C-SPACE> <C-R>"


" the following keys are potentially available
" inoremap <TAB> tab
" inoremap <S-TAB> s-tab        -> currently broken by snipmate
" inoremap <C-TAB> c-tab        -> currently broken by snipmate
" inoremap <S-SPACE> s-space
" inoremap <C-SPACE> c-space
" inoremap <S-BS> s-bs
" inoremap <C-BS> c-bs
" inoremap <S-CR> s-cr
" inoremap <C-CR> c-cr
" >>>

" nnoremap z<SPACE>
" nnoremap g<TAB>
" nnoremap z<TAB>
" nnoremap ö<TAB>
" nnoremap ä<TAB>
" nnoremap ü<TAB> -> ü is used for Ctrl-w
" nnoremap Ctrl-w {   tag jump in split window


" based on c,d,y + motions

" dö
" dü
" dä
" cö
" cä
" cü
" yö
" yä
" yü
" dß
" cß
" yß
" m  -> match commands
" o -> co <C-o>
" p
" cp -> close project
" q

" r
" nnoremap dr
" nnoremap yr
" s -> surround.vim 
" u
" v    ??? 
" x
" y
" z    ??? 
" A
" C
" D
" I
" J
" K
" O
" P
" Q
" R
" S -> surround.vim 
" U
" V    ???
" X
" Y
" Z

" based on v + motions
" xnoremap a
" xnoremap i
" xnoremap m
" xnoremap Q
" xnoremap Z
" some more can be seen as FREE as it's questionable if they are useful
" >>>
" by topic <<<
" Align <<<
xnoremap öa :Align<SPACE>
nnoremap öa vip:Align<SPACE>
nnoremap äa :call SetAlignCtrl()<CR>
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
nnoremap <F12> :!ctags --langmap=c:.c.h -f .tags -R --tag-relative=yes --extra=+fq --fields=+znimsStK --c-kinds=+lpx --sort=yes<CR>
" >>>
" Grep <<<
" TODO: test with regex searches
let g:RgHint="rg [options] pattern [path, ...]\n
             \-w whole words \| -i case insensitive \| -v invert match \| -e regex\n
             \-F literally \| --hidden search hidden files \| -t type -T non-type\n
             \--max-depth NUM \| -A NUM after \| -B NUM before \| -C NUM context"

nnoremap ög :echo g:RgHint<CR>:Grep<SPACE>

nnoremap gö :call Grep('-F -w "' . expand('<cword>') . '" %')<CR>
nnoremap gÖ :call Grep('-F -i "' . expand('<cword>') . '" %')<CR>
xnoremap gö "gy:call Grep('-F -w "' . getreg('g') . '" %')<CR>
xnoremap gÖ "gy:call Grep('-F -i "' . getreg('g') . '" %')<CR>

nnoremap gd :call Grep('-F -w "' . expand('<cword>') . '"')<CR>
nnoremap gD :call Grep('-F -i "' . expand('<cword>') . '"')<CR>
xnoremap gd "gy:call Grep('-F -w "' . getreg('g') . '"')<CR>
xnoremap gD "gy:call Grep('-F -i "' . getreg('g') . '"')<CR>

nnoremap gb :call GrepBuffers('-F -w "' . expand('<cword>') . '" %')<CR>
nnoremap gB :call GrepBuffers('-F -i "' . expand('<cword>') . '" %')<CR>
nnoremap gb "gy:call GrepBuffers('-F -w "' . getreg('g') . '" %')<CR>
nnoremap gB "gy:call GrepBuffers('-F -i "' . getreg('g') . '" %')<CR>

nnoremap ym :call AddMatch('')<CR>
xnoremap m "my:call AddMatch('m')<CR>
nnoremap cm :call ClearMatches()<CR>
"nnoremap dm :call DeleteMatch()<CR> " TODO: store ID from matchadd

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
nnoremap är z=
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
nnoremap <SPACE> /
nnoremap <C-SPACE> /\c
nnoremap g<SPACE> *N
nnoremap ch :nohl<CR>
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
nnoremap H :call JumpToStartOfLine()<CR>
nnoremap L :call JumpToEndOfLine()<CR>
nnoremap 0 :call JumpToStartOfLine()<CR>
nnoremap ß :call JumpToEndOfLine()<CR>
nnoremap $ :call JumpToEndOfLine()<CR>
nnoremap W e
nnoremap B ge
nnoremap ; ,
nnoremap , ;
" nnoremap <expr> , getcharsearch().forward ? ';' : ','
" nnoremap <expr> ; getcharsearch().forward ? ',' : ';'
nnoremap co <C-o>
xnoremap <C-o> <ESC>:let b:ByteOffset=GetByteOffset()<CR>`<:if(b:ByteOffset<=GetByteOffset())<BAR>let b:VisCmd=""<BAR>else<BAR>let b:VisCmd="o"<BAR>endif<CR>:exe "normal gv".b:VisCmd<CR>
nnoremap ü <C-w>
tnoremap ü <C-w>
" >>>
" Shift Lines <<<
nnoremap <S-Up>   kddpk
nnoremap <S-Down> ddp
xnoremap <S-Up>   xkP'[V']
xnoremap <S-Down> xp'[V']
" >>>
" Visual Block <<<
onoremap ib :call VisualBlock(0,',')<CR>
onoremap ab :call VisualBlock(1,',')<CR>
onoremap iB :call VisualBlock(0,'')<CR>
onoremap aB :call VisualBlock(1,'')<CR>

nnoremap vib :call VisualBlock(0,',')<CR>
nnoremap vab :call VisualBlock(1,',')<CR>
nnoremap viB :call VisualBlock(0,'')<CR>
nnoremap vaB :call VisualBlock(1,'')<CR>
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
inoremap ü <C-r>
cnoremap ü <C-r>
nnoremap Ü :EditReg<SPACE>
" >>>
" Completion <<<
cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>
"inoremap <expr> <TAB>   Complete(0)
"inoremap <expr> <S-TAB> Complete(1)

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
inoremap är <C-x><C-s>
" tags
inoremap ät <C-x><C-]>
" user defined
inoremap äu <C-x><C-u>
" omni completion
inoremap äo <C-x><C-o>

" add date/time
" äj 2019-08-21
" äh 2019-08-21T14:38
" äJ 21. August 2019
" äH 14:38
inoremap äj <C-R>=strftime("%Y-%m-%d")<CR>
inoremap äh <C-R>=strftime("%Y-%m-%dT%H:%M")<CR>
inoremap äJ <C-R>=strftime("%d. %B %Y")<CR>
inoremap äH <C-R>=strftime("%H:%M")<CR>
" >>>
" Cycle Settings <<<
" nnoremap +a
nnoremap +b :silent call CycleBase()<CR>
nnoremap +c :ColorHEX<CR>
" nnoremap +d
" nnoremap +e
nnoremap +f :call CycleFontType()<CR>
" nnoremap +g
nnoremap +h :call CycleColorscheme()<CR>
" nnoremap +i
" nnoremap +j
" nnoremap +k
" nnoremap +l
" nnoremap +m
nnoremap +n :set relativenumber!<CR>
" nnoremap +o
" nnoremap +p
" nnoremap +q
nnoremap +r :call CycleSpellLang()<CR>
nnoremap +s :call CycleFontSize()<CR>
" nnoremap +s
" nnoremap +t
" nnoremap +u
nnoremap +v :call CycleNotation()<CR>
nnoremap +w :call CycleTextWidth()<CR>
" nnoremap +x
" nnoremap +y
" nnoremap +z
" nnoremap +ä
" nnoremap +ö
" nnoremap +ü
nnoremap +<TAB> :call CycleTabSpace()<CR>
" >>>
" Toggle Settings <<<

" nnoremap -a
nnoremap -b :set ballooneval!<CR>:set ballooneval?<CR>
nnoremap -c :ColorToggle<CR>
" nnoremap -d
" nnoremap -e
nnoremap -f :set fullscreen!<CR>
" nnoremap -g
nnoremap -h :if exists("g:syntax_on") <BAR> syntax off <BAR> else <BAR> syntax on <BAR> endif <CR>
" nnoremap -i
" nnoremap -j
nnoremap -k :if &keywordprg == ":help" <BAR> set keywordprg=man <BAR> echo "keywordprg=man" <BAR> else <BAR> set keywordprg=:help <BAR> echo "keywordprg=:help" <BAR> endif <CR>
nnoremap -l :setlocal list!<CR>:setlocal list?<CR>
nnoremap -m :set cursorcolumn! <BAR> set cursorline!<CR>
nnoremap -n :set number!<CR>
" nnoremap -o
" nnoremap -p
" nnoremap -q
nnoremap -r :set spell!<CR>:set spell?<CR>
nnoremap -s :sign unplace *<CR>
" nnoremap -t
" nnoremap -u
" nnoremap -v
nnoremap -w :set wrap!<CR>:set wrap?<CR>
" nnoremap -x
" nnoremap -y
" nnoremap -z
" nnoremap -ä
" nnoremap -ö
" nnoremap -ü
nnoremap -<TAB> :set expandtab!<CR>:set expandtab?<CR>
" >>>
" Text Objects <<<
onoremap <silent>ai :<C-U>call IndTxtObj(0, 0)<CR>
onoremap <silent>ii :<C-U>call IndTxtObj(1, 0)<CR>
vnoremap <silent>ai :<C-U>call IndTxtObj(0, 0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>call IndTxtObj(1, 0)<CR><Esc>gv

onoremap <silent>aI :<C-U>call IndTxtObj(0, 1)<CR>
onoremap <silent>iI :<C-U>call IndTxtObj(1, 1)<CR>
vnoremap <silent>aI :<C-U>call IndTxtObj(0, 1)<CR><Esc>gv
vnoremap <silent>iI :<C-U>call IndTxtObj(1, 1)<CR><Esc>gv
" >>>
" Misc <<<
nnoremap gG ggVG
nnoremap g. @:
nnoremap gp '[v']
nnoremap gr :r <cfile><CR>
nnoremap gs :%s;;
xnoremap gs :s;\%V;
" or set scrolloff=5
nnoremap z<CR> zt5<C-y>
nnoremap z- zb5<C-e>
nnoremap Q @q
nnoremap Y y$
xnoremap Y "+y
nnoremap <C-p> "+p
xnoremap <C-p> c+
nnoremap U <C-R>
nnoremap cd :cd %:p:h<CR>
nnoremap öf :call Panel('Files')<CR>
nnoremap öm :call Make()<CR>
nnoremap öc :call PanelClose()<CR>
nnoremap zq :qa!<CR>
nnoremap cq :%s///gn<CR>
nnoremap cQ :%s///gn<CR>
nnoremap <S-SPACE> i<SPACE><ESC>l
nnoremap <S-CR> o<ESC>0D
nnoremap g<CR> r<CR>kddpk==
nnoremap <C-CR> i<CR><ESC>
nnoremap g<C-CR> i<CR><ESC>kddpk==
inoremap ö <ESC>
cnoremap ö <ESC>
cnoremap <S-SPACE> <C-R><C-W>
cnoremap <C-SPACE> <C-R><C-A>
" >>>
" >>>
" UNDER DEVELOPMENT <<<
nnoremap öL :call LaTeXMenu("viw")<CR>
xnoremap öL :call LaTeXMenu("gv")<CR>

augroup COMPLETE
   autocmd!
   autocmd CompleteDone <buffer> call LatexFontContinue()
augroup END

nnoremap gk :call JumpToSOBBW()<CR>
nnoremap gj :call JumpToSOBFW()<CR>

vnoremap <expr> <C-u> mode() ==? "\<C-v>" ? ':Left<CR>'   : ':left<CR>'
vnoremap <expr> <C-n> mode() ==? "\<C-v>" ? ':Center<CR>' : ':center<CR>'
vnoremap <expr> <C-i> mode() ==? "\<C-v>" ? ':Right<CR>'  : ':right<CR>'
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

" macOS <<<
if has("macunix")

   if has("gui_running")

      set guioptions+=c
      colorscheme material

      " hi CursorLine guifg=#232526 guibg=#F92672

      "hi MyBooleanTrue  guifg=green
      "hi MyBooleanFalse guifg=red
      "syn keyword MyBooleanTrue  yes on true enable high contained
      "syn keyword MyBooleanFalse no off false disable low contained

   else

      colorscheme default

   endif

endif " >>>

" Linux <<<
if has("unix")
   if has("gui_running")
   else
   endif
endif " >>>

" Windows <<<
if has("win32")

   set viminfofile=D:\\DSUsers\\uid34241\\tools\\vim\\.viminfo
   set directory=$USERPROFILE\AppData\Local\Temp
   set backspace=2
   set lines=999 columns=999

   set grepprg=D:\Tools\cygwin\usr\local\bin\rg.exe\ --vimgrep\ $*
   set grepformat=%f:%l:%c:%m

   if has("gui_running")

      set guioptions-=T
      set guioptions+=c
      set guioptions+=!
      set titlestring=%F
      colorscheme molokai

   else

   endif

endif " >>>

" Cygwin <<<
if has("win32unix")

   set directory=/tmp
   set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep\ $* 
   set grepformat=%f:%l:%c:%m

   colorscheme jellybeans

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

   " hi CursorLine guifg=#232526 guibg=#F92672
   "hi MyBooleanTrue  guifg=green
   "hi MyBooleanFalse guifg=red
   "syn keyword MyBooleanTrue  yes on true enable high contained
   "syn keyword MyBooleanFalse no off false disable low contained

   hi red guifg=#F92672 guibg=#232526 gui=bold
   hi grn guifg=#A6E22E guibg=#232526 gui=bold
   hi org guifg=#FD971F guibg=#232526 gui=bold
   hi blu guifg=#66D9EF guibg=#232526 gui=bold
   hi ppl guifg=#AE81FF guibg=#232526 gui=bold
   hi ylw guifg=#FFE345 guibg=#232526 gui=bold
   hi wht guifg=#F8F8F0 guibg=#232526 gui=NONE

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

else

   set ttyfast

   hi red ctermfg=167 ctermbg=236 cterm=bold
   hi grn ctermfg=143 ctermbg=236 cterm=bold
   hi org ctermfg=173 ctermbg=236 cterm=bold
   hi blu ctermfg=110 ctermbg=236 cterm=bold
   hi ppl ctermfg=139 ctermbg=236 cterm=bold
   hi ylw ctermfg=144 ctermbg=236 cterm=bold
   hi wht ctermfg=15  ctermbg=236 cterm=NONE

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

endif " >>>

set statusline=%#org#CD=%#wht#%{getcwd()}%=%#ylw#SESSION=%#wht#%{GetFileName(v:this_session)}%#red#\ PERM=%#wht#%{getfperm(expand('%'))}\ %#red#FORMAT=%#wht#%{&ff}\ %#red#TYPE=%#wht#%Y\ %#ppl#SPELL=%#wht#%{&spelllang}\ %#grn#LINE=%#wht#%l/%L(%p%%)\ %#grn#COL=%#wht#%v\ %#grn#BYTE=%#wht#%o\ %#blu#DEC=%#wht#\%b\ %#blu#HEX=%#wht#\%B\ 
" set statusline=%#org#Clip=%#wht#%{ShortenString(getreg('\"'),30,'r')}%=%#red#\ PERM=%#wht#%{getfperm(expand('%'))}\ %#red#FORMAT=%#wht#%{&ff}\ %#red#TYPE=%#wht#%Y\ \ %#ppl#SPELL=%#wht#%{&spelllang}\ \ %#grn#LINE=%#wht#%l/%L(%p%%)\ %#grn#COL=%#wht#%v\ %#grn#BYTE=%#wht#%o\ \ %#blu#DEC=%#wht#\%b\ %#blu#HEX=%#wht#\%B\ 

" >>>

" vim: fdm=marker fmr=<<<,>>>
