# get the name of the branch we are on

function update_git_prompt_info() {
  top=$(git rev-parse --show-toplevel) || return
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git describe --tags --exact-match HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || \
  return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref##*/}$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX" > $top/.git/prompt-info
}

function git_prompt_info() {
  [[ "$GIT_PROMPT_DISABLED" != "" ]] && return
  top=$(git rev-parse --show-toplevel 2> /dev/null) || return
  if [[ "$GIT_UPDATE_PROMPT_DISABLED" == "" ]]; then
    ([ ! -f "$top/.git/prompt-info" ] ||
     [ "$top/.git/prompt-info" -ot "$top/.git/HEAD" ] ||
     find "$top" -path "$top/.git" -prune -cnewer "$top/.git/prompt-info" -quit 2> /dev/null) &&
    update_git_prompt_info
  fi
  cat $top/.git/prompt-info 2> /dev/null || return
}

function disable_git_prompt_info() {
  GIT_PROMPT_DISABLED=1
}

function enable_git_prompt_info() {
  GIT_PROMPT_DISABLED=
}

function disable_update_git_prompt_info() {
  GIT_UPDATE_PROMPT_DISABLED=1
}

function enable_update_git_prompt_info() {
  GIT_UPDATE_PROMPT_DISABLED=
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
