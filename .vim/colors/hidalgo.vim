"set background=dark
" - or -------------
set background=light
"TODO

highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="hidalgo"

" Color Palette <<<
let s:lit="#FEFAF4"
let s:lhl="#F8F4EE"
let s:com="#AAAAAA"
let s:drk="#522906"
let s:key="#DA2A00"
let s:typ="#65A6AD"

hi slred guifg=#DA2A00 guibg=#F8F4EE gui=bold
hi slgrn guifg=#65A6AD guibg=#F8F4EE gui=bold
hi slorg guifg=#522906 guibg=#F8F4EE gui=bold
hi slblu guifg=#AAAAAA guibg=#F8F4EE gui=bold
" >>>

" Syntax group     |     Foreground    |     Background    | Style         |
" Editor settings <<<
exe "hi Normal       guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" Cursor and LineNr <<<
exe "hi Cursor       guifg=" . s:drk . " guibg=" . s:lit . " gui=inverse"
exe "hi CursorLine                       guibg=" . s:lhl . " gui=none"
exe "hi CursorColumn                     guibg=" . s:lhl . " gui=none"
exe "hi LineNr       guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi CursorLineNR guifg=" . s:key . " guibg=" . s:lhl . " gui=bold"
" >>>

" Fold column, Sign column <<<
exe "hi FoldColumn   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi SignColumn   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Folded       guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" Window/Tab delimiters <<<
exe "hi VertSplit   guifg=" . s:drk . " guibg=" . s:drk . " gui=none"
exe "hi ColorColumn guifg=" . s:drk . " guibg=" . s:lhl . " gui=none"
exe "hi TabLine     guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi TabLineFill guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi TabLineSel  guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" File Navigation / Searching  <<<
exe "hi Directory guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Search    guifg=" . s:drk . " guibg=" . s:lit . " gui=inverse,underline"
exe "hi IncSearch guifg=" . s:drk . " guibg=" . s:lit . " gui=inverse,underline"
" >>>

" Prompt/Status <<<
exe "hi StatusLine   guifg=" . s:drk . " guibg=" . s:lit . " gui=inverse"
exe "hi StatusLineNC guifg=" . s:drk . " guibg=" . s:com . " gui=none"
exe "hi WildMenu     guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Question     guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Title        guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi ModeMsg      guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi MoreMsg      guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" Visual aid <<<
exe "hi MatchParen guifg=" . s:drk . " guibg=" . s:lit . " gui=inverse"
exe "hi Visual     guifg=" . s:drk . " guibg=" . s:com . " gui=none"
exe "hi VisualNOS  guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi NonText    guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Todo       guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Underlined guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Error      guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi ErrorMsg   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi WarningMsg guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi Ignore     guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi SpecialKey guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" Variable types <<<
exe "hi Constant        guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi String          guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi StringDelimiter guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi Character       guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi Number          guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi Boolean         guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi Float           guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi Identifier      guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
exe "hi Function        guifg=" . s:typ . " guibg=" . s:lit . " gui=none"
" >>>

" Language constructs <<<
exe "hi Statement      guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Conditional    guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Repeat         guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Label          guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Operator       guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Keyword        guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Exception      guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Special        guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi SpecialChar    guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Tag            guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Delimiter      guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Debug          guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Comment        guifg=" . s:com . " guibg=" . s:lit . " gui=none"
exe "hi SpecialComment guifg=" . s:com . " guibg=" . s:lit . " gui=none"
" >>>

" C like <<<
exe "hi PreProc      guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Include      guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Define       guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Macro        guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi PreCondit    guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Type         guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi StorageClass guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Structure    guifg=" . s:key . " guibg=" . s:lit . " gui=none"
exe "hi Typedef      guifg=" . s:key . " guibg=" . s:lit . " gui=none"
" >>>

" Diff <<<
exe "hi DiffAdd    guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi DiffChange guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi DiffDelete guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi DiffText   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" Completion menu <<<
exe "hi Pmenu      guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi PmenuSel   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi PmenuSbar  guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi PmenuThumb guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

" Spelling <<<
exe "hi SpellBad   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi SpellCap   guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi SpellLocal guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
exe "hi SpellRare  guifg=" . s:drk . " guibg=" . s:lit . " gui=none"
" >>>

