let s:red="#FB4934"
let s:grn="#B8BB26"
let s:blu="#458588"
let s:lit="#EBDBB2"
let s:drk="#282828"

exe "hi RVNrm guifg=" . s:lit . " guibg=" . s:drk
exe "hi RVRed guifg=" . s:red . " guibg=" . s:drk
exe "hi RVGrn guifg=" . s:grn . " guibg=" . s:drk
exe "hi RVBlu guifg=" . s:blu . " guibg=" . s:drk

sign define noreview text=! texthl=RVNrm
sign define declined text=× texthl=RVRed
sign define accepted text=✔ texthl=RVGrn
sign define question text=i texthl=RVBlu


" sign place 1 line=10 name=declined file=myfile.c

" Review modus starten
" ReviewDaten laden

function! WriteData(data, filename) abort " <<<
    let serialized = string(a:data)
    call writefile([serialized], a:filename)
endfun " >>>

function! ReadData(filename) abort " <<<
    let serialized = readfile(a:filename)[0]
    execute "let result = " . serialized
    return result
endfun " >>>

function! LoadReview() abort " <<<
   sign unplace *
   let s:Data = ReadData('review.dat')
   for [filename, entries] in items(s:Data.review)
      let l:SignID = 0
      for entry in entries
         let l:SignID = l:SignID + 1
         execute 'sign place ' . l:SignID . ' line=' . entry.line . ' name=' . entry.state .' file=' . filename
         " call SerializeData(entry.comment, "comment.prv")
      endfor
   endfor
   " pedit comment.prv
endfunction " >>>

function! Review() abort " <<<
endfunction " >>>

function! EndReview() abort " <<<
endfunction " >>>

function! CommentLine() abort " <<<
endfunction " >>>

function! AcceptLine() abort " <<<
endfunction " >>>

function! DeclineLine() abort " <<<
endfunction " >>>

function! QuestionLine() abort " <<<
endfunction " >>>

function! RemoveFeedback() abort " <<<
endfunction " >>>

function! RemoveAllFeedback() abort " <<<
endfunction " >>>
