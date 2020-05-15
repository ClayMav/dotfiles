# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export ZSH="/home/maverick/.oh-my-zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export ZSH="/Users/maverick/.oh-my-zsh"
fi

ZSH_THEME="robbyrussell"

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false

# Automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Changes how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13



plugins=(poetry git docker brew yarn tmux pip)

source $ZSH/oh-my-zsh.sh

# User configuration

source ~/.bash_profile
export PATH=$PATH:/Users/maverick/.pyenv/shims

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias ls="exa --sort=type"
alias vim="nvim"
alias git="/usr/local/bin/git"

function cd {
  builtin cd $argv
  ls
}

source ~/.config/tmuxinator.zsh
eval "$(pyenv init -)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/maverick/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/maverick/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/maverick/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/maverick/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PYTHONPATH=$PYTHONPATH:/usr/local/lib
