" git status     -> git status --porcelain
" git branch     -> git for-each-ref --format='%(refname:short)' refs/heads/
" git branch -a  -> git for-each-ref --format='%(refname:short)' refs/heads/ refs/remotes/
"                -> git for-each-ref --format='%(if)%(HEAD)%(then)* %(else)  %(end)%(refname:short)' refs/heads/ refs/remotes/
" current branch -> git symbolic-ref --short HEAD
" git log        -> git log --pretty=tformat:"%h %cs%d %s"
" git remote     -> git config --get-regexp '^remote\..*\.url$'
" git tag        -> git for-each-ref --format='%(refname:short) %(objecttype)' refs/tags/

const s:VIEW_STATUS = 1
const s:VIEW_LOG    = 2
const s:VIEW_BRANCH = 3
const s:VIEW_TAG    = 4
const s:VIEW_REMOTE = 5
let   s:CurrentView = s:VIEW_STATUS

let g:PanelStatusLine     = ""
let g:GitBranchName       = ""
let g:GitStatus           = ""
let g:GitRepoCache        = {}
let s:GitLines            = []
let s:GitLinesDisplayed   = []
const s:GitLogCmd           = 'git log --pretty=tformat:"%H %h %cs%d %s" "@{upstream}"'
const s:GitStatusCmd        = 'git status --porcelain'
const s:GitBranchCmd        = 'git for-each-ref --format="%(refname:short)" refs/heads/ refs/remotes/'
const s:GitRemoteCmd        = 'git config --get-regexp "^remote\..*\.url$"'
const s:GitTagCmd           = 'git for-each-ref --format="%(refname:short) %(objecttype)" refs/tags/'
const s:GitIsRepoCmd        = 'git rev-parse --is-inside-work-tree'
const s:GitGetBranchCmd     = 'git symbolic-ref --short HEAD'
const s:GitGetCommitInfoCmd = 'git log -1 --pretty=tformat:"%s" %s'
const s:ShowCommitInfoFormat= "%nrefs:    %D%ncommit:  %H%nparents: %P%n%nauthor name:   %an%nauthor e-mail: %ae%nauthor date:   %ad%n%ncommitter name:   %cn%ncommitter e-mail: %ce%ncommitter date:   %cd%n%nsubject: %s%n%nbody: %w(100,0,6)%b"

function! Git() " <<<

   let l:MaxPanelWidth     = 60
   let l:MinPanelWidth     = 20
   let l:LongestLineLength = 20
   let l:ToolStatusLine    = "[S]tatus [L]og [B]ranch [T]ag [R]emote"

   call filter(s:GitLines         , 0)
   call filter(s:GitLinesDisplayed, 0)

   if s:CurrentView == s:VIEW_STATUS " <<<

      if !exists('g:GitStatusBuffer')
         let g:GitStatusBuffer = []
      endif

      if len(g:GitStatusBuffer) == 0
         call add(s:GitLinesDisplayed, "all up-to-date")
      else
         for line in g:GitStatusBuffer
            let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
            call add(s:GitLinesDisplayed, l:line)
         endfor
      endif

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitLinesDisplayed, 1, l:ToolStatusLine]
   end " >>>

   if s:CurrentView == s:VIEW_LOG " <<<

      let l:Output = systemlist(s:GitLogCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitLines         , strpart(l:line, 0, 40))
         call add(s:GitLinesDisplayed, strpart(l:line, 41   ))
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitLinesDisplayed, 1, l:ToolStatusLine]
   end " >>>

   if s:CurrentView == s:VIEW_BRANCH " <<<

      let l:Output = systemlist(s:GitBranchCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitLinesDisplayed, l:line)
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitLinesDisplayed, 1, l:ToolStatusLine]
   end " >>>

   if s:CurrentView == s:VIEW_TAG " <<<

      let l:Output = systemlist(s:GitTagCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitLinesDisplayed, l:line)
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitLinesDisplayed, 1, l:ToolStatusLine]
   end " >>>

   if s:CurrentView == s:VIEW_REMOTE " <<<

      let l:Output = systemlist(s:GitRemoteCmd)

      for line in l:Output
         let l:LongestLineLength  = max([l:LongestLineLength, strlen(l:line)])
         call add(s:GitLinesDisplayed, l:line)
      endfor

      return [min([l:MaxPanelWidth, l:LongestLineLength]), s:GitLinesDisplayed, 1, l:ToolStatusLine]
   end " >>>
endfunction " >>>

function! GitSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ GIT

   nnoremap <silent> <nowait> <buffer> S :call <SID>GitStatus()<CR>
   nnoremap <silent> <nowait> <buffer> L :call <SID>GitLog()<CR>
   nnoremap <silent> <nowait> <buffer> B :call <SID>GitBranch()<CR>
   nnoremap <silent> <nowait> <buffer> T :call <SID>GitTag()<CR>
   nnoremap <silent> <nowait> <buffer> R :call <SID>GitRemote()<CR>

   nnoremap <silent> <nowait> <buffer> u :call <SID>GitRefresh()<CR>
   nnoremap <silent> <nowait> <buffer> o :call <SID>Git_o()<CR>
   nnoremap <silent> <nowait> <buffer> i :call <SID>Git_i()<CR>
endfunction " >>>

function! s:GitStatus() " <<<
   let s:CurrentView = 1
   call PanelUpdate()
endfunction " >>>

function! s:GitLog() " <<<
   let s:CurrentView = 2
   call PanelUpdate()
endfunction " >>>

function! s:GitBranch() " <<<
   let s:CurrentView = 3
   call PanelUpdate()
endfunction " >>>

function! s:GitTag() " <<<
   let s:CurrentView = 4
   call PanelUpdate()
endfunction " >>>

function! s:GitRemote() " <<<
   let s:CurrentView = 5
   call PanelUpdate()
endfunction " >>>

function! s:Git_o() " <<<
   echom "oooooooooo"
endfunction " >>>

function! s:Git_i() " <<<
   if s:CurrentView == s:VIEW_LOG " <<<
      call s:GitShowCommitInfo()
   endif " >>>
endfunction " >>>

function! IsGitRepo() " <<<
   let l:cwd = getcwd()
   if !has_key(g:GitRepoCache, l:cwd)
      silent call system(s:GitIsRepoCmd)
      let g:GitRepoCache[l:cwd] = (v:shell_error == 0)
   endif
   return g:GitRepoCache[l:cwd]
endfunction " >>>

function! GitGetBranch() " <<<
   " system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
   " trim(system("git branch --show-current"))
   silent let l:BranchName = trim(system(s:GitGetBranchCmd))
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
   call add(g:GitStatusBuffer, a:msg)
endfunction " >>>

function! OnGitStatusExit(job, exitcode) " <<<
   if a:exitcode != 0
      let g:GitStatus = ""
   else
      let g:GitStatus = GitParseStatus(get(g:, 'GitStatusBuffer', []))
   endif
   redrawstatus
endfunction " >>>

function! GitGetStatus() " <<<
   if exists('g:GitStatusJob') && job_status(g:GitStatusJob) == 'run'
      return
   endif

   if !exists('g:GitStatusBuffer')
      let g:GitStatusBuffer = []
   else
      call filter(g:GitStatusBuffer, 0)
   endif

   let g:GitStatus = "▓"
   let g:GitStatusJob = job_start(['git', 'status', '--porcelain'], {
      \ 'out_cb': function('OnGitStatusOutput'),
      \ 'exit_cb': function('OnGitStatusExit'),
      \ 'out_mode': 'nl',
      \ })
endfunction " >>>

function! GitUpdateInfo() " <<<
   if !IsGitRepo()
      let g:GitStatus     = ""
      let g:GitBranchName = ""
      return
   endif

   call GitGetBranch()
   call GitGetStatus()
endfunction " >>>

function! s:GitRefresh() " <<<
   " call GitGetBranch()
   " call GitGetStatus()
   call PanelUpdate()
endfunction " >>>

function! s:GitGetCommitInfo(commit_id) " <<<
   if a:commit_id == ""
      return
   endif
   let l:Output = systemlist(printf(s:GitGetCommitInfoCmd, s:ShowCommitInfoFormat, a:commit_id))
   if v:shell_error == 0
      return l:Output
   else
      return "something went wrong"
   end
endfunction " >>>

function! s:GitShowCommitInfo() " <<<
   let l:CommitID = s:GitLines[line('.')-1]
   let l:Lines = s:GitGetCommitInfo(l:CommitID)

   let l:BufNr = bufadd('')
   call bufload(l:BufNr)

   call setbufvar(l:BufNr, '&buftype', 'nofile')
   call setbufvar(l:BufNr, '&bufhidden', 'wipe')
   call setbufvar(l:BufNr, '&swapfile', 0)
   call setbufvar(l:BufNr, '&buflisted', 0)

   call setbufline(l:BufNr, 1, l:Lines)

   call popup_create(l:BufNr, {
      \ 'title':     ' Commit Info ',
      \ 'border':    [1, 1, 1, 1],
      \ 'padding':   [0, 1, 0, 1],
      \ 'pos':       'center',
      \ 'moved':     'any',
      \ 'mapping':   0,
      \ 'close':     'click',
      \ })
endfunction " >>>

augroup Git
   autocmd!
   autocmd VimEnter * call timer_start(0, {-> GitUpdateInfo()})
   autocmd DirChanged,BufWritePost,FocusGained,SessionLoadPost * call GitUpdateInfo()
augroup END

