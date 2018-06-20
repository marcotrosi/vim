" Vim number conversion functions
" Convert from base(2,8,10,16) to base(2-32). Also character to html converter.

" Maintainer:      Walter Hutchins
" Last Change:     2006/06/29
" Version:         1.2
" Setup:           Copy to ~/.vim/plugin
"
" Help:            :Tobase -h    (Help)
"                  :Tobase -hc   (Character conversion help)
"
let s:he1=        "Usage - :Tobase obase [0oxy&]inum\n"
let s:he1=s:he1 . "Convert inum to obase and and return it.\n"
let s:he1=s:he1 . "The result will be placed in the unnamed register @@.\n"
let s:he1=s:he1 . "A subsequent 'p' command would put the result\n"
let s:he1=s:he1 . "|P| before, |p| after the cursor. \n"
let s:he1=s:he1 . "Optional modifier preceeding inum indicates \n"
let s:he1=s:he1 . "o-octal, x-hexadecimal, y-binary, &-htmlchar,\n"
let s:he1=s:he1 . "and if not present, inum defaults to base 10 (decimal).\n"
let s:he1=s:he1 . "A zero preceeding inum assumes a valid 'vim' number (:help variable).\n"
let s:he1=s:he1 . "obase may be 2-32, c, or h.\n"
let s:he1=s:he1 . "Version 1.2 has been extended to allow inum to actually be a character.\n"
let s:he1=s:he1 . "(note: vy captures 1 character under the cursor.)\n"
let s:he1=s:he1 . "If obase='c', then it will convert to a character.\n"
let s:he1=s:he1 . "So, you can paste accented characters into document.\n"
let s:he1=s:he1 . "(:digraphs :help digraphs-use :help digraphs-default)\n"
let s:he1=s:he1 . "If obase='h', then it will convert to an html entity.\n"
let s:he1=s:he1 . "Also character to html converter. ':Tobase -hc' for info\n\n"
let s:he1=s:he1 . "examples:\n"
let s:he1=s:he1 . "    :Tobase 16 192             - prints C0\n"
let s:he1=s:he1 . "    :Tobase 10 xc0             - prints 192\n"
let s:he1=s:he1 . "    :Tobase 11 2662            - prints 2000\n"
let s:he1=s:he1 . "    :Tobase h 192              - prints &Agrave;\n"
let s:he1=s:he1 . "    :Tobase c xC0              - prints A with grave accent\n"
let s:he1=s:he1 . "    :Tobase 2 7 5 5            - prints 111 101 101 (chmod)\n"
let s:he1=s:he1 . "    :Tobase 10 y111 y101 y101  - prints 755\n"
let s:he1=s:he1 . "    :Tobase 16 244 164 96      - prints F4 A4 60 (sandybrown\n"
let s:he1=s:he1 . "    :Tobase 10 xF4 xA4 o140    - prints 244 164 96\n"
let s:he1=s:he1 . "    :Tobase c &Agr &Aac &Aum   - prints accented A's\n"
"The above help message prints when you type :Tobase -h


let s:he2="\n"
let s:he2=s:he2 . "Converting to/from Characters/HtmlEntities...\n\n"
let s:he2=s:he2 . "Put these commands in your ~/.vimrc file:\n"
let s:he2=s:he2 . "command! -range -nargs=* Foo <line1>,<line2>call Char2HtmlExec(<f-args>)\n"
let s:he2=s:he2 . "command! -range -nargs=* Foof <line1>,<line2>call Html2CharExec(<f-args>)\n"
let s:he2=s:he2 . "command! -range -nargs=* Fooa <line1>,<line2>call Char2AsciiExec(<f-args>)\n"
let s:he2=s:he2 . "You may use other names besides Foo, Foof, and Fooa,\n"
let s:he2=s:he2 . "as long as they begin with a capital letter.\n"
let s:he2=s:he2 . "You may optionally supply a range and function arguments.\n"
let s:he2=s:he2 . "Without a range, the commands act on all lines as if\n"
let s:he2=s:he2 . "you had supplied the range 1,$.\n"
let s:he2=s:he2 . "The range may be line numbers such as 1,15 or it may be\n"
let s:he2=s:he2 . "relative such as .-5,.+5 or markers such as 'a,'b.\n"
let s:he2=s:he2 . "Range may also be searches such as /The range/,/Range may/\n"
let s:he2=s:he2 . "Here are some examples:\n"
let s:he2=s:he2 . ":Foo                     -Convert accented chars plus &<>\" to html, all lns.\n"
let s:he2=s:he2 . ":Foof                    -Convert html entities plus &amp; &lt; &gt; &quot;\n"
let s:he2=s:he2 . "                          to chars, all lns. (reverse of :Foo)\n"
let s:he2=s:he2 . ":Fooa                    -Convert chars x80-xFF plus &<>\" to ascii simulation.\n"
let s:he2=s:he2 . ":12,15Foo 0 0 &          -Convert & to &amp; in lns 12-15.\n"
let s:he2=s:he2 . ":10,25Foo 0x80 0xFF &<>\" -Convert chars x80-xFF plus &<>\" to html lns 10-25.\n"
let s:he2=s:he2 . ":10,25Foof 128 255 &<>\"  -Reverse of the above. \n"
let s:he2=s:he2 . ":Fooa 0x80 0x9f          -Convert CP1252 chars to ascii look-alikes, all lns.\n"
let s:he2=s:he2 . ":Foo 0 0 &<>\"            -Just convert &<>\" to html, all lns.\n"
let s:he2=s:he2 . ":Foo j                   -Shortcut of above. j-ust do &<>\"\n"
let s:he2=s:he2 . ":Foo 0x80 0xFF           -Conver chars x80-xFF, but not &<>\" to html, all lns\n"
let s:he2=s:he2 . ":Foo n                   -Shortcut of above. n-ot do &<>\"\n"
let s:he2=s:he2 . ":/<!-- SCODE -->/+1,/<!-- ECODE -->/-1 Foo j       -To display some code.\n"
let s:he2=s:he2 . "Whether or not you set up commands like above,\n"
let s:he2=s:he2 . "you can also do it like this:\n"
let s:he2=s:he2 . ":101,1250call Char2HtmlExec(0x80, 0xFF, '&')\n\n"
let s:he2=s:he2 . "Note that if you do not supply a line range or arguments,\n"
let s:he2=s:he2 . "it defaults to doing everything on all lines.\n"
let s:he2=s:he2 . ":call Char2HtmlExec() is the same as :Foo which is the\n"
let s:he2=s:he2 . "same as :1,$call Char2HtmlExec(128, 255, '&<>\") which\n"
let s:he2=s:he2 . "is the same as :1,$Foo 0x80 255 '&<>\".\n"
let s:he2=s:he2 . "Note: the command version does not have parentheses around, or commas between\n"
let s:he2=s:he2 . "the arguments.\n"
let s:he2=s:he2 . "The arguments if supplied are:\n"
let s:he2=s:he2 . "Minimum character (number), maximum character (number), special\ncharacters (string). The string can contain '&', '<>', '&<>\"'.\n"
let s:he2=s:he2 . "Minimum and maximum of 0,0 means none.\n"
let s:he2=s:he2 . "Note: You cannot do just 1 line. If the range equates to one line, it does all.\n"
let s:he2=s:he2 . "Note: Conversion to ascii simulation (Fooa) is one-way -- not reversible.\n"
let s:he2=s:he2 . "In the terminal, there could be a length of time in which\n"
let s:he2=s:he2 . "nothing seems to be happening. The time depends on system\n"
let s:he2=s:he2 . "speed, the file size, and how many replacements to be made.\n"
let s:he2=s:he2 . "On 800mz pentium III and 3mb file with thousands of\nreplacements to make, this took 20 seconds.\n\n"
let s:he2=s:he2 . "Regarding characters known to PHP as htmlspecialchars()\n"
let s:he2=s:he2 . "&, <, >, and \" :\n"
let s:he2=s:he2 . "If you were using PHP and you did htmlspecialchars() more\n"
let s:he2=s:he2 . "than once, you could start getting &amp;amp; corruption.\n"
let s:he2=s:he2 . "This script doesn't seem to do that.\n"
"The above help message prints when you type :Tobase -hc

"
"Beta - not 'connected' yet:
"If you have called Tobase with base="h" you may then :call s:SubOne() 
"to replace the first such character on the current line with the html entity. 
"Likewise, :call s:SubAll() will replace all occurances of that character 
"in the document with the html code.

" see :help normal-index, encoding, nr2char,  char2nr
" see :help variable if the only desired conversion is either from hexadecimal 
"     to decimal or from octal to decimal.
" see :help ga,g8 if you want the code for the character under the cursor.

command! -nargs=* Tobase echo s:Tobasem(<f-args>)

function s:Tobasem(base, ...)
    let obase=a:base
    if tolower(obase) == "-h" || match(tolower(obase), "help\\|?\\|--h") != -1
        echo s:he1
    endif
    if tolower(obase) == "-hc"
        echo s:he2
    endif
    if a:0 == 1
        return s:Tobase(obase, a:1)
    endif
    "call Tobase with multiple input numbers ( < 20 )
    ":he function say more than 20, but throws an argument error.
    let remargs=a:0
    let nxtarg=1
    let s:mresnum=""
    while remargs > 0
        execute "let arg=a:" . nxtarg
        let res=s:Tobase(obase, arg)
        let s:mresnum=s:mresnum . " " . res
        let remargs=remargs - 1
        let nxtarg=nxtarg + 1
    endwhile
    let arrrr = "let @@=s:mresnum"
    execute arrrr
    return s:mresnum
endfunction

function s:Tobase(base, inum, ...)
    if a:0 > 1
        echo "Too many arguments for function. try s:Tobasem"
        return
    endif
    let digits="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let prefix="0OXY" "zero, O, X, Y
    let s:base=a:base
    if  tolower(a:base) == "c"
         let s:base=10
         let s:showchar=1
    endif
    if  tolower(a:base) == "h"
         let s:base=16
         let s:showchar=2
    endif
    let s:resnum=""
    if a:0 > 0
        let s:resnum=a:1
    endif
    let num=a:inum
    if type(num) == 1
        let len = strlen(substitute(num, ".", "x", "g"))  " :he strlen
        if len == 1
            if match("0123456789", num) == -1
                let num=char2nr(num)            "new v1.2: character inum
            endif
        endif
    endif
    if type(num) == 1                           "if arg is string
        if strpart(num, 0, 1) == "&"
             let num=s:FindChar(num)
        endif
        let num=toupper(num)
        let bcode=strpart(num, 0, 1)
        if match(prefix, strpart(num, 0, 1)) > 0
            let num=s:Todec(num)                     "convert to decimal
        else
            let num=num + 0                        "vim can convert to decimal
        endif
    endif
    let r=num % s:base
    if (num - r) == 0
        let digit=strpart(digits, num, 1)
        let s:resnum=digit . s:resnum
    else
        let digit=strpart(digits, r, 1)
        let nxt=(num - r) / s:base
        let s:resnum=digit . s:resnum
        call s:Tobase(s:base, nxt, s:resnum) 
    endif
    if a:0 == 0
        if exists("s:showchar") && s:showchar != 0
            "This is the html character 'game'
            if s:showchar == 1     "clean for next use
                let s:showchar=0
                let arr = nr2char(s:resnum)
                let arrrr = "let @@=arr"
                execute arrrr
                return arr
            endif
            if s:showchar == 2
                let s:showchar=0    "clean for next use
                call Char2HtmlStr()
                let srch="x" . s:resnum
                let srch2="\\"
                let srch3="/"
                let mtch1=match(s:c2h, srch)
                let mtch2=match(s:c2h, srch2, mtch1)
                let mtch3=match(s:c2h, srch3, mtch2 + 1)
                let mlen=mtch3 - mtch2
                if mtch1 == -1 || mtch2 == -1 || mtch3 == -1
                    let arr=srch . "- Out of range of supported html entities"
                    echo arr
                    return
                endif
                let htmlcode=strpart(s:c2h, mtch2 + 1, mlen - 1)
                let arr = htmlcode
                let arrrr = "let @@=arr"
                execute arrrr
                let arr2 = nr2char(s:Todec(s:resnum))
                let arr = "<" . htmlcode . "> " . arr2 .  ", \\" . srch
                let srchchar = nr2char(s:Todec(srch))
                let s:subOneCmd='s/\' . srchchar . '/\' . htmlcode . '/'
                let s:subAllCmd='%s/\' . srchchar . '/\' . htmlcode . '/g'
                return arr
            endif
        else
            let arrrr = "let @@=s:resnum"
            execute arrrr
            return s:resnum
        endif
    endif
endfunction

function s:Todec(inum)
    let decnum=0
    let digits="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let prefix="0OXY" "zero, O, X, Y
    let num=toupper(a:inum)
    let bcode=strpart(num, 0, 1)
    if match(prefix, bcode) == -1
        let s:mult=16
    else
        let num=strpart(num, 1)
        if bcode == "O" || bcode == "0"
            let s:mult=8
        elseif bcode == "X"
            let s:mult=16
        elseif bcode == "Y"
            let s:mult=2
        endif
    endif
    let l=strlen(num)
    let c=0
    while (l > 0)
        let place=l - 1
        let fac=1
        while (place > 0)
            let fac=fac * s:mult
            let place=place - 1
        endwhile
        let hdigit=strpart(num, c, 1)
        let ddigit=match(digits, hdigit)
        let decnum=decnum + (ddigit * fac)
        let c=c + 1
        let l=l - 1
    endwhile
    return decnum
endfunction

function s:FindChar(...)
    let ampcode=a:1
    call Char2HtmlStr()
    let srch='x[a-fA-F0-9]\{2,2}/\\' . ampcode
    let mtch1=match(s:c2h, srch)
    let htmlcode=strpart(s:c2h, mtch1, 3)
    let arr = htmlcode
    let arrrr = "let @@=arr"
    execute arrrr
    return arr
endfunction

function s:SubOne()
    if exists("s:subOneCmd")
        let doCmd=s:subOneCmd
        execute doCmd
    endif
endfunction

function s:SubAll()
    if exists("s:subAllCmd")
        let doCmd=s:subAllCmd
        execute doCmd
    endif
endfunction

function Char2HtmlStr()
    "This string is used by Tobase to lookup the html character reference 
    "associated with a particular number.
    "The resulting string is actually a viable bash sed script to convert
    "from iso-8859-1 and cp1252 characters to html entities.
    "One method to make the script:
    "     :new
    "     :put =Char2HtmlStr()
    "     :w! myIso2Html
    if exists("s:c2h")
        return s:c2h
    endif
    let s:c2h=""
    let s:c2h=s:c2h . "#! /bin/bash" . "\n"
    let s:c2h=s:c2h . "sed $(cat<<EOF" . "\n"
    "this will miss &bar, but at least won't do &amp;amp; corruption
    "this is similar to  :help @! foo\(bar\)\@! any "foo" not followed by "bar"
    let s:c2h=s:c2h . " -e s/\\&\\([^a-zA-Z0-9#]\\{1,6\\}\\)\\([^;]\\)/\\&amp;\\1\\2/g" . "\n"
    "to get &bar, use the following line, but only run once or &amp;amp; mess.
    ":let s:c2h=s:c2h . " -e s/\\&/\\&amp;\\1\\2/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x22/\\&quot;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x3C/\\&lt;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x3E/\\&gt;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x82/\\&sbquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x83/\\&fnof;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x84/\\&bdquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x85/\\&hellip;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x86/\\&dagger;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x87/\\&Dagger;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x88/\\&circ;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x89/\\&permil;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x8A/\\&Scaron;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x8B/\\&lsaquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x8C/\\&OElig;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x8D/\\x8D/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x8E/\\&#381;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x8F/\\x8F/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x90/\\x90/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x91/\\&lsquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x92/\\&rsquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x93/\\&ldquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x94/\\&rdquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x95/\\&bull;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x96/\\&ndash;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x97/\\&mdash;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x98/\\&tilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x99/\\&trade;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x9A/\\&scaron;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x9B/\\&rsaquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x9C/\\&oelig;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x9D/\\x9D/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x9E/\\&#382;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\x9F/\\&Yuml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA0/\\&nbsp;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA1/\\&iexcl;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA2/\\&cent;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA3/\\&pound;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA4/\\&curren;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA5/\\&yen;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA6/\\&brvbar;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA7/\\&sect;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA8/\\&uml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xA9/\\&copy;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xAA/\\&ordf;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xAB/\\&laquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xAC/\\&not;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xAD/\\&shy;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xAE/\\&reg;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xAF/\\&macr;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB0/\\&deg;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB1/\\&plusmn;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB2/\\&sup2;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB3/\\&sup3;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB4/\\&acute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB5/\\&micro;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB6/\\&para;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB7/\\&middot;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB8/\\&cedil;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xB9/\\&sup1;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xBA/\\&ordm;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xBB/\\&raquo;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xBC/\\&frac14;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xBD/\\&frac12;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xBE/\\&frac34;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xBF/\\&iquest;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC0/\\&Agrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC1/\\&Aacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC2/\\&Acirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC3/\\&Atilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC4/\\&Auml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC5/\\&Aring;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC6/\\&AElig;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC7/\\&Ccedil;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC8/\\&Egrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xC9/\\&Eacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xCA/\\&Ecirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xCB/\\&Euml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xCC/\\&Igrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xCD/\\&Iacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xCE/\\&Icirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xCF/\\&Iuml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD0/\\&ETH;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD1/\\&Ntilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD2/\\&Ograve;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD3/\\&Oacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD4/\\&Ocirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD5/\\&Otilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD6/\\&Ouml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD7/\\&times;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD8/\\&Oslash;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xD9/\\&Ugrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xDA/\\&Uacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xDB/\\&Ucirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xDC/\\&Uuml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xDD/\\&Yacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xDE/\\&THORN;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xDF/\\&szlig;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE0/\\&agrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE1/\\&aacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE2/\\&acirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE3/\\&atilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE4/\\&auml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE5/\\&aring;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE6/\\&aelig;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE7/\\&ccedil;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE8/\\&egrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xE9/\\&eacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xEA/\\&ecirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xEB/\\&euml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xEC/\\&igrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xED/\\&iacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xEE/\\&icirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xEF/\\&iuml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF0/\\&eth;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF1/\\&ntilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF2/\\&ograve;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF3/\\&oacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF4/\\&ocirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF5/\\&otilde;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF6/\\&ouml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF7/\\&divide;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF8/\\&oslash;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xF9/\\&ugrave;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xFA/\\&uacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xFB/\\&ucirc;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xFC/\\&uuml;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xFD/\\&yacute;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xFE/\\&thorn;/g" . "\n"
    let s:c2h=s:c2h . " -e s/\\xFF/\\&yuml;/g" . "\n"
    let s:c2h=s:c2h . "EOF)" . "\n"
    return s:c2h
endfunction

function s:Chars()
    if exists("s:chars")
        return s:chars
    endif
    let ac=0
    let cc=""
    while ac < 256
        let cc=cc . nr2char(ac)
        if strlen(nr2char(ac)) == 1
            let cc=cc . nr2char(ac)
        endif
        let ac=ac + 1
    endwhile
    let s:chars=cc
    return s:chars
endfunction

function s:GetChar(num)
    if a:num < 1
       return 0
    endif
    let ac=a:num - 1
    if !exists("s:chars")
        call s:Chars()
    endif
    let c1=strpart(s:chars, ac*2, 1)
    let c2=strpart(s:chars, ac*2 + 1, 1)
    let c3=strpart(s:chars, ac*2, 2)
    if c1 == c2
       let char=c1
    else
       let char=c3
    endif
    return char
endfunction

function s:Pad(s,l)
    let st=a:s
    let sl=a:l
    while strlen(st) < sl
        let st=st . " "
   endwhile
   return st
endfunction

function s:Entities()
    if exists("s:entities")
        return s:entities
    endif
    let c=0
    let st=""
    while c < 0x80
        if c < 16
            let lz="0"
        else
            let lz=""
        endif
        let st1='x' . lz . s:Tobase(16, c) . 'x' . lz . s:Tobase(16, c)
        if c == 0x26
            let st1=s:Pad("x26&amp;", 11)
        elseif c == 0x3C
            let st1=s:Pad("x3C&lt;", 11)
        elseif c == 0x3E
            let st1=s:Pad("x3E&gt;", 11)
        elseif c == 0x22
            let st1=s:Pad("x22&quot;", 11)
        endif
        let st=st . s:Pad(st1, 11)
        let c=c + 1
    endwhile
    let st=st . s:Pad("x80&euro;", 11)
    let st=st . s:Pad("x81x81", 11)
    let st=st . s:Pad("x82&sbquo;", 11)
    let st=st . s:Pad("x83&fnof;", 11)
    let st=st . s:Pad("x84&bdquo;", 11)
    let st=st . s:Pad("x85&hellip;", 11)
    let st=st . s:Pad("x86&dagger;", 11)
    let st=st . s:Pad("x87&Dagger;", 11)
    let st=st . s:Pad("x88&circ;", 11)
    let st=st . s:Pad("x89&permil;", 11)
    let st=st . s:Pad("x8A&Scaron;", 11)
    let st=st . s:Pad("x8B&lsaquo;", 11)
    let st=st . s:Pad("x8C&OElig;", 11)
    let st=st . s:Pad("x8Dx8D", 11)
    let st=st . s:Pad("x8E&#381;", 11)
    let st=st . s:Pad("x8Fx8F", 11)
    let st=st . s:Pad("x90x90", 11)
    let st=st . s:Pad("x91&lsquo;", 11)
    let st=st . s:Pad("x92&rsquo;", 11)
    let st=st . s:Pad("x93&ldquo;", 11)
    let st=st . s:Pad("x94&rdquo;", 11)
    let st=st . s:Pad("x95&bull;", 11)
    let st=st . s:Pad("x96&ndash;", 11)
    let st=st . s:Pad("x97&mdash;", 11)
    let st=st . s:Pad("x98&tilde;", 11)
    let st=st . s:Pad("x99&trade;", 11)
    let st=st . s:Pad("x9A&scaron;", 11)
    let st=st . s:Pad("x9B&rsaquo;", 11)
    let st=st . s:Pad("x9C&oelig;", 11)
    let st=st . s:Pad("x9Dx9D", 11)
    let st=st . s:Pad("x9E&#382;", 11)
    let st=st . s:Pad("x9F&Yuml;", 11)
    let st=st . s:Pad("xA0&nbsp;", 11)
    let st=st . s:Pad("xA1&iexcl;", 11)
    let st=st . s:Pad("xA2&cent;", 11)
    let st=st . s:Pad("xA3&pound;", 11)
    let st=st . s:Pad("xA4&curren;", 11)
    let st=st . s:Pad("xA5&yen;", 11)
    let st=st . s:Pad("xA6&brvbar;", 11)
    let st=st . s:Pad("xA7&sect;", 11)
    let st=st . s:Pad("xA8&uml;", 11)
    let st=st . s:Pad("xA9&copy;", 11)
    let st=st . s:Pad("xAA&ordf;", 11)
    let st=st . s:Pad("xAB&laquo;", 11)
    let st=st . s:Pad("xAC&not;", 11)
    let st=st . s:Pad("xAD&shy;", 11)
    let st=st . s:Pad("xAE&reg;", 11)
    let st=st . s:Pad("xAF&macr;", 11)
    let st=st . s:Pad("xB0&deg;", 11)
    let st=st . s:Pad("xB1&plusmn;", 11)
    let st=st . s:Pad("xB2&sup2;", 11)
    let st=st . s:Pad("xB3&sup3;", 11)
    let st=st . s:Pad("xB4&acute;", 11)
    let st=st . s:Pad("xB5&micro;", 11)
    let st=st . s:Pad("xB6&para;", 11)
    let st=st . s:Pad("xB7&middot;", 11)
    let st=st . s:Pad("xB8&cedil;", 11)
    let st=st . s:Pad("xB9&sup1;", 11)
    let st=st . s:Pad("xBA&ordm;", 11)
    let st=st . s:Pad("xBB&raquo;", 11)
    let st=st . s:Pad("xBC&frac14;", 11)
    let st=st . s:Pad("xBD&frac12;", 11)
    let st=st . s:Pad("xBE&frac34;", 11)
    let st=st . s:Pad("xBF&iquest;", 11)
    let st=st . s:Pad("xC0&Agrave;", 11)
    let st=st . s:Pad("xC1&Aacute;", 11)
    let st=st . s:Pad("xC2&Acirc;", 11)
    let st=st . s:Pad("xC3&Atilde;", 11)
    let st=st . s:Pad("xC4&Auml;", 11)
    let st=st . s:Pad("xC5&Aring;", 11)
    let st=st . s:Pad("xC6&AElig;", 11)
    let st=st . s:Pad("xC7&Ccedil;", 11)
    let st=st . s:Pad("xC8&Egrave;", 11)
    let st=st . s:Pad("xC9&Eacute;", 11)
    let st=st . s:Pad("xCA&Ecirc;", 11)
    let st=st . s:Pad("xCB&Euml;", 11)
    let st=st . s:Pad("xCC&Igrave;", 11)
    let st=st . s:Pad("xCD&Iacute;", 11)
    let st=st . s:Pad("xCE&Icirc;", 11)
    let st=st . s:Pad("xCF&Iuml;", 11)
    let st=st . s:Pad("xD0&ETH;", 11)
    let st=st . s:Pad("xD1&Ntilde;", 11)
    let st=st . s:Pad("xD2&Ograve;", 11)
    let st=st . s:Pad("xD3&Oacute;", 11)
    let st=st . s:Pad("xD4&Ocirc;", 11)
    let st=st . s:Pad("xD5&Otilde;", 11)
    let st=st . s:Pad("xD6&Ouml;", 11)
    let st=st . s:Pad("xD7&times;", 11)
    let st=st . s:Pad("xD8&Oslash;", 11)
    let st=st . s:Pad("xD9&Ugrave;", 11)
    let st=st . s:Pad("xDA&Uacute;", 11)
    let st=st . s:Pad("xDB&Ucirc;", 11)
    let st=st . s:Pad("xDC&Uuml;", 11)
    let st=st . s:Pad("xDD&Yacute;", 11)
    let st=st . s:Pad("xDE&THORN;", 11)
    let st=st . s:Pad("xDF&szlig;", 11)
    let st=st . s:Pad("xE0&agrave;", 11)
    let st=st . s:Pad("xE1&aacute;", 11)
    let st=st . s:Pad("xE2&acirc;", 11)
    let st=st . s:Pad("xE3&atilde;", 11)
    let st=st . s:Pad("xE4&auml;", 11)
    let st=st . s:Pad("xE5&aring;", 11)
    let st=st . s:Pad("xE6&aelig;", 11)
    let st=st . s:Pad("xE7&ccedil;", 11)
    let st=st . s:Pad("xE8&egrave;", 11)
    let st=st . s:Pad("xE9&eacute;", 11)
    let st=st . s:Pad("xEA&ecirc;", 11)
    let st=st . s:Pad("xEB&euml;", 11)
    let st=st . s:Pad("xEC&igrave;", 11)
    let st=st . s:Pad("xED&iacute;", 11)
    let st=st . s:Pad("xEE&icirc;", 11)
    let st=st . s:Pad("xEF&iuml;", 11)
    let st=st . s:Pad("xF0&eth;", 11)
    let st=st . s:Pad("xF1&ntilde;", 11)
    let st=st . s:Pad("xF2&ograve;", 11)
    let st=st . s:Pad("xF3&oacute;", 11)
    let st=st . s:Pad("xF4&ocirc;", 11)
    let st=st . s:Pad("xF5&otilde;", 11)
    let st=st . s:Pad("xF6&ouml;", 11)
    let st=st . s:Pad("xF7&divide;", 11)
    let st=st . s:Pad("xF8&oslash;", 11)
    let st=st . s:Pad("xF9&ugrave;", 11)
    let st=st . s:Pad("xFA&uacute;", 11)
    let st=st . s:Pad("xFB&ucirc;", 11)
    let st=st . s:Pad("xFC&uuml;", 11)
    let st=st . s:Pad("xFD&yacute;", 11)
    let st=st . s:Pad("xFE&thorn;", 11)
    let st=st . s:Pad("xFF&yuml;", 11)
    let s:entities=st
    return s:entities
endfunction

function s:GetEntity(code)
    if type(a:code) == 1
        let ncode=s:Tobase(10, a:code)
    else
        let ncode=a:code
    endif
    if !exists("s:chars")
        call s:Chars()
    endif
    if !exists("s:entities")
        call s:Entities()
    endif
    let ent=strpart(s:entities, ncode * 11, 11)
    let amp=match(ent, "&")
    let sc=match(ent, ";")
    if amp != -1 && sc != -1 && sc > amp
        let len=sc - amp + 1
        let rv=strpart(ent, amp, len)
    else
        let rv=strpart(s:chars, ncode * 2 - 2, 2)
        if strpart(rv, 0, 1) == strpart(rv, 1, 1)
            let rv=strpart(rv, 0, 1)
       endif
    endif
    return rv
endfunction

function s:ValidateNumber(num)
    let num=a:num
    return s:Tobase(10, num)
endfunction

function Char2HtmlExec(...) range
    if a:firstline == a:lastline
        let firl="1"
        let lasl="$"
    else
        let firl=a:firstline
        let lasl=a:lastline
    endif
    if a:0 == 0
        execute s:Toh(firl, lasl, 0x80, 0xFF, "&<>\"")
    elseif a:0 == 1
        if a:1 == "n"
            execute s:Toh(firl, lasl, 0x80, 0xFF)
        elseif a:1 == "j"
            execute s:Toh(firl, lasl, 0, 0, "&<>\"")
        endif
    elseif a:0 == 2
        let a1=s:ValidateNumber(a:1)
        let a2=s:ValidateNumber(a:2)
        execute s:Toh(firl, lasl, a1, a2)
    elseif a:0 == 3
        let a1=s:ValidateNumber(a:1)
        let a2=s:ValidateNumber(a:2)
        let a3=a:3
        execute s:Toh(firl, lasl, a1, a2, a3)
    endif
endfunction

function Html2CharExec(...) range
    if a:firstline == a:lastline
        let firl="1"
        let lasl="$"
    else
        let firl=a:firstline
        let lasl=a:lastline
    endif
    if a:0 == 0
        execute s:Fmh(firl, lasl, 0x80, 0xFF, "&<>\"")
    elseif a:0 == 1
        if a:1 == "n"
            execute s:Fmh(firl, lasl, 0x80, 0xFF)
        elseif a:1 == "j"
            execute s:Fmh(firl, lasl, 0, 0, "&<>\"")
        endif
    elseif a:0 == 2
        let a1=s:ValidateNumber(a:1)
        let a2=s:ValidateNumber(a:2)
        execute s:Fmh(firl, lasl, a1, a2)
    elseif a:0 == 3
        let a1=s:ValidateNumber(a:1)
        let a2=s:ValidateNumber(a:2)
        let a3=a:3
        execute s:Fmh(firl, lasl, a1, a2, a3)
    endif
endfunction

function Char2AsciiExec(...) range
    if a:firstline == a:lastline
        let firl="1"
        let lasl="$"
    else
        let firl=a:firstline
        let lasl=a:lastline
    endif
    if a:0 == 0
        execute s:Toa(firl, lasl, 0x80, 0xFF, "&<>\"")
    elseif a:0 == 1
        if a:1 == "n"
            execute s:Toa(firl, lasl, 0x80, 0xFF)
        elseif a:1 == "j"
            execute s:Toa(firl, lasl, 0, 0, "&<>\"")
        endif
    elseif a:0 == 2
        let a1=s:ValidateNumber(a:1)
        let a2=s:ValidateNumber(a:2)
        execute s:Toa(firl, lasl, a1, a2)
    elseif a:0 == 3
        let a1=s:ValidateNumber(a:1)
        let a2=s:ValidateNumber(a:2)
        let a3=a:3
        execute s:Toa(firl, lasl, a1, a2, a3)
    endif
endfunction

function s:Toh(firl, lasl, ...)
    "To html entity from character
    let ran=a:firl . ',' . a:lasl
    let ac=0x80
    let max=0xFF
    let special=""
    let rv=""
    if a:0 > 0
        let ac=a:1
    endif    
    if a:0 > 1
        let max=a:2
    endif    
    if a:0 > 2
        let special=a:3
    endif
    if ac == 0 && max == 0
       let ac=1
    endif
    if match(special, "&") != -1
        let cn=0x26
        "from :help @! -- foo\(bar\)\@!         any "foo" not followed by "bar"
        let rv=rv . ran . 's/&\([a-zA-Z0-9#]\{2,6};\)\@!/\&amp;/ge' . "\n"
    endif
    if match(special, "<") != -1
        let cn=0x3C
        let rv=rv . ran . 's/' . s:GetChar(cn) . '/\' . s:GetEntity(cn) . '/ge' . "\n"
    endif
    if match(special, ">") != -1
        let cn=0x3E
        let rv=rv . ran . 's/' . s:GetChar(cn) . '/\' . s:GetEntity(cn) . '/ge' . "\n"
    endif
    if match(special, "\"") != -1
        let cn=0x22
        let rv=rv . ran . 's/' . s:GetChar(cn) . '/\' . s:GetEntity(cn) . '/ge' . "\n"
    endif
    while ac <= max
       let gc=s:GetChar(ac)
       let ge=s:GetEntity(ac)
       if gc != ge && ac >= 0x80 && ac <= 0xFF
           "let rv=rv . ran . 's/' . s:GetChar(ac) . '/\' . s:GetEntity(ac) . '/ge' . "\n"
           let rv=rv . ran . 's/' . gc . '/\' . ge . '/ge' . "\n"
       endif
       let ac=ac + 1
    endwhile
    return rv
endfunction

function s:Fmh(firl, lasl, ...)
    "From html entity to character
    let ran=a:firl . ',' . a:lasl
    let ac=0x80
    let max=0xFF
    let special=""
    let rv=""
    if a:0 > 0
        let ac=a:1
    endif    
    if a:0 > 1
        let max=a:2
    endif    
    if a:0 > 2
        let special=a:3
    endif
    if ac == 0 && max == 0
       let ac=1
    endif
    if match(special, "&") != -1
        let cn=0x26
        let rv=rv . ran . 's/' . s:GetEntity(cn) . '/\' . s:GetChar(cn) . '/ge' . "\n"
    endif
    if match(special, "<") != -1
        let cn=0x3C
        let rv=rv . ran . 's/' . s:GetEntity(cn) . '/' . s:GetChar(cn) . '/ge' . "\n"
    endif
    if match(special, ">") != -1
        let cn=0x3E
        let rv=rv . ran . 's/' . s:GetEntity(cn) . '/' . s:GetChar(cn) . '/ge' . "\n"
    endif
    if match(special, "\"") != -1
        let cn=0x22
        let rv=rv . ran . 's/' . s:GetEntity(cn) . '/' . s:GetChar(cn) . '/ge' . "\n"
    endif
    while ac <= max
       let gc=s:GetChar(ac)
       let ge=s:GetEntity(ac)
       if gc != ge && ac >= 0x80 && ac <= 0xFF
           "let rv=rv . ran . 's/' . s:GetEntity(ac) . '/' . s:GetChar(ac) . '/ge' . "\n"
           let rv=rv . ran . 's/' . ge . '/' . gc . '/ge' . "\n"
       endif
       let ac=ac + 1
    endwhile
    return rv
endfunction

function s:Toa(firl, lasl, ...)
    "To ascii from character (nearest reasonable look-alike ascii character)
    "Good for translating cp1252 to latin1 which is generally not possible.
    "One exception: make a cp1252 bullet a middot.
    let ran=a:firl . ',' . a:lasl
    let ac=0x80
    let max=0xFF
    let special=""
    let rv=""
    if a:0 > 0
        let ac=a:1
    endif    
    if a:0 > 1
        let max=a:2
    endif    
    if a:0 > 2
        let special=a:3
    endif
    if ac == 0 && max == 0
       let ac=1
    endif
    if match(special, "&") != -1
        let cn=0x26
        "from :help @! -- foo\(bar\)\@!         any "foo" not followed by "bar"
        let rv=rv . ran . 's/&\([a-zA-Z0-9#]\{2,6};\)\@!/\&amp;/ge' . "\n"
    endif
    if match(special, "<") != -1
        let cn=0x3C
        let rv=rv . ran . 's/' . s:GetChar(cn) . '/\' . s:GetAsciiSim(cn) . '/ge' . "\n"
    endif
    if match(special, ">") != -1
        let cn=0x3E
        let rv=rv . ran . 's/' . s:GetChar(cn) . '/\' . s:GetAsciiSim(cn) . '/ge' . "\n"
    endif
    if match(special, "\"") != -1
        let cn=0x22
        let rv=rv . ran . 's/' . s:GetChar(cn) . '/\' . s:GetAsciiSim(cn) . '/ge' . "\n"
    endif
    while ac <= max
       let gc=s:GetChar(ac)
       let ge=s:GetAsciiSim(ac)
       if gc != ge && ac >= 0x80 && ac <= 0xFF
           "let rv=rv . ran . 's/' . s:GetChar(ac) . '/' . s:GetAsciiSim(ac) . '/ge' . "\n"
           let rv=rv . ran . 's/' . gc . '/' . ge . '/ge' . "\n"
        endif
        let ac=ac + 1
    endwhile
    return rv
endfunction

function s:GetAsciiSim(code)
    if type(a:code) == 1
        let ncode=s:Tobase(10, a:code)
    else
        let ncode=a:code
    endif
    if !exists("s:chars")
        call s:Chars()
    endif
    if !exists("s:asciis")
        call s:AsciiSims()
    endif
    let ent=strpart(s:asciis, ncode * 11, 11)
    let amp=match(ent, "&")
    let sc=match(ent, ";")
    if amp != -1 && sc != -1 && sc > amp
        let len=sc - amp + 1
        if ncode != 0x3C && ncode != 0x3E && len < 5 || ncode == 0x85 || ncode == 0x97 || ncode == 0xAC || ncode == 0xB1 || ncode == 0xBC || ncode == 0xBD || ncode == 0xBE
            let len=sc - amp - 1
            let amp=amp + 1
        endif
        let rv=strpart(ent, amp, len)
    else
        let rv=strpart(s:chars, ncode * 2 - 2, 2)
        if strpart(rv, 0, 1) == strpart(rv, 1, 1)
            let rv=strpart(rv, 0, 1)
       endif
    endif
    return rv
endfunction

function s:AsciiSims()
    if exists("s:asciis")
        return s:asciis
    endif
    let c=0
    let st=""
    while c < 0x80
        if c < 16
            let lz="0"
        else
            let lz=""
        endif
        let st1='x' . lz . s:Tobase(16, c) . 'x' . lz . s:Tobase(16, c)
        if c == 0x26
            let st1=s:Pad("x26&amp;", 11)
        elseif c == 0x3C
            let st1=s:Pad("x3C&lt;", 11)
        elseif c == 0x3E
            let st1=s:Pad("x3E&gt;", 11)
        elseif c == 0x22
            let st1=s:Pad("x22&quot;", 11)
        endif
        let st=st . s:Pad(st1, 11)
        let c=c + 1
    endwhile
    let st=st . s:Pad("x80&E;", 11)
    let st=st . s:Pad("x81x81", 11)
    let st=st . s:Pad("x82&';", 11)
    let st=st . s:Pad("x83&f;", 11)
    let st=st . s:Pad("x84&\";", 11)
    let st=st . s:Pad("x85& ... ;", 11)
    let st=st . s:Pad("x86&+;", 11)
    let st=st . s:Pad("x87&+;", 11)
    let st=st . s:Pad("x88&^;", 11)
    let st=st . s:Pad("x89&%;", 11)
    let st=st . s:Pad("x8A&S;", 11)
    let st=st . s:Pad("x8B&<;", 11)
    let st=st . s:Pad("x8C&OE;", 11)
    let st=st . s:Pad("x8Dx8D", 11)
    let st=st . s:Pad("x8E&Z;", 11)
    let st=st . s:Pad("x8Fx8F", 11)
    let st=st . s:Pad("x90x90", 11)
    let st=st . s:Pad("x91&';", 11)
    let st=st . s:Pad("x92&';", 11)
    let st=st . s:Pad("x93&\";", 11)
    let st=st . s:Pad("x94&\";", 11)
    let st=st . s:Pad("x95&" . nr2char(0xB7) . ";", 11)
    let st=st . s:Pad("x96&-;", 11)
    let st=st . s:Pad("x97& -- ;", 11)
    let st=st . s:Pad("x98&~;", 11)
    let st=st . s:Pad("x99&TM;", 11)
    let st=st . s:Pad("x9A&s;", 11)
    let st=st . s:Pad("x9B&>;", 11)
    let st=st . s:Pad("x9C&oe;", 11)
    let st=st . s:Pad("x9Dx9D", 11)
    let st=st . s:Pad("x9E&z;", 11)
    let st=st . s:Pad("x9F&Y;", 11)
    let st=st . s:Pad("xA0& ;", 11)
    let st=st . s:Pad("xA1&!;", 11)
    let st=st . s:Pad("xA2&c;", 11)
    let st=st . s:Pad("xA3&L;", 11)
    let st=st . s:Pad("xA4&c;", 11)
    let st=st . s:Pad("xA5&y;", 11)
    let st=st . s:Pad("xA6&|;", 11)
    let st=st . s:Pad("xA7&S;", 11)
    let st=st . s:Pad("xA8&..;", 11)
    let st=st . s:Pad("xA9&c;", 11)
    let st=st . s:Pad("xAA&o;", 11)
    let st=st . s:Pad("xAB&<<;", 11)
    let st=st . s:Pad("xAC&NOT;", 11)
    let st=st . s:Pad("xAD&-;", 11)
    let st=st . s:Pad("xAE&R;", 11)
    let st=st . s:Pad("xAF&-;", 11)
    let st=st . s:Pad("xB0&o;", 11)
    let st=st . s:Pad("xB1&+\\/-;", 11)
    let st=st . s:Pad("xB2&2;", 11)
    let st=st . s:Pad("xB3&3;", 11)
    let st=st . s:Pad("xB4&';", 11)
    let st=st . s:Pad("xB5&u;", 11)
    let st=st . s:Pad("xB6&P;", 11)
    let st=st . s:Pad("xB7&" . nr2char(0xB7) . ";", 11)
    let st=st . s:Pad("xB8&,;", 11)
    let st=st . s:Pad("xB9&1;", 11)
    let st=st . s:Pad("xBA&o;", 11)
    let st=st . s:Pad("xBB&>>;", 11)
    let st=st . s:Pad("xBC&1\\/4;", 11)
    let st=st . s:Pad("xBD&1\\/2;", 11)
    let st=st . s:Pad("xBE&3\\/4;", 11)
    let st=st . s:Pad("xBF&?;", 11)
    let st=st . s:Pad("xC0&A;", 11)
    let st=st . s:Pad("xC1&A;", 11)
    let st=st . s:Pad("xC2&A;", 11)
    let st=st . s:Pad("xC3&A;", 11)
    let st=st . s:Pad("xC4&A;", 11)
    let st=st . s:Pad("xC5&A;", 11)
    let st=st . s:Pad("xC6&AE;", 11)
    let st=st . s:Pad("xC7&C;", 11)
    let st=st . s:Pad("xC8&E;", 11)
    let st=st . s:Pad("xC9&E;", 11)
    let st=st . s:Pad("xCA&E;", 11)
    let st=st . s:Pad("xCB&E;", 11)
    let st=st . s:Pad("xCC&I;", 11)
    let st=st . s:Pad("xCD&I;", 11)
    let st=st . s:Pad("xCE&I;", 11)
    let st=st . s:Pad("xCF&I;", 11)
    let st=st . s:Pad("xD0&E;", 11)
    let st=st . s:Pad("xD1&N;", 11)
    let st=st . s:Pad("xD2&O;", 11)
    let st=st . s:Pad("xD3&O;", 11)
    let st=st . s:Pad("xD4&O;", 11)
    let st=st . s:Pad("xD5&O;", 11)
    let st=st . s:Pad("xD6&O;", 11)
    let st=st . s:Pad("xD7&x;", 11)
    let st=st . s:Pad("xD8&O;", 11)
    let st=st . s:Pad("xD9&U;", 11)
    let st=st . s:Pad("xDA&U;", 11)
    let st=st . s:Pad("xDB&U;", 11)
    let st=st . s:Pad("xDC&U;", 11)
    let st=st . s:Pad("xDD&Y;", 11)
    let st=st . s:Pad("xDE&T;", 11)
    let st=st . s:Pad("xDF&sz;", 11)
    let st=st . s:Pad("xE0&a;", 11)
    let st=st . s:Pad("xE1&a;", 11)
    let st=st . s:Pad("xE2&a;", 11)
    let st=st . s:Pad("xE3&a;", 11)
    let st=st . s:Pad("xE4&a;", 11)
    let st=st . s:Pad("xE5&a;", 11)
    let st=st . s:Pad("xE6&ae;", 11)
    let st=st . s:Pad("xE7&c;", 11)
    let st=st . s:Pad("xE8&e;", 11)
    let st=st . s:Pad("xE9&e;", 11)
    let st=st . s:Pad("xEA&e;", 11)
    let st=st . s:Pad("xEB&e;", 11)
    let st=st . s:Pad("xEC&i;", 11)
    let st=st . s:Pad("xED&i;", 11)
    let st=st . s:Pad("xEE&i;", 11)
    let st=st . s:Pad("xEF&i;", 11)
    let st=st . s:Pad("xF0&e;", 11)
    let st=st . s:Pad("xF1&n;", 11)
    let st=st . s:Pad("xF2&o;", 11)
    let st=st . s:Pad("xF3&o;", 11)
    let st=st . s:Pad("xF4&o;", 11)
    let st=st . s:Pad("xF5&o;", 11)
    let st=st . s:Pad("xF6&o;", 11)
    let st=st . s:Pad("xF7&\\/;", 11)
    let st=st . s:Pad("xF8&o;", 11)
    let st=st . s:Pad("xF9&u;", 11)
    let st=st . s:Pad("xFA&u;", 11)
    let st=st . s:Pad("xFB&u;", 11)
    let st=st . s:Pad("xFC&u;", 11)
    let st=st . s:Pad("xFD&y;", 11)
    let st=st . s:Pad("xFE&t;", 11)
    let st=st . s:Pad("xFF&y;", 11)
    let s:asciis=st
    return s:asciis
endfunction
