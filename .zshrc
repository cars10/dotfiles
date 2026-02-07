# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster-custom"

# Load git plugin
plugins=(git)

# Source oh-my-zsh for theming
source $ZSH/oh-my-zsh.sh

# Load zsh-audocomplete
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load shell configuration (containing aliases, ENV variables, etc)
[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc

# Set zsh user
DEFAULT_USER=$USER
