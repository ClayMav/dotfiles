# dotfiles
Simple collection of my dotfiles. Managed using [yadm](https://github.com/TheLocehiliosan/yadm)

# Installation
1. Install yadm
```bash
case "${OSTYPE:?}" in
  linux*)   sudo apt install -y yadm ;;
  darwin*)  brew install yadm ;;
esac
```

2. Clone with yadm
```bash
yadm clone 'git@github.com:ClayMav/dotfiles.git'
```
