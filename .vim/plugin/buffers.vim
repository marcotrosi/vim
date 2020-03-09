let s:ListOfBuffers          = [] " linenumber as index; buffernumbers and unchanged buffernames as values
let s:ListOfDisplayedBuffers = [] " linenumber as index; modified buffernames as displayed

function! Buffers() " <<<

   let l:MaxPanelWidth         = 40
   let l:NumOfBuffers          = bufnr('$')
   let l:LineNumOfActiveBuffer = 0
   let l:NumOfDisplayedBuffers = 0
   let l:LongestNameLength     = 20

   " clean lists
   call filter(s:ListOfBuffers         , 0)
   call filter(s:ListOfDisplayedBuffers, 0)

   let l:i = 0 | while l:i <= l:NumOfBuffers | let l:i = l:i + 1

      let l:BufferName = bufname(l:i)

      if strlen(l:BufferName)
      \&& getbufvar(l:i, '&modifiable')
      \&& getbufvar(l:i, '&buflisted')

         call add(s:ListOfBuffers, {'bufname': l:BufferName, 'bufnumber': l:i})

         let l:NumOfDisplayedBuffers = l:NumOfDisplayedBuffers + 1

         if bufwinnr(l:i) != -1
            let l:BufferName            = l:BufferName . '*'
            let l:LineNumOfActiveBuffer = l:NumOfDisplayedBuffers
         else
            let l:BufferName = l:BufferName . ' '
         endif

         if getbufvar(l:i, '&modified')
            let l:BufferName = ' ' . l:BufferName . '+'
         else
            let l:BufferName = ' ' . l:BufferName . ' '
         endif

         let l:AdjustedBufferName = s:AdjustBufferName(l:BufferName, l:MaxPanelWidth)
         let l:LongestNameLength  = max([l:LongestNameLength, strlen(l:AdjustedBufferName)])
         call add(s:ListOfDisplayedBuffers, l:AdjustedBufferName)
      endif
   endwhile

   return [min([l:MaxPanelWidth, l:LongestNameLength]), s:ListOfDisplayedBuffers, l:LineNumOfActiveBuffer]
endfunction " >>>

function! BuffersSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ BUFFERS
   map <silent> <nowait> <buffer> o :call BufferOpen()<CR>
   map <silent> <nowait> <buffer> <CR> :call BufferOpen()<CR>
   map <silent> <nowait> <buffer> d :call BufferDelete()<CR>
   map <silent> <nowait> <buffer> + :call BufferInc()<CR>
   map <silent> <nowait> <buffer> - :call BufferDec()<CR>
endfunction " >>>

function! BufferOpen() " <<<
   " echo s:ListOfBuffers[line('.')-1].bufname s:ListOfBuffers[line('.')-1].bufnumber
   " get buffer number; unfortunately index starts at zero
   let l:num = s:ListOfBuffers[line('.')-1].bufnumber
   " close __PANEL__
   bwipeout
   " open buffer
   exec ':b ' . l:num
endfunction " >>>

function! BufferDelete() " <<<
   " echo s:ListOfBuffers[line('.')-1].bufname s:ListOfBuffers[line('.')-1].bufnumber
   " get index; unfortunately index starts at zero
   let l:idx = line('.')-1
   " get buffer number
   let l:num = s:ListOfBuffers[l:idx].bufnumber
   " delete buffer
   exec ':bd ' . l:num
   call remove(s:ListOfBuffers, l:idx)
   call remove(s:ListOfDisplayedBuffers, l:idx)
   set modifiable
   .d_
   set nomodifiable
endfunction " >>>

function! s:AdjustBufferName(str, width) " <<<
   if strlen(a:str) > a:width
      return ' …'.strpart(a:str, strlen(a:str) - a:width + 2)
   " elseif strlen(a:str) < a:width
   "    exec 'return printf("%'.a:width.'s", a:str)'
   else
      return a:str
   end
endfunction " >>>

" TODO: use PanelUpdate and maybe pass desired size to Buffers(45)
function! BufferInc() " <<<
   vertical resize +5
   " set modifiable
   " set nomodifiable
endfunction " >>>

function! BufferDec() " <<<
   vertical resize -5
   " set modifiable
   " set nomodifiable
endfunction " >>>
