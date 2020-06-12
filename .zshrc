# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

DISABLE_UPDATE_PROMPT="true"

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false


export UPDATE_ZSH_DAYS=13

plugins=(git docker brew yarn tmux pip)

command_exists() {
  hash "$1" 2> /dev/null;
}

source $ZSH/oh-my-zsh.sh

# User configuration
#
if command_exists pyenv ; then
  # pyenv is installed
  export PATH="$PATH:$HOME/.pyenv/shims"
fi

if command_exists exa ; then
  alias ls="exa --sort=type"
fi
if command_exists nvim ; then
  alias vim="nvim"
fi

function cd {
    builtin cd $argv
    ls
}

export EDITOR='vim'

alias ssh='TERM=xterm-256color ssh'

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
