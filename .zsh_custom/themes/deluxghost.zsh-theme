function get_current_dir {
    echo "${PWD/#$HOME/~}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg_bold[red]%}✘ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg_bold[green]%}✔ "

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
PROMPT='%{$fg_bold[cyan]%}%n%{$fg_bold[magenta]%}@%M %{$fg_bold[yellow]%}%~ $(git_prompt_info)
${ret_status}'
