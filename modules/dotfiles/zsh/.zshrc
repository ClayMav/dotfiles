DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=30

# Allow more file watchers
ulimit -n 20000
ulimit -u 2048

setopt COMBINING_CHARS

# Nomad and Vault addresses
export NOMAD_ADDR="http://nomad-servers.prod.stratos.host:4646"
export VAULT_ADDR="https://vault.prod.stratos.host:8200"
export CONSUL_HTTP_ADDR="https://nomad-servers.prod.stratos.host:8501"

function command_exists() {
  hash "$1" 2> /dev/null;
}

function cd {
    builtin cd $argv
    ls
}

# If the file exists, then we need to add the ssh key
if [ -f ~/.ssh/id_ed25519 ] ; then
    if [ -z "$SSH_AUTH_SOCK" ] ; then
        eval `ssh-agent -s`
    fi
    ssh-add -D
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
fi

# If there is an sso directory in ~/.aws, then we need to login
if [ -d ~/.aws/sso ] ; then
    aws sts get-caller-identity > /dev/null 2>&1 || aws sso login
fi

export GITHUB_TOKEN=$(gh auth token)

# Allow go executables to be run (air, etc.)
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$(go env GOPATH)/bin
