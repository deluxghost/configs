set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
runtime autoload/vundle.vim

function! Start_Vundle()
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'ervandew/supertab'
    Plugin 'ctrlpvim/ctrlp.vim'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'ntpeters/vim-better-whitespace'
    call vundle#end()
    let g:vundle_installed = 1
endfunction

function! Install_Vundle()
    echomsg "Installing Vundle..."
    if executable("git")
        execute "!git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
        if v:shell_error
            echomsg "Failed to install: can't clone repo. Please install Vundle manually."
            echomsg "All plugins are disabled."
        else
            echomsg "Vundle has been installed."
            call Start_Vundle()
            autocmd VimEnter * PluginInstall
        endif
    else
        echomsg "Failed to install: git not found. Install git and try again."
        echomsg "All plugins are disabled."
    endif
endfunction

if exists("*vundle#rc")
    call Start_Vundle()
else
    call Install_Vundle()
endif

set fileencodings=utf-8,gbk,gb18030
set shortmess=atI
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set number
set expandtab
set showcmd
set incsearch
set ignorecase
set showmatch
set cursorline
set wildmenu
set showtabline=2
set laststatus=2

set statusline=
set statusline+=%1*%<%F
set statusline+=\ %2*\ %{'['.(&filetype!=''?&filetype:'none').']'}
set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}%{(&bomb?\",bom\":\"\")}
set statusline+=\ %{&fileformat}
set statusline+=\ %0*%=%2*\ Ln\ %l/%L\ Col\ %c
set statusline+=\ %1*%m%r%w\ %P\ %0*
highlight User1 ctermbg=Yellow ctermfg=DarkGrey
highlight User2 ctermbg=Blue ctermfg=White

syntax on
filetype plugin indent on
highlight TabLine ctermbg=Yellow ctermfg=DarkGrey
highlight TabLineSel ctermbg=Blue ctermfg=White
highlight TabLineFill ctermbg=Blue ctermfg=LightGrey
highlight ColorColumn ctermbg=grey ctermfg=darkblue
highlight CursorLine cterm=none ctermfg=white ctermbg=darkblue
highlight Pmenu ctermbg=lightmagenta ctermfg=white
highlight PmenuSel ctermbg=lightgreen ctermfg=white
highlight PmenuSbar ctermbg=lightmagenta
highlight PmenuThumb ctermbg=yellow
highlight Comment ctermfg=lightblue

let mapleader = ","
nmap <leader>c :call Set_ColorColumn()<CR>
nmap <leader>z :call Set_FoldMethod()<CR>
nmap <leader>i :call Set_AutoIndent()<CR>
nmap <silent> <leader>p :call PasteMode()<CR>
nmap <silent> <leader>op :normal o<CR>:call PasteMode()<CR>
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

if !exists("g:autocmd_vimrc")
    let g:autocmd_vimrc = 1
    autocmd! InsertLeave * set nopaste
    autocmd! BufWritePost $MYVIMRC source %
    command! P r !cat
    if exists("*strftime")
        command! Time echo strftime("Time: %F %a %T")
    endif
endif

function! Set_ColorColumn()
    if &colorcolumn == "81"
        set colorcolumn=
        echo "ColorColumn Off"
    else
        set colorcolumn=81
        echo "ColorColumn On"
    endif
endfunction
function! Set_FoldMethod()
    if &foldmethod == "indent"
        set foldmethod=manual
        normal zR
        echo "Fold Off"
    else
        set foldmethod=indent
        normal zM
        echo "Fold On"
    endif
endfunction
function! Set_AutoIndent()
    if &autoindent
        set noautoindent
        echo "AutoIndent Off"
    else
        set autoindent
        echo "AutoIndent On"
    endif
endfunction
function! PasteMode()
    set paste
    startinsert
endfunction

if exists("g:vundle_installed")
    nmap <leader><leader>p :PluginInstall<CR>
    nmap <leader><space><space> :StripWhitespace<CR>:echo "Whitespace Cleared!"<CR>
    let g:ctrlp_map = '<C-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc|pyo|pyd)$',
    \ }
endif
