" Do not modify version
let g:my_vimrc_version = "1.5.0"

" Necessary settings
let g:my_vimrc_windows = 0
let g:my_vimrc_sep = "/"
let g:my_vimrc_vim = $HOME . "/.vim/"
if has("win32") || has("win64") || has("win16")
    let g:my_vimrc_windows = 1
    let g:my_vimrc_sep = "\\"
    let g:my_vimrc_vim = $HOME . "\\vimfiles\\"
    if !executable("git") || !executable("curl")
        let g:my_vimrc_windows = 2
    endif
endif
let g:my_vimrc_repo = "https://github.com/deluxghost/configs"
let g:my_vimrc_update = "https://raw.githubusercontent.com/deluxghost/configs/master/.vimrc"
let g:my_vimrc_settings = g:my_vimrc_vim . "my_vimrc" . g:my_vimrc_sep
let g:my_vimrc_version_file = g:my_vimrc_settings . "vimrc.version"
let g:my_vimrc_update_file = g:my_vimrc_settings . "vimrc.update"
let g:my_vimrc_updatable = executable("curl") ? "curl" : executable("wget") ? "wget" : ""
if !isdirectory(g:my_vimrc_settings)
    call mkdir(g:my_vimrc_settings, "p")
endif
if !empty(glob(g:my_vimrc_settings . ".noupdate")) || !empty(glob(g:my_vimrc_settings . "_noupdate"))
    let g:my_vimrc_updatable = ""
endif
let g:my_vimrc_gvim = 0
if has("gui_running")
    let g:my_vimrc_gvim = 1
    set guioptions+=c
    set guioptions-=T
    set guioptions-=m
    set guioptions-=e
endif
let g:vundle_installed = 0

" Use Vim instead of Vi
set nocompatible
" Load Vundle runtime
filetype off
if g:my_vimrc_windows
    set runtimepath+=$HOME\vimfiles\bundle\Vundle.vim\
else
    set runtimepath+=~/.vim/bundle/Vundle.vim/
endif
runtime autoload/vundle.vim
let g:need_plugin_install = 0

" Init Vundle and load plugins
function! Start_Vundle()
    if g:my_vimrc_windows
        call vundle#begin('$USERPROFILE/vimfiles/bundle/')
    else
        call vundle#begin()
    endif
    let vimrc_plugin_name = [".vim.plugin", "_vim.plugin", ".vimrc.plugin", "_vimrc.plugin"]
    for name in vimrc_plugin_name
        if filereadable($HOME . g:my_vimrc_sep . name)
            execute "source " . $HOME . g:my_vimrc_sep . name
        endif
    endfor
    unlet vimrc_plugin_name
    call vundle#end()
    let g:vundle_installed = 1
endfunction

" Install Vundle automatically
function! Install_Vundle()
    if g:my_vimrc_windows == 2
        return
    endif
    if executable("git")
        let vundle_cwd = g:my_vimrc_vim . "bundle/Vundle.vim"
        if !isdirectory(vundle_cwd)
            call mkdir(vundle_cwd, "p")
        endif
        if g:my_vimrc_windows && !g:my_vimrc_gvim
            silent execute "!cls"
        endif
        silent execute "!git clone https://github.com/VundleVim/Vundle.vim.git " . vundle_cwd
        if v:shell_error
            echomsg "Failed to install: can't clone repo. Please install Vundle manually."
            echomsg "All plugins are disabled."
        else
            echomsg "Vundle has been installed."
            call Write_Plugin()
            call Start_Vundle()
            let g:need_plugin_install = 1
        endif
        unlet vundle_cwd
    else
        echomsg "Failed to install: git not found. Install git and try again."
        echomsg "All plugins are disabled."
    endif
endfunction

" Default plugins
function! Write_Plugin()
    let plugin_list = [
        \"Plugin 'VundleVim/Vundle.vim'",
        \"Plugin 'ervandew/supertab'",
        \"Plugin 'tpope/vim-surround'",
        \"Plugin 'ctrlpvim/ctrlp.vim'",
        \"Plugin 'joshdick/onedark.vim'",
        \"Plugin 'scrooloose/nerdcommenter'",
        \"Plugin 'easymotion/vim-easymotion'",
        \"Plugin 'terryma/vim-multiple-cursors'",
        \"Plugin 'ntpeters/vim-better-whitespace'"
    \]
    if g:my_vimrc_windows
        let plugin_file = "_vim.plugin"
    else
        let plugin_file = ".vim.plugin"
    endif
    call writefile(plugin_list, $HOME . g:my_vimrc_sep . plugin_file)
    unlet plugin_list
endfunction

function! Enter_Init()
    " Install plugins
    if g:need_plugin_install
        PluginInstall
    endif
    " Color Scheme
    if g:my_vimrc_gvim
        silent! colorscheme evening
        silent! colorscheme onedark
    else
        silent! colorscheme default
    endif
    call Highlight_Fix()
    " Check vimrc update
    if g:my_vimrc_windows == 2
        echo "Vundle needs git and curl to work.\n\nHow to install git and curl on Windows: \nhttps://github.com/VundleVim/Vundle.vim/wiki/Vundle-for-Windows"
    endif
    if !empty(g:my_vimrc_new_version) && g:my_vimrc_new_version != g:my_vimrc_version
        echo "New vimrc found: " . g:my_vimrc_new_version . " | Your version: " . g:my_vimrc_version . "\n" . g:my_vimrc_repo
    endif
    let update_cmd = ""
    if g:my_vimrc_updatable == "curl"
        let update_cmd = "curl -s -o \"" . g:my_vimrc_update_file . "\" \"" . g:my_vimrc_update . "\""
    elseif g:my_vimrc_updatable == "wget"
        let update_cmd = "wget -q -O \"" . g:my_vimrc_update_file . "\" \"" . g:my_vimrc_update. "\""
    endif
    if !empty(update_cmd)
        if g:my_vimrc_windows
            silent execute "!start /b " . update_cmd
        else
            let update_cmd = "!" . update_cmd . " &"
            silent execute update_cmd | redraw!
        endif
    endif
    unlet update_cmd
endfunction

" Check and install Vundle on first time
if exists("*vundle#rc")
    call Start_Vundle()
    " Check vimrc version and update plugins
    silent! let vimrc_file_version = readfile(g:my_vimrc_version_file, "", 1)
    let vimrc_old_version = (len(vimrc_file_version) > 0 ? vimrc_file_version[0] : "")
    if vimrc_old_version != g:my_vimrc_version
        let g:need_plugin_install = 1
    endif
    unlet vimrc_file_version
else
    call Install_Vundle()
endif
call writefile([g:my_vimrc_version], g:my_vimrc_version_file)

" Check vimrc update
if !empty(g:my_vimrc_updatable)
    silent! let vimrc_file_update = readfile(g:my_vimrc_update_file, "", 3)
    let vimrc_new = ""
    for line in vimrc_file_update
        let vermatch = matchstr(line, '^let g:my_vimrc_version = "\zs.\{-}\ze"$')
        if !empty(vermatch)
            let vimrc_new = vermatch
        endif
        unlet vermatch
    endfor
    let g:my_vimrc_new_version = vimrc_new
    unlet vimrc_file_update
    unlet vimrc_new
endif

" Highlight patching
function! Highlight_Fix()
    if !g:my_vimrc_gvim && (g:colors_name == "default" || g:colors_name == "evening")
        highlight ColorColumn ctermbg=Grey ctermfg=DarkBlue
        highlight CursorLine cterm=none ctermbg=DarkBlue ctermfg=White
    endif
endfunction

" Detect file encoding automatically
set fileencodings=utf-8,gbk,gb18030
" Detect file format automatically
set fileformats=unix,dos,mac
" Remove unused buffer
set nohidden
" How many lines of history can vim remember
set history=700
" Disable welcome message
set shortmess=atI
" Ensure backspace work
set backspace=indent,eol,start
" Set width of tab to 4
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Use spaces instead of tabs
set expandtab
" Smarter tab
set smarttab
" Don't break line
set textwidth=0
" Reload when a file is changed outside
set autoread
" Enable auto indent
set autoindent
" Show line number
set number
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
" Ignore compiled and resource files
set wildignore=*.a,*.o,*.so,*~,*.pyc,*.class
set wildignore+=*.bak,*.swp,*.swo
set wildignore+=*.bmp,*.jpg,*.jpeg,*.gif,*.png,*.pdf
" Ignore project directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
" Show tab bar
set showtabline=2
" Show status bar
set laststatus=2

" Enable syntax highlighting
syntax on
" Enable filetype plugins and indents
filetype plugin indent on

" Set the format of status bar
set statusline=
"  Filename
set statusline+=%<%F
"  Filetype, encoding and file format (line-ending)
set statusline+=\ %{'['.(&filetype!=''?&filetype:'none').']'}
set statusline+=\ %{''.(&fenc!=''?&fenc:&enc).''}%{(&bomb?\",bom\":\"\")}
set statusline+=\ %{&fileformat}
"  Line and column number
set statusline+=\ %=\ Ln\ %l/%L\ Col\ %c
"  Modified, readonly, preview and ruler
set statusline+=\ %m%r%w\ %P\ %0*
" Avoid unexpected searching highlight
nohlsearch

" Set map leader
let mapleader = ","
let g:mapleader = ","
" General mapping
"  Column 80 ruler
nmap <leader>c :call Set_ColorColumn()<CR>
"  Go PasteMode
nmap <silent> <leader>p :normal o<CR>:call PasteMode()<CR>
nmap <silent> <leader>P :normal O<CR>:call PasteMode()<CR>
"  Switch tabs
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
"  Arrow keys moving in wrapped lines
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" Declare commands and auto commands
"  Do after vim loaded
autocmd! VimEnter * call Enter_Init()
"  Disable PasteMode automatically
autocmd! InsertLeave * setlocal nopaste
"  Fix highlight automatically
autocmd! ColorScheme * call Highlight_Fix()
"  Reload VIMRC automatically
autocmd! BufWritePost $MYVIMRC source %
"  Jump to the last edit position
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
"  Syntax for .vim.plugin and .vimrc2
autocmd! BufNewFile,BufReadPost,BufNew .vim.plugin,_vim.plugin,.vimrc.plugin,_vimrc.plugin setl ft=vim
autocmd! BufNewFile,BufReadPost,BufNew .vimrc2,_vimrc2,.vimrc.user,_vimrc.user setl ft=vim
"  Show my vimrc version
command! Ver echo g:my_vimrc_version
"  Alternative of PasteMode, Ctrl-D to confirm
if executable("cat")
    command! P r !cat
endif
"  Tell you the time
command! Time echo strftime("Time: %F %a %T")

" Toggle column 80 ruler
function! Set_ColorColumn()
    if &colorcolumn == "80"
        set colorcolumn=
        echo "Column Ruler Off"
    else
        set colorcolumn=80
        echo "Column Ruler On"
    endif
endfunction

" Enter PasteMode (:set paste)
function! PasteMode()
    set paste
    startinsert
endfunction

" If Vundle loaded successfully
if g:vundle_installed
    " Vundle mappings
    nmap <leader><leader>p :PluginInstall<CR>
    nmap <leader><leader>pi :PluginInstall<CR>
    nmap <leader><leader>pc :PluginClean<CR>
    nmap <leader><leader>pl :PluginList<CR>
    nmap <leader><leader>pu :PluginUpdate<CR>
    " Clear Whitespace
    nmap <leader><space><space> :StripWhitespace<CR>:echo "Trailing Whitespaces Cleared!"<CR>
    " CtrlP Settings
    let g:ctrlp_map = '<C-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
        \'dir':  '\v[\/]\.(git|hg|svn|rvm|DS_Store)$',
        \'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$'
    \}
endif

" Load user settings
let vimrc_name = [".vimrc2", "_vimrc2", ".vimrc.user", "_vimrc.user"]
for name in vimrc_name
    if filereadable($HOME . "/" . name)
        execute "source " . $HOME . "/" . name
    endif
endfor
unlet vimrc_name
