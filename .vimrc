" Use Vim instead of Vi
set nocompatible
" Load Vundle runtime
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
runtime autoload/vundle.vim

" Init Vundle and load plugins
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

" Install Vundle automatically
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

" Check and install Vundle on first time
if exists("*vundle#rc")
    call Start_Vundle()
else
    call Install_Vundle()
endif

" Detect file encoding automatically
set fileencodings=utf-8,gbk,gb18030
" How many lines of history can vim remember
set history=700
" Disable welcome message
set shortmess=atI
" Set width of tab to 4
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Reload when a file is changed outside
set autoread
" Enable auto indent
set autoindent
" Show line number
set number
" Use space instead of tab
set expandtab
" Show command at the last line
set showcmd
" Show search matches dynamically
set incsearch
" Highlight search results
set hlsearch
" Ignore case when searching
set ignorecase
" Only ignore case when pattern contains no upper case
set smartcase
" Show matching brackets
set showmatch
" Highlight current line
set cursorline
" Auto completion of command-line
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.pyo
" Arrow keys can wrap line on insert mode
set whichwrap=b,s,[,]
" Show tab bar
set showtabline=2
" Show status bar
set laststatus=2

" Set the format of status bar
set statusline=
" Filename
set statusline+=%1*%<%F
" Filetype, encoding and file format (line-ending)
set statusline+=\ %2*\ %{'['.(&filetype!=''?&filetype:'none').']'}
set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}%{(&bomb?\",bom\":\"\")}
set statusline+=\ %{&fileformat}
" Line and column number
set statusline+=\ %0*%=%2*\ Ln\ %l/%L\ Col\ %c
" Modified, readonly, preview and others
set statusline+=\ %1*%m%r%w\ %P\ %0*
" Highlight status bar
highlight User1 ctermbg=Yellow ctermfg=DarkGrey
highlight User2 ctermbg=Blue ctermfg=White

" Enable syntax highlighting
syntax on
" Enable filetype plugins and indents
filetype plugin indent on
" Highlight tab bar
highlight TabLine ctermbg=Yellow ctermfg=DarkGrey
highlight TabLineSel ctermbg=Blue ctermfg=White
highlight TabLineFill ctermbg=Blue ctermfg=LightGrey
" Highlight color column and current line
highlight ColorColumn ctermbg=grey ctermfg=darkblue
highlight CursorLine cterm=none ctermfg=white ctermbg=darkblue
" Highlight popup menu
highlight Pmenu ctermbg=lightmagenta ctermfg=white
highlight PmenuSel ctermbg=lightgreen ctermfg=white
highlight PmenuSbar ctermbg=lightmagenta
highlight PmenuThumb ctermbg=yellow
" Highlight comment
highlight Comment ctermfg=lightblue

" Set map leader
let mapleader = ","
let g:mapleader = ","
" General mapping
" Toggles
nmap <leader>c :call Set_ColorColumn()<CR>
nmap <leader>z :call Set_FoldMethod()<CR>
nmap <leader>i :call Set_AutoIndent()<CR>
" Go PasteMode
nmap <silent> <leader>p :call PasteMode()<CR>
" Go PasteMode from a new line
nmap <silent> <leader>op :normal o<CR>:call PasteMode()<CR>
" Switch tabs
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

" Declare commands and auto commands
if !exists("g:autocmd_vimrc")
    let g:autocmd_vimrc = 1
    " Disable PasteMode automatically
    autocmd! InsertLeave * set nopaste | nohlsearch
    " Reload VIMRC automatically
    autocmd! BufWritePost $MYVIMRC source %
    " Alternative of PasteMode, Ctrl-D to confirm
    command! P r !cat
    " Tell you the time
    if exists("*strftime")
        command! Time echo strftime("Time: %F %a %T")
    endif
endif

" Toggle 80 column ruler
function! Set_ColorColumn()
    if &colorcolumn == "81"
        set colorcolumn=
        echo "ColorColumn Off"
    else
        set colorcolumn=81
        echo "ColorColumn On"
    endif
endfunction

" Toggle fold
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

" Toggle auto indent
function! Set_AutoIndent()
    if &autoindent
        set noautoindent
        echo "AutoIndent Off"
    else
        set autoindent
        echo "AutoIndent On"
    endif
endfunction

" Enter PasteMode (:set paste)
function! PasteMode()
    set paste
    startinsert
endfunction

" If Vundle loaded successfully
if exists("g:vundle_installed")
    " Vundle mapping
    nmap <leader><leader>p :PluginInstall<CR>
    nmap <leader><leader>pc :PluginClean<CR>
    nmap <leader><leader>pl :PluginList<CR>
    nmap <leader><leader>pu :PluginUpdate<CR>
    " Clear Whitespace
    nmap <leader><space><space> :StripWhitespace<CR>:echo "Whitespace Cleared!"<CR>
    " CtrlP Settings
    let g:ctrlp_map = '<C-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc|pyo|pyd)$',
    \ }
endif
