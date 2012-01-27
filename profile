# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

parent_process_name=$(ps -o comm= -p $PPID)
case ${parent_process_name##*/} in
  sshd) type tmux >/dev/null 2>/dev/null &&
          if tmux has-session -t 0; then
            exec tmux attach-session -t 0
          else
            exec tmux new-session -s 0
          fi;;
  tmux) type zsh >/dev/null 2>/dev/null &&
        tmux set -g default-shell zsh &&
        exec zsh;;
esac
export LANGUAGE="en_US:en"
export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
