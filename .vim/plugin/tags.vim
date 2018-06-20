"/Users/marcotrosi/Code/config/vim/plugin/taglist.vim

function! Tags()

   let s:ListOfTags          = {}
   let s:ListOfDisplayedTags = []

   for tg in taglist('^')
      if has_key(s:ListOfTags, tg.kind) == 0
         let s:ListOfTags[tg.kind] = []
      endif
      call add(s:ListOfTags[tg.kind], tg.name)
   endfor

   for [kind, lst] in items(s:ListOfTags)
      call add(s:ListOfDisplayedTags, ' ' . KindToString(kind))
      for sym in lst
         call add(s:ListOfDisplayedTags, '    ' . sym)
      endfor
      call add(s:ListOfDisplayedTags, '')
   endfor
   call add(s:ListOfDisplayedTags, '')

   let l:Content = join(s:ListOfDisplayedTags, "\n")

   return [40, l:Content, 1]
endfunction

function! TagsSetup()
   syn clear
   setlocal cursorline
   setlocal statusline=\ TAGS
endfunction

function! KindToString(kind)
   if     (a:kind == 'c')||(a:kind == 'class')     "classes
      return 'CLASSES'
   elseif (a:kind == 'd')||(a:kind == 'macro')     "macro definitions
      return 'MACROS'
   elseif (a:kind == 'f')||(a:kind == 'function')  "function definitions
      return 'FUNCTIONS'
   elseif (a:kind == 'F')||(a:kind == 'file')      "file
      return 'FILES'
   elseif (a:kind == 'g')||(a:kind == 'enum')      "enumeration names
      return 'ENUMERATIONS'
   elseif (a:kind == 'e')||(a:kind == 'enumerator')"enumerators (values inside an enumeration)
      return 'ENUMERATORS'
   elseif (a:kind == 'l')||(a:kind == 'local')     "local variables
      return 'LOCAL_VARIABLES'
   elseif (a:kind == 'm')||(a:kind == 'member')    "class, struct, and union members
      return 'MEMBERS'
   " elseif (a:kind == 'n')||(a:kind == 'namespace') "namespaces
   "    return 'NAMESPACES'
   elseif (a:kind == 'p')||(a:kind == 'prototype') "function prototypes
      return 'PROTOTYPES'
   elseif (a:kind == 's')||(a:kind == 'struct')    "structure names
      return 'STRUCTURES'
   elseif (a:kind == 't')||(a:kind == 'typedef')   "typedefs
      return 'TYPEDEFS'
   elseif (a:kind == 'u')||(a:kind == 'union')     "union names
      return 'UNIONS'
   elseif (a:kind == 'v')||(a:kind == 'variable')  "variable definitions
      return 'VARIABLES'
   elseif a:kind == 'x'                            "external and forward variable declarations
      return 'EXTERNAL_VARIABLES'
   end
endfunction

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
