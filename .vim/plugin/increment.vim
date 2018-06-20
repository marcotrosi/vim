"=============================================================================
" File: increment.vim
" Author: 
"         Based on work done by: William Natter (natter at magma.ca) (vimscript #842)
"                                Ely Schoenfeld (ely at nauta.com.mx) (vimscript #1199)
"                                Stanislav Sitar (sitar at procaut.sk) (vimscript #145)
"                                Charles E. Campbell, Jr.  Ph.D (drchip at campbellfamily.biz) (vimscript #670)
" Creation Date: February 4, 2005
" Last Modified: November 23, 2005
" Version: 1.1
"
" Help:
" Put increment.vim into a plugin directory. (~/.vim/plugin)
" Put increment.txt into a doc directory. (~/.vim/doc)
"    To be able to do:
"        :help Inc
"    you have to do, for example:
"        :helptags ~/.vim/doc
"=========================================================================

" Command syntax:
"
"   :[line1,line2]Inc [s<number>] [i<number>] [r<number>] [w<number>] [h] [o] [p<regexp>] [w<number>] [c]
"
"   STARTING  [s<number>]:  to change the starting value
"                           (default: 0)
"
"   INCREMENT [i<number>]:  to increase the value by this amount between matches
"                           (default: 1)
"
"   REPEAT    [r<number>]:  to increase the value after <number> matches
"                           (default: 1)
"
"   WIDTH     [w<number>]:  to align all the numbers to the right with the given width
"                           (default: 4)
"
"   FILLER    [f<char>]:    to align numbers to the right, use the given character
"
"   HEX       [h]:          to use a hexadecimal base
"
"   OCTAL     [o]:          to use an octal base
"
"   PATTERN   [p<regexp>]:  if not using w parameter:
"                               to replace the pattern
"                           if using w parameter: 
"                               to search the line that matches the pattern and change a specific word
"
"                           NOTE: with regexp be careful to use \ before spaces and \\ to place a literal \
"
"   CONFIRM   [c]        :  to confirm each substitution; one to confirm before, two to confirm before AND after.
"                           (default: not active)
"
"   NOTE: The default values can be changed.
"
"   EXAMPLE:
"       For examples see increment.txt
"

let g:IncIncr = 1
let g:IncStartVal = 0
let g:IncMatchPat = "@"
let g:IncWordToChange = "-1"
let g:IncDoConfirm = "-1"
let g:IncReps = 1
let g:IncBase = 10
let g:IncDoAlign = 0
let g:IncWidth = 4
let g:IncFiller = " "

" Dec2Dec: convert decimal to decimal {{{
fun! s:Dec2Dec(dec)
    return a:dec
endfun "}}}

" Dec2Hex: convert decimal to hexadecimal {{{
fun! s:Dec2Hex(b10)
    "  call Dfunc("Dec2Hex(b10=".a:b10.")")
    if a:b10 >= 0
        let b10 = a:b10
        let neg = 0
    else
        let b10 = -a:b10
        let neg = 1
    endif
    "  call Decho('b10<'.b10.'> neg='.neg)
    if v:version >= 700
        let hex= printf("%x",b10)
    else
        let hex = ""
        while b10
            let hex = '0123456789abcdef'[b10 % 16] . hex
            let b10 = b10 / 16
        endwhile
    endif
    if neg
        let hex= "-".hex
    endif
    "  call Dret("Dec2Hex ".hex)
    return hex
endfun "}}}

" Dec2Oct: convert decimal to octal {{{
fun! s:Dec2Oct(b10)
    "  call Dfunc("Dec2Oct(b10=".a:b10.")")
    if a:b10 >= 0
        let b10 = a:b10
        let neg = 0
    else
        let b10 = -a:b10
        let neg = 1
    endif
    if v:version >= 700
        let oct= printf("%o",b10)
    else
        let oct = ""
        while b10
            let oct = '01234567'[b10 % 8] . oct
            let b10 = b10 / 8
        endwhile
    endif
    if neg
        let oct= "-".oct
    endif
    "  call Dret("Dec2Oct ".oct)
    return oct
endfun "}}}

" ---------------------------------------------------------------------
" Increment: main function in this plugin
function! Increment(...) range

    " Save line numbers
    let s:lfirst = a:firstline
    let s:llast = a:lastline

    " Save a and b marks to restore them if necessary
    let s:amarkline = line("'a")
    let s:amarkcol = col("'a")
    let s:bmarkline = line("'b")
    let s:bmarkcol = col("'b")

    " Defaults
    let s:incr = g:IncIncr
    let s:startingValue = g:IncStartVal
    let s:pattern = g:IncMatchPat
    let s:doconfirm = g:IncDoConfirm
    let s:repetitions = g:IncReps
    let s:doalign = g:IncDoAlign
    let s:width = g:IncWidth
    let s:base = g:IncBase
    let s:filler = g:IncFiller
    let s:formatFunc = function("s:Dec2Dec")

    " Get arguments
    " Change letter with a command setting the appropriate value
    let s:nargs = 1
    while s:nargs <= a:0
        let s:toex = ""
        if a:{s:nargs} =~? "^i"
            " User-defined increment value
            let s:toex = substitute(a:{s:nargs},"^i","let s:incr = ","")
            execute s:toex
        elseif a:{s:nargs} =~? "^w"
            " User-defined width for right-aligned numbers
            let s:doalign = 1
            let s:toex = substitute(a:{s:nargs},"^w","let s:width = ","")
            execute s:toex
        elseif a:{s:nargs} =~? "^f"
            " User-defined filler, hopefully one character only
            let s:toex = substitute(a:{s:nargs},"^f","let s:filler = ","")
            execute s:toex
        elseif a:{s:nargs} =~? "^o"
            " Octal numbers
            let s:base = 8
            let s:formatFunc = function("s:Dec2Oct")
        elseif a:{s:nargs} =~? "^h"
            " Hexadecimal numbers
            let s:base = 16
            let s:formatFunc = function("s:Dec2Hex")
        elseif a:{s:nargs} =~? "^s"
            " User-defined start value
            let s:toex = substitute(a:{s:nargs},"^s","let s:startingValue = ","")
            execute s:toex
        elseif a:{s:nargs} =~? "^n"
            " Number pattern (easier than typing it by hand)
            let s:toex = "let s:pattern = \"\\d\\+\""
            execute s:toex
        elseif a:{s:nargs} =~? "^p"
            " User-defined pattern
            let s:toex = substitute(a:{s:nargs},"^p","let s:pattern = \"","")
            let s:toex = substitute(s:toex,"$","\"","")
            execute s:toex
        elseif a:{s:nargs} =~? "^c"
            " Confirmation by user
            let s:toex = "let s:doconfirm = s:doconfirm + 1"
            execute s:toex
        elseif a:{s:nargs} =~? "^r"
            " Repeat the same number this many times before increasing the
            " value
            let s:toex = substitute(a:{s:nargs},"^r","let s:repetitions = ","")
            execute s:toex
        else
            " Ignore
        endif
        let s:nargs = s:nargs + 1
    endwhile

    let s:stringFormatPattern = "^\\(.*\\)$"
    let s:i = s:width
    let s:fullPad = ""
    if s:doalign == 1
        let s:stringFormatPattern = "^.*\\(.\\{".s:width."\\}\\)$"
        while s:i
            let s:fullPad .= s:filler
            let s:i -= 1
        endwhile
    endif

    let s:val = s:startingValue
    let s:savedline = line(".")
    let s:savedcol = col(".")

    " Start search at the end of the file if s:lfirst is the first line in the file
    " (allows matching the start of the first line if necessary)
    let s:startline = s:lfirst
    " Go to the first line
    silent! cursor(s:startline, 0)

    let s:curline = line(".")
    let s:curcol = col(".")
    let s:reps = 1
    let s:replstr = ""
    while search(s:pattern, "Wc", s:llast)

        " Save the position found with search
        let s:curline = line(".")
        let s:curcol = col(".")

        " Confirm whether the change must be made
        if s:doconfirm > -1
            echo "---------------------------------------"
            "let s:CurrentLine = getline(s:curline)
            let s:st = ""
            "let s:st = s:st . "---> " . s:CurrentLine . "\n"
            echo "---> " . getline(s:curline)
            "let s:st = s:st . "Pattern: \"" . s:pattern . "\"\n"
            let s:st = s:st . "Replace with ".s:val."?"
            let s:choice = confirm(s:st, "&Yes\nNo\nAll\nQuit")
            if s:choice == 1
                "do nothing
            elseif s:choice == 2
                continue
            elseif s:choice == 3
                let s:doconfirm = -1
            elseif s:choice == 4
                break
            endif
        endif

        " Make the change
        "let s:string = str2nr(s:val, s:base)
        let s:string = s:fullPad
        let s:string .= s:formatFunc(s:val)
        if s:doalign == 1
            let s:string = substitute(s:string, s:stringFormatPattern, "\\1", "")
        endif

        silent! execute s:curline."s/".s:pattern."/".s:string."/"

        " Confirm if the change is suitable
        if s:doconfirm > -1 
            if s:choice == 1
                "let s:CurrentLine = getline(s:curline)
                let s:st = ""
                "let s:st = s:st . "---> " . s:CurrentLine . "\n"
                echo "---> " . getline(s:curline)
                let s:st = s:st . "Replace Ok?"
                let s:choice = confirm(s:st, "Yes\nYes &All\nQuit")
                if s:choice == 1
                    "do nothing
                elseif s:choice == 2
                    let s:doconfirm = -1
                elseif s:choice == 3
                    break
                endif
            endif
        endif

        " Go to the character just after the portion that was just modified
        " (note: depends on replacement being a number)
        silent! cursor(s:curline, s:curcol)
        silent! normal /\d*\ze\d<CR>l
        if (s:reps >= s:repetitions)
            let s:val = s:val + s:incr
            let s:reps = 0
        endif
        let s:reps = s:reps + 1
    endwhile
    silent! cursor(s:savedline, s:savedcol)
endfunction

" Command definition
command! -n=* -range Inc :<line1>,<line2>call Increment(<f-args>)

