{ config, pkgs, self, ... }@inputs:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "clay";
    autoMigrate = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Activation script to create aliases for applications
  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  users.users.clay = {
    home = "/Users/clay";
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      KeyRepeat = 2;
      InitialKeyRepeat = 25;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    brews = [ "mas" ];
    casks = [ "figma" "google-drive" "firefox" "spotify" "cursor" "docker" "shottr" "logitech-g-hub" "monokle" "notion" ];
    masApps = {
      Bitwarden = 1352778147;
      Tailscale = 1475387142;
    };
  };
}
