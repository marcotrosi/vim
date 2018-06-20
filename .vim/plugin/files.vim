" h - toggle dot files
" g - toggle non repo-files
" o - open
" d - delete

function! Files() 
   let l:Content = glob("*/", v:true, v:true)
   return [40, l:Content, 1]
endfunction 

function! FilesSetup() 
endfunction 

