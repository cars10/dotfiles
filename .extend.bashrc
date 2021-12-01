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
alias cp='acp -g'
alias mv='amv -g'
# Git
alias gd='git diff'
alias gdc='git diff --cached'
alias gpl='git pull --prune && ([ -f Gemfile ] && command -v bundle > /dev/null && bundle --quiet) || true && ([ -f package.json ] && yarn --silent) || true'
alias gps='git push'
alias ga='git add'
alias gc='git commit --verbose'

#####################################################################################
### ENV Variables
#####################################################################################
# default editor
export EDITOR=/usr/bin/vim
# Fix for ugly font rendering in intellij (and it's derivates: rubymine, webstorm, etc)
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
# $PATH adjustments for various programming language environments
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"   # Add cargo bin to PATH to use rust binaries
# bash history
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

lazynvm() {
    if [[ -z $NVM_LOADED ]]; then
        unset -f nvm
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        NVM_LOADED=1
    fi
}

nvm() {
  lazynvm
  nvm $@
}

eval "$(rbenv init --no-rehash -)"
