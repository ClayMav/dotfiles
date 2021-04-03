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
  eval "$(pyenv init -)"
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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$PATH:$HOME/.poetry/bin"

PATH="/Users/clay/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/clay/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/clay/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/clay/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/clay/perl5"; export PERL_MM_OPT;

ulimit -n 200000
ulimit -u 2048
