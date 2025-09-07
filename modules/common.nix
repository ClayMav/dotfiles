{ pkgs, nixpkgs, ... }@inputs:
{
  system.stateVersion = 5;
  system.primaryUser = "clay";
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs.unstable; [
    vim
    neovim
    git
    zsh
    tmux
    gh
    bun
    curl
    wget
    wezterm
    google-chrome
    jetbrains.datagrip
    inkscape
    gimp
    ripgrep
    nodePackages.localtunnel
    fzf
    sqlite
    poetry
    uv
    tldr
    nodePackages.vercel
    watch
    oh-my-zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    vlc-bin
    monitorcontrol
    tree-sitter
    go
    air
    delve
    yarn
    nodejs_22
    corepack_22
    fnm
    pipx
    # dotagent
    # gemini-cli # TOO SLOW TO UPDATE

    # Fix nix creating symlinks for applications, create aliases as well
    mkalias
    # Formatter for nix files
    nixfmt-rfc-style
    # Language server for nix
    nixd
    # Search for nix packages
    nix-search-cli
    # Wishlist
    # - Logitech Unifying Software
  ];

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.settings.download-buffer-size = "1G";
}
