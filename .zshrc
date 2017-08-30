unsetopt GLOBAL_RCS

function is_wsl()
{
    grep -q Microsoft /proc/version
    return $?
}

function psdir()
{
    if [ $# -ne 1 ]; then
        echo "Usage: psdir <process_name>"
        return
    fi
    for pid in `ps -e | grep $1 | awk '{print $1}'`; do
        sudo ls -l /proc/${pid}/exe | awk "{print $pid \"\\t\" \$11}"
    done
}

if is_wsl; then
    for i in {a..z}; do
        hash -d $i=/mnt/$i
    done
fi

PROMPT="%B%F{cyan}%n%F{magenta}@%F{cyan}%M  %F{green}%/%b%f
%(?..%? )%B%F{red}>>%b%f"

export PATH=$HOME/bin:$PATH
export HISTSIZE=2000
export SAVEHIST=3000
export HISTFILE=~/.zhistory

setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

limit coredumpsize 0

bindkey -e
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE
autoload -U compinit
compinit

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always

[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 2 numeric

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'

zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'

alias ls='ls -F --color'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias grep='grep --color'
alias rr='rm -r'
