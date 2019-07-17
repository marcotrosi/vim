if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

setlocal comments=s:--[[,m:_,e:--]],:--
setlocal commentstring=\ --\ %s
setlocal iskeyword+=:
