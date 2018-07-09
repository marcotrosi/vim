let s:ShowDotFiles=v:false
let s:OpenDirs=[]
let s:DotIgnore=['.', '..', '.DS_Store']
let s:ListOfPaths=[]
let s:GitHighlighting = v:false

function! Files()  " <<<

   let l:Content = []
   call filter(s:ListOfPaths, 0)
   call s:GetDirContent(l:Content, s:TopDir, 0)

   " !!! EXPERIMENTAL !!!
   " !!! to keep it simple I will abort in case of unexpected situations !!!
   if s:GitHighlighting && isdirectory('.git')

      let l:Messages     = []
      let l:GitStatusCmd = 'git status --porcelain=v1 -u --ignored'
      let l:GitStatus    = systemlist(l:GitStatusCmd)

      for item in l:GitStatus
         " https://git-scm.com/docs/git-status
         " let l:XWorkTree = item[0:0]
         " let l:YIndex    = item[1:1]
         let l:Info = item[0:1]
         let l:Info = substitute(l:Info, "\s", "", "g")

         let l:StartOfArrow = match(item, " -> ", 3)

         if l:StartOfArrow == -1
            let l:File = item[3:-1]
         else
            let l:File = item[l:StartOfArror+4:-1]
         endif

         " if     l:Info == ''   " unmodified
            " do nothing
         if     l:Info == 'M'  " modified
         elseif l:Info == 'A'  " added
         elseif l:Info == 'D'  " deleted
            call add(l:Messages, "files.vim warning: D (deleted) not yet implemented")
         elseif l:Info == 'R'  " renamed
            call add(l:Messages, "files.vim warning: R (renamed) not yet implemented")
         elseif l:Info == 'C'  " copied
            call add(l:Messages, "files.vim warning: C (copied) not yet implemented")
         elseif l:Info == 'U'  " updated but unmerged         
            call add(l:Messages, "files.vim warning: U (updated) not yet implemented")
         elseif l:Info == '??' " untracked
         elseif l:Info == '!!' " ignored
         else
            call add(l:Messages, "files.vim warning: unexpected situation (".l:Info.")")
         endif
            " for obj in s:ListOfPaths
            "    if !obj.isdir
            "       if obj.rpath == l:File
            "          call matchaddpos("ErrorMsg", [obj.idx+1])
            "       endif
            "    endif
            " endfor
      endfor

      echo l:Messages
   endif

   return [40, l:Content, 1]
endfunction  " >>>

function! FilesInit() " <<<
   let s:TopDir=Slash(getcwd())
endfunction " >>>

function! FilesSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ FILES
   map <silent> <nowait> <buffer> a :call AllFiles()<CR>
   map <silent> <nowait> <buffer> o :call FileOpen()<CR>
   map <silent> <nowait> <buffer> e :call FileEdit()<CR>
   " map <silent> <nowait> <buffer> e :call ExpandDirs()<CR>
   map <silent> <nowait> <buffer> f :call FoldDirs()<CR>
   map <silent> <nowait> <buffer> u :call DirUp()<CR>
   map <silent> <nowait> <buffer> w :call WorkingDir()<CR>
   " map <silent> <nowait> <buffer> t :call CreateFile()<CR>
   " map <silent> <nowait> <buffer> m :call CreateDir()<CR>
   " map <silent> <nowait> <buffer> d :call Delete()<CR>
   " map <silent> <nowait> <buffer> r :call Rename()<CR>
   " g - toggle non repo-files
   " show changed/missing files
   " show untracked files
   " diff files
endfunction " >>>

function! AllFiles() " <<<
   let s:ShowDotFiles=!s:ShowDotFiles
   call PanelUpdate()
endfunction " >>>

function! FileOpen() " <<<
   let l:idx = line('.')-1
   let l:Object = s:ListOfPaths[l:idx]
   if l:Object.isdir
      if l:Object.isopen
         call remove(s:OpenDirs, index(s:OpenDirs, l:Object.path))
      else
         call add(s:OpenDirs, l:Object.path)
      endif
      call PanelUpdate()
      call cursor(l:idx+1, 1)
   else
      let l:PanelWinNum = winnr() " get win number of __PANEL__
      wincmd p " go back to the window from which __PANEL__ was opened
      exec ':e ' . l:Object.path
      exec l:PanelWinNum . 'wincmd w'
   endif
endfunction " >>>

function! FileEdit() " <<<
   let l:Object = s:ListOfPaths[line('.')-1]
   if !l:Object.isdir
      silent! bwipeout! __PANEL__
      exec ':e ' . l:Object.path
   endif
endfunction " >>>

function! ExpandDirs() " <<<
   " NON RECURSIVE !!!
   for directory in globpath(s:TopDir, "*/", v:false, v:true)
      if index(s:OpenDirs, directory) == -1
         call insert(s:OpenDirs, directory)
      end
   endfor
   call PanelUpdate()
endfunction " >>>

function! FoldDirs() " <<<
   call filter(s:OpenDirs, 0)
   call PanelUpdate()
endfunction " >>>

function! DirUp() " <<<
   if s:TopDir != '/'
      let s:TopDir = Slash('/'.join(split(s:TopDir, '/')[0:-2], '/')) " TODO think about making a function in path.vim
      call PanelUpdate()
   endif
endfunction " >>>

function! WorkingDir() " <<<
   let l:idx = line('.')-1
   let l:Object = s:ListOfPaths[l:idx]
   exec ':cd ' . l:Object.dir
   let s:TopDir = l:Object.dir
   call PanelUpdate()
endfunction " >>>

function! s:GetDirContent(lst,dir,lvl) " <<<

   if a:lvl == 0
      call add(a:lst, ' ./')
      call add(s:ListOfPaths, {'path':a:dir, 'rpath':'./', 'isdir': v:true, 'isopen': v:true, 'dir':a:dir, 'idx':len(s:ListOfPaths)})
      call insert(s:OpenDirs, a:dir)
   endif

   for directory in globpath(a:dir, "*/", v:false, v:true)
      if index(s:OpenDirs, directory) != -1
         call add(a:lst, repeat('  ', a:lvl).' ▼ ' . split(directory, '/')[-1])
         call add(s:ListOfPaths, {'path':directory, 'rpath':substitute(directory, Slash(getcwd()), '', ''), 'isdir': v:true, 'isopen': v:true, 'dir':directory, 'idx':len(s:ListOfPaths)})
         call s:GetDirContent(a:lst, directory, a:lvl + 1)
      else
         call add(a:lst, repeat('  ', a:lvl).' ▶︎ ' . split(directory, '/')[-1])
         call add(s:ListOfPaths, {'path':directory, 'rpath':substitute(directory, Slash(getcwd()), '', ''), 'isdir': v:true, 'isopen': v:false, 'dir':directory, 'idx':len(s:ListOfPaths)})
      endif
   endfor

   for filename in globpath(a:dir, "*", v:false, v:true)
      if isdirectory(filename) == 0
         call add(a:lst, repeat('  ', a:lvl).'   ' . substitute(filename, '.*/', '', ''))
         call add(s:ListOfPaths, {'path':filename, 'rpath':substitute(filename, Slash(getcwd()), '', ''), 'isdir': v:false, 'dir':a:dir, 'idx':len(s:ListOfPaths)})
      endif
   endfor

   if s:ShowDotFiles
      for dotfile in globpath(a:dir, ".*" , v:false, v:true)
         if index(s:DotIgnore, substitute(dotfile, '.*/', '', '')) == -1
            call add(a:lst, repeat('  ', a:lvl).'   ' . substitute(dotfile, '.*/', '', ''))
            call add(s:ListOfPaths, {'path':filename, 'rpath':substitute(dotfile, Slash(getcwd()), '', ''), 'isdir': v:false, 'dir':a:dir, 'idx':len(s:ListOfPaths)})
         endif
      endfor
   endif
endfunction " >>>
