"/Users/marcotrosi/.vim/plugin/files.vim
"/Users/marcotrosi/.vim/plugin/tags.vim
"/Users/marcotrosi/.vim/plugin/sessions.vim
"/Users/marcotrosi/.vim/plugin/buffers.vim

" Things to consider when using this file
" 1. provide a function that fills the panel with content and a second function with the same name in the beginning and
"    ending with Setup. MyPanel() + MyPanelSetup(). Look at buffers.vim, sessions.vim, tags.vim, files.vim for more information.
" 2. The main function (e.g. MyPanel()) has to return a list containing [PanelWidth, PanelContentAsString, LineNumberToPutCursorOn].

if exists('PanelLoaded')
   finish
endif
let PanelLoaded = 1

let s:Panel = "Files" " init value in case PanelToggle is called first

function! PanelClose() " <<<
   silent! bwipeout! __PANEL__
endfunction " >>>

function! Panel(tool) " <<<

   let l:PanelWinNum = bufwinnr("__PANEL__")

   "no __PANEL__ buffer open
   if l:PanelWinNum == -1

      let s:Panel = a:tool

      if exists('*'.s:Panel.'Init')
         exec 'call '.s:Panel.'Init()'
      endif

      exec 'let l:Data='.s:Panel.'()'

      exec 'silent! ' . l:Data[0] . 'vnew __PANEL__'
   
      setlocal modifiable

      put! =l:Data[1]

      $d_

      call cursor(l:Data[2], 1)

      setlocal noshowcmd
      setlocal buftype=nofile
      setlocal bufhidden=wipe
      setlocal noswapfile
      setlocal nowrap
      setlocal nobuflisted
      setlocal nonumber
      setlocal nospell
      setlocal statusline=
      " setlocal noruler
      " setlocal laststatus=0
      setlocal nomodifiable

      " if exists('*'.s:Panel.'Setup')
      exec 'call '.s:Panel.'Setup()'
      " endif

      nnoremap <buffer> <silent> q :bwipeout!<CR>

   else
      " __PANEL__ buffer already open
      " let's check for which tool
      if s:Panel != a:tool
         " switch to new tool
         bwipeout! __PANEL__
         call Panel(a:tool)

      else
         " same tool
         " we close the __PANEL__ buffer if the focus is already on that buffer
         if bufname("%") == "__PANEL__"
            bwipeout! __PANEL__
         else
            " or we select the __PANEL__ buffer
            exec l:PanelWinNum . 'wincmd w'
         endif
      endif
   endif
endfunction " >>>

function! PanelUpdate() " <<<
   exec 'let l:Data='.s:Panel.'()'
   exec 'vertical resize ' . l:Data[0]
   setlocal modifiable
   %d
   put! =l:Data[1]
   $d_
   setlocal nomodifiable
   call cursor(l:Data[2], 1)
endfunction " >>>
