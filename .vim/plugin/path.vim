" TODO: support dotfiles

function! GetFilePath(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   let l:FileName = substitute(l:FileName, '\(.*\)/.*', '\1', '')
   return l:FileName
endfunction " >>>

function! GetFileName(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   let l:FileName = substitute(l:FileName, '.*/', '', '')
   let l:FileName = substitute(l:FileName, '\(.*\)\..*', '\1', '')
   return l:FileName
endfunction " >>>

function! GetFileNameExt(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   let l:FileName = substitute(l:FileName, '.*/', '', '')
   return l:FileName
endfunction " >>>

function! GetFileExt(str) " <<<
   let l:FileName = substitute(a:str, '.*\.', '', '')
   return l:FileName
endfunction " >>>

function! Slash(str)
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   if l:FileName[-1:-1] == '/'
      return l:FileName
   else
      return l:FileName.'/'
   endif
endfunction

" function! NoSlash(str)
"    let l:FileName = substitute(a:str, '\\', '/', 'g')
"    if l:FileName[-1:-1] == '/'
"       return l:FileName[0:-2]
"    else
"       return l:FileName
"    endif
" endfunction
