# dotfiles
Simple collection of my dotfiles. Managed using [yadm](https://github.com/TheLocehiliosan/yadm)

# Installation
Executables referenced in my dotfiles:
* [exa](https://the.exa.website/)
* [nvim](https://neovim.io/)
* [tmux](https://github.com/tmux/tmux)
* [zsh](https://www.zsh.org/)

> If you wish to use the dotfiles in this repo, you will need the above items.

1. Install yadm
```bash
case "${OSTYPE:?}" in
  linux*)   sudo apt install -y yadm ;;
  darwin*)  brew install yadm ;;
esac
```

2. Clone with yadm
```bash
# Clones my dotfiles to your home directory
yadm clone 'git@github.com:ClayMav/dotfiles.git'
```

3. Bootstrap with yadm
```bash
# Installs oh-my-zsh right now. In the future, might tackle the referenced executables listed above.
yadm bootstrap
```
