function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function jobs_status() {
  [[ "$(jobs)" == "" ]] && return
  jobs_str=
  jobs 2> /dev/null | while read job; do
    id="$(expr match "$job" '\[\([0-9]*\)\]')"
    [ "$id" == "" ] && continue
    nm="$(expr match "$job" '.*  \(.*\)')"
    [ ${#nm} -gt 10 ] && nm="$(expr match "$nm" '\(..\)')..$(expr match "$nm" '.*\(.......\)')"
    jobs_str="$jobs_str $id:$nm"
  done
  echo "(${jobs_str# }) "
}

function uninstall_oh_my_zsh() {
  /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /bin/sh $ZSH/tools/upgrade.sh
}

function take() {
  mkdir -p $1
  cd $1
}

function extract() {
    unset REMOVE_ARCHIVE
    
    if test "$1" = "-r"; then
        REMOVE=1
        shift
    fi
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2) tar xvjf $1;;
      *.tar.gz) tar xvzf $1;;
      *.tar.xz) tar xvJf $1;;
      *.tar.lzma) tar --lzma -xvf $1;;
      *.bz2) bunzip $1;;
      *.rar) unrar x $1;;
      *.gz) gunzip $1;;
      *.tar) tar xvf $1;;
      *.tbz2) tar xvjf $1;;
      *.tgz) tar xvzf $1;;
      *.zip) unzip $1;;
      *.Z) uncompress $1;;
      *.7z) 7z x $1;;
      *) echo "'$1' cannot be extracted via >extract<";;
    esac

    if [[ $REMOVE_ARCHIVE -eq 1 ]]; then
        echo removing "$1";
        /bin/rm "$1";
    fi

  else
    echo "'$1' is not a valid file"
  fi
}

errno() {
  if which gcc >/dev/null; then
    # Header finding trick from Kees Cook <kees@ubuntu.com>
    headers=$(echo "#include <asm/errno.h>" | gcc -E - 2>/dev/null | grep --color=none "\.h" | awk -F\" '{print $2}' | sort -u)
  else
    headers="/usr/include/asm-generic/errno*.h"
  fi

  if [ ! -f "$(echo $headers)" ] 2>/dev/null; then
    return
  fi  

  code="$1"

  if [ "$code" -le 0 -o "$code" -ge 0 ] 2>/dev/null; then
    # Input is a number, search for a particular matching code
    sed -n "s,^#define\s\+[^[:space:]]\+\s\+${code}\s\+\/\*\s\+\(.*\)\s\+\*\/,\1,p" $(echo $headers)
  else
    # Input is not a number, search for any matching strings
    sed -n "s,^#define\s\+\(.*${code}.*\),\1,Ip" $(echo $headers)
  fi
}

errno_info() {
  echo -n $1
  info=$(errno $1)
  [ "$info" != "" ] && echo " - $info"
}
