" Vim syntax file
" Language:	DXL
" Maintainer:	XXX
" Last Change:
" Remark:

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syntax case match

syntax keyword dxlBaseType bool char int
syntax keyword dxlBaseType real string void

syntax keyword dxlStatement and
syntax keyword dxlStatement break
syntax keyword dxlStatement by
syntax keyword dxlStatement continue
syntax keyword dxlStatement module
syntax keyword dxlStatement object
syntax keyword dxlStatement or
syntax keyword dxlStatement pragma
syntax keyword dxlStatement return
syntax keyword dxlStatement sizeof
syntax keyword dxlStatement static

syntax keyword dxlConditional if
syntax keyword dxlConditional then
syntax keyword dxlConditional else

syntax keyword dxlRepeat for
syntax keyword dxlRepeat in
syntax keyword dxlRepeat do
syntax keyword dxlRepeat while

syntax keyword dxlReserved case
syntax keyword dxlReserved const
syntax keyword dxlReserved default
syntax keyword dxlReserved enum
syntax keyword dxlReserved struct
syntax keyword dxlReserved switch
syntax keyword dxlReserved union

syntax keyword dxlType AccessRec ArchiveData ArchiveItem Array
syntax keyword dxlType AttrBaseType AttrDef Attribute AttrType
syntax keyword dxlType Baseline BaselineSet BaselineSetDefinition Buffer
syntax keyword dxlType Column ConfStream ConfType Database Date DB DBE
syntax keyword dxlType EmbeddedOleObject ExternalLink ExternalLinkBehavior
syntax keyword dxlType ExternalLinkDirection Filter Folder Group GroupList
syntax keyword dxlType History HistorySession HistoryType
syntax keyword dxlType Icon InPartition IPC Item Justification
syntax keyword dxlType Language Link LinkFilter LinkRef Linkset Locale
syntax keyword dxlType Lock LockList Module ModuleProperties ModuleVersion
syntax keyword dxlType Object OleAutoObj OleAutoArgs OutPartition
syntax keyword dxlType PageLayout PartitionAttribute PartitionDefinition
syntax keyword dxlType PartitionFile PartitionModule PartitionPermission
syntax keyword dxlType PartitionView Permission Project Regexp RichText
syntax keyword dxlType SignatureEntry SignatureInfo Skip Sort SpellingOptions
syntax keyword dxlType Stream Template Trigger User UserList UserNotifyList
syntax keyword dxlType View ViewDef

syntax region dxlInclude start=/#include/ end=/$/ contains=dxlComment keepend

syntax keyword dxlTodo contained TODO FIXME XXX

syntax region dxlString start=/L\="/ skip=/\\\\\|\\"/ end=/"/

syntax region dxlCommentLine start=+//+ skip=/\\$/ end=/$/ keepend contains=dxlTodo
syntax region dxlComment start="/\*" end="\*/" contains=dxlTodo fold extend

syntax region dxlBlock start="{" end="}" transparent fold
syntax sync ccomment dxlComment minlines=50

hi def link dxlBaseType		Type
hi def link dxlStatement	Statement
hi def link dxlConditional	Conditional
hi def link dxlRepeat		Repeat
hi def link dxlString		String
hi def link dxlCommentLine	Comment
hi def link dxlComment		Comment
hi def link dxlInclude		Include
hi def link dxlTodo		Todo
hi def link dxlReserved		Error
hi def link dxlType		Identifier

let b:current_syntax = "dxl"
