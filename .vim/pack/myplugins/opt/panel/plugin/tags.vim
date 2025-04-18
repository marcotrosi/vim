" TODO replace s:KindToString() function with dictionary
" TODO check if l: or s: shall be used for each symbol
" TODO handle documentation per Markdown file
" TODO maybe add display text to initial dictionary, like done for Doc tags
" TODO in case of big tag files, maybe caching and regularly checking if tag has been written
" TODO should the tags be listed again under their respective file?
" TODO remember panel state?
" TODO jumping to file+line without closing panel?
" TODO show function names for local variables OR ignore local variables
" TODO skim popup filter

" ctags --langmap=c:.c.h -f .tags -R --tag-relative=yes --extra=+fq --fields=+znimsStK --c-kinds=+lpx --sort=yes<CR>

let s:KindHeaderStates = {}

function! s:SortByLine(i1, i2) " <<<
   return a:i1['line'] - a:i2['line']
endfunction " >>>

function! Tags() " <<<

   let s:ListOfTags           = {}
   let s:ListOfTagKinds       = []
   let s:KindHeaderLineNums   = {}
   let s:ListOfDisplayedLines = []
   let s:ListOfTagLocations   = []
   let s:ListOfDocSections    = []
   let s:ListOfDocSecTypes    = [ 'chapter' , 'section' , 'subsection' , 'subsubsection' , 'l4subsection' , 'l5subsection' ]

   for tg in taglist('^')
      if index(s:ListOfDocSecTypes, tg.kind) != -1
         call add(s:ListOfDocSections, {'name':tg.name, 'filename':tg.filename, 'line':tg.line, 'kind':tg.kind, 'text':repeat(' ', 4+index(s:ListOfDocSecTypes, tg.kind)) .. tg.name})
         continue
      endif

      if has_key(s:ListOfTags, tg.kind) == 0
         let s:ListOfTags[tg.kind] = []
         call add(s:ListOfTagKinds, tg.kind)
      endif
      call add(s:ListOfTags[tg.kind], {'name':tg.name, 'filename':tg.filename, 'line':tg.line, 'kind':tg.kind})
   endfor

   messages clear

   " handle makefile targets <<<
   let l:IndexToShift = index(s:ListOfTagKinds, 'target')
   if l:IndexToShift != -1
      call add(s:ListOfTagKinds, remove(s:ListOfTagKinds, l:IndexToShift))
      call sort(s:ListOfTags['target'])
   endif
   " >>>

   " handle list of files <<<
   let l:IndexToShift = index(s:ListOfTagKinds, 'file')
   if l:IndexToShift != -1
      call add(s:ListOfTagKinds, remove(s:ListOfTagKinds, l:IndexToShift))
      call sort(s:ListOfTags['file'])
   endif
   " >>>

   " handle documentation <<<
   if len(s:ListOfDocSections) != 0
      call sort(s:ListOfDocSections, 's:SortByLine')
   endif
   " >>>

   for kind in s:ListOfTagKinds
      if has_key(s:KindHeaderStates, kind) && s:KindHeaderStates[kind]
         let l:HeaderStateSign = ' ▼ '
      " let s:KindHeaderStates[kind] = 1
      else
         let l:HeaderStateSign = ' ▶︎ '
         let s:KindHeaderStates[kind] = 0
      endif

      call add(s:ListOfDisplayedLines, l:HeaderStateSign . s:KindToString(kind))
      call add(s:ListOfTagLocations  , {'name':'', 'filename':'', 'line':'', 'kind':kind})
      let s:KindHeaderLineNums[kind]=len(s:ListOfDisplayedLines)

      if s:KindHeaderStates[kind]
         for tg in s:ListOfTags[kind]
            if (kind == 'member') && (match(tg.name, '::') == -1)
               continue
            endif
            call add(s:ListOfDisplayedLines, '    ' . tg.name)
            call add(s:ListOfTagLocations, tg)
         endfor
      endif

      " add empty line
      " call add(s:ListOfDisplayedLines, '')
      " call add(s:ListOfTagLocations  , {'name':'', 'filename':'', 'line':'', 'kind':''})

   endfor

   " let l:Content = join(s:ListOfDisplayedLines, "\n")
   " return [40, l:Content, 1] " TODO detect longest tag and adjust panel width
   return [40, s:ListOfDisplayedLines, 1] " TODO detect longest tag and adjust panel width
endfunction " >>>

function! TagsSetup() " <<<
   syn clear
   setlocal cursorline
   setlocal statusline=\ TAGS
   map <silent> <nowait> <buffer> o :call TagOpen()<CR>
   map <silent> <nowait> <buffer> <CR> :call TagOpen()<CR>
   map <silent> <nowait> <buffer> p :call TagPreview()<CR>
   map <silent> <nowait> <buffer> c :call TagClose()<CR>
   map <silent> <nowait> <buffer> e :call TagExpand()<CR>
   map <silent> <nowait> <buffer> f :call TagFold()<CR>
endfunction " >>>

function! TagOpen() " <<<
   let l:idx = line('.')-1
   let l:FileName = s:ListOfTagLocations[l:idx].filename
   let l:LineNum  = s:ListOfTagLocations[l:idx].line
   let l:Kind     = s:ListOfTagLocations[l:idx].kind

   if l:FileName != ''
      pclose
      bwipeout
      exec 'edit +'.l:LineNum.' '.l:FileName
      norm zz
   else
      if l:Kind != ''
         let s:KindHeaderStates[l:Kind] = 1
         call PanelUpdate()
         call cursor(l:idx+2, 1)
      endif
   endif
endfunction " >>>

function! TagPreview() " <<<
   let l:idx = line('.')-1
   let l:FileName = s:ListOfTagLocations[l:idx].filename
   let l:LineNum  = s:ListOfTagLocations[l:idx].line

   if l:FileName != ''
      let l:PanelWinNum = winnr() " get win number of __PANEL__
      wincmd p " go back to the window from which __PANEL__ was opened
      exec 'pedit +'.l:LineNum.' '.l:FileName
      exec l:PanelWinNum . 'wincmd w'
   endif
endfunction " >>>

function! TagClose() " <<<
   let l:idx  = line('.')-1
   let l:Kind = s:ListOfTagLocations[l:idx].kind

   if l:Kind != ''
      let s:KindHeaderStates[l:Kind] = 0
      call PanelUpdate()
      call cursor(s:KindHeaderLineNums[l:Kind], 1)
   endif
endfunction " >>>

function! TagExpand() " <<<
   for [kind, value] in items(s:KindHeaderStates)
      let s:KindHeaderStates[kind]=1
   endfor
   call PanelUpdate()
endfunction " >>>

function! TagFold() " <<<
   for [kind, value] in items(s:KindHeaderStates)
      let s:KindHeaderStates[kind]=0
   endfor
   call PanelUpdate()
endfunction " >>>

function! s:KindToString(kind) " <<<
   if     (a:kind == 'c')||(a:kind == 'class')      "classes
      return 'CLASSES'
   elseif (a:kind == 'd')||(a:kind == 'macro')      "macro definitions
      return 'MACROS'
   elseif (a:kind == 'f')||(a:kind == 'function')   "function definitions
      return 'FUNCTIONS'
   elseif (a:kind == 'F')||(a:kind == 'file')       "file
      return 'FILES'
   elseif (a:kind == 'g')||(a:kind == 'enum')       "enumeration names
      return 'ENUMERATIONS'
   elseif (a:kind == 'e')||(a:kind == 'enumerator') "enumerators (values inside an enumeration)
      return 'ENUMERATORS'
   elseif (a:kind == 'l')||(a:kind == 'local')      "local variables
      return 'LOCAL_VARIABLES'
   elseif (a:kind == 'm')||(a:kind == 'member')     "class, struct, and union members
      return 'MEMBERS'
   " elseif (a:kind == 'n')||(a:kind == 'namespace')  "namespaces
   "    return 'NAMESPACES'
   elseif (a:kind == 'p')||(a:kind == 'prototype')  "function prototypes
      return 'PROTOTYPES'
   elseif (a:kind == 's')||(a:kind == 'struct')     "structure names
      return 'STRUCTURES'
   elseif (a:kind == 't')||(a:kind == 'typedef')    "typedefs
      return 'TYPEDEFS'
   elseif (a:kind == 'u')||(a:kind == 'union')      "union names
      return 'UNIONS'
   elseif (a:kind == 'v')||(a:kind == 'variable')   "variable definitions
      return 'VARIABLES'
   elseif (a:kind == 'x')||(a:kind == 'externvar')  "external and forward variable declarations
      return 'EXTERNAL_VARIABLES'
   elseif a:kind == 'target'                        "makefile targets
      return 'MAKE_TARGETS'
   elseif a:kind == 'chapter'                       "documentation chapter
      return 'CHAPTER'
   elseif a:kind == 'section'                       "documentation section
      return 'SECTION'
   elseif a:kind == 'subsection'                    "documentation subsection
      return 'SUBSECTION'
   elseif a:kind == 'l4subsection'                  "documentation level 4 subsection
      return 'L4SUBSECTION'
   elseif a:kind == 'l5subsection'                  "documentation level 5 subsection
      return 'L5SUBSECTION'
   end
   " a Access (or export) of class members
   " f File-restricted scoping [enabled]
   " i Inheritance information
   " k Kind of tag as a single letter [enabled]
   " K Kind of tag as full name
   " l Language of source file containing tag
   " m Implementation information
   " n Line number of tag definition
   " s Scope of tag definition [enabled]
   " S Signature of routine (e.g. prototype or parameter list)
   " z Include the "kind:" key in kind field
   " t Type and name of a variable or typedef as "typeref:" field [enabled]

endfunction " >>>

