" Vim syntax file
" Language: AddressBook
" Maintainer: deluxghost <deluxghost@gmail.com>
" Last Change: 2014 Feb 13
if exists("b:current_syntax")
    finish
endif
syn case match
syn keyword addrType name tag tel addr im email web other birth id
syn keyword addrFlat work home mobi qq irc gtalk bm
syn match addrComment /"[^"]\+$/
syn match addrString /\("[^"]*"\)\|\('[^']*'\)/
syn match addrUsertype "|.*|"
syn match addrNames "\(^name \)\@<=.*"
syn match addrEmail "\S\+@\S\+"
syn match addrWeb "http[s]\=://\S\+"
syn match addrNumber "\(\d\|-\)\+"
syn match addrBM "BM-\w\{34}"
hi def link addrComment Comment
hi def link addrString String
hi def link addrUsertype Statement
hi def link addrType Statement
hi def link addrFlat Type
hi def link addrNames Special
hi def link addrEmail Underlined
hi def link addrWeb Underlined
hi def link addrNumber Number
hi def link addrBM Underlined

