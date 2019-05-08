# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/maverick/.oh-my-zsh"

ZSH_THEME="robbyrussell"

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false

# Automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Changes how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13



plugins=(git docker brew yarn tmux pip)

source $ZSH/oh-my-zsh.sh

# User configuration

source ~/.bash_profile

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias ls="exa --sort=type"
alias vim="nvim"

function cd {
  builtin cd $argv
  ls
}
