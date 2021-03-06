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
alias vi='vim'
alias cp='cp -i'                            # confirm before overwriting something
alias df='df -h'                            # human-readable sizes
alias tailf='tail -f'                       # 'tailf' is deprecated on arch.
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F -h -a'
alias cd..='cd ..'                          # fix stupid typo
alias mirrors='sudo pacman-mirrors -f 25'   # Update pacman mirrorslist with 15 fastest mirrors
alias printer='system-config-printer'       # .. because i tend to forget the command
alias rustupdate='rustup self update && rustup update'
alias sidekiq='bundle exec sidekiq -L /dev/stdout -c 10'
alias curl='noglob curl'
alias ffmpeg='noglob ffmpeg'
alias cp='acp -g'
alias mv='amv -g'
# Git
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch --prune'
alias gpl='git pull --prune && ([ -f Gemfile ] && command -v bundle > /dev/null && bundle --quiet) || true && ([ -f package.json ] && yarn --silent) || true'
alias gps='git push'
alias ga='git add'
alias gc='git commit --verbose'
alias gl="git log --pretty=format:'%C(yellow)%h%Creset%C(bold green)%d%Creset %Cgreen%ad %Creset%s %Cblue%an%x09' --date=short --no-merges"
alias glp="git log --pretty=format:'%C(yellow)%h%Creset%C(bold green)%d%Creset %s %Cgreen%ad %Cblue%an%x09' --date=short --no-merges -p"


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
export PATH="$PATH:/usr/local/go/bin"  # Add go bin to PATH
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/chromium
# FZF: use rg to search
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
# History
HISTFILE=~/.bash_history
HISTFILESIZE=25000
HISTSIZE=25000


#####################################################################################
### Shell functions
#####################################################################################
# ex - archive extractor
# usage: ex <file>
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# copyfile - copy content of file to clipboard
# usage: copyfile /path/to/some/file
copyfile () {
  cat $1 | xclip -selection c
}

# Check if $1 is installed via pacman
pmi () {
  pacman -Q |grep $1
}

#####################################################################################
### Misc
#####################################################################################
xhost +local:root > /dev/null 2>&1
# Fix for ruby rake tasks
alias rake='noglob rake'
# Prevent the terminal from catching CTRL+s and CTRL+q 
stty -ixon
# disable beep
xset b off

#####################################################################################
# Includes
#####################################################################################
# eval dircolors config
eval $(dircolors -b ~/.dir_colors)
# Load bash completion scripts. Depending on your distro these might not be available at this path.
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

lazynvm() {
    if [[ -z $NVM_LOADED ]]; then
        unset -f nvm
        export NVM_DIR=~/.nvm
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
        if [ -f "$NVM_DIR/bash_completion" ]; then
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
        fi
        NVM_LOADED=1
    fi
}

nvm() {
  lazynvm
  nvm $@
}

eval "$(rbenv init -)"
