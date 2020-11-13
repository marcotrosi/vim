" variables <<<
let s:ReviewFile = '.review'
let s:CommentFile = '.comment'
let s:SignID = 1
" >>>

" functions <<<
function! WriteComment(comment, filename) abort " <<<
   call writefile(a:comment, a:filename)
endfun " >>>

function! WriteData(data, filename) abort " <<<
   let serialized = string(a:data)
   call writefile([serialized], a:filename)
endfun " >>>

function! ReadData(filename) abort " <<<
   let serialized = readfile(a:filename)[0]
   execute "let result = " . serialized
   return result
endfun " >>>

function! CreateReviewFile() abort " <<<
   let l:FileLines = ["{'review':{}}"]
   call writefile(l:FileLines, s:ReviewFile)
endfunction " >>>

function! StartReview() abort " <<<

   if ! filereadable(s:ReviewFile)
      call CreateReviewFile()
   endif

   let s:Data = ReadData(s:ReviewFile)

   " colors and signs <<<
   let s:red="#FB4934"
   let s:grn="#B8BB26"
   let s:blu="#458588"
   let s:ylw="#FABD2F"
   let s:lit="#EBDBB2"
   let s:drk="#282828"

   exe "hi RVNrm guifg=" . s:lit . " guibg=" . s:drk
   exe "hi RVRed guifg=" . s:red . " guibg=" . s:drk
   exe "hi RVGrn guifg=" . s:grn . " guibg=" . s:drk
   exe "hi RVBlu guifg=" . s:blu . " guibg=" . s:drk
   exe "hi RVYlw guifg=" . s:ylw . " guibg=" . s:drk
   exe "hi SignColumn guifg=" . s:lit . " guibg=" . s:drk

   sign define noreview text=\  texthl=RVNrm
   sign define modified text=!  texthl=RVYlw
   sign define declined text=×  texthl=RVRed
   sign define accepted text=✔  texthl=RVGrn
   sign define question text=?  texthl=RVBlu
   " >>>

   augroup REVIEW
      autocmd! REVIEW
      autocmd BufEnter * call SetSigns()
      autocmd BufEnter * set readonly
      autocmd BufLeave * set noreadonly
      " autocmd CursorHold * ++nested call ViewComment()
      autocmd CursorHold * call ViewComment()
   augroup END

   call TurnOnMappings()
   nnoremap <nowait> <space>x :call SaveComment()<CR>
   let s:UsersStatusLine = &statusline
   let s:UsersUpdateTime = &updatetime
   set statusline=[a]ccept\ [d]ecline\ [q]uestion\ [r]emove\ [c]omment\ [e]nd
   set updatetime=200
   call SetSigns()
endfunction " >>>

function! EndReview() abort " <<<
   call WriteData(s:Data, s:ReviewFile)
   call delete(s:CommentFile)
   pclose
   sign unplace *
   autocmd! REVIEW
   call TurnOffMappings()
   let &statusline=s:UsersStatusLine
   let &updatetime=s:UsersUpdateTime
   set noreadonly
endfunction " >>>

function! GetEntry(FileName, LineNum) abort " <<<
   let l:FileName = a:FileName
   let l:LineNum = a:LineNum
   if has_key(s:Data.review, l:FileName) == 0
      let s:Data.review[l:FileName] = []
   endif
   " let l:FileData = get(s:Data.review, l:FileName, [])
   let l:FileData = s:Data.review[l:FileName]
   for entry in l:FileData
      if l:LineNum == entry["line"]
         return entry
      endif
   endfor
   call add(l:FileData, {'line':string(l:LineNum), 'state' : 'noreview', 'comment' : [], 'signid':s:SignID})
   return l:FileData[-1]
endfunction " >>>

function! GetComment() abort " <<<
   let l:FileName = expand("%")
   let l:LineNum = line('.')
   " let l:FileData = get(s:Data.review, l:FileName, [])
   let l:Entry = GetEntry(l:FileName, l:LineNum)
   return l:Entry['comment']
   " for entry in l:FileData
   "    if l:LineNum == entry["line"]
   "       return entry['comment']
   "    endif
   " endfor
   " return []
endfunction " >>>

function! SetSigns() abort " <<<
   if &previewwindow
      return
   endif
   let l:FileName = expand("%")
   execute 'sign unplace * file=' .. l:FileName
   let s:SignID = 1
   let l:FileData = get(s:Data.review, l:FileName, [])
   for entry in l:FileData
      execute 'sign place ' .. s:SignID .. ' line=' .. entry.line .. ' name=' .. entry.state .. ' file=' .. l:FileName
      let entry["signid"] = string(s:SignID)
      let s:SignID = s:SignID + 1
   endfor
endfunction " >>>

function! SetStatus(state) abort " <<<
   let l:State = a:state
   let l:FileName = expand("%")
   let l:LineNum = line('.')
   let l:Entry = GetEntry(l:FileName, l:LineNum)
   let l:SignID = l:Entry["signid"]
   let l:Entry["state"] = l:State
   execute 'sign place ' . l:SignID . ' line=' . l:LineNum . ' name=' . l:State . ' file=' . l:FileName
endfunction " >>>

function! ViewComment() abort " <<<
   if &previewwindow
      return
   endif
   let l:Comment = GetComment()
   call WriteComment(l:Comment, s:CommentFile)
   " silent! pedit! +res5|setlocal\ nobuflisted\ noswapfile\ nonumber\ filetype=markdown\ statusline=<space>x|let\ s:PWinID=win_getid() s:CommentFile
   silent! pedit! +res5|setlocal\ nobuflisted\ noswapfile\ nonumber\ filetype=markdown\ statusline=<space>x|let\ s:PWinID=win_getid() .comment
endfunction " >>>

function! TurnOnMappings() abort  " <<<
   nnoremap <nowait> a :call SetStatus("accepted")<CR>
   nnoremap <nowait> d :call SetStatus("declined")<CR>
   nnoremap <nowait> q :call SetStatus("question")<CR>
   nnoremap <nowait> r :call SetStatus("noreview")<CR>
   nnoremap <nowait> c :call CommentLine()<CR>
   nnoremap <nowait> e :call EndReview()<CR>
   " nnoremap <nowait> x :call SaveComment()<CR>
endfunction " >>>

function! TurnOffMappings() abort  " <<<
   silent! unmap a
   silent! unmap d
   silent! unmap q
   silent! unmap r
   silent! unmap c
   silent! unmap e
   " silent! unmap x
endfunction " >>>

function! CommentLine() abort " <<<
   let s:FileName = expand("%")
   let s:LineNum = line('.')
   let l:Entry = GetEntry(s:FileName, s:LineNum)
   let s:FWinID=win_getid()
   call win_gotoid(s:PWinID)
   call TurnOffMappings()
   set noreadonly
endfunction " >>>

function! SaveComment() abort " <<<
   if &previewwindow == 0
      return
   endif
   let l:Comment = getline(1, '$')
   let l:Entry = GetEntry(s:FileName, s:LineNum)
   let l:Entry["comment"] = l:Comment
   set readonly
   call win_gotoid(s:FWinID)
   call TurnOnMappings()
endfunction " >>>

function! RemoveFeedback() abort " <<<
endfunction " >>>

function! RemoveAllFeedback() abort " <<<
endfunction " >>>
" >>>

" commands <<<
command! Review call StartReview()
" >>>

" vim: fmr=<<<,>>> fdm=marker
