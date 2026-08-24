" git status     -> git status --porcelain
" git branch     -> git for-each-ref --format='%(refname:short)' refs/heads/
" git branch -a  -> git for-each-ref --format='%(refname:short)' refs/heads/ refs/remotes/
"                -> git for-each-ref --format='%(if)%(HEAD)%(then)* %(else)  %(end)%(refname:short)' refs/heads/ refs/remotes/
" current branch -> git symbolic-ref --short HEAD
" git log        -> git log --pretty=tformat:"%h %cs%d %s"

let g:PanelStatusLine    = ""
let g:GitBranchName      = ""
let g:GitStatus          = ""
let g:GitRepoCache       = {}
let s:GitStatusDisplayed = []
let s:GitLogDisplayed    = []
let s:GitBranchDisplayed = []
let s:CurrentView        = 1 "1=status, 2=log, 3=branch
let s:GitLogCmd          = 'git log --pretty=tformat:"%h %cs%d %s" "@{upstream}"'
let s:GitStatusCmd       = 'git status --porcelain'
let s:GitBranchCmd       = 'git for-each-ref --format="%(refname:short)" refs/heads/ refs/remotes/'

function! Git() " <<<

   let l:MaxPanelWidth     = 60
   let l:MinPanelWidth     = 20
   let l:LongestLineLength = 20

   " let g:PanelStatusLine = "[S]tatus [L]og [B]ranch"

   if s:CurrentView == 1 " status <<<
      " clean lists
      call filter(s:GitStatusDisplayed, 0)

      let l:Output = systemlist(s:GitStatusCmd)

      if len(l:Output) == 0
         call add(s:GitStatusDisplayed, "all up-to-date")
      else
         for line in l:Output
            let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
            call add(s:GitStatusDisplayed, l:line)
         endfor
      endif

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitStatusDisplayed, 1]
   end " >>>

   if s:CurrentView == 2 " log <<<
      " clean lists
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
   " map <silent> <nowait> <buffer> o :call GitOpen()<CR>
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

" function! GitOpen() " <<<
" endfunction " >>>

" git functions <<<
function! IsGitRepo() " <<<
   let l:cwd = getcwd()
   if !has_key(g:GitRepoCache, l:cwd)
      silent call system('git rev-parse --is-inside-work-tree')
      let g:GitRepoCache[l:cwd] = (v:shell_error == 0)
   endif
   return g:GitRepoCache[l:cwd]
endfunction " >>>

function! GitGetBranch() " <<<
   " system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
   " trim(system("git branch --show-current"))
   silent let l:BranchName = trim(system("git symbolic-ref --short HEAD"))
   if v:shell_error == 0
      let g:GitBranchName = l:BranchName
   else
      let g:GitBranchName = ""
   end
endfunction
" >>>

function! GitParseStatus(lines) " <<<

   let l:Staged    = 0
   let l:Modified  = 0
   let l:Untracked = 0
   let l:Conflicts = 0

   for line in a:lines
      let l:X = line[0:0] " Index
      let l:Y = line[1:1] " Worktree

      if l:X == '?' && l:Y == '?'
         let l:Untracked += 1
      elseif l:X == 'U' || l:Y == 'U'
         let l:Conflicts += 1
      else
         if l:X != '.' && l:X != ' '
            let l:Staged += 1
         endif
         if l:Y != '.' && l:Y != ' '
            let l:Modified += 1
         endif
      endif
   endfor

   let l:Parts = []

   if l:Conflicts | call add(l:Parts, l:Conflicts .. '!') | endif
   if l:Staged    | call add(l:Parts, l:Staged    .. '+') | endif
   if l:Modified  | call add(l:Parts, l:Modified  .. '∆') | endif
   if l:Untracked | call add(l:Parts, l:Untracked .. '?') | endif

   return len(l:Parts) ? join(l:Parts, ' ') : '✓'

endfunction " >>>

function! OnGitStatusOutput(channel, msg) " <<<
   if !exists('g:GitStatusBuffer')
      let g:GitStatusBuffer = []
   endif
   call add(g:GitStatusBuffer, a:msg)
endfunction " >>>

function! OnGitStatusExit(job, exitcode) " <<<
   if a:exitcode != 0
      let g:GitStatus = ""
   else
      let g:GitStatus = GitParseStatus(get(g:, 'GitStatusBuffer', []))
   endif
   let g:GitStatusBuffer = []
   redrawstatus
endfunction " >>>

function! GitGetStatus() " <<<
   if exists('g:GitStatusJob') && job_status(g:GitStatusJob) == 'run'
      return
   endif

   let g:GitStatus = "▓"
   let g:GitStatusJob = job_start(['git', 'status', '--porcelain'], {
      \ 'out_cb': function('OnGitStatusOutput'),
      \ 'exit_cb': function('OnGitStatusExit'),
      \ 'out_mode': 'nl',
      \ })
endfunction " >>>

function! GitUpdateInfo()
   if !IsGitRepo()
      let g:GitStatus     = ""
      let g:GitBranchName = ""
      return
   endif

   call GitGetBranch()
   call GitGetStatus()
endfunction

augroup Git
   autocmd!
   autocmd VimEnter * call timer_start(0, {-> GitUpdateInfo()})
   autocmd DirChanged,BufWritePost,FocusGained * call GitUpdateInfo()
augroup END

" >>>
