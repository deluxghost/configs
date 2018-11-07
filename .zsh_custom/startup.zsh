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

export PYENV_ROOT=~/.pyenv
export EDITOR=vim
export PATH=$PATH:/usr/local/bin:$PYENV_ROOT/bin:$PYENV_ROOT/shims:~/.cargo/bin:~/.n/bin:~/bin

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

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
alias py='ipython'
alias ee='exa'
alias cat='bat --theme=TwoDark'
alias help='tldr --theme=base16'
alias ping='prettyping'
