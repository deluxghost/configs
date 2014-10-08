" Vim indent file
" Language:	AddressBook
" Maintainer: deluxghost <deluxghost@gmail.com>
" Last Change: 2014 Feb 13

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetABIndent()
setlocal indentkeys+==name,=tag

if exists("*GetABIndent")
  finish
endif

function GetABIndent()
    if getline(v:lnum) =~ 'name'
        return 0
    endif
    if getline(v:lnum) =~ 'tag'
        return 4
    endif
    return -1
endfunction
