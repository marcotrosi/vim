" git status     -> git status --porcelain
" git branch     -> git for-each-ref --format='%(refname:short)' refs/heads/
" git branch -a  -> git for-each-ref --format='%(refname:short)' refs/heads/ refs/remotes/
"                -> git for-each-ref --format='%(if)%(HEAD)%(then)* %(else)  %(end)%(refname:short)' refs/heads/ refs/remotes/
" current branch -> git symbolic-ref --short HEAD
" git log        -> git log --pretty=tformat:"%h %cs%d %s"

let s:GitStatus          = []
let s:GitStatusDisplayed = []
let s:GitLog             = []
let s:GitLogDisplayed    = []
let s:GitBranch          = []
let s:GitBranchDisplayed = []
let s:CurrentView        = 1 "1=status, 2=log, 3=branch
let s:GitLogCmd          = 'git log --pretty=tformat:"%h %cs%d %s"'
let s:GitStatusCmd       = 'git status --porcelain'
let s:GitBranchCmd       = 'git for-each-ref --format="%(refname:short)" refs/heads/ refs/remotes/'

function! Git() " <<<

   let l:MaxPanelWidth     = 60
   let l:MinPanelWidth     = 20
   let l:LongestLineLength = 20

   if s:CurrentView == 1 " status <<<
      " clean lists
      call filter(s:GitStatus         , 0)
      call filter(s:GitStatusDisplayed, 0)

      let l:Output = systemlist(s:GitStatusCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitStatusDisplayed, l:line)
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitStatusDisplayed, 1]
   end " >>>

   if s:CurrentView == 2 " log <<<
      " clean lists
      call filter(s:GitLog         , 0)
      call filter(s:GitLogDisplayed, 0)

      let l:Output = systemlist(s:GitLogCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitLogDisplayed, l:line)
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitLogDisplayed, 1]
   end " >>>

   if s:CurrentView == 3 " branch <<<
      " clean lists
      call filter(s:GitBranch         , 0)
      call filter(s:GitBranchDisplayed, 0)

      let l:Output = systemlist(s:GitBranchCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitBranchDisplayed, l:line)
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitBranchDisplayed, 1]
   end " >>>
endfunction " >>>

function! GitSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ GIT

   map <silent> <nowait> <buffer> S :call GitStatus()<CR>
   map <silent> <nowait> <buffer> L :call GitLog()<CR>
   map <silent> <nowait> <buffer> B :call GitBranch()<CR>
   map <silent> <nowait> <buffer> o :call GitOpen()<CR>
endfunction " >>>

function! GitStatus() " <<<
   let s:CurrentView = 1
   call PanelUpdate()
endfunction " >>>

function! GitLog() " <<<
   let s:CurrentView = 2
   call PanelUpdate()
endfunction " >>>

function! GitBranch() " <<<
   let s:CurrentView = 3
   call PanelUpdate()
endfunction " >>>

function! GitOpen() " <<<
endfunction " >>>

" --------------------------
