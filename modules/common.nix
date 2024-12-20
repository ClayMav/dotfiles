{ pkgs, ... }@inputs:
{
  system.stateVersion = 5;
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.neovim
      pkgs.git
      pkgs.zsh
      pkgs.tmux
      pkgs.fnm
      pkgs.gh
      pkgs.bun
      pkgs.curl
      pkgs.wget
      pkgs.wezterm
      pkgs.google-chrome
      #   pkgs.spotify
      pkgs.docker
      pkgs.jetbrains.datagrip
      pkgs.inkscape
      pkgs.gimp
      pkgs.tailscale
      pkgs.ripgrep
      pkgs.nodePackages.localtunnel
      pkgs.fzf
      pkgs.sqlite
      pkgs.poetry
      pkgs.uv
      pkgs.tldr
      pkgs.nodePackages.vercel
      pkgs.watch
      pkgs.oh-my-zsh
      pkgs.zsh-completions
      pkgs.zsh-autosuggestions
      pkgs.zsh-syntax-highlighting
      pkgs.vlc-bin
      pkgs.monitorcontrol
      pkgs.tree-sitter
      pkgs.go
      pkgs.air
      pkgs.delve

      # Fix nix creating symlinks for applications, create aliases as well
      pkgs.mkalias
      # Formatter for nix files
      pkgs.nixpkgs-fmt
      # Language server for nix
      pkgs.nil
      # Wishlist
      # - Logitech Unifying Software
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
}
