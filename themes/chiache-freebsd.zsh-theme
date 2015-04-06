PROMPT='%(?,,%{$fg[red]%} -- exit %{(%}$?%) -- %{$reset_color%}
)%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%m %{$fg_bold[blue]%}%(!.%1~.%20<..<%~%<<) $(jobs_status)$(git_prompt_info)%#%{$reset_color%} '
RPROMPT='%{$fg_no_bold[blue]%}[%*]%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}] "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}@"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}@"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}@"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[green]%}~"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}X"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}!!!!"
