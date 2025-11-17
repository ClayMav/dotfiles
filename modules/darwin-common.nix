{
  config,
  nixpkgs,
  pkgs,
  self,
  ...
}@inputs:
let
  commonDockApps = [
    "/Applications/Zen.app"
    "/Applications/Notion Calendar.app"
    "/Applications/Notion.app"
    "/Applications/Visual Studio Code - Insiders.app"
    "/Applications/Sleep Aid.app"
  ];
in
{
  system.primaryUser = "clay";
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
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  # programs.fish.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.clay = {
    home = "/Users/clay";
    shell = pkgs.zsh;
  };

  system.defaults = {
    CustomSystemPreferences.NSGlobalDomain."com.apple.mouse.linear" = true;
    ".GlobalPreferences"."com.apple.mouse.scaling" = 0.875;
    finder = {
      ShowStatusBar = true;
      ShowPathbar = true;
    };
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
      NSAutomaticPeriodSubstitutionEnabled = false;
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    brews = [
      {
        "name" = "colima";
        "start_service" = true;
      }
      "lima-additional-guestagents"
      "mas"
      "docker"
      "docker-compose"
      "gemini-cli"
      "goimports"
    ];
    casks = [
      # Browsers
      "vivaldi" # Primary browser
      "zen"
      "firefox" # Backup browser
      "google-chrome" # Backup browser
      # Other
      "figma"
      "shottr"
      "logitech-g-hub"
      "notion"
      "notion-calendar"
      "private-internet-access"
      "tailscale-app"
      "vlc"
      "chatgpt"
      "sleep-aid"
      "font-codicon"
      "gimp"
      "raycast"
      "inkscape"
      "monitorcontrol"
      # Development
      "ghostty"
      # "zed"
      # "cursor"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "datagrip"
      "codex"
    ];
    masApps = {
      Bitwarden = 1352778147;
    };
  };

  # Export commonDockApps for use in host configurations
  _module.args.commonDockApps = commonDockApps;
}
