DISABLE_UPDATE_PROMPT="true"

export UPDATE_ZSH_DAYS=20
# Allow more file watchers
ulimit -n 20000
ulimit -u 2048

# Nomad and Vault addresses
export NOMAD_ADDR="http://nomad-servers.prod.stratos.host:4646"
export VAULT_ADDR="https://vault.prod.stratos.host:8200"
export CONSUL_HTTP_ADDR="https://nomad-servers.prod.stratos.host:8501"

# fnm
export PATH="/Users/clay/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

setopt COMBINING_CHARS

function cd {
    builtin cd $argv
    ls
}
