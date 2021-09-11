# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="flo"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$HOME/.config/zsh/custom"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

setopt extended_glob # allows us to use ^ to negate globs
unsetopt nomatch # but when pattern matching fails, simply use the command as is. See robbyrussell/oh-my-zsh#449

# Enable backward tab
# https://stackoverflow.com/a/842370/4520435
bindkey '^[[Z' reverse-menu-complete

