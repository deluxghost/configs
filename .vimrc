set nocompatible
set fileencodings=utf-8,gbk,gb18030
set shortmess=atI
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set number
set expandtab
set showcmd
set incsearch
set showmatch
set cryptmethod=blowfish
set cursorline
syntax on
filetype plugin indent on
highlight colorcolumn ctermbg=grey ctermfg=darkblue
highlight cursorline cterm=none ctermfg=white ctermbg=darkblue
highlight pmenu ctermbg=lightmagenta ctermfg=white
highlight pmenusel ctermbg=lightgreen ctermfg=white
highlight Comment ctermfg=lightblue

nmap <F2> :!
nmap <F8> :!gdb ./
nmap <F9> :make<CR>
nmap <F10> :make clean<CR>
nmap <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "$@"<CR>
nmap <Tab> <C-w>w
nmap wm :WMToggle<CR>:echo "Window Manager Toggled"<CR>
nmap tm :echo strftime("Time: %Y-%m-%d %H:%M:%S")<CR>
nmap sh :!./
nmap bb :b
nmap sc :call Set_colorcolumn()<CR>
nmap sz :call Set_foldmethod()<CR>
nmap si :call Set_indent()<CR>

let Tlist_Show_One_File=0
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close=1
let g:winManagerWindowLayout='FileExplorer|TagList|BufExplorer'
let g:winManagerWidth=30
let g:SuperTabRetainCompletionType=2
let g:NERDTree_title = "[NERDTree]"
function! NERDTree_Start()
    exe 'NERDTree'
endfunction
function! NERDTree_IsValid()
    return 1
endfunction

function Set_colorcolumn()
    if &colorcolumn == "81"
        set colorcolumn=
        echo "Set No ColorColumn"
    else
        set colorcolumn=81
        echo "Set ColorColumn"
    endif
endfunction
function Set_foldmethod()
    if &foldmethod == "indent"
        set foldmethod=manual
        normal zR
        echo "Set No Fold"
    else
        set foldmethod=indent
        normal zM
        echo "Set Fold"
    endif
endfunction
function Set_indent()
    if &cindent
        set nocindent
        set nosmartindent
        set noautoindent
        echo "Set No AutoIndent"
    else
        set cindent
        set smartindent
        set autoindent
        echo "Set AutoIndent"
    endif
endfunction
