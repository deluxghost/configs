ZSH_THEME="deluxghost"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
HYPHEN_INSENSITIVE="true"
export UPDATE_ZSH_DAYS=5
setopt noincappendhistory
setopt nosharehistory

source ~/bin/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle tmux
antigen bundle mosh
antigen bundle python
antigen bundle docker
antigen bundle systemd
antigen bundle common-aliases
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle Tarrasch/zsh-bd
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zdharma/history-search-multi-word
antigen apply

export OS="`uname`"

function is_wsl()
{
    grep -q Microsoft /proc/version &> /dev/null
    return $?
}

function mcdir()
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

export EDITOR=vim
export PATH=$PATH:~/bin

alias esrc='$EDITOR "$ZSH_CUSTOM/startup.zsh"'
alias resrc='source ~/.zshrc'
if [[ "$OS" == "Darwin" || "$OS" == "FreeBSD" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias rr='rm -r'
