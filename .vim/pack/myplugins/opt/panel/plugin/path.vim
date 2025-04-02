" TODO: support dotfiles

" Input Is File    -> /foo/bar/file.txt
"
" GetPath          -> /foo/bar
" GetDir           -> bar
" GetFileName      -> file.txt
" GetFileNameNoExt -> file
" GetFileExt       -> txt
"
" Input Is File w.o. ExT-> /foo/bar/file
"
" GetPath          -> /foo/bar
" GetDir           -> bar
" GetFileName      -> file
" GetFileNameNoExt -> file
" GetFileExt       ->
"
" Input Is Dir     -> /foo/bar/dir
"
" GetPath          -> /foo/bar
" GetDir           -> bar
" GetFileName      ->
" GetFileNameNoExt ->
" GetFileExt       ->
"
" SplitPath        -> alles und die Ordnernamen als Array
"
" ToWin            ->
" ToCyg            ->
" ToMix            ->
"
" IsWin            ->
" IsCyg            ->
" IsMix            ->
"
" IsDir            ->
" IsFile           ->

function! GetPath(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   let l:FileName = substitute(l:FileName, '\(.*\)/.*', '\1', '')
   return l:FileName
endfunction

" echo GetPath('C:/super/foo/bar.txt') ' == C:/super/foo'
" echo GetPath('super/foo/bar.txt') ' == super/foo'
" echo GetPath('/super/foo/bar.txt') ' == /super/foo'
" echo GetPath('foo/bar.txt') ' == foo'
" echo GetPath('foo/bar') ' == foo'
" echo GetPath('./foo') ' == .'
" echo GetPath('foo') ' == '    TODO

" >>>

function! GetFileName(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   let l:FileName = substitute(l:FileName, '.*/', '', '')
   let l:FileName = substitute(l:FileName, '\(.*\)\..*', '\1', '')
   return l:FileName
endfunction

" echo GetFileName('C:/super/foo/bar.txt') ' == bar'
" echo GetFileName('super/foo/bar.txt') ' == bar'
" echo GetFileName('/super/foo/bar.txt') ' == bar'
" echo GetFileName('foo/bar.txt') ' == bar'
" echo GetFileName('foo/bar') ' == bar'
" echo GetFileName('./foo') ' == foo'
" echo GetFileName('foo') ' == foo'

" >>>

function! GetFileNameExt(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   let l:FileName = substitute(l:FileName, '.*/', '', '')
   return l:FileName
endfunction

" echo GetFileNameExt('C:/super/foo/bar.txt') ' == bar.txt'
" echo GetFileNameExt('super/foo/bar.txt') ' == bar.txt'
" echo GetFileNameExt('/super/foo/bar.txt') ' == bar.txt'
" echo GetFileNameExt('foo/bar.txt') ' == bar.txt'
" echo GetFileNameExt('foo/bar') ' == bar'
" echo GetFileNameExt('./foo.txt') ' == foo.txt'
" echo GetFileNameExt('foo.txt') ' == foo.txt'
" echo GetFileNameExt('./foo') ' == foo'
" echo GetFileNameExt('foo') ' == foo'

" >>>

function! GetFileExt(str) " <<<
   let l:FileName = substitute(a:str, '.*\.', '', '')
   return l:FileName
endfunction

" echo GetFileExt('C:/super/foo/bar.txt') ' == txt'
" echo GetFileExt('super/foo/bar.txt') ' == txt'
" echo GetFileExt('/super/foo/bar.txt') ' == txt'
" echo GetFileExt('foo/bar.txt') ' == txt'
" echo GetFileExt('foo/bar') ' == ""' " TODO
" echo GetFileExt('./foo.txt') ' == txt'
" echo GetFileExt('foo.txt') ' == txt'
" echo GetFileExt('./foo') ' == ""' " TODO
" echo GetFileExt('foo') ' == ""' " TODO

" >>>

function! Slash(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   if l:FileName[-1:-1] == '/'
      return l:FileName
   else
      return l:FileName.'/'
   endif
endfunction
" >>>

function! NoSlash(str) " <<<
   let l:FileName = substitute(a:str, '\\', '/', 'g')
   if l:FileName[-1:-1] == '/'
      return l:FileName[0:-2]
   else
      return l:FileName
   endif
endfunction
" >>>

