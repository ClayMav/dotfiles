# dotfiles
Configuration heaven.

# Installation
Programs used in these dotfiles:
* [exa](https://the.exa.website/)
* [nvim](https://neovim.io/)
* [tmux](https://github.com/tmux/tmux)
* [zsh](https://www.zsh.org/)
* [nvm](https://github.com/nvm-sh/nvm)
* [node](https://nodejs.org/en/) *Installed via* ***nvm***

> If you wish to use the dotfiles in this repo, you will need the above items.

1. Install [chezmoi](https://github.com/twpayne/chezmoi)

2. Initialize chezmoi
  ```bash
  # Clones my dotfiles to your home directory
  chezmoi init 'git@github.com:ClayMav/dotfiles.git'
  ```

# Future Work
* Look into nix or similar for package management
* Bootstrapping
  ```
  * install programs referenced above
  * create .vim/{.undo,.backup,.swp} directories
  * install oh-my-zsh without overwritting the .zshrc file
  * change default shell to zsh
  ```
