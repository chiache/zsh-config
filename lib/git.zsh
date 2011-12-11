# get the name of the branch we are on

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_prompt_info'
precmd_functions+='precmd_update_git_prompt_info'
chpwd_functions+='chpwd_update_git_prompt_info'

function update_git_prompt_info() {
  [[ "$GIT_TOPLEVEL" == "" ]] && return
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git describe --tags --exact-match HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || \
  return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref##*/}$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX" > $GIT_TOPLEVEL/.git/prompt-info
}

function git_prompt_info() {
  [[ "$GIT_PROMPT_DISABLED" != "" ]] && return
  [[ "$GIT_TOPLEVEL" == "" ]] && return
  if [ ! -f "$top/.git/prompt-info" ]; then
    disable_update_git_prompt_info
    update_git_prompt_info
  fi
  cat $top/.git/prompt-info 2> /dev/null
}

function preexec_update_git_prompt_info() {
  [[ "$GIT_TOPLEVEL" == "" ]] && return
  case "$1" in
    git*|vi*|emac|make)
        enable_update_git_prompt_info
        ;;
  esac
}

function precmd_update_git_prompt_info() {
  [[ "$GIT_TOPLEVEL" == "" ]] && return
  if [[ "$GIT_UPDATE_PROMPT_DISABLED" == "" ]]; then
    disable_update_git_prompt_info
    update_git_prompt_info
  fi
}

function chpwd_update_git_prompt_info() {
  top=$(git rev-parse --show-toplevel 2> /dev/null) || unset GIT_TOPLEVEL
  disable_update_git_prompt_info
  if [[ "$GIT_TOPLEVEL" != "$top" ]]; then
    GIT_TOPLEVEL="$top"
    update_git_prompt_info
  fi
}

function disable_git_prompt_info() {
  GIT_PROMPT_DISABLED=1
}

function enable_git_prompt_info() {
  unset GIT_PROMPT_DISABLED
}

function disable_update_git_prompt_info() {
  GIT_UPDATE_PROMPT_DISABLED=1
}

function enable_update_git_prompt_info() {
  unset GIT_UPDATE_PROMPT_DISABLED
}

# Checks if working tree is dirty
parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}
