"/Users/marcotrosi/.vim/plugin/panel.vim
"/Users/marcotrosi/.vim/snippets/_.snippets
"/Users/marcotrosi/.vim/snippets/c.snippets
"/Users/marcotrosi/.vim/snippets/lua.snippets
"/Users/marcotrosi/.vim/snippets/vim.snippets
"/Users/marcotrosi/.vim/snippets/tex.snippets

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
let s:myColorschemeFiles = globpath("~/.vim/colors", "*.vim", 0, 1)
for cs in s:myColorschemeFiles
   call add(s:myColorschemeList, substitute(substitute(cs, "\.vim$", "",""), ".*/", "", ""))
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

" cycle font face and size <<< 
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
endfunc 

function! CycleFontSize() 
   let s:myFontSize = s:myFontSize + 1 
   if s:myFontSize >= len(s:myFontSizeList) | let s:myFontSize = 0 | endif 
   exe "set guifont=".s:myFontTypeList[s:myFontType].":h".s:myFontSizeList[s:myFontSize] 
   redraw 
   set guifont? 
endfunc 
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

" make menu <<<
function! Make()
   let l:myMakeTargets = ["quit", "", "tag", "cln", "bld", "tst", "rel", "all", "doc"]
   let l:c=0
   let l:c = confirm("Make Menu","&make\nta&g\n&cln\n&bld\n&tst\n&rel\n&all\n&doc")
   if l:c != 0
      exe "make " . l:myMakeTargets[l:c] . " NOCOLOR=true"
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
   call matchadd(NextMatch(), a:str) 
endfunction 

nnoremap ym :call AddMatch('')<CR> 
vnoremap m "zy:call AddMatch('z')<CR> 
nnoremap cm :call ClearMatches()<CR>
"nnoremap dm :call DeleteMatch()<CR>
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
function! JumpToTest()
   let l:funcname = expand('<cword>')
   if(match(l:funcname, '^test_') != -1)
      "echo substitute(l:funcname, '^test_', '', '')
      let l:jumpto = substitute(l:funcname, '^test_', '', '')
   else
      "echo "test_".l:funcname
      let l:jumpto = "test_".l:funcname
   end
   exe "tag ".l:jumpto
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

" jump to start <<<
function! JumpToStart()

   let l:CurCol = col(".")

   if l:CurCol == 1
      normal _
   else
      call cursor(".", 1)
   endif

endfunction
" >>>

" jump to end <<<
function! JumpToEnd()

   let l:CurCol = col(".")
   let l:EndCol = col("$")-1

   if l:CurCol == l:EndCol
      normal g_
   else
      exec 'call cursor(".", '.l:EndCol.')'
   endif

endfunction
" >>>

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

nnoremap öL :call LaTeXMenu("viw")<CR>
vnoremap öL :call LaTeXMenu("gv")<CR>

augroup COMPLETE
   autocmd!
   autocmd CompleteDone <buffer> call LatexFontContinue()
augroup END

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

set completefunc=LatexFont
" >>>

" clean up <<<
function! CleanUp()
      call delete(g:BalloonText)
      call delete(g:MsgFile)
      call delete(g:SignVimFile)
endfunction
" >>>
" >>>

" settings <<<
" off <<<
set nocompatible
set noconfirm
set nocursorcolumn
set nocursorline
set noerrorbells
set nolinebreak
set nosol
set nolist
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
" >>>

" values <<<
let g:TabSpace=3
execute 'set tabstop='.g:TabSpace
execute 'set softtabstop='.g:TabSpace
set shiftwidth=0

set belloff=all
set encoding=utf-8
set errorformat+=%f:%l:%c:\ %m
set errorformat=luac:\ %f:%l:\ %m
set fillchars=vert:╏,fold:━
set foldmarker=<<<,>>>
set foldmethod=marker
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
set keywordprg=:help
set laststatus=2
set listchars=eol:↲,tab:↦\ ,nbsp:␣,extends:…,trail:⋅
set mousemodel=popup_setpos
set nrformats=bin,hex,alpha
set path=.,,** " use :checkpath
set sessionoptions=buffers,curdir
set shortmess="fIlmnxtToO"
set spelllang=en
set spellsuggest=9
set tags=.tags
set textwidth=120
set virtualedit=block

function! Diff()
   " let l:opt = ''
   " if &diffopt =~ 'icase'
   "    let l:opt = opt . '-i '
   " endif
   " if &diffopt =~ 'iwhite'
   "    let l:opt = opt . '-b '
   " endif
   silent execute '!git diff --patience --no-color ' . v:fname_in . ' ' . v:fname_new
endfunction
set diffexpr=Diff()
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

   autocmd BufEnter *.c,*.h let C='//'
   autocmd BufEnter *.lua let C='--'
   autocmd BufEnter *.tex let C='%'
   autocmd BufEnter makefile,*.py,*.pl let C='#'
   autocmd BufEnter .vimrc,*.vim let C='"'

   autocmd BufEnter *.dox set filetype=c.doxygen
   autocmd BufEnter *.py set noexpandtab
   autocmd BufLeave *.py set expandtab
   autocmd BufEnter makefile set noexpandtab
   autocmd BufLeave makefile set expandtab
   autocmd VimLeavePre * call CleanUp()
   autocmd ColorScheme * call DefMatchColors() " temporary til part of colorschemes
   " autocmd WinLeave * let g:prevwin=win_getid()
   "autocmd BufWritePost .crontab !crontab ~/.crontab
augroup END
" >>>

" plugin settings <<<
" colorizer <<<
let g:colorizer_startup = 0
" >>>
" wildfire <<<
let g:wildfire_objects   = split("iw,iW,ip,i),a),i],a],i},a},i',a',i\",a\",it", ",")
" >>>
" align <<<
let g:DrChipTopLvlMenu= "&Plugins.&Align."
" >>>
" >>>

" gui vs. term <<<
if has("gui_running")

   set titlestring=%F
   set balloonexpr=Balloon()
   set noballooneval
   set guioptions+=c
   colorscheme molokai
   "colorscheme soft-morning-light

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

   exe "set guifont=".s:myFontTypeList[s:myFontType].":h".s:myFontSizeList[s:myFontSize]

else

   set ttyfast
   colorscheme default

   hi red ctermfg=167 ctermbg=236 cterm=bold
   hi grn ctermfg=143 ctermbg=236 cterm=bold
   hi org ctermfg=173 ctermbg=236 cterm=bold
   hi blu ctermfg=110 ctermbg=236 cterm=bold
   hi ppl ctermfg=139 ctermbg=236 cterm=bold
   hi ylw ctermfg=144 ctermbg=236 cterm=bold
   hi wht ctermfg=15  ctermbg=236 cterm=NONE

endif

sign define E text=× texthl=red
sign define W text=! texthl=org
sign define I text=i texthl=blu
sign define O text=✔ texthl=grn

set statusline=%#org#CD=%#wht#%{getcwd()}%=%#ylw#SESSION=%#wht#%{GetFileName(v:this_session)}%#red#\ PERM=%#wht#%{getfperm(expand('%'))}\ %#red#FORMAT=%#wht#%{&ff}\ %#red#TYPE=%#wht#%Y\ %#ppl#SPELL=%#wht#%{&spelllang}\ %#grn#LINE=%#wht#%l/%L(%p%%)\ %#grn#COL=%#wht#%v\ %#grn#BYTE=%#wht#%o\ %#blu#DEC=%#wht#\%b\ %#blu#HEX=%#wht#\%B\ 
" >>>
" >>>

" mappings <<<

" Align
vnoremap öa :Align<Space>
nnoremap öa vip:Align<Space>
nnoremap äa :call SetAlignCtrl()<CR>

" Increment
vnoremap öi c@<ESC>gv:Inc s1 i1<CR>
vnoremap öI c@<ESC>gv:Inc s0 i1<CR>

" Tags
" nnoremap gt :tag<Space>
nnoremap öt :call Panel('Tags')<CR>
nnoremap öö g<C-]>zz
nnoremap ää <C-t>zz
nnoremap öä :call JumpToTest()<CR>zz
nnoremap öH :helptags ~/.vim/doc<CR>

" Grep
" TODO: test with regex searches
function! Grep(args)
   exec 'silent lgrep ' . a:args
   lopen
endfunction

command! -nargs=1 Grep call Grep('<args>')

let g:AgHint="ag [options] pattern [%, path, ...]\n
             \-s case sensitive \| -i case insensitive (dflt) \| -n no recurse \| -r recursive (dflt)\n
             \-w whole words \| -Q literally \| --hidden search hidden files \| -g find files"

nnoremap ög :echo g:AgHint<CR>:Grep<SPACE>

nnoremap gb :call Grep('-Q -w -s ' . expand('<cword>') . ' %')
nnoremap gB :call Grep('-Q '       . expand('<cword>') . ' %')

nnoremap gd :call Grep('-Q -w -s ' . expand('<cword>'))
nnoremap gD :call Grep('-Q '       . expand('<cword>'))

function! GrepBuffers(args)
   call setloclist(winnr(), [])
   let l:CWord = expand('<cword>')
   exec 'bufdo silent lgrepadd ' . a:args . ' ' . l:CWord . ' %'
   lopen
endfunction

nnoremap ga :call GrepBuffers('-Q -w -s ')<CR>
nnoremap gA :call GrepBuffers('-Q ')<CR>

" QuickFix And Location List
nnoremap öe :call ToggleQuickFix()<CR>
nnoremap e :cnext<CR>zz
nnoremap E :cprevious<CR>zz

nnoremap ös :call ToggleLocList()<CR>
nnoremap <C-h> :silent! lolder<CR>
nnoremap <C-l> :silent! lnewer<CR>
nnoremap <C-j> :lnext<CR>zz
nnoremap <C-k> :lprevious<CR>zz

" Sessions
nnoremap öp :call Panel('Sessions')<CR>
nnoremap cp :%bd<BAR>let v:this_session=''<CR>

" Spell
nnoremap ör ]szz
nnoremap öR [szz
nnoremap är z=

" Search
vnoremap / y/"<CR>
vnoremap ? y?"<CR>
vnoremap # y/\<"\><CR>
vnoremap * y/\<"\><CR>

" Buffer
nnoremap ön :bn<CR>
nnoremap öh :bp<CR>
nnoremap öb :call Panel('Buffers')<CR>
nnoremap öl :call Panel('Buffers')<CR>
nnoremap ö<SPACE> :b#<CR>
nnoremap öw :w!<CR>
nnoremap öd :bd<CR>
nnoremap öD :%bd<BAR>e#<CR>
nnoremap öx :%d<CR>
nnoremap öu :e!<CR>

" Vimrc
nnoremap öv :e  $MYVIMRC<CR>
nnoremap öV :so $MYVIMRC<CR>

" Slash/Backslash
nnoremap <silent> <Bslash>/ :let tmp=@/<BAR>s:\\:/:ge<BAR>let @/=tmp<BAR>noh<CR>
nnoremap <silent> <Bslash><Bslash> :let tmp=@/<BAR>s:/:\\:ge<BAR>let @/=tmp<BAR>noh<CR>

" Jump To Start/End Of Line
nnoremap 0 :call JumpToStart()<CR>
nnoremap ß :call JumpToEnd()<CR>
nnoremap $ :call JumpToEnd()<CR>

" Moving
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Jumping
nnoremap ök {zz
nnoremap öj }zz
nnoremap n nzz
nnoremap N Nzz

" Shift Lines
nnoremap <S-Up>   kddpk
nnoremap <S-Down> ddp
vnoremap <S-Up>   xkP'[V']
vnoremap <S-Down> xp'[V']

" Indent
vnoremap <C-l> >gv
vnoremap <C-h> <gv

" Fold
nnoremap zp vip<ESC>'<A =C<CR> <<<<ESC>'>A =C<CR> >>><ESC>
vnoremap zp <ESC>'<A =C<CR> <<<<ESC>'>A =C<CR> >>><ESC>

" Marks
nnoremap mn ]`zz
nnoremap mN [`zz
nnoremap mm g`Mzz

" Misc
nnoremap gG ggVG
nnoremap g= gg=Gg``zz
nnoremap g. @:
nnoremap gp '[v']
nnoremap gr :r <cfile><CR>
nnoremap gs :%s;;
vnoremap gs :s;;

nnoremap co <C-o>
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
nnoremap öf :call Panel('Files')<CR>
" öb
" ög
" öF
" öB
" öG

" zp -> fold put
nnoremap zq :qa!<CR>
" zy

" zö
" zä
" zü
" zß

nnoremap ++ <C-a>
nnoremap -- <C-x>
nnoremap ü <C-w>
cnoremap ü <C-r>
nnoremap Q @q
nnoremap Y y$
nnoremap W e
nnoremap B ge
nnoremap ; ,
nnoremap , ;
nnoremap U <C-R>
nnoremap äd :cd %:p:h<CR>

inoremap <expr> <ESC> pumvisible() ? "\<C-e>" : "\<ESC>"
inoremap <expr> <SPACE> pumvisible() ? "\<C-y>" : "\<SPACE>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>\<ESC>" : "\<CR>"
inoremap <S-TAB> <C-V><TAB>
inoremap <S-SPACE> <C-X><C-U>

cnoremap <S-SPACE> <C-R><C-A>
cnoremap <C-SPACE> <C-R>"

nnoremap <S-SPACE> i<SPACE><ESC>
nnoremap <S-CR> o<ESC>0D
nnoremap <C-CR> i<CR><ESC>
nnoremap <SPACE> /
nnoremap g<SPACE> *
nnoremap g<CR> :nohl<CR>

" nnoremap g<TAB>
" nnoremap z<TAB>
" nnoremap ö<TAB>
" nnoremap ä<TAB>
" nnoremap ü<TAB> -> ü is used for Ctrl-w
" nnoremap Ctrl-w {   tag jump in split window

nnoremap öm :call Make()<CR>

nnoremap öc :call PanelClose()<CR>
nnoremap <F1> :call PanelClose()<CR>
nnoremap <F2> :call Panel('Buffers')<CR>
nnoremap <F3> :call Panel('Sessions')<CR>
nnoremap <F4> :call Panel('Tags')<CR>
nnoremap <F5> :call Panel('Files')<CR>

" nnoremap <F11> :!ltags -f .tags -R<CR>
nnoremap <F12> :!ctags --langmap=c:.c.h -f .tags -R --tag-relative=yes --extra=+fq --fields=+znimsStK --c-kinds=+lpx --sort=yes<CR>

" Toggles And Cycles
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
" nnoremap +s :call Sign()<CR>
" nnoremap +t
" nnoremap +u
nnoremap +v :call CycleNotation()<CR>
" nnoremap +w
" nnoremap +x
" nnoremap +y
" nnoremap +z
" nnoremap +ä
" nnoremap +ö
" nnoremap +ü
" nnoremap +ß

nnoremap +<TAB> :call CycleTabSpace()<CR>
nnoremap -<TAB> :set expandtab!<CR>:set expandtab?<CR>

"nnoremap -a
nnoremap -b :set ballooneval!<CR>:set ballooneval?<CR>
nnoremap -c :ColorToggle<CR>
"nnoremap -d :NERDTreeToggle<CR>
" nnoremap -e :set expandtab!<CR>:set expandtab?<CR>
nnoremap -f :set fullscreen!<CR>
" nnoremap -g
nnoremap -h :if exists("g:syntax_on") <BAR> syntax off <BAR> else <BAR> syntax on <BAR> endif <CR>
" nnoremap -i
" nnoremap -j
nnoremap -k :if &keywordprg == ":help" <BAR> set keywordprg=man <BAR> echo "keywordprg=man" <BAR> else <BAR> set keywordprg=:help <BAR> echo "keywordprg=:help" <BAR> endif <CR>
nnoremap -l :set list!<CR>:set list?<CR>
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
" nnoremap -ß

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
nnoremap cq :%s///gn<CR>
nnoremap cQ :%s///gn<CR>
" r
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
" vnoremap a
" vnoremap i
" vnoremap m
" vnoremap Q
" vnoremap Z
" some more can be seen as FREE as it's questionable if they are useful
" >>>

" menus <<<

" reduce duplicate lines
nmenu &Utils.Red&DuplLines :%s;^\(.*\)\(\n\1\)\+$;\1;<CR>
vmenu &Utils.Red&DuplLines :s;^\(.*\)\(\n\1\)\+$;\1;<CR>

" delete empty lines
nmenu &Utils.Del&EmptyLines :g/^\s*$/d<CR>
vmenu &Utils.Del&EmptyLines :g/^\s*$/d<CR>

" reduce emtpy lines
nmenu &Utils.&RedEmptyLines :%s;^\(\s*\)\(\n\1\)\+$;\1;<CR>
vmenu &Utils.&RedEmptyLines :s;^\(\s*\)\(\n\1\)\+$;\1;<CR>

" strip
nmenu &Utils.&StripLines :%s;^\s*\(.\{-}\)\s*$;\1;<CR>
vmenu &Utils.&StripLines :s;^\s*\(.\{-}\)\s*$;\1;<CR>

" strip right
nmenu &Utils.StripLines&Right :%s;\s\+$;;<CR>
vmenu &Utils.StripLines&Right :s;\s\+$;;<CR>

" strip left
nmenu &Utils.StripLines&Left :%s;^\s\+;;<CR>
vmenu &Utils.StripLines&Left :s;^\s\+;;<CR>

" reverse lines 
nmenu &Utils.&RevLines :g/^/m0
function! RevSelLines()
   execute 'move'.eval(a:firstline-1)
endfunction
vmenu &Utils.&RevLines :call RevSelLines()<CR>
" vmenu &Utils.&RevLines2 <ESC>:let top=line("'<")-1<CR>:'<,'>:g/^/exec "m".top<CR>

" forward backward slashes
nmenu &Utils.&BackSlash2Slash :%s;\\;/;ge<CR>
nmenu &Utils.&Slash2BackSlash :%s;/;\\;ge<CR>
vmenu &Utils.&BackSlash2Slash :s;\\;/;ge<CR>
vmenu &Utils.&Slash2BackSlash :s;/;\\;ge<CR>

" hex, binary, octal, decimal, ... 
" >>>

