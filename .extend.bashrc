#
# ~/.extend.bashrc
#
# I use this file as the main shell configuration.
# This file is sourced in every .*bash*|.*profile* file to have the same aliases and variables
# available in every shell.
# 
# Example usage:
#   [[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc
# 
# This is included in all the shell files, for example
#   ~/.bashrc 
#   ~/.bash_profile
#   ~/.profile
#   ~/.zshrc
#   ...
#
#####################################################################################
### Shell aliases
#####################################################################################
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F -h -a'
alias cd..='cd ..'                          # fix stupid typo
alias mirrors='sudo pacman-mirrors -f 25'   # Update pacman mirrorslist with 15 fastest mirrors
# Git
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch --prune'
alias gps='git push'
alias ga='git add'
alias gc='git commit --verbose'
# docker
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias ds='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

#####################################################################################
### ENV Variables
#####################################################################################
export BAT_PAGER=""
# default editor
export EDITOR=/usr/bin/vim
# Fix for ugly font rendering in intellij (and it's derivates: rubymine, webstorm, etc)
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
# $PATH adjustments for various programming language environments
export PATH="$PATH:$HOME/.cargo/bin"   # Add cargo bin to PATH to use rust binaries
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/google-chrome-stable
# FZF: use rg to search
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
# History
HISTFILE=~/.bash_history
HISTFILESIZE=25000
HISTSIZE=25000

#####################################################################################
### Misc
#####################################################################################
xhost +local:root > /dev/null 2>&1
# Prevent the terminal from catching CTRL+s and CTRL+q 
stty -ixon
# disable beep
xset b off

#####################################################################################
# Includes
#####################################################################################
eval $(dircolors -b ~/.dir_colors)
# Load bash completion scripts. Depending on your distro these might not be available at this path.
#[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
