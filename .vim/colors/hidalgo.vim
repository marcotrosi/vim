" Author: Marco Trosi


set background=light
hi clear

if exists("syntax_on")
   syntax reset
endif

let g:colors_name="hidalgo"

" Color Palette <<<
let s:blu1="#195E98"
let s:blu2="#3A98CB"
let s:blu3="#ABCCE6"

let s:azr1="#1B6986"
let s:azr2="#3FAFC9"
let s:azr3="#B2E7F3"

let s:tqs1="#217E73"
let s:tqs2="#5EB1AF"
let s:tqs3="#AEE6DD"

let s:grn1="#2D7132"
let s:grn2="#67A575"
let s:grn3="#BDD9C0"

let s:lim1="#4F6E16"
let s:lim2="#9AB14D"
let s:lim3="#D4E5A7"

let s:ylw1="#AE9E0F"
let s:ylw2="#F5E630"
let s:ylw3="#FCF5A3"

let s:org1="#A85F0D"
let s:org2="#F1A11E"
let s:org3="#F4BC74"

let s:red1="#891E1A"
let s:red2="#B75150"
let s:red3="#EFCACB"

let s:pnk1="#7E224D"
let s:pnk2="#C15887"
let s:pnk3="#E9C0D6"

let s:ppl1="#691C67"
let s:ppl2="#A6489F"
let s:ppl3="#E1B7E2"

let s:vlt1="#63448A"
let s:vlt2="#A485C8"
let s:vlt3="#D4C9ED"

let s:shd0="#391D01"
let s:shd1="#48280C"
let s:shd2="#693C15"
let s:shd3="#7C5135"
let s:shd4="#815C3D"
let s:shd5="#977659"
let s:shd6="#CBAC9D"
let s:shd7="#E3D3BE"
let s:shd8="#FAF3E7"
let s:shd9="#FBF6F3"

let s:gry0="#000000"
let s:gry1="#202020"
let s:gry2="#404040"
let s:gry3="#606060"
let s:gry4="#808080"
let s:gry5="#A0A0A0"
let s:gry6="#C0C0C0"
let s:gry7="#E0E0E0"
let s:gry8="#F0F0F0"
let s:gry9="#FFFFFF"
" >>>

let g:terminal_ansi_colors = ['#282828', '#cc241d', '#98971a', '#d79921',
         \ '#458588', '#b16286', '#689d6a', '#a89984', '#928374', '#fb4934',
         \ '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#ebdbb2']

" Defaults <<<
" Syntax group     |     Foreground    |     Background    | Style         |
" Editor settings <<<
exe "hi Normal       guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Cursor and LineNr <<<
exe "hi Cursor       guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=inverse"
exe "hi CursorLine                        guibg=" . s:shd8 . " gui=none"
exe "hi CursorColumn                      guibg=" . s:shd8 . " gui=none"
exe "hi LineNr       guifg=" . s:shd2 . " guibg=" . s:shd8 . " gui=none"
exe "hi CursorLineNR guifg=" . s:shd2 . " guibg=" . s:shd8 . " gui=bold"
" >>>

" Fold column, Sign column <<<
exe "hi FoldColumn   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi SignColumn   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Folded       guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Window/Tab delimiters <<<
exe "hi VertSplit   guifg=" . s:shd1 . " guibg=" . s:shd1 . " gui=none"
exe "hi ColorColumn guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi TabLine     guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi TabLineFill guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi TabLineSel  guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" File Navigation / Searching  <<<
exe "hi Directory guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Search    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=inverse"
exe "hi IncSearch guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=inverse"
" >>>

" Prompt/Status <<<
exe "hi StatusLine   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=inverse"
exe "hi StatusLineNC guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi WildMenu     guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Question     guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Title        guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi ModeMsg      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi MoreMsg      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Visual aid <<<
exe "hi MatchParen guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=inverse"
exe "hi Visual     guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi VisualNOS  guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi NonText    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Todo       guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Underlined guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Error      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi ErrorMsg   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi WarningMsg guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Ignore     guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi SpecialKey guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Variable types <<<
exe "hi Constant        guifg=" . s:vlt2 . " guibg=" . s:shd9 . " gui=none"
exe "hi String          guifg=" . s:grn2 . " guibg=" . s:shd9 . " gui=none"
exe "hi StringDelimiter guifg=" . s:ppl2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Character       guifg=" . s:pnk2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Number          guifg=" . s:org2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Boolean         guifg=" . s:ylw2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Float           guifg=" . s:tqs2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Identifier      guifg=" . s:blu2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Function        guifg=" . s:red2 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Language constructs <<<
exe "hi Statement      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Conditional    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Repeat         guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Label          guifg=" . s:red2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Operator       guifg=" . s:red2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Keyword        guifg=" . s:red2 . " guibg=" . s:shd9 . " gui=none"
exe "hi Exception      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Special        guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi SpecialChar    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Tag            guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Delimiter      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Debug          guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Comment        guifg=" . s:shd7 . " guibg=" . s:shd9 . " gui=none"
exe "hi SpecialComment guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" C like <<<
exe "hi PreProc      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Include      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Define       guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Macro        guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi PreCondit    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Type         guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi StorageClass guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Structure    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi Typedef      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Diff <<<
exe "hi DiffAdd    guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi DiffChange guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi DiffDelete guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi DiffText   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Completion menu <<<
exe "hi Pmenu      guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi PmenuSel   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi PmenuSbar  guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi PmenuThumb guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>

" Spelling <<<
exe "hi SpellBad   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi SpellCap   guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi SpellLocal guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
exe "hi SpellRare  guifg=" . s:shd1 . " guibg=" . s:shd9 . " gui=none"
" >>>
" >>>

" StatusLine <<<
exe "hi SLRed guifg=" . s:red1 . " guibg=" . s:shd8 . " gui=bold"
exe "hi SLGrn guifg=" . s:lim1 . " guibg=" . s:shd8 . " gui=bold"
exe "hi SLOrg guifg=" . s:org1 . " guibg=" . s:shd8 . " gui=bold"
exe "hi SLBlu guifg=" . s:blu1 . " guibg=" . s:shd8 . " gui=bold"
exe "hi SLPpl guifg=" . s:vlt1 . " guibg=" . s:shd8 . " gui=bold"
exe "hi SLYlw guifg=" . s:ylw1 . " guibg=" . s:shd8 . " gui=bold"
exe "hi SLNrm guifg=" . s:shd2 . " guibg=" . s:shd8 . " gui=none"
" >>>

