#
# ~/.extend.bashrc
# loaded in 
#   ~/.bashrc 
#   ~/.bash_profile
#   ~/.zshrc
#

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

#####################################################################################
### Shell aliases
#####################################################################################
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias tailf="tail -f"
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias cd..="cd .."
alias mirrors='sudo pacman-mirrors -f 15'
alias printer='system-config-printer'
alias update='yaourt -Syua'


#####################################################################################
### ENV Variables
#####################################################################################
# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export EDITOR=/usr/bin/vim
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

export PATH="$PATH:$HOME/.rvm/bin"   # Add RVM to PATH for scripting
export PATH="$HOME/.cargo/bin:$PATH" # Add cargo bin to PATH to use rust binaries
export PATH="$PATH:/usr/local/go/bin"  # Add go bin to PATH

# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/chromium


#####################################################################################
### Shell functions
#####################################################################################

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
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


#####################################################################################
### Misc
#####################################################################################
xhost +local:root > /dev/null 2>&1
alias rake='noglob rake'
eval $(dircolors -b ~/.dir_colors)
